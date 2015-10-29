REBAR = `which rebar`
RELX = `which relx`


all: deps compile

deps:
	@( $(REBAR) get-deps )

compile:
	@( $(REBAR) compile )

rel:
	@( $(RELX) -o rel )

clean:
	@( $(REBAR) clean && rm -rf rel/csi)

run:
	@( erl -pa `pwd`/ebin deps/*/ebin -boot start_sasl -s csi -name csi@127.0.0.1)

erl:
	@( erl -pa `pwd`/ebin deps/*/ebin -name csi@127.0.0.1 )


.PHONY: all deps compile clean run rel
