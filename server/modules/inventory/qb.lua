local coreResourceName = 'qb-core'

if GetResourceState(coreResourceName) ~= 'started' then
    error('resource '..coreResourceName.. ' not started')
    return
end

local Inventory = {}

local Functions = exports[coreResourceName]:GetCoreObject().Functions
Inventory.UseItem = Functions.UseItem
Inventory.CanUseItem = Functions.CanUseItem
Inventory.GetItemByName = Functions.GetItemByName

return Inventory