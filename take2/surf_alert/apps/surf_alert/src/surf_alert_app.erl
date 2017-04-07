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

% start(_StartType, _StartArgs) ->
%     {ok, Pid} = 'cowboy_hello_world_sup':start_link(),
%     Routes = [ {
%         '_',
%         [
%             {"/", cowboy_hello_world_root, []}
%         ]
%     } ],
%     Dispatch = cowboy_router:compile(Routes),
% 
%     NumAcceptors = 10,
%     TransOpts = [ {ip, {0,0,0,0}}, {port, 2938} ],
%     ProtoOpts = [{env, [{dispatch, Dispatch}]}],
% 
%     {ok, _} = cowboy:start_http(chicken_poo_poo,
%         NumAcceptors, TransOpts, ProtoOpts),
% 
%     {ok, Pid}.

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
        {'_', [
          % {"/", cowboy_static, {priv_file, surf_alert, "index.html"}},
          % {"/api/email-submit", api_handler, []}
          {"/api/email-submit", toppage_handler, []}
          % {"/api/email-unsubscribe", api_handler, []},
          % {"/[...]", cowboy_static, {priv_dir, surf_alert, []}}
        ]}
    ]),
    {ok, _} = cowboy:start_clear(my_http_listener, 100,
        [{port, 8081}],
        #{env => #{dispatch => Dispatch}}
    ),
    surf_alert_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
