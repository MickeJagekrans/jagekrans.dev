# mikael.jagekrans.dev

My freelance contractor profile website.

## Overview and design

### Initial considerations:

* Page should be minimal with minimal load times
* Page should have some content which changes over time but only rarely - no need for a fully fledged CMS
* Page should be generated from dynamic content and output as static content
* No SPA/client-side rendering - why have massive memory usage for a static page?

### Features:

* English/Swedish
* Adaptive design
* Light/Dark mode (stretch)

### Hosting:

* Azure Static Web Apps

### Backend:

Contact form  
-> Event Grid  
-> Azure Function  
-> E-mail  

**Why not just post directly to the Azure Function?**

Reason number one: **Cold start times**.  

Another big reason is that we can set up a dead-letter queue for the Event Grid to ensure that no messages are lost.
