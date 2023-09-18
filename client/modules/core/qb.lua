
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    TriggerEvent('bl_bridge:client:playerLoaded')
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    TriggerEvent('bl_bridge:client:playerUnloaded')
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(...)
    TriggerEvent('bl_bridge:client:jobUpdated', ...)
end)

return {}