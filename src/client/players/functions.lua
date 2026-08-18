--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/client/players/functions.lua
--- @description Handles client side player specific functions.

--- @section Initialisation

local m = {}

--- @section Helpers

local function request_model(model, timeout)
    if HasModelLoaded(model) then return true end

    RequestModel(model)
    local start = GetGameTimer()
    local max_wait = timeout or 10000

    while not HasModelLoaded(model) do
        if GetGameTimer() - start > max_wait then
            print(("[players] request_model: Model load timeout: %s"):format(model))
            return false
        end
        Wait(0)
    end

    return true
end

local function request_anim_dict(dict, timeout)
    if HasAnimDictLoaded(dict) then return true end

    RequestAnimDict(dict)
    local start = GetGameTimer()
    local max_wait = timeout or 10000

    while not HasAnimDictLoaded(dict) do
        if GetGameTimer() - start > max_wait then
            print(("[players] request_anim_dict: Anim dict load timeout: %s"):format(dict))
            return false
        end
        Wait(0)
    end

    return true
end

--- @section Headshots

function m.get_player_headshot(player_ped)
    player_ped = player_ped or PlayerPedId()
    local headshot = RegisterPedheadshotTransparent(player_ped)
    if not (headshot and IsPedheadshotValid(headshot)) then
        return nil
    end

    local timeout, txd = 1000, nil
    while not IsPedheadshotReady(headshot) and timeout > 0 do
        Wait(10)
        timeout = timeout - 10
    end

    if IsPedheadshotReady(headshot) then
        txd = GetPedheadshotTxdString(headshot)
        SetTimeout(2000, function() UnregisterPedheadshot(headshot) end)
    else
        UnregisterPedheadshot(headshot)
    end

    return txd and ("https://nui-img/%s/%s?v=%d"):format(txd, txd, GetGameTimer())
end

--- @section Animations

function m.play_animation(player_ped, options, callback)
    player_ped = player_ped or PlayerPedId()

    if not options or not options.dict or not options.anim then
        print("[players] play_animation: options or animation dictionary/animation name is missing")
        return
    end

    request_anim_dict(options.dict)

    if options.freeze then FreezeEntityPosition(player_ped, true) end

    local duration = options.duration or 2000

    local props = {}
    if options.props then
        for _, prop in ipairs(options.props) do
            request_model(prop.model)
            local prop_entity = CreateObject(GetHashKey(prop.model), GetEntityCoords(player_ped), true, true, true)
            AttachEntityToEntity(prop_entity, player_ped, GetPedBoneIndex(player_ped, prop.bone), prop.coords.x or 0.0, prop.coords.y or 0.0, prop.coords.z or 0.0, prop.rotation.x or 0.0, prop.rotation.y or 0.0, prop.rotation.z or 0.0, true, prop.use_soft or false, prop.collision or false, prop.is_ped or true, prop.rot_order or 1, prop.sync_rot or true)
            table.insert(props, prop_entity)
        end
    end

    if options.continuous then
        TaskPlayAnim(player_ped, options.dict, options.anim, options.blend_in or 8.0, options.blend_out or -8.0, -1, options.flags or 49, options.playback or 0, options.lock_x or 0, options.lock_y or 0, options.lock_z or 0)
    else
        TaskPlayAnim(player_ped, options.dict, options.anim, options.blend_in or 8.0, options.blend_out or -8.0, duration, options.flags or 49, options.playback or 0, options.lock_x or 0, options.lock_y or 0, options.lock_z or 0)
        Wait(duration)
        ClearPedTasks(player_ped)
        if options.freeze then
            FreezeEntityPosition(player_ped, false)
        end
        for _, prop_entity in ipairs(props) do
            DeleteObject(prop_entity)
        end
        if callback then
            callback()
        end
    end
end

return m