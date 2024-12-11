local inventory = {}
local invFramework = GetFramework('inventory')
local Utils = require'utils'
local isOx = invFramework == 'ox_inventory'
local isQS = invFramework == 'qs-inventory'

-- function inventory.items()
--     local inventoryItems = isOx and exports.ox_inventory:Items() or core.getPlayerData().items or {}
--     return inventoryItems
-- end

function inventory.playerItems()
    local playerData = {}
    if isOx then
        playerData = exports.ox_inventory:GetPlayerItems()
    elseif isQS then
        playerData = exports['qs-inventory']:getUserInventory()
    else
        local core = Framework.core
        if not core then
            Utils.waitFor(function()
                if Framework.core then return true end
            end)
        end
        playerData = core.getPlayerData().inventory
    end

    for _, itemData in pairs(playerData) do
        local count = itemData.count
        if count then
            itemData.amount = count
            itemData.count = nil
        end
    end
    return playerData
end

function inventory.openInventory(invType, invId)
    if isOx then
        exports.ox_inventory:openInventory(invType, {type = invId})
    elseif invFramework == 'qb' or isQS then
        local inventoryData = Utils.await('bl_bridge:validInventory', 10, invType, invId)
        if not inventoryData then return end
        TriggerServerEvent('inventory:server:OpenInventory', invType, invId, inventoryData)
    end
end

function inventory.hasItem(itemName, itemCount)
    itemCount = itemCount or 1
    local playerData = inventory.playerItems()
    local notify = Framework.notify

    if type(itemName) ~= 'string' then
        notify({
            title = 'item isn\'t string'
        })
        return
    end

    for _, itemData in pairs(playerData) do
        local name, amount in itemData
        if itemName == name and itemCount <= amount then
            return true
        end
    end
    return false
end

return inventory
