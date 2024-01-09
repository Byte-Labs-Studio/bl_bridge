---@diagnostic disable: lowercase-global

local textui = {}

---@param text string
---@param options? TextUIOptions
function textui.showTextUI(text, options)
    lib.showTextUI(text, options)
end

function textui.hideTextUI()
    lib.hideTextUI()
end

---@return boolean
function textui.isTextUIOpen()
    return lib.isTextUIOpen()
end

return textui