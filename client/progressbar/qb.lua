local Progressbar = {}
Progressbar.state = false

function Progressbar.showProgress(data)
    local prop, animation, disableControl in data
    local promise = promise.new()
    disableControl = disableControl or {}

    exports['progressbar']:Progress({
        name = 'progress',
        duration = data.duration,
        label = data.label,
        useWhileDead = data.useWhileDead,
        canCancel = data.canCancel,
        controlDisables = {
            disableMovement = disableControl.move ~= false,
            disableCarMovement = disableControl.car ~= false,
            disableMouse = disableControl.mouse ~= false,
            disableCombat = disableControl.combat ~= false,
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
        promise:resolve(not cancelled)
    end)
    local success = Citizen.Await(promise)

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