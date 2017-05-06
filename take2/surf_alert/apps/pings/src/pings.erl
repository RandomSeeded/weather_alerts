-module(pings).
-compile(export_all).
-behavior(gen_server).

-include("include/config.hrl").
-include("include/surfline_definitions.hrl").

start_link(Name) ->
  gen_server:start_link({local, Name}, ?MODULE, Name, []).

init(Name) ->
  Period = maps:get(cron_period, ?Config),
  Job = {?MODULE, run, [Name]},
  erlcron:cron({Period, Job}),
  {ok, Name}.

internal_send_emails(EmailsForRegion, RegionId) ->
  lists:foreach(fun(Email) ->
                    email:send(Email, RegionId)
                end, EmailsForRegion),
  ok.

get_running_maximum(Acc, CurrentMax, [Elem|Tail]) when Elem > CurrentMax ->
  get_running_maximum([Elem|Acc], Elem, Tail);
get_running_maximum(Acc, CurrentMax, [Elem|Tail]) when Elem =< CurrentMax ->
  get_running_maximum([CurrentMax|Acc], CurrentMax, Tail);
get_running_maximum(Acc, _CurrentMax, []) ->
  lists:reverse(Acc).

internal_run(Name) ->
  % TODO (nw): rename things to follow surfline_definitions conventions
  #spot{surfline_spotId = SpotId, internal_id = RegionId} = lists:keyfind(Name, #spot.internal_id, ?Surfline_definitions),
  % TODO (nw): yield api & mongo queries to run in parallel
  RegionalForecasts = [maps:get(Forecast, ?Surfline_qualities, -1) || Forecast <- surfline_api:get_forecast(SpotId)],
  % TODO (nw): this should be a hash and not a list
  TopForecastInPeriod = get_running_maximum([], 0, RegionalForecasts),
  EmailsForRegion = mongo_handler:get_emails_for_region(RegionId),
  EmailsMeetingThreshold = lists:filter(fun(#{<<"thresholdId">> := ThresholdId, <<"withinPeriod">> := WithinPeriod}) ->
                                            lists:nth(WithinPeriod, TopForecastInPeriod) >= ThresholdId
                                        end, EmailsForRegion),
  internal_send_emails(EmailsMeetingThreshold, RegionId).

handle_cast(run, Name) ->
  internal_run(Name),
  {noreply, Name}.

run(Name) ->
  gen_server:cast(Name, run).
