-module(surf_alert_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
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
