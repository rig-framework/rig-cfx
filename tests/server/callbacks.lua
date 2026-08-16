local callbacks = require("src.core.server.callbacks.functions")

callbacks.register("test_ping", function(source, data, cb)
    print(("[Callback Test] test_ping received from %s - data: %s"):format(source, tostring(data and data.msg)))
    cb({ reply = "pong", received = data and data.msg, from_source = source })
end)