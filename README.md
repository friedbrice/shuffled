# friedbrice/shuffled

Command line utility that determines if line 3 of stdin can be derived from lines 1 and 2 by shuffling once.

## Example

For the below input:

```
0 1 2 3
4 5 6 7
0 4 1 2 5 3 6 7
```

The expected output is `True`.

For the below input:

```
l l l l
r r r
l l l r r r r
```

The expected output is `False`.

See _test-cases.txt_ for further examples.

## Setup

You'll need `make`, `ghc`, and (optionally) `python3` and `numpy` installed.

Use `make compile` to compile a native binary.

Use `make test` to run unit tests.

Use `make run` to exercise the compiled native binary.

## Considerations

The present implementation does not complete the final unit test in a reasonable amount of time.
