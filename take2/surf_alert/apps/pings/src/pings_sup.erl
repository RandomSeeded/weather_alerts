%%%-------------------------------------------------------------------
%% @doc pings top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(pings_sup).

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
    {ok, { {rest_for_one, 0, 1}, [
          {pings, {pings, start_link, []},
          permanent,
          5000,
          worker,
          []}
          ]
         }}.

%%====================================================================
%% Internal functions
%%====================================================================
