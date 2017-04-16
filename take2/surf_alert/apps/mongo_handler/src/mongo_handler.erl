-module(mongo_handler).
-compile(export_all).
-behavior(gen_server).

-include("include/surfline_definitions.hrl").

-record(db_info, {collection="emails",
  connection}).

% By our supervisor
start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

start_link(Args) ->
  gen_server:start_link(?MODULE, Args, []).

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

get_emails_internal(DB) ->
  Connection = DB#db_info.connection,
  Collection = <<"emails">>,
  {ok, Cursor} = mc_worker_api:find(Connection, Collection, #{}),
  AllEntries = mc_cursor:rest(Cursor),
  AllEmails = [maps:get(<<"email">>, Map) || Map <- AllEntries],
  {reply, AllEmails, DB}.

remove_email_internal(DB, Email) ->
  Connection = DB#db_info.connection,
  Collection = <<"emails">>,
  mc_worker_api:delete(Connection, Collection, #{<<"email">> => Email}).

% Short-lived processes (self-killing)
init({add_email, Email, Region}) ->
  {ok, DB} = establish_connection(),
  add_email_internal(DB, Email, Region),
  ignore;
init({remove_email, Email}) ->
  {ok, DB} = establish_connection(),
  remove_email_internal(DB, Email),
  ignore;
% Longer-lived processes
init(_DBInfo) ->
  application:ensure_all_started(mongodb),
  Database = <<"surf_alert">>,
  {ok, Connection} = mc_worker_api:connect([{database, Database}]),
  DB = #db_info{connection=Connection},
  {ok, DB}.

handle_call(get_emails, _From, DB) ->
  get_emails_internal(DB).

handle_info({ack, _Pid, {error, normal}}, State) -> % This is triggered by m_cursor:rest; it represents no more entries in the db
  {noreply, State}.

add_email(Email, Region) ->
  supervisor:start_child(mongo_handler_sup, [{add_email, Email, Region}]).

get_emails() ->
  {ok, Pid} = supervisor:start_child(mongo_handler_sup, [get_emails]),
  AllEmails = gen_server:call(Pid, get_emails),
  supervisor:terminate_child(mongo_handler_sup, Pid),
  AllEmails.

remove_email(Email) ->
  supervisor:start_child(mongo_handler_sup, [{remove_email, Email}]).
