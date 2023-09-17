local bl_bridge = exports.bl_bridge

Framework = setmetatable({}, {
    __index = function(self, index)
        self[index] = bl_bridge[index]()
        return self[index]
    end
})