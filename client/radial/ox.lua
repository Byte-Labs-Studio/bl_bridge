local Radial = {}
local menu = lib
local callback = menu.callback

function Radial.addOptions(optionId, data)
    local id = callback.await('UUID', false, 8)

    local title, icon, items in data
    lib.registerRadial({
        id = id,
        items = items
    })

    lib.addRadialItem({
        {
            id = optionId,
            label = title or 'Unknown',
            icon = icon or 'hand',
            menu = id
        },
    })
end

function Radial.removeOption(onExit)
    
end

return Radial