const { app } = require('@azure/functions');

const sendGridApiKey = process.env.SENDGRID_API_KEY;
const msgReceiver = process.env.MSG_RECEIVER;

app.http('contact', {
  methods: ['POST'],
  authLevel: 'anonymous',
  handler: async (request, context) => {
    const formData = await request.formData();

    const contactInfo = {
      name: formData.get('name'),
      email: formData.get('email'),
      message: formData.get('message')
    };

    const honeypotTriggered =
      !!formData.get('contact_by_fax_only') || !!formData.get('password');

    if (honeypotTriggered) {
      context.log('Honeypot triggered, likely spam');
      context.log(contactInfo);

      return successResponse();
    }

    const subject = `Contact request from ${contactInfo.name}`;
    const msgBody = `Name: ${contactInfo.name}\nEmail: ${contactInfo.email}\nMessage:\n${contactInfo.message}`;

    try {
      // Await response to ensure that failures are communicated back to the caller
      await fetch('https://api.sendgrid.com/v3/mail/send', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${sendGridApiKey}`
        },
        body: JSON.stringify({
          personalizations: [{ to: [{ email: msgReceiver }] }],
          from: { email: msgReceiver },
          subject,
          content: [{ type: 'text/plain', value: msgBody }]
        })
      });
    } catch (e) {
      context.error(`Something went wrong when sending email!`);
      context.error(`Failed message contents: ${msgBody}`);
      context.error(e);

      return failResponse();
    }

    return successResponse();
  }
});

function successResponse() {
  return { status: 303, headers: { Location: '/#contact-success' } };
}

function failResponse() {
  return { status: 303, headers: { Location: '/#contact-failed' } };
}
