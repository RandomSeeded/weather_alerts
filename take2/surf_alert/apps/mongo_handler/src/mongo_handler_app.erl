%%%-------------------------------------------------------------------
%% @doc mongo_handler public API
%% @end
%%%-------------------------------------------------------------------

-module(mongo_handler_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1, add_email/2]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    io:format("mongo_handler_app start~n"),
    mongo_handler_sup:start_link().

% Move location of add_email to mongo_handler
add_email(Email, Region) ->
    io:format("mongo handler app add_email ~n"),
    mongo_handler_sup:add_email(Email, Region).

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
