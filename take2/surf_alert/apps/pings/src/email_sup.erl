%%%-------------------------------------------------------------------
%% @doc pings top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(email_sup).

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
    io:format("email sup start_link ~n"),
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    io:format("email sup init ~n"),
    ChildSpec = {email, {email, start_link, []},
      temporary,
      5000,
      worker,
      []},
    {ok, { {simple_one_for_one, 0, 1}, [ChildSpec]}}.
%%====================================================================
%% Internal functions
%%====================================================================
