if not lib then return end
local DEFAULT_FRAMEWORK = 'qb'
Framework = setmetatable({}, {
    __newindex = function(self, name, fn)
        exports(name, function() return fn end)
        rawset(self, name, fn)
    end
})

local function format(str)
    if not string.find(str, "'") then return str end
    return str:gsub("'", "")
end

Config = {
    frameworks = {
        ox = true,
        esx = true,
        qb = true,
        nd = true,
        ps = true,
        qs = true
    },
    convars = {
        core = format(GetConvar('bl:framework', DEFAULT_FRAMEWORK)),
        inventory = format(GetConvar('bl:inventory', DEFAULT_FRAMEWORK)),
        context = format(GetConvar('bl:context', DEFAULT_FRAMEWORK)),
        target = format(GetConvar('bl:target', DEFAULT_FRAMEWORK)),
        progressbar = format(GetConvar('bl:progressbar', DEFAULT_FRAMEWORK)),
        radial = format(GetConvar('bl:radial', DEFAULT_FRAMEWORK)),
        notify = format(GetConvar('bl:notify', DEFAULT_FRAMEWORK)),
        textui = format(GetConvar('bl:textui', DEFAULT_FRAMEWORK)),
    },
    resources = {
        inventory = {
            ox = 'ox_inventory',
            qb = 'qb-inventory',
            ps = 'ps-inventory',
            qs = 'qs-inventory'
        },
        core = {
            nd = 'ND_Core',
            qb = 'qb-core',
            esx = 'es_extended'
        },
        context = {
            qb = 'qb-menu',
            ox = 'none'
        },
        progressbar = {
            qb = 'progressbar',
            ox = 'none'
        },
        radial = {
            qb = 'qb-radialmenu',
            ox = 'none'
        },
        target = {
            qb = 'qb-target',
            ox = 'ox_target',
        },
        notify = {
            qb = 'none',
            ox = 'none',
            esx = 'none',
        },
        textui = {
            ox = 'none',
            qb = 'none',
        }
    },

    client = {
        dir = 'client',
        moduleNames = {
            "core",
            "context",
            "target",
            "radial",
            "notify",
            "inventory",
            "progressbar",
            'textui',
        },
        all = {
            inventory = true
        },
    },
    server = {
        dir = 'server',
        moduleNames = {
            "inventory",
            "core",
            "notify",
        },
        alternative = {
            inventory = {
                ps = 'qb',
                qs = 'qb'
            }
        },
    }
}

exports('getFramework', function(module)
    local moduleConfig = Config.resources[module]
    if not moduleConfig then return end
    
    return moduleConfig[Config.convars[module]]
end)

local function loadModule(dir, moduleName, framework)
    local fomartedModule = ("%s.%s.%s"):format(dir, moduleName, framework)
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

local modulesConfig = Config[lib.context]

if lib.context == 'server' then
    local UUID = require'utils'.UUID
    lib.callback.register('UUID', function(_, num)
        return UUID(num)
    end)
end

for _, moduleName in ipairs(modulesConfig.moduleNames) do
    local framework = Config.convars[moduleName]
    if Config.frameworks[framework] then
        local hasAlternative = modulesConfig.alternative and modulesConfig.alternative[moduleName]
        local moduleForAll = modulesConfig.all and modulesConfig.all[moduleName] and 'all' or framework
        local alternative = hasAlternative and hasAlternative[moduleForAll] or moduleForAll

        local resourceName = Config.resources[moduleName] and Config.resources[moduleName][framework]

        if not resourceName then
            return error('there is no '..framework.. ' on module '..moduleName.. '!, please make sure you configured your convars on cfg!')
        elseif resourceName == 'none' or GetResourceState(resourceName) == 'started' then
            loadModule(modulesConfig.dir, moduleName, alternative)
        else
            ExecuteCommand('ensure '..resourceName)
            if lib.waitFor(function()
                if GetResourceState(resourceName) == 'started' then
                    return true
                end
            end, ('resource %s is not starting'):format(resourceName), 2000) then
                loadModule(modulesConfig.dir, moduleName, alternative)
            end
        end
    end
end
