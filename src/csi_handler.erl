-module(csi_handler).

-export([init/2]).
-export([websocket_handle/3]).
-export([websocket_info/3]).

init(Req, Opts) ->
	self() ! {setup, #{self => self()}},
	{cowboy_websocket, Req, Opts}.

handle_inbound({call, Correlation, {Module, Function}, Params}) ->
	Result = erlang:apply(Module, Function, Params),
	self() ! {reply, {Correlation, Result}};

handle_inbound({send, Pid, Message}) ->
	Pid ! Message.

websocket_handle({binary, Data}, Req, State) ->
	Decoded = erlang:binary_to_term(Data),
	lager:info("received data: ~p", [Decoded]),
	handle_inbound(Decoded),
	{ok, Req, State}.

% reply message
websocket_info({reply, _} = Reply, Req, State) ->
	{reply, {binary, term_to_binary(Reply)}, Req, State};

% setup message
websocket_info({setup, _} = Info, Req, State) ->
	{reply, {binary, term_to_binary(Info)}, Req, State};

% any received message is passed to the client
websocket_info(Info, Req, State) ->
	lager:info("received generic message: ~p", [Info]),
	{reply, {binary, term_to_binary({message, Info})}, Req, State}.
