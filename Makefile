REBAR = `which rebar3`
RELX = `which relx`

all: compile

compile:
	@( $(REBAR) compile )

clean:
	@( $(REBAR) clean)

run: compile
	@( erl -pa `pwd`/ebin _build/default/lib/*/ebin -config etc/sys.config -boot start_sasl -s csi -name csi@127.0.0.1)

erl: compile
	@( erl -pa `pwd`/ebin _build/default/lib/*/ebin -config etc/sys.config -name csi@127.0.0.1 )

.PHONY: all compile clean run
