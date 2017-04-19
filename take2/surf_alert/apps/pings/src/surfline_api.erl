-module(surfline_api).
-behavior(gen_server).
-compile(export_all).

start_link(Args) ->
  gen_server:start_link(?MODULE, Args, []).

init({check_forecast, SpotId}) ->
  ThreeDayForecast = get_forecast(SpotId),
  {stop, normal, ThreeDayForecast, []}.

get_forecast(SpotId) ->
  inets:start(),
  SpotId_Str = integer_to_list(SpotId),
  Url = "http://api.surfline.com/v1/forecasts/" ++ SpotId_Str ++ "?resources=analysis&days=4",
  {ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} = httpc:request(Url),
  Struct = mochijson:decode(Body),
  {struct, JSONData} = Struct,
  % This needs to actually look it up (lists:keyfind)
  {"Analysis", {struct, Analysis}} = lists:nth(5, JSONData),
  {"generalCondition", {array, RegionalForecasts}} = lists:nth(9, Analysis),
  ThreeDayForecast = lists:nth(4, RegionalForecasts), % Get the forecast for three days out
  io:format("ThreeDayForecast ~p ~p~n", [ThreeDayForecast, SpotId]),
  ThreeDayForecast.

check_forecast(SpotId) ->
  io:format("check forecast spotId ~p~n", [SpotId]),
  supervisor:start_child(surfline_api_sup, [{check_forecast, SpotId}]).
