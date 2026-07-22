local symbol_empty_array = "$<empty array>"
local symbol_null = "$<null>"

local pattern_empty_array = "\"%$<empty array>\""
local pattern_null = "\"%$<null>\""

local function replace(basic: string): string
	local with_empty_array = string.gsub(basic, pattern_empty_array, "[]")
	local with_null = string.gsub(with_empty_array, pattern_null, "null")
	return with_null
end

-- ~ Todo: Use generic type instantiation.
local symbol_empty_array_any: {any} = symbol_empty_array :: any

local replace_JSON = {
	empty_array = symbol_empty_array,
	empty_array_any = symbol_empty_array_any,
	null = symbol_null,
	replace = replace,
}

return replace_JSON
