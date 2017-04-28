%%%-------------------------------------------------------------------
%% @doc surf_alert public API
%% @end
%%%-------------------------------------------------------------------

-module(surf_alert_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
        {'_', [
          {"/", cowboy_static, {priv_file, surf_alert, "index.html"}},
          % TODO (nw): collapse api routes into one
          {"/api/subscribe", api_handler, []},
          {"/api/unsubscribe", api_handler, []},
          {"/[...]", cowboy_static, {priv_dir, surf_alert, []}}
        ]}
    ]),
    {ok, _} = cowboy:start_clear(my_http_listener, 100,
        [{port, 1080}],
        #{env => #{dispatch => Dispatch}}
    ),
    surf_alert_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
