-module(csi_app).
-behaviour(application).

-export([start/2, start_link/2, stop/1]).


start(_StartType, _StartParams) ->
  start_link(8080, "/ws").

start_link(Port, Path) ->
  Dispatch = cowboy_router:compile([
    {'_', [
      {Path, csi_handler, []}
    ]}
  ]),
  cowboy:start_http(http, 100, [{port, Port}], [{env, [{dispatch, Dispatch}]}]).

stop(_State) ->
  ok.   
