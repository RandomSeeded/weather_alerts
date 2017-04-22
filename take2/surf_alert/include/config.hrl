-define(Config, case os:getenv("ENVIRONMENT") of
                  false ->
                    #{canonical_host_url => "http://natewillard.com/projects/surf_alert",
                      forecast_threshold => 5,
                      cron_period => {daily, {10, am}}};
                  "DEV" ->
                    #{canonical_host_url => "http://localhost:1080",
                      forecast_threshold => 0,
                      cron_period => {once, 1}}
                end).
