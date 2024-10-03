local utils = require 'utils'
local retreiveExportsData = utils.retreiveExportsData
local overrideFunction = {}
local registeredInventories = {}


overrideFunction.methods = retreiveExportsData(exports['qb-inventory'], {
    addItem = {
        originalMethod = 'AddItem',
        modifier = {
            passSource = true,
            effect = function(originalFun, src, name, amount, metadata, slot)
                TriggerClientEvent('inventory:client:ItemBox', src, name, "add", amount)
                TriggerClientEvent('qb-inventory:client:ItemBox', src, name, "add", amount)
                return originalFun(src, name, amount, slot, metadata)
            end
        }
    },
    removeItem = {
        originalMethod = 'RemoveItem',
        modifier = {
            passSource = true,
            effect = function(originalFun, src, name, amount, slot)
                TriggerClientEvent('inventory:client:ItemBox', src, name, "remove", amount)
                TriggerClientEvent('qb-inventory:client:ItemBox', src, name, "remove", amount)
                return originalFun(src, name, amount, slot)
            end
        }
    },
    setMetaData = {
        originalMethod = 'SetItemData',
        modifier = {
            passSource = true,
            effect = function(originalFun, src, slot, data)
                local item = exports['qb-inventory']:GetItemBySlot(src, slot)

                if not item then return end
                if type(data) ~= 'table' then return end

                originalFun(src, item.name, 'info', data)
            end
        }
    },
    canCarryItem = {
        originalMethod = 'CanAddItem',
        modifier = {
            passSource = true,
        }
    },
    getItem = {
        originalMethod = 'GetItemByName',
        modifier = {
            passSource = true,
            effect = function(originalFun, src, itemName)
                local data = originalFun(src, itemName)
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

utils.register('bl_bridge:validInventory', function(_, invType, invId)
    local inventory = registeredInventories[('%s-%s'):format(invType, invId)]
    if not inventory then return end
    return inventory
end)

return overrideFunction