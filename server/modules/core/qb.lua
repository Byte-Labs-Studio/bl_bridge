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
local playerFunctionsOverride = {
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
                    return {name = job.name, label = job.label, onDuty = job.onduty, isBoss = job.isboss, grade = { name = job.grade.level, label = job.grade.name, salary = job.payment } }
                end
            }
        },
        gang = {
            originalMethod = 'gang',
            modifier = {
                executeFun = true,
                effect = function(data)
                    local gang = data
                    return {name = gang.name, label = gang.label, isBoss = gang.isboss, grade = {name = gang.grade.level, label = gang.grade.label}}
                end
            }
        },
        charinfo = {
            originalMethod = 'charinfo',
            modifier = {
                executeFun = true,
                effect = function(data)
                    return {firstname = data.firstname, lastname = data.lastname}
                end
            }
        },
        name = {
            originalMethod = 'name',
        },
        id = {
            originalMethod = 'citizenid',
        },
    }
}

function Core.players()
    local data = {}
    for k,v in ipairs(shared.Players) do
        local playerData = v.PlayerData
        local job = playerData.job
        local gang = playerData.gang
        local charinfo = playerData.charinfo
        data[k] = {
            job = {name = job.name, label = job.label, onDuty = job.onduty, isBoss = job.isboss, grade = {name = job.grade.level, label = job.grade.label, salary = job.payment}},
            gang = {name = gang.name, label = gang.label, isBoss = gang.isboss, grade = {name = gang.grade.level, label = gang.grade.label}},
            charinfo = {firstname = charinfo.firstname, lastname = charinfo.lastname}
        }
    end
    return data
end

function Core.CommandAdd(name, permission, cb, suggestion, flags)
    if type(name) == 'table' then
        for _,command in ipairs(name) do
            shared.Commands.Add(command, suggestion.help, suggestion.arguments, flags.argsrequired, cb, permission)
        end
        return
    end
    shared.Commands.Add(name, suggestion.help, suggestion.arguments, flags.argsrequired, cb, permission)
end

function Core.RegisterUsableItem(name, cb)
    shared.Functions.CreateUseableItem(name, cb)
end

local totalFunctionsOverride = merge(inventoryFunctions, playerFunctionsOverride)

function Core.GetPlayer(src)
    local player = shared.Functions.GetPlayer(src)
    if not player then return end
    local wrappedPlayer = retreiveStringIndexedData(player, totalFunctionsOverride, src)

    return wrappedPlayer
end

function Core.hasPerms(...)
    return shared.Functions.HasPermission(...)
end

return Core