-- ~ Polytoria link id: 284100cd-1cb7-40f7-beb0-a67b31d651b1

type callback<T...> = (T...) -> ()

export type signal<T...> = {
	callbacks: {callback<T...>}
}

type connection = {
	index: number,
}

local function signal_create(): signal<any>
	local signal: signal<any> = {
		callbacks = {},
	}
	return signal
end

local function signal_connect<T...>(signal: signal<T...>, callback: callback<T...>): connection
	local index = #signal.callbacks + 1
	signal.callbacks[index] = callback
	local connection: connection = {
		index = index,
	}
	return connection
end

local function signal_disconnect(signal: signal<any>, index: number): ()
	table.remove(signal.callbacks, index)
end

local function signal_fire<T...>(signal: signal<T...>, ...: T...): ()
	for _, callback in signal.callbacks do
		callback(...)
	end
end

local function signal_destroy(signal: signal<any>): ()
	table.clear(signal.callbacks)
	table.clear(signal)

	local husk: any = signal
	husk["what"] = "Destroyed object. Was formerly a signal."
end

local signal_mod = {
	create = signal_create,
	connect = signal_connect,
	destroy = signal_destroy,
	disconnect = signal_disconnect,
	fire = signal_fire,
}

return signal_mod
