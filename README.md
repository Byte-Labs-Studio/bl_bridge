

## CFG
``` 
# Frameworks 'ox' | 'qb' | 'esx' | 'custom'
sets bl:framework 'qb' 

# Inventories 'ox' | 'qb' | 'esx' | 'ps' | 'custom'
sets bl:inventory 'qb'

# Context 'ox' | 'qb' | 'esx' | 'custom'
sets bl:context 'qb'

# Target 'ox' | 'qb' | 'esx' | 'custom'
sets bl:target 'qb'

# Progress 'ox' | 'qb' | 'esx' | 'custom'
sets bl:progress 'qb'

# Notification 'ox' | 'qb' | 'esx' | 'custom'
sets bl:radial 'qb'
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