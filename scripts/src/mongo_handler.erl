-module(mongo_handler).
-compile(export_all).
-behavior(gen_server).
-record(db_info, {collection="emails",
    connection}).


% This function is called by the supervisor
% It is responsible for creating a mongo process via init
% And returning the processId for that process to the supervisor
start_link() ->
  gen_server:start_link(?MODULE, init, []).

% This function: initial setup and then loops
init(_DBInfo) ->
  application:ensure_all_started(mongodb),
  Database = <<"surf_alert">>,
  {ok, Connection} = mc_worker_api:connect([{database, Database}]),
  MyDB = #db_info{connection=Connection},
  {ok, MyDB}.

handle_call(get_emails, _From, MyDB) ->
  io:format("Retrieving emails...~n"),
  Connection = MyDB#db_info.connection,
  Collection = <<"emails">>,
  Res = mc_worker_api:find_one(Connection, Collection, #{}), %% CHANGE TO FIND ALL (need to work w/ mc_cursor)
  {reply, Res, MyDB}.

get_emails(Pid) ->
  gen_server:call(Pid, get_emails).

% This loop function listens from messages from our externally facing functions such as add_email
% loop(MyDB) ->
%   receive
%     {shutdown} ->
%       io:format("Shutdown~n"),
%       ok;
%     {Pid, MsgRef, {add_email, Email}} ->
%       io:format("adding email~n"),
%       Connection = MyDB#db_info.connection,
%       Collection = <<"emails">>,
%       mc_worker_api:insert(Connection, Collection, [#{<<"email">> => Email}]),
%       Pid ! {MsgRef, ok},
%       loop(MyDB);
%     {Pid, MsgRef, get_emails} ->
%       io:format("Retrieving emails...~n"),
%       Connection = MyDB#db_info.connection,
%       Collection = <<"emails">>,
%       mc_worker_api:find(Connection, Collection, [#{}]),
%       Pid ! {MsgRef, ok},
%       loop(MyDB);
%     Unknown ->
%       io:format("Unknown message ~p~n", [Unknown]),
%       loop(MyDB)
%   end.

