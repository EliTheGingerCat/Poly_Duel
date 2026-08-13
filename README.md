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

One can read a short explanation about each script by executing `lune list`.

#### analyse

Flags:
- `--all`: Check all code directories. This will override the positional arguments.
- `--output`: Output the analysis to `./code_errors.txt`.

Positional arguments: Code directories to check.

#### build

Use `./source` and add a header to most files. The results are stored in `./build`. Also, `./main.poly` is edited to add any new scripts.

#### diff_poly

Use Git to create `./poly_file_changes.patch`, which details the changes between the current `./main.poly` and that of the previous commit.

#### generate_inheritance_chains

Use `./.poly/luau/def.json` to create `./mock/classes/class_inheritance.luau`, which stores which classes each class inherits from, which is used by the method `NetworkedObject:IsA(...)`.

#### move_Git_files

Move directories while notifying Git of the move so that the files are considered to be renamed rather than to be deleted and created somewhere else.

This should be renamed to `Git_move_files`.

#### patch definitions

Fix (some parts of) `./.poly/luau/def.d.luau`. Ideally, these changes should be committed to the official Polytoria code rather than stay in this repository.

## Development strategies

To create a new script, simply create a file in `./source`, in the desired sub-directory.

If any code file gets edited, one must run `lune run build` before playtesting. I think it is possible to add file watching so that the script will rebuild automatically.
