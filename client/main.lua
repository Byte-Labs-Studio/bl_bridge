local convars, frameworks in Config
local clientDir = 'client.modules'
local moduleNames = {
    'core',
    "context",
}

print('choosed framework: ' .. json.encode(convars))

for _, moduleName in ipairs(moduleNames) do
    local framework = convars[moduleName]
    if frameworks[framework] then
        local fomartedModule = ("%s.%s.%s"):format(clientDir, moduleName, framework)
        local success, module = pcall(require, fomartedModule)
        if success then
            print('module loaded: ' .. moduleName)
            Framework[moduleName] = module
        else
            error(("Error loading module %s: %s"):format(moduleName, module))
        end
    end
end
