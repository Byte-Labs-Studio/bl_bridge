local Radial = {}


function Radial.addOptions(optionId, data)
    local id = require'utils'.await('UUID', false, 8)
    local lib = exports.ox_lib
    
    local title, icon, items in data
    lib:registerRadial({
        id = id,
        items = items
    })

    lib:addRadialItem({
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