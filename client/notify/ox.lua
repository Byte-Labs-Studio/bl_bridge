---@diagnostic disable: lowercase-global

---@param data NotificationParams Notification data
function notify(data)
    exports.ox_lib:notify(data)
end

return notify