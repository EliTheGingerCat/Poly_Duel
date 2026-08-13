# Poly Duel

This is a Polytoria game I am working on.

Currently, the plan is for it to be a Polytoria version of [Libre Duel](<https://github.com/EliTheGingerCat/libre-duel>).

## Development tools

### in-game

- datamodel explorer
- selection outlines

### mock

There is some work done on a mock of the Polytoria datamodel.

The mock is not usable yet.

Location: `./mock`.

### tests

There are no tests yet. This is something that I want to implement using the mock.

### scripts

#### analyse

Flags:
- `--all`: Check all code directories. This will override the positional arguments.
- `--output`: Output the analysis to `./code_errors.txt`.

Positional arguments: Code directories to check.

## Development strategies

To create a new script, simply create a file in `./source`, in the desired sub-directory.

If any code file gets edited, one must run `lune run build` before playtesting. I think it is possible to add file watching so that the script will rebuild automatically.
