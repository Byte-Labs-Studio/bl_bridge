---@diagnostic disable: lowercase-global

---@param data NotificationParams Notification data
function notify(data)
    local title, type, duration in data
    if type == 'inform' then type = 'info' end
    exports.es_extended:getSharedObject().ShowNotification(title, type, duration)
end

return notify