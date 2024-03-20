---@diagnostic disable: lowercase-global
local textui_fw = 'qb-core'
local qb_textui = exports[textui_fw]
local open = false
local textui = {}

---@param text string
---@param options? TextUIOptions
function textui.showTextUI(text, position)
    qb_textui:DrawText(text, position or 'right')
    open = true
end

function textui.hideTextUI()
    open = false
    qb_textui:HideText()
end

---@return boolean
function textui.isTextUIOpen()
    return open
end

return textui