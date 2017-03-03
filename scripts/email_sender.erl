-module(email_sender).
-export([start/0, test/0]). 

test() ->
  ok.

start() -> 
  application:start(crypto),
  application:start(asn1),
  application:start(public_key),
  application:start(ssl),
  {ok, Password} = file:read_file("../.passwords"),
  Recipient = "nawnate@gmail.com",
  gen_smtp_client:send_blocking({"SurfAlertMailer@gmail.com",
      [Recipient], "Subject: New Test123456"},
    [{relay, "smtp.gmail.com"},
      {ssl, true},
      {username, "SurfAlertMailer@gmail.com"},
      {password, erlang:binary_to_list(Password)}]),
  erlang:halt(0).

