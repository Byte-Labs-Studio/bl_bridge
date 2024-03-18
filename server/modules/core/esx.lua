if GetResourceState('es_extended') ~= 'started' then
    error('The imported file from the chosen framework isn\'t starting')
    return
end

local Core = {}
local shared = exports["es_extended"]:getSharedObject()
local Utils = require 'utils'
local merge = lib.table.merge

local inventoryFunctions = Framework.inventory
local coreFunctionsOverride = {
    getBalance = {
        originalMethod = 'getAccount',
        modifier = {
            effect = function(originalFun, type)
                return originalFun(type == 'cash' and 'money' or type).money
            end
        }
    },
    removeBalance = {
        originalMethod = 'removeAccountMoney',
        modifier = {
            effect = function(originalFun, type, amount)
                return originalFun(type == 'cash' and 'money' or type, amount)
            end
        }
    },
    addBalance = {
        originalMethod = 'addAccountMoney',
        modifier = {
            effect = function(originalFun, type, amount)
                return originalFun(type == 'cash' and 'money' or type, amount)
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
            effect = function(data)
                local job = data()
                return {name = job.name, label = job.label, onDuty = true, isBoss = false, grade = {name = job.grade, label = job.grade_label, salary = job.grade_salary}}
            end
        }
    },
    name = {
        originalMethod = 'getName',
        modifier = {
            executeFun = true,
        }
    },
    id = {
        originalMethod = 'identifier',
    },
    gender = {
        originalMethod = 'sex',
    },
    dob = {
        originalMethod = 'dateofbirth',
        modifier = {
            effect = function(string)
                if type(string) ~= 'string' then return end
                local month, day, year = string:match("(%d+)/(%d+)/(%d+)")
                return ('%s/%s/%s'):format(month, day, year)
            end
        }
    },
}

local totalFunctionsOverride = merge(inventoryFunctions.methods, coreFunctionsOverride)

function Core.CommandAdd(name, permission, cb, suggestion, flags)
    shared.RegisterCommand(name, permission, cb, flags.allowConsole, suggestion)
end

Core.RegisterUsableItem = inventoryFunctions.registerUsableItem or function(name, cb)
    shared.RegisterUsableItem(name, cb)
end

function Core.GetPlayer(src)
    local player = shared.GetPlayerFromId(src)
    if not player then return end
    local wrappedPlayer = Utils.retreiveStringIndexedData(player, totalFunctionsOverride)
    return wrappedPlayer
end

Core.Players = shared.Players
return Core