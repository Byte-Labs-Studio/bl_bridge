local currentFramework = Config.convars
local serverDir = 'server.modules'
local moduleNames = {
    "inventory",
    "core"
}
lib.callback.register('UUID', function(_, num)
    return require'utils'.UUID(num)
end)

print('choosed framework: ' .. json.encode(currentFramework))

for _, moduleName in ipairs(moduleNames) do
    local isModuleExist = currentFramework[moduleName]
    if isModuleExist then
        local success, module = pcall(require, ("%s.%s.%s"):format(serverDir, moduleName, isModuleExist))
        if success then
            Framework[moduleName] = module
        else
            error(("Error loading module %s: %s"):format(moduleName, module))
        end
    end
end
