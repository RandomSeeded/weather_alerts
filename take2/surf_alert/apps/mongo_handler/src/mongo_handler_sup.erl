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
    io:format("Mongo handler supervisor start_link~n"),
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    io:format("Mongo handler supervisor init~n"),
    {ok, { {one_for_all, 0, 1}, [
          {mongo_handler, {mongo_handler, start_link, []},
          permanent,
          5000,
          worker,
          []}
          ]} }.

%%====================================================================
%% Internal functions
%%====================================================================
