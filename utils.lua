local Utils = {}

local function retreiveStringIndexedData(playerTable, functionsOverride)
    local newMethods = {}
    local function modifyMethods(data, overrides)
        for method, modification in pairs(overrides) do
            local originalMethod = modification.originalMethod
            local modifier = modification.modifier
            local ref = data[originalMethod]
            if originalMethod and ref then

                newMethods[method] = modifier and (modifier.executeFun and modifier.effect(ref) or function(...)
                    return modifier.effect(ref, ...)
                end) or ref
            end
        end
    end

    local function processTable(tableToProcess, overrides)
        for method, modification in pairs(overrides) do
            if type(modification) == 'table' and not modification.originalMethod then
                processTable(tableToProcess[method], modification)
            else
                modifyMethods(tableToProcess, overrides)
            end
        end
    end

    processTable(playerTable, functionsOverride)
    return newMethods
end

local function retreiveNumberIndexedData(playerTable, functionsOverride)
    local newMethods = {}
    local function modifyMethods(data, overrides)
        for dataIndex, dataValue in ipairs(data) do
            for method, modification in pairs(overrides) do
                local originalMethod = modification.originalMethod
                local originalMethodRef = originalMethod and dataValue[originalMethod]

                if originalMethod == 'none' then
                    local hasKeys = modification.hasKeys
                    for _, key in ipairs(hasKeys) do
                        if dataValue[key] then
                            newMethods[dataIndex] = newMethods[dataIndex] or {}
                            newMethods[dataIndex][method] = {[key] = dataValue[key]}
                        end
                    end
                elseif originalMethodRef then
                    local modifier = modification.modifier
                    newMethods[dataIndex] = newMethods[dataIndex] or {}
                    newMethods[dataIndex][method] = modifier and (modifier.executeFun and modifier.effect(originalMethodRef) or function(...)
                        return modifier.effect(originalMethodRef, ...)
                    end) or originalMethodRef
                end
                
            end
        end
    end

    local function processTable(tableToProcess, overrides)
        for _, value in ipairs(tableToProcess) do
            for method, modification in pairs(overrides) do
                if type(modification) == 'table' and not modification.originalMethod then
                    processTable(value[method], modification)
                else
                    modifyMethods(tableToProcess, overrides)
                end
            end
        end

    end

    processTable(playerTable, functionsOverride)
    return newMethods
end


local function UUID(num)
    num = type(num) == 'number' and num or 5
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    
    local uuid = string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)

    local timestamp = os.time()
    local uuidWithTime = string.format("%s-%s", uuid, timestamp)
    
    if num > 0 and num <= #uuidWithTime then
        uuidWithTime = string.sub(uuidWithTime, 1, num)
    end

    return uuidWithTime
end

Utils.retreiveStringIndexedData = retreiveStringIndexedData
Utils.retreiveNumberIndexedData = retreiveNumberIndexedData
Utils.UUID = UUID
return Utils