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

    const subject = `Contact request from ${contactInfo.name}`;
    const msgBody = `Name: ${contactInfo.name}\nEmail: ${contactInfo.email}\nMessage:\n${contactInfo.message}`;

    const honeypotTriggered =
      !!formData.get('contact_by_fax_only') || !!formData.get('password');

    if (honeypotTriggered) {
      context.log('Honeypot triggered, likely spam');
      context.log(contactInfo);

      return { status: 303, headers: { Location: '/#contact-success' } };
    }

    try {
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
      context.error(`Something went wrong when sending email:`);
      context.error(`Failed message contents: ${msgBody}`);
      context.error(e);

      return { status: 500, headers: { Location: '/#contact-failed' } };
    }

    return { status: 303, headers: { Location: '/#contact-success' } };
  }
});
