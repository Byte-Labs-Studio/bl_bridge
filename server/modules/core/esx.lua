if GetResourceState('es_extended') ~= 'started' then
    error('The imported file from the chosen framework isn\'t starting')
    return
end

return exports["es_extended"]:getSharedObject()