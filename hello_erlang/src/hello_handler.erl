-module(hello_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Req0, State) ->
    Req = cowboy_req:reply(200,
        #{<<"content-type">> => <<"text/html">>},
        <<"<html><head><title>Sup</title></head><body><p>Hello Erlang!</p></body></html>">>,
        Req0),
    {ok, Req, State}.
