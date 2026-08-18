--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/shared/globals/print.lua
--- @description Internal print function with coloured tags nothing special.

--- @section Constants

local PRINT = print
local LOG_COLOURS = { 
    reset = "^7", 
    debug = "^6", 
    info = "^5", 
    success = "^2", 
    warn = "^3", 
    error = "^8", 
    critical = "^1", 
    dev = "^9" 
}

--- @section Function

local function _print(level, message, force)
    if not message then message, level = level, "info" end
    if not force and not GetConvarBool("rig:debug", false) then return end

    local _time = IsDuplicityVersion() and os.date("%Y-%m-%d %H:%M:%S") or (GetLocalTime and ("%04d-%02d-%02d %02d:%02d:%02d"):format(GetLocalTime()) or "0000-00-00 00:00:00")
    local _clr = LOG_COLOURS[level] or "^7"
    local _res = GetCurrentResourceName()

    PRINT(("%s[%s] [%s] [%s]:^7 %s"):format(_clr, _time, _res, level:upper(), message))
end

--- @section Globals

_G.PRINT = PRINT
_G.print = _print