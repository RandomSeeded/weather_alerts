# TODO

## High level

- spot search (nobody likes having to do the shit select from region nonsense)
- multiple spots
- accounts
- manage my alerts
- not having to re-enter email addr over and over again
- email verification?
- specify your own criteria for alerts
- change how much advanced notice you want for alerts

## Implementation details

### Factor out the surfline API checker to be its own process. Options:

1) Run itself on repeat and save to cache, when invoked retrieve from cache
2) Don't run on repeat, but save to cache, when invoked re-fetch if cache too old

What's the point? Are they really different than just running the whole job periodically?
- we can fallback to cache in case the API changes on us
- we can factor all the icky dealing with surfline API logic out into a separate process and therefore not break everything if we don't happy path

### Simple run script instead of command within erl shell

This pending better understanding of setting up proper supervisor / applications / releases.

## Immediate next steps

### Multi-region support

1) Re-enable multiple regions in frontend
2) Database needs add'l field to be written corresponding to region
3) Expand surfline api to check against every region, not just SF / san mateo
4) Modify email sending script to use regions
5) Modify email recipient finder to find based on regions
6) Modify email body to take region into account

### Hide API submissions

- probably jquery for simplicity


