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
    while not shared.IsPlayerLoaded() do
        Wait(1000)
    end
    local data = shared.GetPlayerData()
    local job = data.job
    local month, day, year = data.dateofbirth and data.dateofbirth:match("(%d+)/(%d+)/(%d+)") or 00, 00, 24

    local formattedJob = {
        name = job.name,
        label = job.label,
        onDuty = true,
        isBoss = false,
        grade = {
            name = job.grade,
            label = job.grade_label,
            salary = job.grade_salary
        }
    }

    return {
        cid = data.identifier,
        money = data.money or 0,
        inventory = data.inventory or {},
        job = formattedJob,
        firstName = data.firstName or 'Unknown',
        lastName = data.lastName or 'Unknown',
        phone = data.phone_number or '0',
        gender = data.sex == 'm' and 'male' or 'female',
        dob = ('%02d/%02d/%04d'):format(month, day, year) -- DD/MM/YYYY
    }
end

function Core.playerLoaded()
    return shared.IsPlayerLoaded()
end

return Core
