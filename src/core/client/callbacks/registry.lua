--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/core/client/callbacks/registry.lua
--- @description Client-side pending-callback storage.

local Registry = require("src.core.shared.classes.registry")

return Registry.new()