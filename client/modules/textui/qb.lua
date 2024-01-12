---@diagnostic disable: lowercase-global
local textui_fw = 'qb-core'
local qb_textui = exports[textui_fw]

local textui = {
    open = false
}

---@param text string
---@param options? TextUIOptions
function textui.showTextUI(text, options)
    local position = 'left'

    if options then
        local pos = string.match(options.position, "(.-)-")

        if pos then
            position = pos
        end
    end

    qb_textui:DrawText(text, position)

    textui.open = true
end

function textui.hideTextUI()
    qb_textui:HideText()
end

---@return boolean
function textui.isTextUIOpen()
    return textui.open
end

return textui