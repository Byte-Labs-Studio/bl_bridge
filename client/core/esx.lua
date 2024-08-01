local coreName = 'es_extended'
if GetResourceState(coreName) ~= 'started' then
    error('The imported file from the chosen framework isn\'t starting')
    return
end

local Core = {}
local retreiveStringIndexedData = require 'utils'.retreiveStringIndexedData

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

local coreFunctionsOverride = {
    playerData = {
        originalMethod = 'GetPlayerData',
        modifier = {
            executeFun = true,
            effect = function(originalFun)
                while not shared.IsPlayerLoaded() do
                    Wait(1000)
                end
                local data = originalFun()
                local job = data.job

                local month, day, year = data.dateofbirth and data.dateofbirth:match("(%d+)/(%d+)/(%d+)") or 00, 00, 24

                return {
                    cid = data.identifier,
                    money = data.money or 0,
                    inventory = data.inventory or {},
                    job = {name = job.name, label = job.label, onDuty = true, isBoss = false, grade = {name = job.grade, label = job.grade_label, salary = job.grade_salary}},
                    firstName = data.firstName or 'Unknown',
                    lastName = data.lastName or 'Unknown',
                    phone = data.phone_number or '0',
                    gender = data.sex == 'm' and 'male' or 'female',
                    dob = ('%s/%s/%s'):format(month, day, year)
                }
            end
        }
    },
}

function Core.getPlayerData()
    local wrappedPlayer = retreiveStringIndexedData(shared, coreFunctionsOverride)
    return wrappedPlayer.playerData
end

function Core.playerLoaded()
    return shared.IsPlayerLoaded()
end

return Core
