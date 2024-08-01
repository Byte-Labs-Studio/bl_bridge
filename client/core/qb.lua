local coreName = 'qb-core'
if GetResourceState(coreName) ~= 'started' then
    error('The imported file from the chosen framework isn\'t starting')
    return
end

local Core = {}

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    TriggerEvent('bl_bridge:client:playerLoaded')
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    TriggerEvent('bl_bridge:client:playerUnloaded')
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    TriggerEvent('bl_bridge:client:jobUpdated', { name = job.name, label = job.label, onDuty = job.onduty, type = job.type, isBoss = job.isboss, grade = { name = job.grade.level, label = job.grade.name, salary = job.payment } })
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(gang)
    TriggerEvent('bl_bridge:client:gangUpdated', { name = gang.name, label = gang.label, isBoss = gang.isboss, grade = { name = gang.grade.level, label = gang.grade.label } })
end)

local shared = exports[coreName]:GetCoreObject()

function Core.getPlayerData()
    local player = shared.GetPlayerData()
    local job = player.job
    local gang = player.gang
    local charinfo = player.charinfo
    local year, month, day = charinfo.birthdate:match('(%d+)-(%d+)-(%d+)')

    local formattedJob = {
        name = job.name,
        label = job.label,
        onDuty = job.onduty,
        isBoss = job.isboss,
        type = job.type,
        grade = {
            name = job.grade.level,
            label = job.grade.name,
            salary = job.payment
        }
    }

    local formattedGang = {
        name = gang.name,
        label = gang.label,
        isBoss = gang.isboss,
        grade = {
            name = gang.grade.level,
            label = gang.grade.label
        }
    }

    return {
        cid = player.citizenid,
        money = player.money or 0,
        inventory = type(player.items) == 'string' and json.decode(player.items) or player.items,
        job = formattedJob,
        gang = formattedGang,
        firstName = charinfo.firstName or 'Unknown',
        lastName = charinfo.lastName or 'Unknown',
        phone = charinfo.phone or '0000000',
        gender = charinfo.gender == 1 and 'female' or 'male',
        dob = ('%02d/%02d/%04d'):format(month, day, year) -- DD/MM/YYYY
    }
end

function Core.playerLoaded()
    return LocalPlayer.state.isLoggedIn
end

return Core
