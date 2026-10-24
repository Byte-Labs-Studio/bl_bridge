local retreiveExportsData = bridgeRequire 'utils'.retreiveExportsData
local overrideFunction = {}
local registeredInventories = {}
local codem_inventory = exports['codem-inventory']

overrideFunction.methods = retreiveExportsData(codem_inventory, {
    addItem = {
        originalMethod = 'AddItem',
        modifier = {
            passSource = true,
            effect = function(originalFun, src, name, amount, metadata, slot)
                return originalFun(src, name, amount, slot, metadata)
            end
        }
    },
    removeItem = {
        originalMethod = 'RemoveItem',
        modifier = {
            passSource = true,
            effect = function(originalFun, src, name, amount, slot)
                return originalFun(src, name, amount, slot)
            end
        }
    },
    setMetaData = {
        originalMethod = 'SetItemMetadata',
        modifier = {
            passSource = true,
            effect = function(originalFun, src, slot, data)
                originalFun(src, slot, data)
            end
        }
    },
    canCarryItem = {
        originalMethod = 'HasItem',
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

    for i = 1, #(items or {}) do
        local v = items[i]
        v.amount = v.amount or 1
        v.slot = i
    end

    registeredInventories[('%s-%s'):format(type, id)] = {
        label     = name,
        items     = items,
        slots     = slots or #items,
        maxweight = maxWeight
    }

    if type == 'shop' and codem_inventory.CreateShop then
        codem_inventory:CreateShop({
            name = name,
            label = name,
            slots = slots or #items,
            items = items
        })
    end
end

bridgeRequire'utils'.register('bl_bridge:validInventory', function(_, invType, invId)
    local inventory = registeredInventories[('%s-%s'):format(invType, invId)]
    if not inventory then return end
    return inventory
end)

return overrideFunction