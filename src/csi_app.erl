-module(csi_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
  Dispatch = cowboy_router:compile([
		{'_', [
			{"/ws", csi_handler, []}
		]}
	]),
	cowboy:start_http(http, 100, [{port, 8080}], [{env, [{dispatch, Dispatch}]}]).

stop(_State) ->
  ok.   
