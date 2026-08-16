--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/client/gui/modal.lua
--- @description Server side modal handling, nothing special.

--- @section Function

--- Shows a modal
--- @param source number: Player source
--- @param opts table: Modal options
local function build_modal(source, opts)
    if not source or not opts then
        print("error", "build_modal: Player source or opts missing")
        return
    end
    TriggerClientEvent("rig:client:build_modal", source, opts)
end

exports("build_modal", build_modal)