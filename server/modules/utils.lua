local Utils = {}

function Utils.retreiveData(player, functionsOverride)
    local wrappedPlayer = table.clone(player)
    for method, modification in pairs(functionsOverride) do
        local originalMethod = modification.originalMethod
        local modifier = modification.modifier
        local ref = wrappedPlayer[originalMethod]

        if originalMethod and ref then
            wrappedPlayer[method] = modifier and function(...)
                return modifier(ref, ...)
            end or ref

            wrappedPlayer[originalMethod] = nil
        end
    end
    return wrappedPlayer
end


return Utils