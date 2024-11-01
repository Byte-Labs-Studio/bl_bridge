---@diagnostic disable: lowercase-global
local esx_textui = exports['esx_textui']
local open = false
local textui = {}

---@param text string
---@param position? TextUIOptions
function textui.showTextUI(text, position)
    esx_textui:TextUI(text)
    open = true
end

function textui.hideTextUI()
    open = false
    esx_textui:HideUI()
end

---@return boolean
function textui.isTextUIOpen()
    return open
end

return textui