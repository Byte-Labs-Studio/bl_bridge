local inventory = {}
local invFramework = Config.convars.inventory

function inventory.hasItem(itemName, itemCount)
    itemCount = itemCount or 1
    local core = Framework.core
    if not core then
        lib.waitFor(function()
            if Framework.core then return true end
        end)
    end
    local playerData = invFramework == 'ox' and exports.ox_inventory:GetPlayerItems() or core.getPlayerData().inventory or {}
    local notify = Framework.notify

    if type(itemName) ~= 'string' then
        notify({
            title = 'item isn\'t string'
        })
        return
    end

    for _, itemData in ipairs(playerData) do
        local name, amount, count in itemData
        if itemName == name and itemCount <= (amount or count) then
            return true
        end
    end
    return false
end

return inventory