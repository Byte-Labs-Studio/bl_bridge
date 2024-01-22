
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
