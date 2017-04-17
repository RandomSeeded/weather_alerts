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

% OK SO: whats the plan?
% ISSUES: 
% 1) we should be running all the surfline API calls in parallel, not in sequence
% 2) we should be able to handle failures gracefully
%
% THOUGHTS:
% 1) We should have multiple 'runner' processes. We should have one for each region.
% 2) These don't need to be dynamically generated; we have a fixed list of one per region
% 3) These can be shared code and just take in the region info as part of the init. Ballin.
% 4) What about the surfline API? You could do the same thing for those and have a fixed amount?
% 5) Alternately you could spin up new ones as needed with simple_one_for_one...given that it's a fixed amount, I don't see any need for dynamic supervision. Create the sub-process via start_link in init, given the same name. There's no need for any supervision of the sub-processes at all.
% 6) If the link dies, the process dies, and the supervisor restarts this. We're fine.
internal_run() ->
  io:format("Checking Forecast~n"),
  lists:foreach(fun(S) ->
                    SpotId = S#spot.surfline_spotId,
                    io:format("SpotId ~p~n", [SpotId])
                    % Surfline API should totally be its own thing
                    % OK SO it needs to have dynamically created processes, ye
                    % But that sounds like a job for a one-for-one spervisor :wink:
                    % How do you want to handle failure cases though? You don't want to crash this job just because one of the sub-jobs failed...ESPECIALLY because this is an API call.
                    % Unrelated, these should be able to run in parallel. This shit is blocking.
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
