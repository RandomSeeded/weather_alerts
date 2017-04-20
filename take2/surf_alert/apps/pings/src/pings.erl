-module(pings).
-compile(export_all).
-behavior(gen_server).

-include("include/surfline_definitions.hrl").

start_link(Name) ->
  gen_server:start_link({local, Name}, ?MODULE, Name, []).

init(Name) ->
  % Period = {daily, {10, am}},
  Period = {once, 1},
  Job = {?MODULE, run, [Name]},
  erlcron:cron({Period, Job}),
  {ok, Name}.

internal_run(Name) ->
  #spot{surfline_spotId = SpotId} = lists:keyfind(Name, #spot.internal_id, ?Surfline_definitions),
  surfline_api:get_forecast(SpotId).

handle_cast(run, Name) ->
  internal_run(Name),
  {noreply, Name}.

run(Name) ->
  gen_server:cast(Name, run).

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
%    - possibly.
%    - why NOT? s1f1 kinda clunky when you're doing async returns like this
%    - also cleanup sucks (have to terminate children). Does it though? exit(normal) or terminate_child or gen_server:stop or {stop, reason, reply, newstate}
% 2) created beforehand, named according to spots [permanent]
%   - weirdness here is that worker 1 needs to know the name of worker 2 (same name for both)
%   - pro: we dont actually need dynamic supervision...and this fits the bill
%   - con: what if the process dies and isnt restarted in time? Also they need to be permanent.
%   - con2: the two processes for the spot (runner and api) cant have same name
%   - the prefixing thing is super hacky and seems generally frowned upon. Dont do it.
%   - OK SO: you dont actually need to have the processes be registered / named at all for the surfline API!
% 3) created on-demand manually no supervisor (the API methods call start_link upon themselves)
%   - no! Bad practice to have workers supervising other workers (even via a link)
% 4) created on-demand manually with supervisor support (the API method calls supervisor:start_child) [transient, not s1f1?]
%    - possibly
%    - cleanup sucks though this would suck. Not that bad actually you just exit(normal) or do {stop, reason}.
%
% FINAL THOUGHTS RE ^
% Runner processes are named. We start_link them from the supervisor. They are transient. Always up. Never dupes for a single region.
% We then call out to run_all_the_shit(Name)
% This then does a gen_server:call/cast(Name)
% HOWEVER the surfline API processes dont need to be created ahead of time or named. We will just call supervisor:create_child(), when we want one, it will have no name, and then it will call {stop, } at the end.
% This can be either dynamic supervision s1f1 or dynamic supervision normal. Either is fine.

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
