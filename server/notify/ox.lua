---@diagnostic disable: lowercase-global

---@param source number Source of player
---@param data NotificationParams Notification data
local function notify(source, data)
    TriggerClientEvent('ox_lib:notify', source, data)
end

return notify