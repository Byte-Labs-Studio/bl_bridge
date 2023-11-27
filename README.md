

## CFG
``` 
# Frameworks 'ox' | 'qb' | 'esx' | 'custom'
setr bl:framework 'qb' 

# Inventories 'ox' | 'qb' | 'esx' | 'ps' | 'custom'
setr bl:inventory 'ox'

# Context 'ox' | 'qb' | 'esx' | 'custom'
setr bl:context 'ox'

# Target 'ox' | 'qb' | 'esx' | 'custom'
setr bl:target 'ox'

# Progress 'ox' | 'qb' | 'esx' | 'custom'
setr bl:progress 'ox'

# Radial 'ox' | 'qb' | 'esx' | 'custom'
setr bl:radial 'ox'

# Notification 'ox' | 'qb' | 'esx' | 'custom'
setr bl:notify 'ox'
```

## Import 
```lua
client_scripts '@bl_bridge/imports/client.lua',

server_scripts '@bl_bridge/imports/server.lua',
```

# Current Module and Methods

## Server
## Framework.core
```lua
 local coreModule = Framework.core
 local player = coreModule.GetPlayer(src)
---param@ type: 'cash' | 'bank'
 player.getBalance(type)
 player.removeBalance(type, amount)
 player.addBalance(type, amount)
 coreModule.CommandAdd(name, permission, cb, suggestion, flags)
 coreModule.Players--players data (still will do synced methods for all framework, now every framework have their players data)
```