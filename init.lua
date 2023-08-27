if not lib then return end
local DEFAULT_FRAMEWORK = 'esx'
Framework = setmetatable({}, {
    __newindex = function(self, name, fn)
        local data = function() return fn end
        exports(name, data)
        rawset(self, name, fn)
    end
})
Config = {
    convars = {
        core = GetConvar('bl:framework', DEFAULT_FRAMEWORK),
        menu = GetConvar('bl:menu', DEFAULT_FRAMEWORK),
        textui = GetConvar('bl:textui', DEFAULT_FRAMEWORK),
        target = GetConvar('bl:target', DEFAULT_FRAMEWORK),
        inventory = GetConvar('bl:inventory', DEFAULT_FRAMEWORK),
        progress = GetConvar('bl:progress', DEFAULT_FRAMEWORK),
        radial = GetConvar('bl:radial', DEFAULT_FRAMEWORK),
    },
}

require(("%s.main"):format(lib.context))
