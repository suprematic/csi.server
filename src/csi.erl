-module(csi).

-export([start/0]).

start() ->
  ok = application:start(compiler),
  ok = application:start(syntax_tools),
  ok = application:start(goldrush),
  ok = application:start(lager),
  ok = application:start(sync),
  ok = application:start(inets),
  ok = application:start(ranch),
  ok = application:start(crypto),
  ok = application:start(cowlib),
  ok = application:start(cowboy),
  ok = application:start(csi).
