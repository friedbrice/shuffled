# friedbrice/shuffled

Command line utility that determines if line 3 of stdin can be derived from lines 1 and 2 by shuffling once.

## Example

For the below input:

```
OBFUSCATION
eschew
OBesFUScCheATIwON
```

The expected output is `True`.

For the below input:

```
OBFUSCATION
eschew
OBesFSUcCheATIwON
```

The expected output is `False`.

See _test-cases.txt_ and _sample-input/_ for further examples.

## Setup

You'll need `make`, `haskell-platform`, and (optionally) `python3` installed.

Use `make compile` to compile a native binary with optimizations.

Use `make test` to run unit tests in interpreted mode (slow).

Use `make run` to exercise the native binary against the sample input.

## Considerations

The present implementation does not complete the final test case in a reasonable amount of time.
