local Ox = require '@ox_core/lib/init'
local Core = {}
local retreiveStringIndexedData = require 'utils'.retreiveStringIndexedData
LocalPlayer.state.isLoggedIn = true

AddEventHandler('ox:playerLoaded', function()
    TriggerEvent('bl_bridge:client:playerLoaded')
    LocalPlayer.state.isLoggedIn = true
end)

RegisterNetEvent('bl_bridge:client:playerUnloaded',function()
    LocalPlayer.state.isLoggedIn = false
end)

local function prepareJobData(job, grade)
    return {name = job.name, label = job.label, onDuty = true, isBoss = job.accountRoles[tostring(grade)] == 'owner', type = job.type, grade = { name = grade, label = job.grades[grade], salary = 0 } }
end

RegisterNetEvent('ox:setGroup', function(groupName, grade)
    local job = Ox.GetGroup(groupName)
    TriggerEvent('bl_bridge:client:jobUpdated', prepareJobData(job, grade))
end)

local coreFunctionsOverride = {
    playerData = {
        originalMethod = 'GetPlayer',
        modifier = {
            executeFunc = true,
            effect = function(originalFun) -- TODO: lazy loading for all data, only return what need, others can be requested like get(key)
                while not LocalPlayer.state.isLoggedIn do
                    Wait(1000)
                end
                local data = originalFun()
                ---@type function
                local get = data.get
                local activeJob = get('activeGroup')
                if not activeJob then return end

                local grade = data.getGroup(activeJob)
                local job = Ox.GetGroup(activeJob)
                local group = prepareJobData(job, grade)
                
                return {
                    cid = data.citizenid,
                    money = data.money or 0,
                    inventory = exports.ox_inventory:GetPlayerItems(),
                    job = group,
                    gang = group,
                    firstName = get('firstName') or 'Unknown',
                    lastName = get('lastName') or 'Unknown',
                    phone = get('phoneNumber') or '0000000',
                    gender = get('gender'),
                    dob = get('dateOfBirth') -- DD/MM/YYYY
                }
            end
        }
    },
}

function Core.getPlayerData()
    local wrappedPlayer = retreiveStringIndexedData(Ox, coreFunctionsOverride)
    return wrappedPlayer.playerData
end

function Core.playerLoaded()
    return LocalPlayer.state.isLoggedIn
end

return Core