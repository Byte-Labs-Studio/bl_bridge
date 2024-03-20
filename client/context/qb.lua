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
        hasKeys = true,
        modifier = {
            effect = function(data)
                local params = {}
                if data.onSelect then
                    params.event = data.onSelect
                    params.isAction = true
                elseif data.event then
                    params.event = data.event
                    params.args = data.args
                elseif data.serverEvent then
                    params.event = data.serverEvent
                    params.isServer = true
                    params.args = data.args
                end
                return params
            end
        },
    },
    disabled = {
        originalMethod = 'disabled',
    },
    isMenuHeader = {
        originalMethod = 'isHeader',
    },
}

---@param data ContextMenuProps | ContextMenuProps[]
function Context.openContext(data)
    qb_menu:openMenu(Utils.retreiveNumberIndexedData(data, overRideData))
end

function Context.closeContext()
    qb_menu:closeMenu()
end

return Context
