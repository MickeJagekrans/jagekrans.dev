const { app } = require('@azure/functions');

app.http('wake', {
  methods: ['GET'],
  authLevel: 'anonymous',
  handler: async (_request, _context) => {
    return { status: 204 };
  }
});
