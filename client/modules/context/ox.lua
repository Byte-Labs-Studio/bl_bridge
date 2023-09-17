local Context = {}
local menu = lib
local callback = menu.callback

local function findHeader(data)
    for _,v in ipairs(data) do
        if v.isMenuHeader then
            return v.header
        end
    end
    return 'Header'
end

function Context.openContext(data)
    local id = callback.await('UUID', false, 8)
    menu.registerContext({id = id, title = findHeader(data),options = data})
    menu.showContext(id)
    return id
end

function Context.closeContext(onExit)
    menu.hideContext(onExit)
end

return Context