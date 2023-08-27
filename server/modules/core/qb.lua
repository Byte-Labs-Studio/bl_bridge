if GetResourceState('qb-core') ~= 'started' then
    error('The imported file from the chosen framework isn\'t starting')
    return
end

local Core = {}
local shared = exports['qb-core']:GetCoreObject()
local Utils = require 'utils'
local functionsOverride = {
    getBalance = {
        originalMethod = 'GetMoney',
    },
    removeBalance = {
        originalMethod = 'RemoveMoney',
    },
    addBalance = {
        originalMethod = 'AddMoney',
    }
}

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
    local wrappedPlayer = Utils.retreiveData(player.Functions, functionsOverride)
    return wrappedPlayer
end

Core.Players = shared.Players
return Core