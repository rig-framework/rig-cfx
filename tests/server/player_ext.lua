--- @class TestExtension
--- @description Minimal extension for testing the load/method/data/event flow end to end.

local TestExtension = {}

function TestExtension:on_load()
    local player = self.player
    player:add_data("test_stats", { hunger = 100, thirst = 100 }, true)

    player:add_method("adjust_test_stat", function(stat, amount)
        local stats = player:get_data("test_stats")
        if not stats or stats[stat] == nil then return false end

        local before = stats[stat]
        stats[stat] = math.max(0, math.min(100, stats[stat] + amount))
        player:set_data("test_stats", stats, true)

        if before > 0 and stats[stat] <= 0 then
            player:emit("test_stat_depleted", stat)
        end

        return true
    end)
end

function TestExtension:on_save()
    return {}
end

return TestExtension