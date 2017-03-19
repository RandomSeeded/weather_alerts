-module(api_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Req0, State) ->
  Method = cowboy_req:method(Req0),
  Path = cowboy_req:path(Req0),
  Req = handle(Method, Path, Req0),
  {ok, Req, State}.

handle(<<"POST">>, <<"/api/email-submit">>, Req0) ->
  {ok, KeyValues, Req} = cowboy_req:read_urlencoded_body(Req0),
  Email = proplists:get_value(<<"email">>, KeyValues),
  mongo_handler:add_email(Email),
  cowboy_req:reply(200, #{
    <<"content-type">> => <<"text/plain">>
  }, "OK", Req);
handle(<<"POST">>, <<"/api/email-unsubscribe">>, Req0) ->
  {ok, KeyValues, Req} = cowboy_req:read_urlencoded_body(Req0),
  Email = proplists:get_value(<<"email">>, KeyValues),
  mongo_handler:remove_email(Email),
  cowboy_req:reply(200, #{
    <<"content-type">> => <<"text/plain">>
  }, "OK", Req);
handle(_Method, _Path, Req) ->
  cowboy_req:reply(405, Req).



