local file = ('%s.lua'):format('client/main')
local chunk, err = load(LoadResourceFile('bl_bridge', file), ('@@bl_bridge/%s'):format(file))

if err or not chunk then
    error(err or ("Unable to load file '%s'"):format(file))
end

return chunk()
