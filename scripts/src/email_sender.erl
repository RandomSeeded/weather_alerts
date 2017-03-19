-module(email_sender).
-compile(export_all).

-behavior(gen_server).

start_link() ->
  gen_server:start_link(?MODULE, [], []).

% This function: initial setup and then loops
init([]) ->
  application:start(crypto),
  application:start(asn1),
  application:start(public_key),
  application:start(ssl),
  {ok, Password} = file:read_file("../.passwords"),
  {ok, Password}.

handle_cast({send_email, Recipient}, Password) ->
  gen_smtp_client:send({"SurfAlertMailer@gmail.com",
      [Recipient], io_lib:format("Subject: Surf Alert\r\nFrom: Surf Alert Daemon\r\nTo: ~p\r\n\r\nSurf incoming! http://www.surfline.com/surf-forecasts/northern-california/sf-san-mateo-county_2957", [Recipient])},
    [{relay, "smtp.gmail.com"},
      {ssl, true},
      {username, "SurfAlertMailer@gmail.com"},
      {password, erlang:binary_to_list(Password)}]),
  {noreply, Password}.

send_email(Pid, Recipient) ->
  gen_server:cast(Pid, {send_email, Recipient}).

