-module(csi_server).

-behaviour(gen_server).

-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

init([Handler | _Other] = Args) ->
    process_flag(trap_exit, true),
    lager:info("~p init ~p -> ~p", [?MODULE, {self(), Handler}, Args]),
    self() ! {setup, #{self => self()}},
    {ok, Handler}.

handle_call(terminate, _From, State) ->
  {stop, terminate, ok, State};

handle_call({command, {call, #{correlation := Correlation} = Header, {Module, Function} = Call, Params}}, _From, Handler) ->
  lager:info("~p incoming call request: ~p -> ~p | ~p", [?MODULE, {self(), Handler}, Header, Call]),
  Result = erlang:apply(Module, Function, Params), 
  self() ! {reply, {Correlation, Result}},
  {reply, ok, Handler};

handle_call({command, {send, Pid, Message}}, _From, State) ->
  Pid ! Message,
  {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(Message, Handler) ->
  ToSend = case Message of
    {setup, _} -> Message;
    {reply, _} -> Message;
    Other      -> {message, Other}
  end,
  Handler ! ToSend,
  {noreply, Handler}.

terminate(Reason, Handler) ->
    lager:info("~p terminate: ~p -> ~p", [?MODULE, {self(), Handler}, Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
