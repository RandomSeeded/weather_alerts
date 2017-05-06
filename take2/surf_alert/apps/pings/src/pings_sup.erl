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

-include("include/surfline_definitions.hrl").
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
    InternalSpots = [S#spot.internal_id || S <- ?Surfline_definitions],
    RunnerSpecs = [{Name, {pings, start_link, [Name]},
        permanent,
        50000,
        worker,
        []} || Name <- InternalSpots],
    ApiSupervisor = [{api_supervisor, {surfline_api_sup, start_link, []},
        permanent,
        5000,
        supervisor,
        []}],
    EmailSupervisor = [{email_supervisor, {email_sup, start_link, []},
        permanent,
        5000,
        supervisor,
        []}],
    {ok, { {one_for_one, 5, 30}, RunnerSpecs ++ ApiSupervisor ++ EmailSupervisor }}.
%%====================================================================
%% Internal functions
%%====================================================================
