-module(surfline_api).
-behavior(gen_server).
-compile(export_all).

start_link(Args) ->
  gen_server:start_link(?MODULE, Args, []).


