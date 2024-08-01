local targetName = 'qb-target'

-- Check resource state
if GetResourceState(targetName) ~= 'started' then
    error(targetName .. ' isn\'t started')
    return
end

local target = exports[targetName]
local Utils = require'utils'
local retreiveNumberIndexedData = Utils.retreiveNumberIndexedData
local Target = {}

local OverrideData = {
    label = { originalMethod = 'label' },
    type = {
        originalMethod = { 'event', 'serverEvent' },
        modifier = {
            executeFun = true,
            effect = function(value, originalMethod)
                return originalMethod == 'event' and 'client' or originalMethod == 'serverEvent' and 'server'
            end
        }
    },
    event = {
        originalMethod = { 'event', 'serverEvent' }
    },
    icon = {
        originalMethod = 'icon',
    },
    targeticon = {
        originalMethod = 'targeticon',
    },
    item = {
        originalMethod = 'items'
    },
    action = {
        originalMethod = 'onSelect',
    },
    canInteract = {
        originalMethod = 'canInteract',
    },
    job = {
        originalMethod = 'groups',
    },
    gang = {
        originalMethod = 'groups',
    }
}

-- alot of them have exclusive args
-- add up here
local funcs = {
    {
        name = "addBoxZone",
        originalname = "AddBoxZone",
        args = function(data, id)
            local length, width = table.unpack(data.size)
            return { id, data.coords, length, width, {
                name      = id,
                heading   = data.rotation,
                debugPoly = data.debug,
            } }
        end
    },
    {
        name = "addCircleZone",
        originalname = "AddCircleZone",
        args = function(data, id)
            return { id, data.coords, data.radius, {
                name      = id,
                heading   = data.rotation,
                debugPoly = data.debug,
            } }
        end
    },
    {
        name = "addModel",
        originalname = "AddTargetModel",
        args = function(data)
            return {data.models}
        end
    },
    {
        name = "addEntity",
        originalname = "AddTargetEntity",
        args = function(data)
            return {data.entity}
        end
    },
    {
        name = "addLocalEntity",
        originalname = "AddTargetEntity",
        args = function(data)
            return {data.entity}
        end
    },
    {
        name = "removeZone",
        originalname = "RemoveZone",
        args = function(data)
            return data
        end
    },
    {
        name = "removeEntity",
        originalname = "RemoveTargetEntity",
        args = function(data)
            return data
        end
    },
    {
        name = "removeLocalEntity",
        originalname = "RemoveTargetEntity",
        args = function(data)
            return data
        end
    },
}

-- dynamic way of creating funcs for the target, i will make it global in the future
for _, exportData in ipairs(funcs) do
    Target[exportData.name] = function(data)
        local id = Utils.await('UUID', false, 8)
        local originalName = exportData.originalname or exportData.name

        local args = exportData.args(data, id)

        if type(data) == "table" and data.options then
            args[#args + 1] = {
                options = retreiveNumberIndexedData(data.options, OverrideData),
                distance = data.distance
            }
        end

        if type(args) == "table" then
            target[originalName]("bruh", table.unpack(args))
        else
            target[originalName]("bruh", args)
        end
        return id
    end
end

-- for options is exactly the same as https://overextended.dev/ox_target
-- Example
--[[ local id = Target.addBoxZone({
    coords = vector3(428, -973.44, 30.71),
    size = vector3(2, 2, 2),
    rotation = 90,
    distance = 5.0,
    debug = true,
    options = {
        {
            label = "W",
            icon = "fa-solid fa-scissors",
            onSelect = function()
                print("frist")
            end
        },
        {
            label = "Destroy",
            icon = "fa-regular fa-eye",
            onSelect = function()
                print("second")
            end
        }
    }
}
)


local id2 = Target.addCircleZone({
    coords = vector3(428, -973.44, 30.71),
    radius = 2,
    rotation = 90,
    distance = 5.0,
    debug = true,
    options = {
        {
            label = "W",
            icon = "fa-solid fa-scissors",
            serverEvent = 'dwadaw',
        },
        {
            label = "Destroy",
            icon = "fa-regular fa-eye",
            onSelect = function()
                print("second")
            end
        }
    }
}
)
 ]]



return Target
