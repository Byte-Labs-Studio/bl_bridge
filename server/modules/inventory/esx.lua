if GetResourceState('qb-inventory') ~= 'started' then
    error('The imported file from the chosen framework isn\'t starting')
    return
end

return {
    addItem = {
        originalMethod = 'AddItem',
    },
    removeItem = {
        originalMethod = 'RemoveItem',
    },
    getItem = {
        originalMethod = 'GetItemByName',
    },
    items = {
        originalMethod = 'getInventory',
        modifier = {
            effect = function(originalFun)
                return originalFun.items
            end
        }
    },
}
