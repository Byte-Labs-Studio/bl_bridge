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
            ps = 'ps-inventory'
        },
        core = {
            nd = 'ND_Core',
            qb = 'qb-core',
            esx = 'es_extended'
        },
        context = {
            qb = 'qb-menu',
        },
        progressbar = {
            qb = 'progressbar'
        },
        radial = {
            qb = 'qb-radialmenu'
        },
        target = {
            qb = 'qb-target'
        },
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
                ps = 'qb'
            }
        },
    }
}

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

        if not resourceName or GetResourceState(resourceName) == 'started' then
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
