%%%-------------------------------------------------------------------
%% @doc mongo_handler top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(mongo_handler_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, add_email/2]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

% This logic should be MAYBE be moved into the worker
% Though it seems kind of weird to have the worker call out to its supervisor...
add_email(Email, Region) ->
  % Doesnt make sense to grab the below Pid anymore.
  {ok, Pid} = supervisor:start_child(?MODULE, [{add_email, Email, Region}]).

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
