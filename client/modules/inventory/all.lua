local inventory = {}

function inventory.hasItem(item, count)
    count = count or 1
    local core = Framework.core
    if not core then
        lib.waitFor(function()
            if Framework.core then return true end
        end)
    end
    local playerData = core.getPlayerData()
    local notify = Framework.notify

    if type(item) ~= 'string' then
        notify({
            title = 'item isn\'t string'
        })
        return
    end

    for _, itemData in ipairs(playerData.inventory) do
        local name, amount in itemData
        if item == name and count <= amount then
            return true
        end
    end
    return false
end

return inventory