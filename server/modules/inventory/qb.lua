if GetResourceState('qb-inventory') ~= 'started' then
    error('The imported file from the chosen framework isn\'t starting')
    return
end


local overrideFunction = {}

overrideFunction.methods = {
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

return overrideFunction