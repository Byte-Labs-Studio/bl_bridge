if GetResourceState('es_extended') ~= 'started' then
    error('The imported file from the chosen framework isn\'t starting')
    return
end

local Core = {}
local shared = exports["es_extended"]:getSharedObject()
local Utils = require 'utils'
local functionsOverride = {
    getBalance = {
        originalMethod = 'getAccount',
        modifier = function(originalFun, type)
            return originalFun(type == 'cash' and 'money' or type).money
        end
    },
    removeBalance = {
        originalMethod = 'removeAccountMoney',
        modifier = function(originalFun, type, amount)
            return originalFun(type == 'cash' and 'money' or type, amount)
        end
    },
    addBalance = {
        originalMethod = 'addAccountMoney',
        modifier = function(originalFun, type, amount)
            return originalFun(type == 'cash' and 'money' or type, amount)
        end
    }
}


function Core.CommandAdd(name, permission, cb, suggestion, flags)
    shared.RegisterCommand(name, permission, cb, flags.allowConsole, suggestion)
end

function Core.GetPlayer(src)
    local player = shared.GetPlayerFromId(src)
    if not player then return end
    local wrappedPlayer = Utils.retreiveData(player, functionsOverride)
    return wrappedPlayer
end

Core.Players = shared.Players
return Core