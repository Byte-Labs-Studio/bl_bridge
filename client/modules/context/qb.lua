local menuName = 'qb-menu'
if GetResourceState(menuName) ~= 'started' then
    error('The imported file from the chosen framework isn\'t starting')
    return
end

local Context = {}
local qb_menu = exports[menuName]
local Utils = require 'utils'

local overRideData = {
    header = {
        originalMethod = 'title',
    },
    txt = {
        originalMethod = 'description',
    },
    icon = {
        originalMethod = 'icon',
        modifier = {
            executeFun = true,
            effect = function(value)
                local text = ('fas fa-%s'):format(value)
                return text
            end
        }
    },
    params = {
        originalMethod = 'none',
        hasKeys = { 'event', 'args' }
    },
    disabled = {
        originalMethod = 'disabled',
    },
    isMenuHeader = {
        originalMethod = 'isHeader',
    },
}

function Context.openContext(data)
    data = Utils.retreiveNumberIndexedData(data, overRideData)
    qb_menu:openMenu(data)
end

function Context.closeContext()
    qb_menu:closeMenu()
end

return Context
