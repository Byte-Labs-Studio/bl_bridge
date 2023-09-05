local Utils = {}

local function retrieveData(playerTable, functionsOverride)
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

Utils.retreiveData = retrieveData

return Utils