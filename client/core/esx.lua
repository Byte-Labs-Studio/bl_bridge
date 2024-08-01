local coreName = 'es_extended'
if GetResourceState(coreName) ~= 'started' then
    error('The imported file from the chosen framework isn\'t starting')
    return
end

local Core = {}

RegisterNetEvent('esx:playerLoaded', function()
    TriggerEvent('bl_bridge:client:playerLoaded')
end)

RegisterNetEvent('esx:onPlayerLogout', function()
    TriggerEvent('bl_bridge:client:playerUnloaded')
end)

RegisterNetEvent('esx:setJob', function(job)
    TriggerEvent('bl_bridge:client:jobUpdated', {name = job.name, label = job.label, onDuty = true, isBoss = false, grade = {name = job.grade, label = job.grade_label, salary = job.grade_salary}})
end)

local shared = exports[coreName]:getSharedObject()

function Core.getPlayerData()
    local player = shared.GetPlayerData()
    local job = player.job
    local gang = player.gang
    local charinfo = player.charinfo
    local year, month, day = charinfo.birthdate:match('(%d+)-(%d+)-($d+)')

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
        isBoss = gang.isBoss,
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
        dob = ('%s/%s/%S'):format(month, day, year) -- DD/MM/YYYY
    }
end

function Core.playerLoaded()
    return shared.IsPlayerLoaded()
end

return Core
