local Progressbar = {}

function Progressbar.showProgress(data)
    return exports.ox_lib:progressBar({
        duration = data.duration,
        label = data.label,
        useWhileDead = data.useWhileDead,
        canCancel = data.canCancel,
        disable = data.disableControl,
        anim = data.animation,
        prop = {
            model = data.prop?.model,
            bone = data.prop?.bone,
            pos = data.prop?.pos,
            rot = data.prop?.rot
        },
    })
end

function Progressbar.cancelProgress()
    exports.ox_lib:cancelProgress()
end

function Progressbar.isProgressActive()
    return exports.ox_lib:progressActive()
end

return Progressbar