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

Factor out the surfline API checker to be its own process. Options:
1) Run itself on repeat and save to cache, when invoked retrieve from cache
2) Don't run on repeat, but save to cache, when invoked re-fetch if cache too old

What's the point? Are they really different than just running the whole job periodically?
- we can fallback to cache in case the API changes on us
- we can factor all the icky dealing with surfline API logic out into a separate process and therefore not break everything if we don't happy path

## Immediate next steps

- simple run script instead of command within erl shell

