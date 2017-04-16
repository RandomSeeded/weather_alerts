%%%-------------------------------------------------------------------
%% @doc mongo_handler top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(mongo_handler_sup).

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
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    {ok, { {simple_one_for_one, 3, 60}, [
          {mongo_handler, {mongo_handler, start_link, []},
          temporary,
          5000,
          worker,
          []}
          ]} }.

%%====================================================================
%% Internal functions
%%====================================================================
