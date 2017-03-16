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
      [Recipient], "Subject: New Test123456"},
    [{relay, "smtp.gmail.com"},
      {ssl, true},
      {username, "SurfAlertMailer@gmail.com"},
      {password, erlang:binary_to_list(Password)}]),
  {noreply, Password}.

send_email(Pid, Recipient) ->
  gen_server:cast(Pid, {send_email, Recipient}).

