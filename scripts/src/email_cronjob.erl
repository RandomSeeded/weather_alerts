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
  % {ok, SurflinePid} = surfline_api:start_link(),
  {ok, []}.

start_link() ->
  gen_server:start_link(?MODULE, [], []).

% OK so this needs to be modified to have multi-region support.
% What do we want architecture to look like?
% We invoke API function single time.
% It loops through all regions
% For each region it spawns a separate surfline-checking process, and waits for a repsonse
% It then invokes send_emails based on that response
internal_run() ->
  io:format("Checking Forecast~n"),
  % Now we need to make this lists:each style.
  % Sync? Async?
  % It's easiest to leave this sync, but then if one fails they all fail, which is shit city.
  % Additionally, the map is synchronous, which is also shit city.
  SurflineDefinitions = ?Surfline_definitions,
  io:format("SurflineDefinitions ~p~n", [SurflineDefinitions]),
  lists:foreach(fun(N) ->
                    io:format("N ~p~n", [N])
                end, ?Surfline_definitions),
  {ok, SurflinePid} = surfline_api:start_link(),
  Forecast = surfline_api:check_forecast_good(SurflinePid),
  % So fundamentally we need to start a new process for each caller, and tell that process to do shit.
  % This is not a good clean model because these processes won't necessarily exit, this is shit city.
  % Instead what we would probably want would be a pool of surfline API check-ers, and a pool of email senders. We would just send messages to each.
  send_emails(Forecast).

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

% TODO: hook something up to this. It's difficult to get gen_server to trigger this call with the current state though.
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

