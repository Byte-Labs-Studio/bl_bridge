---@diagnostic disable: lowercase-global

---@param source number Source of player
---@param data NotificationParams Notification data
function notify(source, data)
    local title, type, duration in data
    if type == 'inform' then type = 'info' end
    TriggerClientEvent('esx:showNotification', source, title, type, duration)
end

return notify