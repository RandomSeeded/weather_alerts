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
%
% OPTIONS (for surfline_api processes)
% 1) simple_one_for_one, created on-demand
% 2) created beforehand, named according to spots [permanent]
%   - weirdness here is that worker 1 needs to know the name of worker 2 (same name for both)
% 3) created on-demand manually no supervisor (the API methods call start_link upon themselves)
% 4) created on-demand manually with supervisor support (the API method calls supervisor:start_child) [transient]
%
% CONCURRENCY? How can we make as concurrent as possible?
% Current approach is:
% check regions
% if region meets criteria for quality, issue DB query for recipients
% send emails to each of the recipients
%
% IDEALLY (everything below done per region, simultaneously)
% 1) check regions and issue db call in parallel
% 2) when both are done (RPC YIELD BALLLER), filter to correct recipients
% 3) spawn email process for each recipient and send em out
internal_run() ->
  io:format("Checking Forecast~n"),
  lists:foreach(fun(S) ->
                    SpotId = S#spot.surfline_spotId,
                    io:format("SpotId ~p~n", [SpotId])
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
