-module(csi_app).
-behaviour(application).

-export([start/2, start_link/3, stop/1]).


start(_StartType, _StartParams) ->
  %%"/admin/ws"
  start_link(8080, "/ws", {csi_server, [], []}).

start_link(Port, Path, {Module, Args, Options}) ->
  application:ensure_all_started(cowboy),
  Dispatch = cowboy_router:compile([
    {'_', [
      {Path, csi_handler, [Module, Args, Options]}
    ]}
  ]),
  cowboy:start_http(http, 100, [{port, Port}], [{env, [{dispatch, Dispatch}]}]).

stop(_State) ->
  ok.   
