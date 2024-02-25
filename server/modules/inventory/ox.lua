if GetResourceState('ox_inventory') ~= 'started' then
    error('The imported file from the chosen framework isn\'t starting')
    return {}
end
local retreiveExportsData = require 'utils'.retreiveExportsData
local overrideFunction = {}
local ox_inventory = exports.ox_inventory

overrideFunction.methods = retreiveExportsData(ox_inventory, {
    addItem = {
        originalMethod = 'AddItem',
        modifier = {
            passSource = true,
        }
    },
    removeItem = {
        originalMethod = 'RemoveItem',
        modifier = {
            passSource = true,
        }
    },
    getItem = {
        originalMethod = 'GetItem',
        modifier = {
            passSource = true,
        }
    },
    items = {
        originalMethod = 'GetInventoryItems',
        modifier = {
            executeFun = true,
            passSource = true,
        }
    },
})

local registeredItems = {}

AddEventHandler('ox_inventory:usedItem', function(playerId, itemName, slotId, metadata)
    local itemEffect = registeredItems[itemName]
    if not itemEffect then return end
    itemEffect(playerId)
end)

function overrideFunction.registerUsableItem(name, cb)
    registeredItems[name] = cb
end

return overrideFunction