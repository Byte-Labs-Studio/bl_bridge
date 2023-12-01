---@diagnostic disable: lowercase-global

---@param data NotificationParams Notification data
function notify(data)
    local title, type in data
    TriggerEvent('QBCore:Notify', title, type)
end

return notify