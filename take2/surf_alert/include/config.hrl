-define(Config, case os:getenv("ENVIRONMENT") of
                  false ->
                    #{canonical_host_url => "http://surfpings.com",
                      cron_period => {daily, {10, am}}};
                  "NATEWILLARD" ->
                    #{canonical_host_url => "http://natewillard.com/projects/surf_alert",
                      cron_period => {daily, {10, am}}};
                  "DEV" ->
                    #{canonical_host_url => "http://localhost:1080",
                      cron_period => {once, 1}}
                end).
