

local convars, frameworks in Config
local serverDir = 'server.modules'
local UUID = require'utils'.UUID
local moduleNames = {
    "inventory",
    "core",
    "notify",
}

lib.callback.register('UUID', function(_, num)
    return UUID(num)
end)

local alternative = {
    inventory = {
        ps = 'qb'
    }
}

for _, moduleName in ipairs(moduleNames) do
    local framework = convars[moduleName]
    local hasAlternative = alternative[moduleName]

    if frameworks[framework] then
        local fomartedModule = ("%s.%s.%s"):format(serverDir, moduleName, hasAlternative and hasAlternative[framework] or framework)
        local success, module = pcall(require, fomartedModule)
        if type(module) ~= "string" or not string.find(module, 'not found') then
            if success then
                Framework[moduleName] = module
                print(("[%s] Loaded module %s"):format(framework, moduleName))
            else
                error(("Error loading module %s: %s"):format(moduleName, module))
            end
        end
    end
end

Framework.inventory = nil