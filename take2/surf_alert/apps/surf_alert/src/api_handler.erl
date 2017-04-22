-module(api_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Req0, State) ->
  Method = cowboy_req:method(Req0),
  Path = cowboy_req:path(Req0),
  Req = handle(Method, Path, Req0),
  {ok, Req, State}.

unsubscribe_internal(AlertId, _Email) when AlertId =/= [] ->
  mongo_handler:remove_alert(AlertId);
unsubscribe_internal(_AlertId, Email) when Email =/= [] ->
  mongo_handler:remove_email(Email).

handle(<<"POST">>, <<"/api/email-submit">>, Req0) ->
  {ok, KeyValues, Req} = cowboy_req:read_urlencoded_body(Req0),
  Email = proplists:get_value(<<"email">>, KeyValues),
  Region = proplists:get_value(<<"region">>, KeyValues),
  mongo_handler:add_email(Email, Region),
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
handle(<<"GET">>, <<"/api/unsubscribe">>, Req) ->
  #{alert := AlertId, email := Email} = cowboy_req:match_qs([{alert, [], ""}, {email, [], ""}], Req),
  unsubscribe_internal(AlertId, Email),
  cowboy_req:reply(200, #{
      <<"content-type">> => <<"text/plain">>
      }, "OK", Req);
handle(_Method, _Path, Req) ->
  cowboy_req:reply(405, Req).

