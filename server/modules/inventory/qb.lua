if GetResourceState('qb-inventory') ~= 'started' then
    error('The imported file from the chosen framework isn\'t starting')
    return
end

local qb_inventory = exports['qb-inventory']
local Inventory = {}

function Inventory.saveInventory(source, isOffline)
    qb_inventory:SaveInventory(source, isOffline)
end

function Inventory.getTotalWeight(items)
    return qb_inventory:GetTotalWeight(items)
end

function Inventory.getSlotsByItem(items, itemName)
    return qb_inventory:GetSlotsByItem(items, itemName)
end

function Inventory.getFirstSlotByItem(items, itemName)
    return qb_inventory:GetFirstSlotByItem(items, itemName)
end

return Inventory