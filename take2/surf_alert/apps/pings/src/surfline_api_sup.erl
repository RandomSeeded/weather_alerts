%%%-------------------------------------------------------------------
%% @doc pings top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(surfline_api_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    io:format("surfline api sup start_link ~n"),
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    io:format("surfline api sup init ~n"),
    ChildSpec = {surfline_api, {surfline_api, start_link, []},
      temporary,
      5000,
      worker,
      []},
    {ok, { {simple_one_for_one, 0, 1}, [ChildSpec]}}.
%%====================================================================
%% Internal functions
%%====================================================================
