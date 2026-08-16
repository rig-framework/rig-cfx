--- @class TestReactorExtension
--- @description Never references TestExtension directly - shows decoupling via the event bus.

local TestReactorExtension = {}

function TestReactorExtension:on_load()
    local player = self.player
    player:add_data("test_reactor", { triggered_by = nil, count = 0 }, true)

    player:on("test_stat_depleted", function(p, stat)
        local reactor = p:get_data("test_reactor")
        reactor.triggered_by = stat
        reactor.count = reactor.count + 1
        p:set_data("test_reactor", reactor, true)

        -- e.g. this is where Injuries/Effects would react to Statuses without knowing it exists
        p:emit("test_reaction_fired", stat)
    end)
end

function TestReactorExtension:on_save()
    return {}
end

return TestReactorExtension