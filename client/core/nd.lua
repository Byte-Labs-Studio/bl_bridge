local coreName = 'ND_Core'
if GetResourceState(coreName) ~= 'started' then
    error('The imported file from the chosen framework isn\'t starting')
    return
end

local Core = {}
local jobInfo = {}
local loaded = false

RegisterNetEvent('ND:characterLoaded', function(character)
    TriggerEvent('bl_bridge:client:playerLoaded')
    jobInfo = character.jobInfo
    jobInfo.name = character.job
    loaded = true
    Wait(1000)
end)

AddEventHandler("ND:characterUnloaded", function(character)
    TriggerEvent('bl_bridge:client:playerUnloaded')
    jobInfo = {}
    loaded = false
end)

RegisterNetEvent('ND:updateCharacter', function(character)
    local jobData = character.jobInfo
    if character.job ~= jobInfo.name or jobInfo.rank ~= jobData.rank then
        TriggerEvent('bl_bridge:client:jobUpdated', { name = character.job, label = jobData.label, onDuty = true, isBoss = jobData.isBoss or false, grade = { name = jobData.rank, label = jobData.rankName, salary = 0 } })
    end
end)

local shared = exports[coreName]

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
    return loaded
end

return Core
