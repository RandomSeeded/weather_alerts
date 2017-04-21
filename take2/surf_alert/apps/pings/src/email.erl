-module(email).
-behavior(gen_server).
-compile(export_all).

-include("include/surfline_definitions.hrl").

start_link(Args) ->
  gen_server:start_link(?MODULE, Args, []).

init({send, {EmailAddress, InternalRegionId}}) ->
  io:format("Sending Email to ~p ~p~n", [EmailAddress, InternalRegionId]),
  {ok, []}.

send(EmailAddress, InternalRegionId) ->
  supervisor:start_child(email_sup, [{send, {EmailAddress, InternalRegionId}}]),
  ok.
