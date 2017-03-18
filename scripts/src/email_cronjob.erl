-module(email_cronjob).
-behavior(gen_server).
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

init([]) ->
  {ok, SurflinePid} = surfline_api:start_link(),
  {ok, SurflinePid}.

start_link() ->
  gen_server:start_link(?MODULE, [], []).

internal_run(SurflinePid) ->
  io:format("Checking Forecast"),
  Forecast = surfline_api:check_forecast_good(SurflinePid),
  send_emails(Forecast).

internal_run_repeat(SurflinePid, Delay) ->
  internal_run(SurflinePid),
  timer:sleep(Delay * 3600000), % convert to hours
  internal_run_repeat(SurflinePid, Delay).

handle_cast(run, SurflinePid) ->
  internal_run(SurflinePid),
  {noreply, SurflinePid};
handle_cast({run_repeat, Delay}, SurflinePid) ->
  internal_run_repeat(SurflinePid, Delay),
  {noreply, SurflinePid}.
  
run(Pid) ->
  gen_server:cast(Pid, run).

run_repeat(Pid, Delay) ->
  gen_server:cast(Pid, {run_repeat, Delay}).

% TODO: hook something up to this. It's difficult to get gen_server to trigger this call with the current state though.
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

