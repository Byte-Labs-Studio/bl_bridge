local menuName = 'progressbar'
if GetResourceState(menuName) ~= 'started' then
    error('The imported file from the chosen framework isn\'t starting')
    return
end

local Progressbar = {}
Progressbar.state = false

function Progressbar.showProgress(data)
    local prop, animation, disableControl in data
    local success
    exports['progressbar']:Progress({
        name = 'progress',
        duration = data.duration,
        label = data.label,
        useWhileDead = data.useWhileDead,
        canCancel = data.canCancel,
        controlDisables = disableControl and {
            disableMovement = disableControl.move,
            disableCarMovement = disableControl.car,
            disableMouse = disableControl.mouse,
            disableCombat = disableControl.combat,
        },
        animation = animation and {
            animDict = animation.dict,
            anim = animation.clip,
            flags = animation.flag
        },
        prop = prop and {
            model = prop.model,
            bone = prop.bone,
            coords = prop.pos,
            rotation = prop.rot
        },
    }, function(cancelled)
        success = not cancelled
    end)
    lib.waitFor(function()
        if success ~= nil then return true end
    end)
    return success
end

function Progressbar.cancelProgress()
    TriggerEvent("progressbar:client:cancel")
end

function Progressbar.isProgressActive()
    return Progressbar.state
end

RegisterNetEvent('progressbar:setstatus', function (state)
    Progressbar.state = state
end)

return Progressbar