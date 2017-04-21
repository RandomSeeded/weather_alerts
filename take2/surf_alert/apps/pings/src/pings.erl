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
  % I really need to rename these things...
  #spot{surfline_spotId = SpotId, internal_id = RegionId} = lists:keyfind(Name, #spot.internal_id, ?Surfline_definitions),
  % TODO (nw): continuation of logic (emails) goes in the runner here
  % You'll call get_forecast with rpc:async_call (still synchronous internally inside surfline_api)
  % You'll call get_emails with rpc:async_call (same)
  % You'll then yield on both. Frickin kickass
  surfline_api:get_forecast(SpotId),
  EmailsForRegion = mongo_handler:get_emails_for_region(RegionId),
  io:format("EmailsForRegion ~p~n", [EmailsForRegion]),
  lists:foreach(fun(Email) ->
                    email:send(Email, RegionId)
                end, EmailsForRegion),
  ok.

handle_cast(run, Name) ->
  internal_run(Name),
  {noreply, Name}.

run(Name) ->
  gen_server:cast(Name, run).
