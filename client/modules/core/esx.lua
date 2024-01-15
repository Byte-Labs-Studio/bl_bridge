local Core = {}
local retreiveStringIndexedData = require 'utils'.retreiveStringIndexedData
local playerLoaded = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    playerLoaded = true
    TriggerEvent('bl_bridge:client:playerLoaded')
end)

RegisterNetEvent('esx:onPlayerLogout', function()
    playerLoaded = false
    TriggerEvent('bl_bridge:client:playerUnloaded')
end)

RegisterNetEvent('esx:setJob', function(...)
    TriggerEvent('bl_bridge:client:jobUpdated', ...)
end)

local shared = exports['es_extended']:getSharedObject()

local coreFunctionsOverride = {
    playerData = {
        originalMethod = 'PlayerData',
        modifier = {
            executeFun = true,
            effect = function(originalFun)
                lib.waitFor(function()
                    if playerLoaded then
                        return true
                    end
                end, nil, 10000)
                local data = originalFun
                local job = data.job
                return {
                    cid = data.identifier,
                    money = data.accounts,
                    inventory = data.inventory,
                    job = {name = job.name, label = job.label, onDuty = true, isBoss = false, grade = {name = job.grade_name, label = job.grade_label, salary = job.grade_salary}},
                    firstName = data.firstName,
                    lastName = data.lastName,
                    phone = data.phone_number or '0',
                }
            end
        }
    },
}

function Core.getPlayerData()
    local wrappedPlayer = retreiveStringIndexedData(shared, coreFunctionsOverride)
    return wrappedPlayer.playerData
end

return Core
