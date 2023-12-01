if not lib then return end
local DEFAULT_FRAMEWORK = 'ox'
Framework = setmetatable({}, {
    __newindex = function(self, name, fn)
        local data = function() return fn end
        exports(name, data)
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
        qb = true
    },
    convars = {
        core =          format(GetConvar('bl:framework', DEFAULT_FRAMEWORK)),
        inventory =     format(GetConvar('bl:inventory', DEFAULT_FRAMEWORK)),
        context =       format(GetConvar('bl:context', DEFAULT_FRAMEWORK)),
        target =        format(GetConvar('bl:target', 'qb')),
        progress =      format(GetConvar('bl:progress', DEFAULT_FRAMEWORK)),
        radial =        format(GetConvar('bl:radial', 'qb')),
        notify =        format(GetConvar('bl:notify', DEFAULT_FRAMEWORK)),
    },
}

require(("%s.main"):format(lib.context))
