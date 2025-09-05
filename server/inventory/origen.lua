local retreiveExportsData = require 'utils'.retreiveExportsData
local overrideFunction = {}
local origen_inventory = exports.origen_inventory

overrideFunction.methods = retreiveExportsData(origen_inventory, {
    addItem = {
        originalMethod = 'addItem',
        modifier = {
            passSource = true,
        }
    },
    removeItem = {
        originalMethod = 'removeItem',
        modifier = {
            passSource = true,
            effect = function(originalFun, source, name, count, slot)
                return originalFun(source, name, count, nil, slot)
            end,
        }
    },
    setMetaData = {
        originalMethod = 'setMetadata',
        modifier = {
            passSource = true,
        }
    },
    canCarryItem = {
        originalMethod = 'canCarryItem',
        modifier = {
            passSource = true,
        }
    },
    getItem = {
        originalMethod = 'getItem',
        modifier = {
            passSource = true,
        }
    },
    items = {
        originalMethod = 'getItems',
        modifier = {
            executeFunc = true,
            passSource = true,
        }
    },
})

function overrideFunction.registerUsableItem(name, cb)
    exports.origen_inventory:CreateUseableItem(name, function(source, item)
        cb(source, item and item.slot, item and item.info)
    end)
end

function overrideFunction.registerInventory(id, data)
    local type, name, items in data
    if type == 'shop' then
        pcall(function()
            origen_inventory:registerShop(id, {name = name or 'Shop',inventory = items or {},})
        end)
    elseif type == 'stash' then
        local maxWeight, slots in data

        pcall(function()
            origen_inventory:registerStash(id, name or 'Stash', slots or 10, maxWeight or 20000)
        end)
    end
end

return overrideFunction