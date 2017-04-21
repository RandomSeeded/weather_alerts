-module(email).
-behavior(gen_server).
-compile(export_all).

-include("include/surfline_definitions.hrl").

start_link(Args) ->
  gen_server:start_link(?MODULE, Args, []).

init({send, {EmailAddress, InternalRegionId}}) ->
  io:format("Sending Email to ~p ~p~n", [EmailAddress, InternalRegionId]),
  application:start(crypto),
  application:start(asn1),
  application:start(public_key),
  application:start(ssl),
  #spot{surfline_url = SurflineUrl} = lists:keyfind(InternalRegionId, #spot.internal_id, ?Surfline_definitions),
  {ok, Password} = file:read_file("apps/pings/priv/.passwords"),
  % TODO (nw): add unsubscribe email link here
  gen_smtp_client:send({"surfalertmailer@gmail.com",
      [EmailAddress], io_lib:format("subject: surf alert\r\nfrom: surf alert daemon\r\nto: ~p\r\n\r\nsurf incoming! ~n~n~s", [EmailAddress, SurflineUrl])},
    [{relay, "smtp.gmail.com"},
      {ssl, true},
      {username, "surfalertmailer@gmail.com"},
      {password, erlang:binary_to_list(Password)}]),
  {stop, normal}.

send(EmailAddress, InternalRegionId) ->
  supervisor:start_child(email_sup, [{send, {EmailAddress, InternalRegionId}}]),
  ok.
