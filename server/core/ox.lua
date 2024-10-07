assert(GetFramework('inventory') == 'ox_inventory', 'Needs ox_inventory')

local Core = {}
local Utils = require 'utils'
local Ox = require '@ox_core/lib/init'
local retreiveStringIndexedData = Utils.retreiveStringIndexedData
local merge = Utils.table_merge
local inventoryFunctions = Framework.inventory
local ox_inv = exports.ox_inventory

AddEventHandler('ox:playerLoaded', function(playerId, ...)
    TriggerEvent('bl_bridge:server:playerLoaded', playerId, ...) -- TODO: sync event data across other framworks
end)

ox_inv:registerHook('swapItems', function(payload)
    local toInv = payload.toInventory
    local fromInv = payload.fromInventory
    if toInv == fromInv then return end     -- swap in same inv, means the amount will stay the same

    local count = payload.count
    if type(toInv) == 'number' and payload.toType == 'player' then
        TriggerEvent('bl_bridge:server:updateMoney', toInv, 'cash', count, 'add')
    end

    if type(fromInv) == 'number' and payload.fromType == 'player' then
        TriggerEvent('bl_bridge:server:updateMoney', fromInv, 'cash', count, 'remove')
    end
    return true
end, {
    itemFilter = {
        money = true,
    },
})
ox_inv:registerHook('createItem', function(payload)
    if type(payload.inventoryId) ~= 'number' then return end
    TriggerEvent('bl_bridge:server:updateMoney', payload.inventoryId, 'cash', payload.count, 'add')
    return true
end, {
    itemFilter = {
        money = true,
    },
})

local playerFunctionsOverride = {
    getBalance = {
        originalMethod = 'getAccount',
        modifier = {
            passSource = true,
            ---@param getAccount function OxAccount
            ---@param source number
            ---@param moneyType MoneyType
            effect = function(getAccount, source, moneyType)
                return moneyType == 'cash' and ox_inv:GetItemCount(source, 'money') or (getAccount()?.get('balance') or 0)
            end,
        }
    },

    removeBalance = {
        originalMethod = 'getAccount',
        modifier = {
            passSource = true,
            ---@param getAccount function OxAccount
            ---@param source number
            ---@param moneyType MoneyType
            ---@param amount number
            effect = function(getAccount, source, moneyType, amount)
                if moneyType == 'bank' then
                    getAccount()?.removeBalance({
                        amount = amount
                    })
                else
                    ox_inv:RemoveItem(source, 'money', amount)
                end
            end,
        }
    },
    addBalance = {
        originalMethod = 'getAccount',
        modifier = {
            passSource = true,
            ---@param getAccount function OxAccount
            ---@param source number
            ---@param moneyType MoneyType
            ---@param amount number
            effect = function(getAccount, source, moneyType, amount)
                if moneyType == 'bank' then
                    getAccount()?.addBalance({
                        amount = amount
                    })
                else
                    ox_inv:AddItem(source, 'money', amount)
                end
            end,
        }
    },
    setBalance = {
        originalMethod = 'SetMoney',
    },
    -- setJob = {
    --     originalMethod = 'SetJob',
    -- },
    -- PlayerData = {
    --     job = {
    --         originalMethod = 'job',
    --         modifier = {
    --             executeFunc = true,
    --             effect = function(originalFun)
    --                 local job = originalFun
    --                 return {name = job.name, label = job.label, onDuty = job.onduty, isBoss = job.isboss, type = job.type, grade = { name = job.grade.level, label = job.grade.name, salary = job.payment } }
    --             end
    --         }
    --     },
    --     gang = {
    --         originalMethod = 'gang',
    --         modifier = {
    --             executeFunc = true,
    --             effect = function(data)
    --                 local gang = data
    --                 return {name = gang.name, label = gang.label, isBoss = gang.isboss, grade = {name = gang.grade.level, label = gang.grade.label}}
    --             end
    --         }
    --     },
    --     charinfo = {
    --         originalMethod = 'charinfo',
    --         modifier = {
    --             executeFunc = true,
    --             effect = function(data)
    --                 return {firstname = data.firstname, lastname = data.lastname}
    --             end
    --         }
    --     },
    --     name = {
    --         originalMethod = 'name',
    --     },
    --     id = {
    --         originalMethod = 'citizenid',
    --     },
    --     gender = {
    --         originalMethod = 'charinfo',
    --         modifier = {
    --             executeFunc = true,
    --             effect = function(data)
    --                 local gender = data.gender
    --                 gender = gender == 1 and 'female' or 'male'
    --                 return gender
    --             end
    --         }
    --     },
    --     dob = {
    --         originalMethod = 'charinfo',
    --         modifier = {
    --             executeFunc = true,
    --             effect = function(data)
    --                 local year, month, day = data.birthdate:match("(%d+)-(%d+)-(%d+)")
    --                 return ('%s/%s/%s'):format(month, day, year) -- DD/MM/YYYY
    --             end
    --         }
    --     },
    --     items = {
    --         originalMethod = 'items',
    --     },
    -- }
}

function Core.players()
    local data = {}
    for k, v in ipairs(Ox.Players) do
        local playerData = v.PlayerData
        local job = playerData.job
        local gang = playerData.gang
        local charinfo = playerData.charinfo
        data[k] = {
            job = { name = job.name, label = job.label, onDuty = job.onduty, type = job.type, isBoss = job.isboss, grade = { name = job.grade.level, label = job.grade.name, salary = job.payment } },
            gang = { name = gang.name, label = gang.label, isBoss = gang.isboss, grade = { name = gang.grade.level, label = gang.grade.label } },
            charinfo = { firstname = charinfo.firstname, lastname = charinfo.lastname }
        }
    end
    return data
end

function Core.CommandAdd(name, permission, cb, suggestion, flags)

end

Core.RegisterUsableItem = inventoryFunctions?.registerUsableItem or function()
    print('how dare you use ox_core without ox_inventory? get a brain!')
end

local totalFunctionsOverride = inventoryFunctions and merge(inventoryFunctions.methods, playerFunctionsOverride) or
playerFunctionsOverride

function Core.GetPlayer(src)
    local player = Ox.GetPlayer(src)
    if not player then return end
    return retreiveStringIndexedData(player, totalFunctionsOverride, src)
end

print(Core.GetPlayer(1).addBalance('cash', 1000))

function Core.hasPerms(...)
    return Ox.Functions.HasPermission(...)
end

return Core
