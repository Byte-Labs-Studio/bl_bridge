if GetResourceState('ox_core') ~= 'started' then
    error('The imported file from the chosen framework isn\'t starting')
    return
end

local file = 'imports/server.lua'
local chunk = assert(load(LoadResourceFile('ox_core', file), ('@@ox_core/%s'):format(file)))
chunk()


return Ox
