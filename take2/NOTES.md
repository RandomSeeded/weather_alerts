General idea here is to use what we've learned about releases to do this in a better way

What will the architecture look like?

We want an application for the web server. Definitely.

We want an application for the mongo handler, because that's shared code. We will have a single source of mongo truth, which will be responsible for writes and reads

We want an application for the jobs. It will run periodically.
- Within this application we want a pool of API workers (to check the forecast) and a pool of email sending workers

Any shared code can go in library applications.
