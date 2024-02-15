local resource = 'ND_Core'
if GetResourceState(resource) ~= 'started' then
    error('The imported file from the chosen framework isn\'t starting')
    return
end

local Core = {}
local shared = exports[resource]
local retreiveStringIndexedData = require 'utils'.retreiveStringIndexedData
local merge = lib.table.merge
local inventoryFunctions = Framework.inventory

AddEventHandler("ND:characterLoaded", function(...)
    TriggerEvent('bl_bridge:server:playerLoaded', ...)
end)

local playerFunctionsOverride = {
    getBalance = {
        originalMethod = 'getData',
        modifier = {
            executeFun = true,
            effect = function(data, type)
                local balance = data(type)
                return balance
            end
        }
    },
    removeBalance = {
        originalMethod = 'deductMoney',
    },
    addBalance = {
        originalMethod = 'addMoney',
    },
    setJob = {
        originalMethod = 'setJob',
    },
    job = {
        originalMethod = 'getJob',
        modifier = {
            executeFun = true,
            effect = function(originalFun)
                local _, jobInfo = originalFun()
                return {name = jobInfo.name, label = jobInfo.label, onDuty = jobInfo.isJob, isBoss = true, grade = {name = jobInfo.rank, label = jobInfo.rankName, salary = 0}}
            end
        }
    },
    charinfo = {
        originalMethod = 'getData',
        modifier = {
            executeFun = true,
            effect = function(data)
                local firstname, lastname = data('firstname'), data('lastname')

                return {firstname = firstname, lastname = lastname}
            end
        }
    },
    name = {
        originalMethod = 'getData',
        modifier = {
            executeFun = true,
            effect = function(data)
                return data('fullname')
            end
        }
    },
    id = {
        originalMethod = 'getData',
        modifier = {
            executeFun = true,
            effect = function(data)
                return data('id')
            end
        }
    },
}

function Core.players()
    local data = {}
    for k, v in ipairs(shared.getPlayers()) do
        local jobInfo = v.jobInfo
        data[k] = {
            job = {name = jobInfo.name, label = jobInfo.label, onDuty = jobInfo.isJob, isBoss = true, grade = {name = jobInfo.rank, label = jobInfo.rankName, salary = 0}},
            charinfo = { firstname = v.firstname, lastname = v.lastname }
        }
    end
    return data
end

function Core.CommandAdd(name, permission, cb, suggestion, flags)
    if type(name) == 'table' then
        for _, command in ipairs(name) do
            shared.Commands.Add(command, suggestion.help, suggestion.arguments, flags.argsrequired, cb, permission)
        end
        return
    end
    shared.Commands.Add(name, suggestion.help, suggestion.arguments, flags.argsrequired, cb, permission)
end

function Core.RegisterUsableItem(name, cb) -- need a way to do this
    return true
end

local totalFunctionsOverride = merge(inventoryFunctions, playerFunctionsOverride)

function Core.GetPlayer(src)
    local player = shared:getPlayer(src)
    if not player then return end
    local wrappedPlayer = retreiveStringIndexedData(player, totalFunctionsOverride, src)

    return wrappedPlayer
end

function Core.hasPerms(...)
    return false
end

return Core
