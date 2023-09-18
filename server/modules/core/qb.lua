if GetResourceState('qb-core') ~= 'started' then
    error('The imported file from the chosen framework isn\'t starting')
    return
end

local Core = {}
local shared = exports['qb-core']:GetCoreObject()
local Utils = require 'utils'
local merge = lib.table.merge
local retreiveStringIndexedData in Utils

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function(...)
    TriggerEvent('bl_bridge:server:playerLoaded', source, ...)
end)

local inventoryFunctions = Framework.inventory
local coreFunctionsOverride = {
    Functions = {
        getBalance = {
            originalMethod = 'GetMoney',
        },
        removeBalance = {
            originalMethod = 'RemoveMoney',
        },
        addBalance = {
            originalMethod = 'AddMoney',
        },
        setJob = {
            originalMethod = 'SetJob',
        },
    },
    PlayerData = {
        job = {
            originalMethod = 'job',
            modifier = {
                executeFun = true,
                effect = function(originalFun)
                    local job = originalFun
                    return {name = job.name, label = job.label, onDuty = job.onduty, isBoss = job.isboss, grade = {name = job.grade.level, label = job.grade.label, salary = job.payment}}
                end
            }
        },
        name = {
            originalMethod = 'name',
        },
    }
}
local totalFunctionsOverride = merge(inventoryFunctions, coreFunctionsOverride)
function Core.CommandAdd(name, permission, cb, suggestion, flags)
    if type(name) == 'table' then
        for _,command in ipairs(name) do
            shared.Commands.Add(command, suggestion.help, suggestion.arguments, flags.argsrequired, cb, permission)
        end
        return
    end
    shared.Commands.Add(name, suggestion.help, suggestion.arguments, flags.argsrequired, cb, permission)
end

function Core.GetPlayer(src)
    local player = shared.Functions.GetPlayer(src)
    if not player then return end
    local wrappedPlayer = retreiveStringIndexedData(player, totalFunctionsOverride, src)

    wrappedPlayer.addItem('water', 1)
    wrappedPlayer.removeItem('water', 1)
    print(wrappedPlayer.items)

    return wrappedPlayer
end

Core.Players = shared.Players

return Core