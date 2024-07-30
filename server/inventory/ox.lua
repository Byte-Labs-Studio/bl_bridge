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
            effect = function(originalFun, source, name, count, slot)
                return originalFun(source, name, count, nil, slot)
            end,
        }
    },
    getItem = {
        originalMethod = 'GetSlotWithItem',
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
    itemEffect(playerId, slotId, metadata)
end)

function overrideFunction.registerUsableItem(name, cb)
    registeredItems[name] = cb
end

function overrideFunction.registerInventory(id, data)
    local type, name, items in data
    if type == 'shop' then
        ox_inventory:RegisterShop(id, {
            name = name or 'Shop',
            inventory = items or {},
        })
    elseif type == 'stash' then
        local maxWeight, slots in data
        ox_inventory:RegisterStash(id, name or 'Stash', slots or 10, maxWeight or 20000)
    end
end

return overrideFunction