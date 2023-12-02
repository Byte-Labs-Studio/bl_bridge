---@diagnostic disable: lowercase-global

---@param source number Source of player
---@param data NotificationParams Notification data
function notify(data)
    local title, type in data
    TriggerClientEvent('QBCore:Notify', source, title, type)
end

return notify