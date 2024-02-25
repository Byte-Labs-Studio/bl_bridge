local menuName = 'progressbar'
if GetResourceState(menuName) ~= 'started' then
    error('The imported file from the chosen framework isn\'t starting')
    return
end

local Progressbar = {}
Progressbar.state = false

function Progressbar.showProgress(data)
    exports['progressbar']:Progress({
        name = 'progress',
        duration = data.duration,
        label = data.label,
        useWhileDead = data.useWhileDead,
        canCancel = data.canCancel,
        controlDisables = {
            disableMovement = data.disableControl?.move,
            disableCarMovement = data.disableControl?.car,
            disableMouse = data.disableControl?.mouse,
            disableCombat = data.disableControl?.combat,
        },
        animation = {
            animDict = data.animation?.dict,
            anim = data.animation?.clip,
            flags = data.animation?.flags
        },
        prop = {
            model = data.prop?.model,
            bone = data.prop?.bone,
            coords = data.prop?.pos,
            rotation = data.prop?.rot
        },
    }, function(cancelled)
        return not cancelled
    end)
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