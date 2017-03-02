-module(api_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Req0, State) ->
  Method = cowboy_req:method(Req0),
  HasBody = cowboy_req:has_body(Req0),
  io:format("HasBody~p~n", [HasBody]),
  Req = handle(Method, HasBody, Req0),
  {ok, Req, State}.

handle(<<"POST">>, true, Req) ->
  cowboy_req:reply(200, #{
    <<"content-type">> => <<"text/plain">>
  }, "OK", Req);
handle(<<"POST">>, false, Req) ->
  cowboy_req:reply(400, #{
    <<"content-type">> => <<"text/plain">>
  }, "Invalid request", Req);
handle(_Method, _HasBody, Req) ->
  cowboy_req:reply(405, Req).
