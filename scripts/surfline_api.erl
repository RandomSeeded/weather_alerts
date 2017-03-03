-module(surfline_api).
-export([check_forecast_good/0]).

get_forecast() ->
  inets:start(),
  Url = "http://api.surfline.com/v1/forecasts/2957?resources=analysis&days=2",
  {ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} = httpc:request(Url),
  Body.

decode_JSON(Body) ->
  Struct = mochijson:decode(Body),
  {struct, JSONData} = Struct,
  % This needs to actually look it up (lists:keyfind)
  {"Analysis", {struct, Analysis}} = lists:nth(5, JSONData),
  {"generalCondition", {array,[_Todays_Forecast,Tomorrows_Forecast]}} = lists:nth(9, Analysis),
  Tomorrows_Forecast.

% Would be expanded for more criteria n stuff
% Additionally, this should be made somehow fault tolerant.
% Right now if the api call fails this thing just keels over and dies
check_forecast_good() ->
  Body = get_forecast(),
  Tomorrows_Forecast = decode_JSON(Body),
  case Tomorrows_Forecast of
    "fair" ->
      true;
    "good" ->
      true;
    _ ->
      false
  end.

