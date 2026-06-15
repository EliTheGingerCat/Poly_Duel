--> Generate the chain of inheritance for each class for `IsA` to use.

local fs = require("@lune/fs")
local serde = require("@lune/serde")

type event_parameter = {
	IsOptional: boolean,
	Name: string,
	Type: string,
}

type event = {
	Name: string,
	Parameters: {event_parameter}?,
}

type method_parameter = {
	DefaultValue: string,
	IsOptional: boolean,
	Name: string,
	Type: string,
}

type method = {
	IsAsync: boolean,
	IsObsolete: boolean,
	IsSemiStatic: boolean,
	IsStatic: boolean,
	Name: string,
	Parameters: {method_parameter},
	ReturnType: string,
}

type property = {
	IsAccessibleByScripts: boolean,
	IsObsolete: boolean,
	IsReadOnly: boolean,
	IsStatic: boolean,
	Name: string,
	Type: string,
}

type class = {
	BaseType: string?,
	Events: {event},
	IsAbstract: boolean,
	IsInstantiable: boolean,
	IsStatic: boolean,
	Methods: {method},
	Name: string,
	Properties: {property},
	StaticAlias: string?,
}

type enum = {
	InternalName: string,
	Options: {string},
	Name: string,
}

type API_data = {
	Classes: {class},
	Enums: {enum},
	InstanceClasses: {string},
	Version: string,
}

type chain = {string}

local API_JSON = fs.readFile("./.poly/luau/def.json")
local API_data: API_data = serde.decode("json", API_JSON)

local chains: {[string]: chain} = {}

for _, class in API_data.Classes do
	if class.BaseType ~= nil then
		-- I think that, by design, a class always comes after its base-type.
		local previous_chain: chain? = chains[class.BaseType]
		if previous_chain == nil then
			print(`Error: Class "{class.Name}" appeared before its base-type, "{class.BaseType}".`)
			return
		end

		local chain: chain = table.clone(previous_chain)
		table.insert(chain, 1, class.BaseType)
		chains[class.Name] = chain
	else
		chains[class.Name] = {}
	end
end

local output_pieces: {string} = {
	"-- This file was automatically generated.",
	"",
	"export type chain = {string}",
	"",
	"local class_inheritance: {[string]: chain} = {",
}
for chain_name, chain in chains do
	local chain_string = "{\"" .. table.concat(chain, "\", \"") .. "\"}"
	table.insert(output_pieces, `\t{chain_name} = {chain_string},`)
end
table.insert(output_pieces, "}")
table.insert(output_pieces, "")
table.insert(output_pieces, "return class_inheritance")
table.insert(output_pieces, "")
local output = table.concat(output_pieces, "\n")

fs.writeFile("./mock/classes/class_inheritance.luau", output)
