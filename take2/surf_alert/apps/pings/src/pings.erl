-module(pings).
-compile(export_all).
-behavior(gen_server).

-include("include/surfline_definitions.hrl").

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
  % Period = {daily, {every, {10, sec}, {between, {1, am}, {11, pm}}}},
  Period = {daily, {10, am}},
  Job = {io, format, ["Hi ~n"]},
  erlcron:cron({Period, Job}),
  {ok, []}.

internal_run() ->
  io:format("Checking Forecast~n"),
  lists:foreach(fun(S) ->
                    SpotId = S#spot.surfline_spotId,
                    io:format("SpotId ~p~n", [SpotId])
                    % Surfline API should totally be its own thing
                    % OK SO it needs to have dynamically created processes, ye
                    % But that sounds like a job for a one-for-one spervisor :wink:
                    % {ok, SurflinePid} = surfline_api:start_link(),
                    % Forecast = surfline_api:check_forecast_good(SurflinePid, SpotId),
                    % send_emails(Forecast),
                    % exit(SurflinePid, normal)
                end, ?Surfline_definitions).

handle_cast(run, State) ->
  internal_run(),
  {noreply, State}.

run() ->
  gen_server:cast(?MODULE, run).
