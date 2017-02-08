-module(csi_handler).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).
-export([terminate/3]).

init(Req, State) ->
	{cowboy_websocket, Req, State}.

websocket_init(_State) ->
	{ok, _} = csi_server:start_link().

websocket_handle({binary, Data}, Pid) ->
	Decoded = erlang:binary_to_term(Data),
	ok = csi_server:command(Pid, Decoded),
	{ok, Pid}.

websocket_info(Info, State) ->
	{reply, {binary, term_to_binary(Info)}, State}.

terminate(Reason, undefined, Pid) ->
	lager:info("websocket handler ~p terminated with reason ~p", [self(), Reason]),
	ok = csi_server:terminate(Pid).
