-module(mongo_handler).
-compile(export_all).
-behavior(gen_server).
-record(db_info, {collection="emails",
  connection}).

% By our supervisor
start_link() ->
  io:format("Mongo handler start_link!~n"),
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

start_link(Email, Region) ->
  io:format("Email, Region ~p ~p~n",[Email, Region]).

% By gen server
init(_DBInfo) ->
  io:format("Mongo handler worker init~n"),
  application:ensure_all_started(mongodb),
  Database = <<"surf_alert">>,
  {ok, Connection} = mc_worker_api:connect([{database, Database}]),
  MyDB = #db_info{connection=Connection},
  {ok, MyDB}.

handle_call(get_emails, _From, MyDB) ->
  io:format("Retrieving emails...~n"),
  Connection = MyDB#db_info.connection,
  Collection = <<"emails">>,
  {ok, Cursor} = mc_worker_api:find(Connection, Collection, #{}),
  AllEntries = mc_cursor:rest(Cursor),
  AllEmails = [maps:get(<<"email">>, Map) || Map <- AllEntries],
  {reply, AllEmails, MyDB};
handle_call(add_email, _From, MyDB) ->
  io:format("Called! ~n"),
  {reply, [], MyDB};
handle_call(_,_,_) ->
  io:format("UNEXPECTED ~n"),
  {reply, [], []}.

handle_info({ack, _Pid, {error, normal}}, State) -> % This is triggered by m_cursor:rest; it represents no more entries in the db
  {noreply, State};
handle_info(Info, State) ->
  io:format("Received handle request for info ~p state ~p~n", [Info, State]),
  {noreply, State}.

% By other applications etc.
get_emails(Pid) ->
  gen_server:call(Pid, get_emails).

add_email(Email, Region) ->
  io:format("worker add_email ~n"),
  gen_server:call(?MODULE, add_email).
% Annoyingly, as this is a named process, we can only have one worker acting as the mongo_handler.
% We could fix that by either:
% - having dynamic supervision, and having our API call our supervisor to spin up a new child
%   - we'd need additional complexity around not spinning up too much; this basically recreates ppool and is a lot of complexity
%   - (do we really need that additional complexity? Maybe not...we could just terminate/delete when we're done)
% - using a pool library (poolboy)
% Upon further investigation: this seems like a case for simple-one-for-one
% No children are added at the start
% When we need to perform an operation, the API will call supervisor:start_child(Sup, List)
% When the call is done, we can do supervisor:terminate_child

% CLEANUP: handled by the worker returning a tuple starting with stop! SO SIMPLE
% WHEN YOU REGISTER A SUPERVISOR CHILD: you supply a MFA tuple which represents the function called when you start the child
% We could just have two 'inits' which had a guard around the MFA tuple
% And then we reach out to do_xxx methods
% That ain't that bad
