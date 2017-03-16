-module(email_cronjob).

-compile(export_all).

% What should this look like?
% It will call the surfline API (this should be a process)
% That call can be synchronous
% When we get a reply from the surfline API, we read everybody in the DB, and send emails to them

send_emails(true) ->
  io:format("Forecast is good, sending emails~n"),
  {ok, MongoPid} = mongo_handler:start_link(),
  Emails = mongo_handler:get_emails(MongoPid),
  lists:foreach(fun(Recipient) ->
        {ok, EmailPid} = email_sender:start_link(),
        email_sender:send_email(EmailPid, Recipient)
    end, Emails),
  ok;
send_emails(_) ->
  io:format("Forecast is not good, sleeping~n"),
  ok.

start() ->
  {ok, Pid} = surfline_api:start_link(),
  Forecast = surfline_api:check_forecast_good(Pid),
  send_emails(Forecast),
  ok.

  % erlang:halt(0). % there's probably a better way than this to end & exit...but I don't know it :shrug:

