-module(csi_server).

-behaviour(gen_server).

-export([start_link/0, terminate/1, command/2]).

-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, self(), []).

terminate(Pid) ->
    gen_server:call(Pid, terminate).

command(Pid, Command) ->
    gen_server:call(Pid, {command, Command}).

init(Handler) ->
    self() ! {setup, #{self => self()}},
    {ok, Handler}.

handle_call(terminate, _From, State) ->
  {stop, terminate, ok, State};

handle_call({command, {call, Correlation, {Module, Function} = Call, Params}}, _From, State) ->
  lager:info("incoming call request: (~p) ~p", [self(), Call]),
  Result = erlang:apply(Module, Function, Params),
  self() ! {reply, {Correlation, Result}},
  {reply, ok, State};

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

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
