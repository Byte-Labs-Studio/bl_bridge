local inventory = {}
local invFramework = Config.convars.inventory

local core = Framework.core
if not core then
    lib.waitFor(function()
        if Framework.core then return true end
    end)
end

function inventory.items()
    local inventoryItems = invFramework == 'ox' and exports.ox_inventory:Items() or core.getPlayerData().items or {}
    return inventoryItems
end

function inventory.playerItems()
    local playerData = invFramework == 'ox' and exports.ox_inventory:GetPlayerItems() or core.getPlayerData().inventory or {}
    for _, itemData in ipairs(playerData) do
        local count = itemData.count
        if count then
            itemData.amount = count
            itemData.count = nil
        end
    end
    return playerData
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

    for _, itemData in ipairs(playerData) do
        local name, amount in itemData
        if itemName == name and itemCount <= amount then
            return true
        end
    end
    return false
end

return inventory