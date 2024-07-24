local Core = {}
local shared = exports['qb-core']:GetCoreObject()
local Utils = require 'utils'
local retreiveStringIndexedData = Utils.retreiveStringIndexedData
local merge = Utils.table_merge
local inventoryFunctions = Framework.inventory

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function(...)
    TriggerEvent('bl_bridge:server:playerLoaded', source, ...)
end)

AddEventHandler('QBCore:Server:OnMoneyChange', function(src, moneyType, amount, operation, reason)
    TriggerEvent('bl_bridge:server:updateMoney', src, moneyType, amount, operation)
end)

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
        setBalance = {
            originalMethod = 'SetMoney',
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
                    return {name = job.name, label = job.label, onDuty = job.onduty, isBoss = job.isboss, type = job.type, grade = { name = job.grade.level, label = job.grade.name, salary = job.payment } }
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
        gender = {
            originalMethod = 'charinfo',
            modifier = {
                executeFun = true,
                effect = function(data)
                    local gender = data.gender
                    gender = gender == 1 and 'female' or 'male'
                    return gender
                end
            }
        },
        dob = {
            originalMethod = 'charinfo',
            modifier = {
                executeFun = true,
                effect = function(data)
                    local year, month, day = data.birthdate:match("(%d+)-(%d+)-(%d+)")
                    return ('%s/%s/%s'):format(month, day, year) -- DD/MM/YYYY
                end
            }
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
            job = {name = job.name, label = job.label, onDuty = job.onduty, type = job.type, isBoss = job.isboss, grade = {name = job.grade.level, label = job.grade.name, salary = job.payment}},
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

Core.RegisterUsableItem = inventoryFunctions and inventoryFunctions.registerUsableItem or function(name, cb)
    shared.Functions.CreateUseableItem(name, function(source, item)
        cb(source, item and item.slot, item and item.info)
    end)
end

local totalFunctionsOverride = inventoryFunctions and merge(inventoryFunctions.methods, playerFunctionsOverride) or playerFunctionsOverride

function Core.GetPlayer(src)
    local player = shared.Functions.GetPlayer(src)
    if not player then return end
    return retreiveStringIndexedData(player, totalFunctionsOverride, src)
end

function Core.hasPerms(...)
    return shared.Functions.HasPermission(...)
end

return Core