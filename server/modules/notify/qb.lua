---@diagnostic disable: lowercase-global

---@param source number Source of player
---@param data NotificationParams Notification data
function notify(source, data)
    local text, type, length = data.description, data.status, data.duration
    
    TriggerClientEvent('QBCore:Notify', source, text, type, length)
end

return notify