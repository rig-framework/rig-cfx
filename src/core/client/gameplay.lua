--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @script src.client.gameplay
--- @description Handles client side gameplay loop

--- @section Helpers

local function split_ids(str)
    local out = {}
    for id in str:gmatch("[^,]+") do
        out[#out + 1] = tonumber(id)
    end
    return out
end

--- @section Config

local cfg = rig.settings.gameplay
local hud_components = split_ids(cfg.hud_components)
local disable_controls = split_ids(cfg.disable_controls_list)

--- @section Setup

if cfg.disable_dispatch then
    for i = 1, 15 do EnableDispatchService(i, false) end
end

if cfg.disable_police_scanner then
    SetAudioFlag("PoliceScannerDisabled", true)
end

if cfg.disable_garbage_trucks then
    SetGarbageTrucks(false)
end

if cfg.disable_random_cops then
    SetCreateRandomCops(false)
    SetCreateRandomCopsNotOnScenarios(false)
    SetCreateRandomCopsOnScenarios(false)
end

if cfg.disable_weapon_autoreload then
    SetWeaponsNoAutoreload(true)
end

if cfg.disable_weapon_autoswap then
    SetWeaponsNoAutoswap(true)
end

--- @section Functions

local has_command_suggestions = false

local function request_suggestions(force)
    if has_command_suggestions and not force then return end
    has_command_suggestions = true
    TriggerServerEvent("rig:server:get_command_suggestions")
end

--- @section Threads

local player_id = PlayerId()

if cfg.hide_hud_components or cfg.disable_controls or cfg.hide_ammo or cfg.invalidate_idle_cam then
    CreateThread(function()
        while true do
            if cfg.hide_hud_components then
                for i = 1, #hud_components do HideHudComponentThisFrame(hud_components[i]) end
            end
            if cfg.disable_controls then
                for i = 1, #disable_controls do DisableControlAction(0, disable_controls[i], true) end
            end
            if cfg.hide_ammo then
                DisplayAmmoThisFrame(false)
            end
            if cfg.invalidate_idle_cam then
                InvalidateIdleCam()
                InvalidateVehicleIdleCam()
            end
            Wait(0)
        end
    end)
end

if cfg.disable_wanted or cfg.artificial_lights then
    CreateThread(function()
        while true do
            if cfg.disable_wanted then
                ClearPlayerWantedLevel(player_id)
            end
            if cfg.artificial_lights then
                SetArtificialLightsState(true)
                SetArtificialLightsStateAffectsVehicles(true)
            end
            Wait(100)
        end
    end)
end

CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(250)
    end
    Wait(1000)
    request_suggestions()
end)