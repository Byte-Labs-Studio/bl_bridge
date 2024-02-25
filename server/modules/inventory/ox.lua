if GetResourceState('ox_inventory') ~= 'started' then
    error('The imported file from the chosen framework isn\'t starting')
    return {}
end
local retreiveExportsData = require 'utils'.retreiveExportsData

local overrideFunction = {
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
        }
    },
    getItem = {
        originalMethod = 'GetItem',
        modifier = {
            passSource = true,
        }
    },
}

return retreiveExportsData(exports['ox_inventory'], overrideFunction)
