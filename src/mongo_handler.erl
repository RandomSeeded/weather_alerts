-module(mongo_handler).
-compile(export_all).

start() ->
  ok.

init() ->
  ok.

add_email(Email) ->
  Database = <<"surf_alert">>,
  Collection = <<"emails">>,
  application:ensure_all_started(mongodb),
  {ok, Connection} = mc_worker_api:connect([{database, Database}]),
  mc_worker_api:insert(Connection, Collection, [#{<<"email">> => Email}]),
  ok.

