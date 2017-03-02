-module(mongo_handler).
-compile(export_all).
-record(db_info, {collection="emails",
    database="surf_alert",
    connection}).


% This function is called by the supervisor
% It is responsible for creating a mongo process via init
% And returning the processId for that process to the supervisor
% do you also need a start_link? Maybe.
start_link() ->
  io:format("MONGO HANDLER START"),
  register(?MODULE, Pid=spawn_link(?MODULE, init, [])),
  Pid.

% This function calls out to loop. Why? See below.
init() ->
  io:format("MONGO HANDLER INIT"),
  Database = "surf_alert",
  {ok, Connection} = mc_worker_api:connect([{database, Database}]),
  DB_Info = #db_info{connection=Connection},
  loop(DB_Info).

% This function listens for messages
% FUNDAMENTALLY THE WAY THIS WORKS IS IT RECEIVES MESSAGES FROM YOUR FUNCTIONS
% BAM NOW IT MAKES SENSE
loop(DB_Info) ->
  receive
    {shutdown} ->
      io:format("Shutdown~n"),
      ok;
    {Pid, MsgRef, {add_email, _Email}} ->
      io:format("adding email~n"),
      Pid ! {MsgRef, ok},
      loop(DB_Info);
    Unknown ->
      io:format("Unknown message ~p~n", [Unknown]),
      loop(DB_Info)
  end.
% We only want to initialize the connection to the server once
% So we can pass along the state (connection) to the server in our loop call
% What happens if we become disconnected?
% DEAL WITH THAT LATER

add_email(Email) ->
  io:format("add_email wrapper ~p~n",[Email]),
  % Crashing because the module has not been registered! We never started it.
  MsgRef = make_ref(),
  ?MODULE ! {self(), MsgRef, {add_email, Email}},
  receive
    {MsgRef, ok} ->
      ok
  after 2000 ->
      timeout
  end.
