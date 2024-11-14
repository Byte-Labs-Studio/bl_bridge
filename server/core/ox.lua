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

AddEventHandler('ox:playerLogout', function(playerId, ...)
    TriggerEvent('bl_bridge:client:playerUnloaded', playerId, ...) -- TODO: sync event data across other framworks
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

local group = {
    originalMethod = 'get',
    modifier = {
        passSource = true,
        executeFunc = true,
        effect = function(get, source)
            local activeGroup = get('activeGroup')
            if not activeGroup then return end

            local job = Ox.GetGroup(activeGroup)

            if type(job) ~= 'table' then return end

            local grade = Ox.GetPlayer(source).getGroup(activeGroup)
            return {name = job.name, label = job.label, onDuty = true, isBoss = job.accountRoles[tostring(grade)] == 'owner', type = job.type, grade = { name = grade, label = job.grades[grade], salary = 0 } }
        end
    }
}

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
        originalMethod = 'getAccount',
        modifier = {
            passSource = true,
            ---@param getAccount function OxAccount
            ---@param source number
            ---@param moneyType MoneyType
            ---@param amount number|string
            effect = function(getAccount, source, moneyType, amount)
                ---@diagnostic disable-next-line: cast-local-type
                amount = tonumber(amount)
                if not amount then return end

                local currentAmount = moneyType == 'cash' and ox_inv:GetItemCount(source, 'money') or (getAccount()?.get('balance') or 0)
                if currentAmount == amount then return end

                if currentAmount > amount then
                    if moneyType == 'cash' then
                        ox_inv:RemoveItem(source, 'money', currentAmount - amount)
                    else
                        getAccount()?.removeBalance({
                            amount = amount
                        })
                    end
                else
                    if moneyType == 'cash' then
                        ox_inv:AddItem(source, 'money', amount - currentAmount)
                    else
                        getAccount()?.addBalance({
                            amount = amount
                        })
                    end
                end
            end
        }
    },
    setJob = {
        originalMethod = 'setGroup',
        modifier = {
            passSource = true,
            ---@param setGroup function
            ---@param source number
            ---@param job string
            ---@param grade number
            effect = function(setGroup, source, job, grade)
                setGroup(job, grade)
                Ox.GetPlayer(source).setActiveGroup(job)
            end
        }
    },
    job = group, -- future TODO: make job and gang as groups
    gang = group,

    charinfo = {
        originalMethod = 'get',
        modifier = {
            ---@param get function 
            ---@return CharInfo
            effect = function(get)
                return { firstname = get('firstName'), lastname = get('lastName') }
            end
        }
    },

    name = {
        originalMethod = 'get',
        modifier = {
            ---@param get function
            ---@return string  --fullname
            effect = function(get)
                return ('%s %s'):format(get('firstName'), get('lastName'))
            end
        }
    },
    id = {
        originalMethod = 'charId',
    },
    gender = {
        originalMethod = 'get',
        modifier = {
            ---@param get function
            ---@return string  --gender
            effect = function(get)
                return get('gender')
            end
        }
    },
    dob = {
        originalMethod = 'get',
        modifier = {
            ---@param get function
            ---@return string  --DD/MM/YYYY
            effect = function(get)
                return get('dateOfBirth')
            end
        }
    },
}

function Core.players()
    return Ox.Players
end

function Core.CommandAdd(name, permission, cb, suggestion, flags)
    print('?') -- todo
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

function Core.hasPerms(...)
    return Ox.Functions.HasPermission(...)
end

return Core
