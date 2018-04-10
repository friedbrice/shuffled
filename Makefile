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
	| xargs -L 1 \
	| while read file; do bin/shuffled < $$file; done

.PHONY: install
install: clean compile test run
	mkdir -p ${HOME}/bin
	cp bin/shuffled ${HOME}/bin

.PHONY: uninstall
uninstall:
	if [ -f ${HOME}/bin/shuffled ]; then rm ${HOME}/bin/shuffled; fi

bin/shuffled: Shuffled.hs ShuffledApp.hs compile
