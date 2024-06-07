local Context = {}
local menu = exports.ox_lib

local function findHeader(data)
    for k, v in ipairs(data) do
        if v.isMenuHeader then
            return k, v.title
        end
    end
    return false, 'Header'
end

---@param data ContextMenuProps | ContextMenuProps[]
function Context.openContext(data)
    local id = require'utils'.await('UUID', false, 8)
    local index, header = findHeader(data)
    if index then table.remove(data, index) end
    menu:registerContext({id = id, title = header, options = data})
    menu:showContext(id)
    return id
end

function Context.closeContext(onExit)
    menu:hideContext(onExit)
end

return Context