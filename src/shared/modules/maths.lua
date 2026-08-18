--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @module maths
--- @file src/shared/modules/maths.lua
--- @description Extra math utilities beyond standard Lua maths library

--- @section Constants

local EPSILON = 1e-10 -- Epsilon for floating-point comparisons

--- @section Initialisation

local m = {}

--- @section Core

function m.clamp(val, lower, upper)
    if lower > upper then lower, upper = upper, lower end
    return math.max(lower, math.min(upper, val))
end

function m.lerp(a, b, t)
    return a + (b - a) * t
end

--- @section 3D Geometry

function m.calculate_distance(start_coords, end_coords)
    local dx = end_coords.x - start_coords.x
    local dy = end_coords.y - start_coords.y
    local dz = end_coords.z - start_coords.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

--- @section Probability

function m.random_between(min, max, rand_func)
    if type(min) ~= "number" or type(max) ~= "number" then
        error("Min and max must be numbers")
    end

    if min > max then
        min, max = max, min
    end

    rand_func = rand_func or math.random
    return min + rand_func() * (max - min)
end

function m.random_int(min, max, rand_func)
    if type(min) ~= "number" or type(max) ~= "number" then
        error("Min and max must be numbers")
    end

    min, max = math.floor(min), math.floor(max)

    if min > max then
        min, max = max, min
    end

    if min == max then
        return min
    end

    rand_func = rand_func or math.random
    return math.floor(rand_func() * (max - min + 1)) + min
end

function m.chance(probability, rand_func)
    if type(probability) ~= "number" then
        error("Probability must be a number")
    end

    if probability < 0 or probability > 1 then
        error("Probability must be between 0.0 and 1.0")
    end

    rand_func = rand_func or math.random
    return rand_func() < probability
end

function m.percent_chance(percentage, rand_func)
    if type(percentage) ~= "number" then
        error("Percentage must be a number")
    end

    if percentage < 0 or percentage > 100 then
        error("Percentage must be between 0 and 100")
    end

    return m.chance(percentage / 100, rand_func)
end

function m.random_choice(tbl, rand_func)
    if type(tbl) ~= "table" or #tbl == 0 then
        return nil
    end

    rand_func = rand_func or math.random
    local index = math.floor(rand_func() * #tbl) + 1
    return tbl[index]
end

function m.weighted_choice(map, rand_func)
    if type(map) ~= "table" then
        error("Map must be a table")
    end

    rand_func = rand_func or math.random

    local total = 0
    for _, w in pairs(map) do
        if type(w) ~= "number" then
            error("All weights must be numbers")
        end
        if w > 0 then
            total = total + w
        end
    end

    if total < EPSILON then
        return nil
    end

    local thresh = rand_func() * total
    local cumulative = 0

    for key, w in pairs(map) do
        if w > 0 then
            cumulative = cumulative + w
            if thresh < cumulative then
                return key
            end
        end
    end

    for key, w in pairs(map) do
        if w > 0 then
            local last_key = key
            for k, wt in pairs(map) do
                if wt > 0 then
                    last_key = k
                end
            end
            return last_key
        end
    end

    return nil
end

function m.shuffle(tbl, rand_func)
    if type(tbl) ~= "table" then
        error("Input must be a table")
    end

    rand_func = rand_func or math.random

    for i = #tbl, 2, -1 do
        local j = math.floor(rand_func() * i) + 1
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end

    return tbl
end

return m