--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/core/server/callbacks/functions.lua
--- @description Server-side callback registration and lookup.

--- @section Imports

local CallbackRegistry = require("src.core.server.callbacks.registry")

--- @section Initialisation

local m = {}

--- @section Functions

function m.register(name, cb)
    if not name or type(cb) ~= "function" then
        print("error", locale(core.server.callbacks.register_failed, name or "nil"))
        return
    end

    if CallbackRegistry:has("callbacks", name) then
        print("warn", locale(core.server.callbacks.callback_overwrite, name))
    end

    CallbackRegistry:set("callbacks", name, cb)
end

function m.get(name)
    return CallbackRegistry:get("callbacks", name)
end

return m