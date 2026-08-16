--- @file src/core/server/callbacks/functions.lua
--- @description Server-side callback registration and lookup.

--- @section Imports

local CallbackRegistry = require("src.core.server.callbacks.registry")

--- @section Initialisation

local m = {}

--- @section Functions

function m.register(name, cb)
    if not name or type(cb) ~= "function" then
        print(("[callbacks] Failed to register callback: %s"):format(name or "nil"))
        return
    end

    if CallbackRegistry:has("callbacks", name) then
        print(("[callbacks] Overwriting existing callback: %s"):format(name))
    end

    CallbackRegistry:set("callbacks", name, cb)
end

function m.get(name)
    return CallbackRegistry:get("callbacks", name)
end

return m