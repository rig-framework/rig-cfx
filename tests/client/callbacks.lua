local callbacks = require("src.client.callbacks.functions")

RegisterCommand("test_callback", function(source, args, raw)
    print("[Callback Test] triggering test_ping...")

    callbacks.trigger("test_ping", { msg = "hello from client" }, function(response)
        if not response then
            print("[Callback Test] no response received.")
            return
        end
        print(("[Callback Test] server replied: reply=%s received=%s from_source=%s"):format(
            tostring(response.reply), tostring(response.received), tostring(response.from_source)
        ))
    end)
end, false)