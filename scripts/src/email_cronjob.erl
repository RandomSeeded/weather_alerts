-module(email_cronjob).
-behavior(gen_server).
-compile(export_all).
-include("surfline_definitions.hrl").

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
  {ok, []}.

start_link() ->
  gen_server:start_link(?MODULE, [], []).

internal_run() ->
  io:format("Checking Forecast~n"),
  lists:foreach(fun(S) ->
                    SpotId = S#spot.surfline_spotId,
                    io:format("SpotId ~p~n", [SpotId]),
                    {ok, SurflinePid} = surfline_api:start_link(),
                    Forecast = surfline_api:check_forecast_good(SurflinePid, SpotId),
                    send_emails(Forecast),
                    exit(SurflinePid, normal)
                end, ?Surfline_definitions).

internal_run_repeat(Delay) ->
  internal_run(),
  timer:sleep(Delay * 3600000), % convert to hours
  internal_run_repeat(Delay).

handle_cast(run, State) ->
  internal_run(),
  {noreply, State};
handle_cast({run_repeat, Delay}, State) ->
  internal_run_repeat(Delay),
  {noreply, State}.
  
run(Pid) ->
  gen_server:cast(Pid, run).

run_repeat(Pid, Delay) ->
  gen_server:cast(Pid, {run_repeat, Delay}).

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

