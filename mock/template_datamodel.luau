export type object = {
	class_name: string,
	children: {object},
	declared: boolean,
	name: string,
	Polytoria_Creator: true?,
}

local template_datamodel: object = {
	class_name = "World",
	children = {
		{
			class_name = "Achievements" .. "Service",
			children = {},
			declared = true,
			name = "Achievements",
		},
		{
			class_name = "Creator" .. "Addons",
			children = {},
			declared = true,
			name = "Addons",
			Polytoria_Creator = true,
		},
		{
			class_name = "Assets" .. "Service",
			children = {},
			declared = true,
			name = "Assets",
		},
		{
			class_name = "Capture" .. "Service",
			children = {},
			declared = true,
			name = "Capture",
		},
		{
			class_name = "Chat" .. "Service",
			children = {},
			declared = true,
			name = "Chat",
		},
		{
			class_name = "CoreUI" .. "Service",
			children = {},
			declared = true,
			name = "CoreUI",
		},
		{
			class_name = "Creator" .. "Service",
			children = {},
			declared = true,
			name = "Creator",
			Polytoria_Creator = true,
		},
		{
			class_name = "CreatorContext" .. "Service",
			children = {},
			declared = true,
			name = "CreatorContext",
			Polytoria_Creator = true,
		},
		{
			class_name = "CreatorGUI",
			children = {},
			declared = true,
			name = "CreatorGUI",
			Polytoria_Creator = true,
		},
		{
			class_name = "Datastore" .. "Service",
			children = {},
			declared = true,
			name = "Datastore",
		},
		{
			class_name = "Environment",
			children = {
				{
					class_name = "Camera",
					children = {},
					declared = true,
					name = "Camera",
				}
			},
			declared = true,
			name = "Environment",
		},
		{
			class_name = "Filter" .. "Service",
			children = {},
			declared = true,
			name = "Filter",
		},
		{
			class_name = "Hidden",
			children = {},
			declared = true,
			name = "Hidden",
		},
		{
			class_name = "Creator" .. "History",
			children = {},
			declared = true,
			name = "History",
			Polytoria_Creator = true,
		},
		{
			class_name = "Http" .. "Service",
			children = {},
			declared = true,
			name = "Http",
		},
		{
			class_name = "Input" .. "Service",
			children = {},
			declared = true,
			name = "Input",
		},
		{
			class_name = "Insert" .. "Service",
			children = {},
			declared = true,
			name = "Insert",
		},
		{
			class_name = "IO" .. "Service",
			children = {},
			declared = true,
			name = "IO",
		},
		{
			class_name = "Lighting",
			children = {
				{
					class_name = "SunLight",
					children = {},
					declared = false,
					name = "SunLight",
				}
			},
			declared = true,
			name = "Lighting",
		},
		{
			class_name = "PlayerDefaults",
			children = {
				{
					class_name = "Inventory",
					children = {},
					declared = false,
					name = "Inventory",
				}
			},
			declared = true,
			name = "PlayerDefaults",
		},
		{
			class_name = "PlayerGUI",
			children = {},
			declared = true,
			name = "PlayerGUI",
		},
		{
			class_name = "Players",
			children = {},
			declared = true,
			name = "Players",
		},
		{
			class_name = "Preferences" .. "Service",
			children = {},
			declared = true,
			name = "Preferences",
		},
		{
			class_name = "Presence" .. "Service",
			children = {},
			declared = true,
			name = "Presence",
		},
		{
			class_name = "Purchases" .. "Service",
			children = {},
			declared = true,
			name = "Purchases",
		},
		{
			class_name = "ScriptService",
			children = {},
			declared = true,
			name = "ScriptService",
		},
		{
			class_name = "Creator" .. "Selections",
			children = {},
			declared = true,
			name = "Selections",
			Polytoria_Creator = true,
		},
		{
			class_name = "ServerHidden",
			children = {},
			declared = true,
			name = "ServerHidden",
		},
		-- Social is not (yet) accessible.
		{
			class_name = "Social" .. "Service",
			children = {},
			declared = false,
			name = "Social",
		},
		{
			class_name = "Stats",
			children = {},
			declared = true,
			name = "Stats",
		},
		{
			class_name = "Teams",
			children = {},
			declared = true,
			name = "Teams"
		},
		-- Temporary is not accessible.
		{
			class_name = "Temporary",
			children = {},
			declared = false,
			name = "Temporary",
		},
		{
			class_name = "Tween" .. "Service",
			children = {},
			declared = true,
			name = "Tween",
		},
		-- Worlds is accessible but not defined in the type definitions.
		{
			class_name = "Worlds" .. "Service",
			children = {},
			declared = false,
			name = "Worlds",
		},
	},
	declared = true,
	name = "World",
}

-- Some have "Service" after, some have "Creator" before.

return template_datamodel
