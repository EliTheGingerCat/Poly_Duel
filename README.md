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

## Development strategies

To create a new script:
1. In the Polytoria Creator, create a script object.
2. Set the filesystem path to the desired place in `./build`.
3. A code file and corresponding meta file will be created.
4. Open the `.meta` file and copy the `id` value into the corresponding code file by using this specific format:

`-- ~ Polytoria link id: [id]`

I always do this as the very first line in the script, though it is technically not necessary.

5. Move the code file into the desired place in `./source`.

Every time any code file is edited, one must run `lune run build`. I think it is possible to add file watching so that the script will rebuild automatically.
