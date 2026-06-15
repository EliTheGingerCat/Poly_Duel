local instance = require("./instance")

type instance = instance.instance

type file_link_asset = {
	LinkedId: string,
}

export type script = instance & {
	LinkedScript: file_link_asset,
}

type mix = {
	[string]: any,
}

local function create_file_link_asset(): file_link_asset
	local file_link_asset: file_link_asset = {
		LinkedId = "",
	}

	return file_link_asset
end

local function fix_general_instance(mixed_up: mix): ()
	local file_link_asset = create_file_link_asset()
	file_link_asset.LinkedId = mixed_up.LinkedScript
	mixed_up.LinkedScript = file_link_asset
end

local script_mod = {
	fix_general_instance = fix_general_instance,
}

return script_mod
