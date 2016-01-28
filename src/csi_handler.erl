-module(csi_handler).

-export([init/2]).
-export([websocket_handle/3]).
-export([websocket_info/3]).
-export([terminate/3]).

init(Req, [Module, Args, Options] = Opts) ->
  lager:info("websocket-handler init: ~p", [{self(), Opts}]),
	{ok, Pid} = gen_server:start_link(Module, [self() | Args], Options), 
	{cowboy_websocket, Req, Pid}. 

websocket_handle({binary, Data}, Req, Pid) ->
	Decoded = erlang:binary_to_term(Data),
    gen_server:call(Pid, {command, Decoded}),
	{ok, Req, Pid}.

websocket_info(Info, Req, State) ->
	{reply, {binary, term_to_binary(Info)}, Req, State}.

terminate(Reason, _Req, Pid) ->
	lager:info("websocket-handler terminate: ~p", [{self(), Reason}]),
  gen_server:cast(Pid, terminate),
  ok.
