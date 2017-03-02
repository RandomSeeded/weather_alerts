-module(mongo_handler).
-compile(export_all).
-record(db_info, {collection="emails",
    connection}).

% This function is called by the supervisor
% It is responsible for creating a mongo process via init
% And returning the processId for that process to the supervisor
start_link() ->
  register(?MODULE, Pid=spawn_link(?MODULE, init, [])),
  Pid.

% This function: initial setup and then loops
init() ->
  Database = <<"surf_alert">>,
  {ok, Connection} = mc_worker_api:connect([{database, Database}]),
  MyDB = #db_info{connection=Connection},
  loop(MyDB).

% This loop function listens from messages from our externally facing functions such as add_email
loop(MyDB) ->
  receive
    {shutdown} ->
      io:format("Shutdown~n"),
      ok;
    {Pid, MsgRef, {add_email, Email}} ->
      io:format("adding email~n"),
      Connection = MyDB#db_info.connection,
      Collection = <<"emails">>,
      mc_worker_api:insert(Connection, Collection, [#{<<"email">> => Email}]),
      Pid ! {MsgRef, ok},
      loop(MyDB);
    Unknown ->
      io:format("Unknown message ~p~n", [Unknown]),
      loop(MyDB)
  end.
% We only want to initialize the connection to the server once
% So we can pass along the state (connection) to the server in our loop call
% What happens if we become disconnected?
% DEAL WITH THAT LATER

add_email(Email) ->
  MsgRef = make_ref(),
  ?MODULE ! {self(), MsgRef, {add_email, Email}},
  receive
    {MsgRef, ok} ->
      ok
  after 2000 ->
      timeout
  end.
