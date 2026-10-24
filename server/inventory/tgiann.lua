local retreiveExportsData = bridgeRequire 'utils'.retreiveExportsData
local overrideFunction = {}
local tgiann_inventory = exports['tgiann-inventory']

overrideFunction.methods = retreiveExportsData(tgiann_inventory, {
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
    setMetaData = {
        originalMethod = 'UpdateItemMetadata',
        modifier = {
            passSource = true,
            effect = function(originalFun, src, slot, data)
                local item = tgiann_inventory:GetItemBySlot(src, slot)
                if not item or not item.name then return end
                return originalFun(src, item.name, slot, data)
            end
        }
    },
    canCarryItem = {
        originalMethod = 'CanCarryItem',
        modifier = {
            passSource = true,
        }
    },
    getItem = {
        originalMethod = 'GetItemByName',
        modifier = {
            passSource = true,
        }
    },
    items = {
        originalMethod = 'GetPlayerItems',
        modifier = {
            executeFunc = true,
            passSource = true,
        }
    },
})

function overrideFunction.registerInventory(id, data)
    local type, name, items in data
    if type == 'shop' then
        pcall(function()
            tgiann_inventory:RegisterShop(id, {
                name = name or 'Shop',
                inventory = items or {},
            })
        end)
    elseif type == 'stash' then
        local maxWeight, slots in data
        pcall(function()
            tgiann_inventory:RegisterStash(id, name or 'Stash', slots or 10, maxWeight or 20000)
        end)
    end
end

return overrideFunction
