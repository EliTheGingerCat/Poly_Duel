# Poly Duel

This is a Polytoria game I am working on.

Currently, the plan is for it to be a Polytoria version of [Libre Duel](<https://github.com/EliTheGingerCat/libre-duel>).

## Development tools

To analyse the code with the [Luau Language Server](<https://github.com/JohnnyMorganz/luau-lsp>) program:

```bash
luau-lsp analyze --settings ./.vscode/settings.json ./source
```

There are also some [Lune](<https://lune-org.github.io/docs/>) scripts.

I am working on in-game development tools. For example, I have built a barebones [explorer](./source/client/visual_interfaces/explorer.client.luau).

I want to make test scripts, along with a mock of the Polytoria datamodel.

### scripts

#### analyse

Flags:
- `--all`: Check all code directories. This will override the positional arguments.
- `--output`: Output the analysis to `./code_errors.txt`.

Positional arguments: Code directories to check.

## Development strategies

To create a new script, simply create a file in `./source`, in the desired sub-directory.

If any code file gets edited, one must run `lune run build` before playtesting. I think it is possible to add file watching so that the script will rebuild automatically.
