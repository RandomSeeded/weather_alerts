-module(email).
-behavior(gen_server).
-compile(export_all).

-include("include/config.hrl").
-include("include/surfline_definitions.hrl").

start_link(Args) ->
  gen_server:start_link(?MODULE, Args, []).

init({send, {Email, InternalRegionId}}) ->
  EmailId = maps:get(<<"_id">>, Email),
  Address = maps:get(<<"email">>, Email),
  CanonicalHostUrl = maps:get(canonical_host_url, ?Config),
  UnsubscribeRegionLink = io_lib:format("~s/api/unsubscribe?alert=~s", [CanonicalHostUrl, EmailId]),
  UnsubscribeAllLink = io_lib:format("~s/api/unsubscribe?email=~s", [CanonicalHostUrl, Address]),
  #spot{surfline_url = SurflineUrl} = lists:keyfind(InternalRegionId, #spot.internal_id, ?Surfline_definitions),

  % TODO (nw): figure out how to HTML the email body / unsub links
  EmailBody = io_lib:format("Surf incoming! ~n~n~s~n~nTo unsubscribe from this alert: ~s~nTo unsubscribe from all alerts: ~s", [SurflineUrl, UnsubscribeRegionLink, UnsubscribeAllLink]),

  application:start(crypto),
  application:start(asn1),
  application:start(public_key),
  application:start(ssl),
  {ok, Password} = file:read_file("apps/pings/priv/.passwords"),
  gen_smtp_client:send({"surfalertmailer@gmail.com",
      [Address], io_lib:format("subject: surf alert\r\nfrom: Surf Alert Daemon\r\nto: ~p\r\n\r\n~s", [Address, EmailBody])},
    [{relay, "smtp.gmail.com"},
      {ssl, true},
      {username, "surfalertmailer@gmail.com"},
      {password, erlang:binary_to_list(Password)}]),
  {stop, normal}.

send(Email, InternalRegionId) ->
  supervisor:start_child(email_sup, [{send, {Email, InternalRegionId}}]),
  ok.
