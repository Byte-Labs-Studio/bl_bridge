local overrideFunction = {}
local registeredInventories = {}
overrideFunction.methods = {
    Functions = {
        addItem = {
            originalMethod = 'AddItem',
            modifier = {
                effect = function(originalFun, name, amount, metadata, slot)
                    return originalFun(name, amount, slot, metadata)
                end
            }
        },
        removeItem = {
            originalMethod = 'RemoveItem',
        },
        getItem = {
            originalMethod = 'GetItemByName',
            modifier = {
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
        }
    },
    PlayerData = {
        items = {
            originalMethod = 'items',
        },
    }
}

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