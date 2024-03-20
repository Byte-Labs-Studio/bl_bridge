local Progressbar = {}
local menu = lib

function Progressbar.showProgress(data)
    return menu.progressBar({
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
    lib.cancelProgress()
end

function Progressbar.isProgressActive()
    return menu.progressActive()
end

return Progressbar