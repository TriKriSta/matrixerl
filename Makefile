APP_NAME = matrixerl

all: compile

compile: clear
	$(shell mkdir -p ebin)
	@erlc -I include -pa ebin/ -o ebin/ src/*.erl

compile_test: compile
	@erlc -I include  -pa ebin/ -o ebin/ test/*.erl

clear:
	@rm -f ebin/*.beam
	@rm -f erl_crash.dump
