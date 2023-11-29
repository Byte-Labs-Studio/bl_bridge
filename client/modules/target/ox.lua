local targetName = 'ox_target'
if GetResourceState(targetName) ~= 'started' then
    error('The imported file from the chosen framework isn\'t started')
    return
end

local target = exports[targetName]
local Target = {}

-- for options is exactly the same as https://overextended.dev/ox_target
-- Example
-- add up here
local funcs = {
    {
        name = "addBoxZone",
        originalname = "addBoxZone",
        args = function(data)
            for _, value in ipairs(data.options) do
                value.distance = value.distance or data.distance
            end -- a simple adjust

            return {
                coords = data.coords,
                size = data.size,
                rotation = data.rotation,
                debug = data.debug,
                drawSprite = data.drawSprite,
                options = data.options
            }
        end
    },
    {
        name = "addCircleZone",
        originalname = "addSphereZone",
        args = function(data)
            for _, value in ipairs(data.options) do
                value.distance = value.distance or data.distance
            end -- a simple adjust

            return {
                coords = data.coords,
                radius = data.radius,
                rotation = data.rotation,
                debug = data.debug,
                drawSprite = data.drawSprite,
                options = data.options
            }
        end
    },
    {
        name = "removeZone",
        originalname = "removeZone",
        args = function(data)
            return data
        end
    },
}

for _, exportData in ipairs(funcs) do
    Target[exportData.name] = function(data)
        local originalName = exportData.originalname or exportData.name

        return target[originalName]("bruh", exportData.args(data)) -- already return id
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

print(id)
Target.removeZone(id)

Target.addCircleZone({
    coords = vector3(428, -973.44, 30.71),
    radius = 2,
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
 ]]

return Target
