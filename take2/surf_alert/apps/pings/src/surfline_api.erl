-module(surfline_api).
-behavior(gen_server).
-compile(export_all).

start_link(Args) ->
  gen_server:start_link(?MODULE, Args, []).

init([]) ->
  {ok, []}.

handle_call({get_forecast, SpotId}, _From, State) ->
  ThreeDayForecast = get_forecast_internal(SpotId),
  {stop, normal, ThreeDayForecast, State}.

get_forecast_internal(SpotId) ->
  inets:start(),
  SpotId_Str = integer_to_list(SpotId),
  Url = "http://api.surfline.com/v1/forecasts/" ++ SpotId_Str ++ "?resources=analysis&days=7",
  {ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} = httpc:request(Url),
  Struct = mochijson:decode(Body),
  {struct, JSONData} = Struct,
  % This needs to actually look it up (lists:keyfind)
  {"Analysis", {struct, Analysis}} = lists:nth(5, JSONData),
  {"generalCondition", {array, RegionalForecasts}} = lists:nth(9, Analysis),
  RegionalForecasts.

get_forecast(SpotId) ->
  io:format("check forecast spotId ~p~n", [SpotId]),
  {ok, Pid} = supervisor:start_child(surfline_api_sup, [[]]),
  gen_server:call(Pid, {get_forecast, SpotId}).

terminate(Reason, _State) when Reason =:= normal; Reason =:= shutdown ->
  ok;
terminate(Reason, _State) ->
  io:format("Surfline api process terminated for reason ~p ~n", [Reason]).

