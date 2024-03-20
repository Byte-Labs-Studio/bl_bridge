---@diagnostic disable: lowercase-global

local textui = {}

---@param text string
function textui.showTextUI(text, position)
    lib.showTextUI(text, position and {position = ('%s-center'):format(position)})
end

function textui.hideTextUI()
    lib.hideTextUI()
end

---@return boolean
function textui.isTextUIOpen()
    return lib.isTextUIOpen()
end

return textui