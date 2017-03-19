-module(surf_alert_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

-include("surfline_definitions.hrl").

start(_Type, _Args) ->
    % Example HRL usage and lookup
    % Test = ?Surfline_definitions,
    % io:format("Test ~p~n", [Test]),
    % SF = lists:keyfind(sf, #spot.internal_id, Test),
    % io:format("SF ~p~n", [SF]),

    % SUPER JANKY HACK UNTIL I CAN FIGURE OUT HOW TO START ON STARTUP
    _MongoSup = mongo_handler_sup:start(mongo_handler, []),
    Dispatch = cowboy_router:compile([
        {'_', [
          {"/", cowboy_static, {priv_file, surf_alert, "index.html"}},
          {"/api/email-submit", api_handler, []},
          {"/api/email-unsubscribe", api_handler, []}
        ]}
    ]),
    {ok, _} = cowboy:start_clear(my_http_listener, 100,
        [{port, 8080}],
        #{env => #{dispatch => Dispatch}}
    ),
    surf_alert_sup:start_link().

stop(_State) ->
	ok.
