---@diagnostic disable: lowercase-global

local textui = {}

---@param text string
function textui.showTextUI(text, position)
    exports.ox_lib:showTextUI(text, position and {position = ('%s-center'):format(position)})
end

function textui.hideTextUI()
    exports.ox_lib:hideTextUI()
end

---@return boolean
function textui.isTextUIOpen()
    return exports.ox_lib:isTextUIOpen()
end

return textui