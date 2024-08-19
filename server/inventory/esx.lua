
local overrideFunction = {}

overrideFunction.methods = {
    addItem = {
        originalMethod = 'addInventoryItem',
    },
    removeItem = {
        originalMethod = 'removeInventoryItem',
    },
    getItem = {
        originalMethod = 'getInventoryItem',
    },
    setMetaData = { -- not exist :()
      
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

return overrideFunction