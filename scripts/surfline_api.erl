-module(surfline_api).
-behavior(gen_server).

% -export([check_forecast_good/0]).

-compile(export_all).

init([]) ->
  {ok, []}.

start_link() ->
  gen_server:start_link(?MODULE, [], []).


% handle-call: for SYNC
% handle-cast: for ASYNC
% Fundamentally get_forecast is for now a synchronous operation

handle_call(get_forecast, _From, []) ->
  {reply, "Test", []};
handle_call(test, _From, []) ->
  {reply, "Test", []}.

% This should probably be a gen_server

test(Pid) ->
  gen_server:call(Pid, test).

get_forecast() ->
  inets:start(),
  Url = "http://api.surfline.com/v1/forecasts/2957?resources=analysis&days=2",
  {ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} = httpc:request(Url),
  Body.

% Helper methods
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


% Client methods
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

