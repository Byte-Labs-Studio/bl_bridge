if GetResourceState('qb-inventory') ~= 'started' then
    error('The imported file from the chosen framework isn\'t starting')
    return
end

return {
    Functions = {
        addItem = {
            originalMethod = 'AddItem',
        },
        removeItem = {
            originalMethod = 'RemoveItem',
        },
        getItem = {
            originalMethod = 'GetItemByName',
        }
    },
    PlayerData = {
        items = {
            originalMethod = 'items',
        },
    }
}