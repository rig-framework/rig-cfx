local gui_functions = require("src.core.shared.gui.functions")

RegisterCommand("test_server_notify", function(source, args, raw)
    TriggerClientEvent("rig:client:notify", source, {
        header = "Test Notification",
        type = "info",
        message = "Test notification from server.",
        duration = 3500
    })
end, false)

RegisterCommand("test_server_modal", function(source, args, raw)
    local modal = gui_functions.sanitize({
        title = "Edit Item",
        options = {
            { id = "item_name", label = "Item Name", type = "text" },
            { id = "amount", label = "Amount", type = "number", min = 1, max = 100 }
        },
        buttons = {
            {
                id = "save_item",
                label = "Save",
                on_action = function(data)
                    print(("[Modal Test] save_item fired - item_name=%s amount=%s"):format(
                        data and data.dataset and data.dataset.item_name,
                        data and data.dataset and data.dataset.amount
                    ))
                    TriggerClientEvent("rig:client:close_modal", source)
                end,
                dataset = {
                    source = "inventory",
                    item_id = "some_id"
                }
            },
            {
                id = "cancel",
                label = "Cancel"
            }
        }
    })

    TriggerClientEvent("rig:client:build_modal", source, modal)
end, false)