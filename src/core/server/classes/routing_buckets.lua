--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @class RoutingBuckets
--- @file src/server/classes/routing_buckets.lua
--- @description Manages routing buckets, preset configurations, player switching, and runtime settings.

--- @section Initialisation

local RoutingBuckets = {}
RoutingBuckets.__index = RoutingBuckets

RoutingBuckets.auto_id = 10000
RoutingBuckets.buckets = {}
RoutingBuckets.player_buckets = {}

--- @section Helpers

function RoutingBuckets:_apply_natives(bucket_id, config)
    if config.population_enabled ~= nil then
        SetRoutingBucketPopulationEnabled(bucket_id, config.population_enabled)
    end

    if config.mode then
        SetRoutingBucketEntityLockdownMode(bucket_id, config.mode)
    end
end

--- @section Factory

function RoutingBuckets.new(preset_buckets)
    local self = setmetatable({
        buckets = {},
        player_buckets = {},
        auto_id = 10000
    }, RoutingBuckets)

    -- @todo MOVE TO CONFIG FILE
    self:register("main", {
        label = locale("core.server.routing_buckets.label_main"),
        bucket = 0,
        mode = "strict",
        population_enabled = false
    })

    if type(preset_buckets) == "table" then
        for key, config in pairs(preset_buckets) do
            self:register(key, config)
        end
    end

    return self
end

--- @section Buckets

function RoutingBuckets:register(key, config)
    config.bucket = config.bucket or self.auto_id
    config.players = config.players or {}

    self.buckets[key] = config
    self:_apply_natives(config.bucket, config)

    print("info", locale("core.server.routing_buckets.registered", key, config.bucket))
    return config
end

function RoutingBuckets:get_bucket(key)
    return self.buckets[key]
end

function RoutingBuckets:set_setting(key, setting, value)
    local b = self.buckets[key]
    if not b then return false end

    b[setting] = value

    if setting == "population_enabled" or setting == "mode" then
        self:_apply_natives(b.bucket, b)
    end

    print("debug", locale("core.server.routing_buckets.setting_updated", key, setting, tostring(value)))
    return true
end

function RoutingBuckets:toggle_setting(key, setting)
    local b = self.buckets[key]
    if not b or type(b[setting]) ~= "boolean" then return false end

    return self:set_setting(key, setting, not b[setting])
end

--- @section Players

function RoutingBuckets:set_player_bucket(source, target_key)
    local target = self.buckets[target_key]
    if not target then
        print("error", locale("core.server.routing_buckets.bucket_not_exists", tostring(target_key)))
        return false
    end

    if target.player_cap and type(target.player_cap) == "number" then
        local current_count = 0
        for _ in pairs(target.players) do current_count = current_count + 1 end
        if current_count >= target.player_cap then
            print("warn", locale("core.server.routing_buckets.bucket_full", source, target_key, current_count, target.player_cap))
            return false
        end
    end

    local old_key = self.player_buckets[source]
    if old_key and self.buckets[old_key] then
        self.buckets[old_key].players[source] = nil
    end

    self.player_buckets[source] = target_key
    target.players[source] = true

    SetPlayerRoutingBucket(source, target.bucket)
    print("info", locale("core.server.routing_buckets.player_moved", source, target_key, target.bucket))
    return true
end

function RoutingBuckets:get_player_bucket(source)
    local key = self.player_buckets[source]
    return key and self.buckets[key]
end

--- @section Personal Buckets

function RoutingBuckets:assign_personal(source, custom_config)
    local key = "personal_" .. source
    local bucket_id = self.auto_id
    self.auto_id = self.auto_id + 1

    local config = custom_config or {
        label = locale("core.server.routing_buckets.label_personal"),
        bucket = bucket_id,
        mode = "strict",
        population_enabled = false
    }
    config.bucket = bucket_id

    self:register(key, config)
    self:set_player_bucket(source, key)
    return key
end

function RoutingBuckets:release_personal(source, fallback_key)
    fallback_key = fallback_key or "main"
    local personal_key = "personal_" .. source

    self:set_player_bucket(source, fallback_key)

    if self.buckets[personal_key] then
        self.buckets[personal_key] = nil
        print("debug", locale("core.server.routing_buckets.personal_released", source))
    end
end

return RoutingBuckets