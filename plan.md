##What does v0 look like?

- just a single spot (easily extensible to be multiple spots later)
- a single amount of advance notice (say noon day before?, can extend to make multiple amounts of advance notice later)
- single criteria (fair to good or better)
- enter in email address
- sends you an email if the surf meets the criteria
- unsubscribe (removes all alerts)

##IMPLEMENTATION - v0

- ~~static webpage (for now), with a single form (input email), with placeholder (one option) for spot selection~~
- erlang webserver which
  - ~~serves static webpage~~
  - ~~has route for email adding~~
  - ~~has database (file?) for email address storing~~
- cronjob (language? probably still erlang for sake of learning)
  - hits surfline API
  - checks if criteria are met
  - sends emails

##IMPROVEMENTS

- spot search (nobody likes having to do the shit select from region nonsense)
- multiple spots
- accounts
  - manage my alerts
  - not having to re-enter email addr over and over again
- email verification?
- specify your own criteria for alerts
- change how much advanced notice you want for alerts

##MISC
- for now static HTML means redirect on form fill, but easy enough to change that in future (API routes)
- we will want to return success / failure depending on what we receive from our worker
