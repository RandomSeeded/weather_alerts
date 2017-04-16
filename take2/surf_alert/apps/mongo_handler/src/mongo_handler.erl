-module(mongo_handler).
-compile(export_all).
-behavior(gen_server).

-include("include/surfline_definitions.hrl").

-record(db_info, {collection="emails",
  connection}).

% By our supervisor
start_link() ->
  io:format("Mongo handler start_link!~n"),
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

start_link({add_email, Email, Region}) -> % you NEED to make this start_link more generic
  io:format("Start link Email, Region ~p ~p~n",[Email, Region]),
  gen_server:start_link(?MODULE, {add_email, Email, Region}, []);
start_link(get_emails) ->
  gen_server:start_link(?MODULE, get_emails, []).

establish_connection() ->
  application:ensure_all_started(mongodb),
  Database = <<"surf_alert">>,
  {ok, Connection} = mc_worker_api:connect([{database, Database}]),
  DB = #db_info{connection=Connection},
  {ok, DB}.

add_email_internal(DB, Email, Region) ->
  ListRegion = binary_to_list(Region),
  InternalRegion = lists:keyfind(ListRegion, #spot.display_name, ?Surfline_definitions),
  RegionId = InternalRegion#spot.internal_id,
  Connection = DB#db_info.connection,
  Collection = <<"emails">>,
  mc_worker_api:insert(Connection, Collection, [#{<<"email">> => Email, <<"region">> => Region}]),
  {ok, DB}.

get_emails(DB) ->
  io:format("Retrieving emails...~n"),
  Connection = DB#db_info.connection,
  Collection = <<"emails">>,
  {ok, Cursor} = mc_worker_api:find(Connection, Collection, #{}),
  AllEntries = mc_cursor:rest(Cursor),
  AllEmails = [maps:get(<<"email">>, Map) || Map <- AllEntries],
  {ok, AllEmails}.

% By gen server
init({add_email, Email, Region}) ->
  {ok, DB} = establish_connection(),
  add_email_internal(DB, Email, Region),
  ignore;
% init(get_emails) ->
%   io:format("mongo handler worker init get emails ~n"),
%   {ok, DB} = establish_connection(),
%   {ok, AllEmails} = get_emails(DB),
%   io:format("AllEmails ~p~n", [AllEmails]),
%   {ok, AllEmails};
init(_DBInfo) ->
  io:format("Mongo handler worker init~n"),
  io:format("DBinfo ~p ~n", [_DBInfo]),
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
handle_call(_,_,_) ->
  io:format("UNEXPECTED ~n"),
  {reply, [], []}.

handle_info({ack, _Pid, {error, normal}}, State) -> % This is triggered by m_cursor:rest; it represents no more entries in the db
  {noreply, State};
handle_info(Info, State) ->
  io:format("Received handle request for info ~p state ~p~n", [Info, State]),
  {noreply, State}.

% By other applications etc.
get_emails() ->
  {ok, Pid} = supervisor:start_child(mongo_handler_sup, [get_emails]),
  AllEmails = gen_server:call(Pid, get_emails),
  supervisor:terminate_child(mongo_handler_sup, Pid),
  AllEmails.
