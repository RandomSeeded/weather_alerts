-module(mongo_handler).
-compile(export_all).
-behavior(gen_server).
-record(db_info, {collection="emails",
  connection}).

% By our supervisor
start_link() ->
  io:format("Mongo handler start_link!~n"),
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

% By gen server
init(_DBInfo) ->
  io:format("Mongo handler Init!~n"),
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
