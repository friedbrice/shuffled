.PHONY: all
all: clean compile test run

.PHONY: clean
clean:
	if [ -d lib ]; then rm -r lib; fi
	if [ -d bin ]; then rm -r bin; fi

.PHONY: compile
compile: Shuffled.hs ShuffledApp.hs
	mkdir -p lib
	mkdir -p bin
	ghc -outputdir lib -o bin/shuffled \
	    -O2 -funfolding-use-threshold=16 -optc-O3 \
	    ShuffledApp.hs

.PHONY: test
test: Shuffled.hs ShuffledTest.hs test-cases.txt
	runghc ShuffledTest.hs

.PHONY: run
run: Shuffled.hs ShuffledApp.hs bin/shuffled
	find sample-input/ -type f \
	| sort \
	| xargs -L 1 \
	| while read file; do echo; echo $$file; time bin/shuffled < $$file; done

bin/shuffled: Shuffled.hs ShuffledApp.hs compile
