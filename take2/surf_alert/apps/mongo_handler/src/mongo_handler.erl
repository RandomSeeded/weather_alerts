-module(mongo_handler).
-compile(export_all).
-behavior(gen_server).
-record(db_info, {collection="emails",
  connection}).

% By our supervisor
start_link() ->
  io:format("Mongo handler start_link!~n"),
  gen_server:start_link({global, ?MODULE}, ?MODULE, [], []). % I should be able to do gen_server:start_link({local, ?module}), but I can't! Why not?

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
  %gen_server:call(?MODULE, {add_email, {Email, Region}}).
  gen_server:call({global, ?MODULE}, add_email).

% How do we create an externally facing API method?
% In ppool_server, we were passed a Name, and we invoked gen_server with that name. Named process.
% Taking in a process seems kinda janky. Why should the caller need to do a start_link? That seems wrong.
% Possible alternate answer: you might not need to do anything differently. You might not need to talk to the supervisor to do a start_link() and api methods on the worker. Is that really reasonable? Not sure.
% OK SO: the _app.erl file now is our API. How does that call out to the workers though?
% OK SO HERE'S HOW IT WORKS
% You give your process a name. Common convention is {local, ?MODULE}.
% We then address all future calls to that same name. Wham bam we're done.
% The API can call this function, which does NOT need to take in the name as a parameter, because it knows the name, because the name is ?MODULE.
%
% The way Fred H does it is slightly different; the name for the pool is provided by the user. He then has to address all future calls to the API for the specific sup to reach out to. This is OK, but not my favorite.
% STILL AN OPEN QUESTION: what happens if we have multiple of these? Does shit break? It seems like it would; we would have two named the same thing, and after we called out to gen_server, it wouldn't know which process to respond to...right?
% WHAT DOES LOCALLY REGISTERED MEAN??
% Local vs. global: determines whether the name is accessible to other nodes in the cluster. We still have named this process. This sucks. This sucks this sucks.
% BUT BUT BUT BUT BUT: just how does a gen_server:call with ?MODULE work anyway? Is that actually a named process?
% OH SNAP. If ServerName={local,Name}, the gen_server process is registered locally as Name using register/2.
% The gen_server process...NOT the individual worker process. o.O
% SO. That means invocations to that same gen_server process WITH THAT NAME may not necessarily go to a specific worker.
% That may or may not be true. I don't know. But we can test this.

