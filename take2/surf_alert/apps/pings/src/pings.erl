-module(pings).
-compile(export_all).
-behavior(gen_server).

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
  Period = {daily, {every, {10, sec}, {between, {1, am}, {11, pm}}}},
  Job = {io, format, ["Hi ~n"]},
  erlcron:cron({Period, Job}),
  {ok, []}.
