-module(csi_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
  Dispatch = cowboy_router:compile([
		{'_', [
			{"/ws", csi_handler, []}
		]}
	]),
  Port = application:get_env(csi, port, 8080),
	{ok, _} = Result = cowboy:start_clear(http, 100, [{port, Port}], #{env => #{dispatch => Dispatch}}),
  lager:info("CSI websocket listener started on port: ~p", [Port]),
  Result.

stop(_State) ->
  cowboy:stop_listener(http),
  ok.
