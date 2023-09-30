

local convars, frameworks in Config
local serverDir = 'server.modules'
local UUID = require'utils'.UUID
local moduleNames = {
    "inventory",
    "core"
}

lib.callback.register('UUID', function(_, num)
    return UUID(num)
end)

print('choosed framework: ' .. json.encode(convars))

for _, moduleName in ipairs(moduleNames) do
    local framework = convars[moduleName]
    if frameworks[framework] then
        local fomartedModule = ("%s.%s.%s"):format(serverDir, moduleName, framework)
        local success, module = pcall(require, fomartedModule)
        if success then
            print('module loaded: ' .. moduleName)
            Framework[moduleName] = module
        else
            error(("Error loading module %s: %s"):format(moduleName, module))
        end
    end
end

Framework.inventory = nil