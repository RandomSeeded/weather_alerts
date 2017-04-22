-define(Config, #{
          canonical_host_url => case os:getenv("CANONICAL_HOST_URL") of
                                  false -> "http://localhost:1080";
                                  E -> E
                                end
         }).

