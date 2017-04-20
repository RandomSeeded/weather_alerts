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
