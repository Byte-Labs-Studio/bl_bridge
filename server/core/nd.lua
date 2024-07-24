local Core = {}
local shared = exports.ND_Core
local Utils = require 'utils'
local retreiveStringIndexedData = Utils.retreiveStringIndexedData
local merge = Utils.table_merge
local inventoryFunctions = Framework.inventory

AddEventHandler("ND:characterLoaded", function(character)
    TriggerEvent('bl_bridge:server:playerLoaded', character.source, character)
end)

AddEventHandler("ND:moneyChange", function(source, account, amount, action, reason)
    TriggerEvent('bl_bridge:server:updateMoney', source, account, amount, action)
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
    setBalance = {
        originalMethod = 'setMetadata',
        modifier = {
            effect = function(originalFun, type, amount)
                return originalFun(type, amount)
            end
        }
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
                return {firstname = data('firstname'), lastname = data('lastname')}
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
    gender = {
        originalMethod = 'getData',
        modifier = {
            executeFun = true,
            effect = function(data)
                return string.lower(data('gender'))
            end
        }
    },
    dob = {
        originalMethod = 'getData',
        modifier = {
            executeFun = true,
            effect = function(data)
                local year, month, day = data('dob'):match("(%d+)-(%d+)-(%d+)")
                return ('%s/%s/%s'):format(month, day, year) -- DD/MM/YYYY
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
    RegisterCommand(name, cb, permission)
end

if inventoryFunctions then
    Core.RegisterUsableItem = inventoryFunctions.registerUsableItem
end

local totalFunctionsOverride = inventoryFunctions and merge(inventoryFunctions.methods, playerFunctionsOverride) or playerFunctionsOverride

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
