---@diagnostic disable: lowercase-global

---@param data NotificationParams Notification data
function notify(data)
    local text, type, length = data.description, data.status, data.duration
    TriggerEvent('QBCore:Notify', text, type, length)
end

return notify