local menuName = 'qb-radialmenu'
if GetResourceState(menuName) ~= 'started' then
    error(menuName..' isn\'t starting')
    return
end

local qb_radial = exports[menuName]
local Radial = {}
local Utils = require 'utils'
local eventIndex = 0
local storedEvents = {}

local overRideData = {
    title = {
        originalMethod = 'label',
    },
    icon = {
        originalMethod = 'icon',
    },
    id = {
        originalMethod = 'menu',
    },
    shouldClose = {
        originalMethod = 'keepOpen',
        modifier = {
            executeFun = true,
            effect = function(value)
                return type(value) ~= 'boolean' and true or not value
            end
        }
    },
    event = {
        originalMethod = 'onSelect',
        modifier = {
            executeFun = true,
            effect = function(value)
                local eventName = ("bl_bridge:client:radialId%s"):format(eventIndex)
                eventIndex+= 1
                return {eventName = eventName, eventId = AddEventHandler(eventName, value)}
            end
        }
    },
}

function Radial.addOptions(optionId, data)
    local id = Utils.await('UUID', false, 8)

    local title, icon, items in data
    items = Utils.retreiveNumberIndexedData(items, overRideData)
    for _,v in ipairs(items) do
        v.type = 'client'
        
        if v.event then
            local eventName, eventId in v.event
            local menuId = v.menu or #storedEvents+1
            storedEvents[menuId] = eventId

            v.menu = menuId
            v.event = eventName
        end
    end
    qb_radial:AddOption({
        id = optionId,
        title = title or 'Unknown',
        icon = icon or 'hand',
        items = items
    }, id)
end

function Radial.removeOption(onExit)
    
end

return Radial