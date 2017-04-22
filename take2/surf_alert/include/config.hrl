-define(Config, #{
          canonical_host_url => case os:getenv("CANONICAL_HOST_URL") of
                                  false -> "http://localhost:1080";
                                  E -> E
                                end,
          forecast_threshold => case os:getenv("FORECAST_THRESHOLD") of
                                  false -> 5;
                                  E -> erlang:list_to_integer(E)
                                end
         }).

