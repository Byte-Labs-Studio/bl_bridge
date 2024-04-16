local coreName = 'qb-core'
if GetResourceState(coreName) ~= 'started' then
    error('The imported file from the chosen framework isn\'t starting')
    return
end

local Core = {}
local retreiveStringIndexedData = require 'utils'.retreiveStringIndexedData

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

local coreFunctionsOverride = {
    Functions = {
        playerData = {
            originalMethod = 'GetPlayerData',
            modifier = {
                executeFun = true,
                effect = function(originalFun)
                    while not LocalPlayer.state.isLoggedIn do
                        Wait(1000)
                    end
                    local data = originalFun()
                    local job = data.job
                    local gang = data.gang
                    local charinfo = data.charinfo

                    local year, month, day = charinfo.birthdate:match("(%d+)-(%d+)-(%d+)")
                    return {
                        cid = data.citizenid,
                        money = data.money or 0,
                        inventory = type(data.items) == 'string' and json.decode(data.items) or data.items,
                        job = { name = job.name, label = job.label, onDuty = job.onduty, isBoss = job.isboss, type = job.type, grade = { name = job.grade.level, label = job.grade.name, salary = job.payment } },
                        gang = { name = gang.name, label = gang.label, isBoss = gang.isboss, grade = { name = gang.grade.level, label = gang.grade.label } },
                        firstName = charinfo.firstname or 'Unknown',
                        lastName = charinfo.lastname or 'Unknown',
                        phone = charinfo.phone or '0000000',
                        gender = charinfo.gender == 1 and 'female' or 'male',
                        dob = ('%s/%s/%s'):format(month, day, year) -- DD/MM/YYYY
                    }
                end
            }
        },
    },
}

function Core.getPlayerData()
    local wrappedPlayer = retreiveStringIndexedData(shared, coreFunctionsOverride)
    return wrappedPlayer.playerData
end

function Core.playerLoaded()
    return LocalPlayer.state.isLoggedIn
end

return Core
