local retreiveExportsData = require 'utils'.retreiveExportsData
local overrideFunction = {}
local registeredInventories = {}

overrideFunction.methods = retreiveExportsData(exports['qs-inventory'], {
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
        originalMethod = 'GetItemByName',
        modifier = {
            passSource = true,
            effect = function(originalFun, itemName)
                local data = originalFun(itemName)
                if not data then
                    return false, 'Item not exist or you don\'t have it'
                end
                return {
                    label = data.label,
                    name = data.name,
                    weight = data.weight,
                    slot = data.slot,
                    close = data.shouldClose,
                    stack = not data.unique,
                    metadata = data.info ~= '' and data.info or {},
                    count = data.amount or 1
                }
            end
        }
    },
    items = {
        originalMethod = 'GetInventory',
        modifier = {
            passSource = true,
        }
    },
})

function overrideFunction.registerInventory(id, data)
    local type, name, items, slots, maxWeight in data

    for k,v in ipairs(items) do
        v.amount = v.amount or 10
        v.slot = k
    end

    registeredInventories[('%s-%s'):format(type, id)] = {
        label     = name,
        items     = items,
        slots     = slots or #items,
        maxweight = maxWeight
    }
end

require'utils'.register('bl_bridge:validInventory', function(_, invType, invId)
    local inventory = registeredInventories[('%s-%s'):format(invType, invId)]
    if not inventory then return end
    return inventory
end)

return overrideFunction