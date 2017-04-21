-module(pings).
-compile(export_all).
-behavior(gen_server).

-define(ForecastThreshold, 0).
-include("include/surfline_definitions.hrl").

start_link(Name) ->
  gen_server:start_link({local, Name}, ?MODULE, Name, []).

init(Name) ->
  % Period = {daily, {10, am}},
  Period = {once, 1},
  Job = {?MODULE, run, [Name]},
  erlcron:cron({Period, Job}),
  {ok, Name}.

internal_send_emails(EmailsForRegion, RegionId, false) ->
  ok;
internal_send_emails(EmailsForRegion, RegionId, true) ->
  io:format("EmailsForRegion ~p~n", [EmailsForRegion]),
  lists:foreach(fun(Email) ->
                    email:send(Email, RegionId)
                end, EmailsForRegion),
  ok.

internal_run(Name) ->
  % TODO (nw): rename things to follow surfline_definitions conventions
  #spot{surfline_spotId = SpotId, internal_id = RegionId} = lists:keyfind(Name, #spot.internal_id, ?Surfline_definitions),
  % TODO (nw): yield api & mongo queries to run in parallel
  ForecastForRegion = surfline_api:get_forecast(SpotId),
  EmailsForRegion = mongo_handler:get_emails_for_region(RegionId),
  io:format("ForecastForRegion ~p~n", [ForecastForRegion]),
  #{ForecastForRegion := NumericForecast} = ?Surfline_qualities,
  % TODO (nw): allow users to set their own thresholds
  ShouldSendEmail = NumericForecast >= ?ForecastThreshold,
  internal_send_emails(EmailsForRegion, RegionId, ShouldSendEmail).

handle_cast(run, Name) ->
  internal_run(Name),
  {noreply, Name}.

run(Name) ->
  gen_server:cast(Name, run).
