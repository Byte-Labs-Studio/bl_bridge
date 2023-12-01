

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
-- Player

 local player = coreModule.GetPlayer(src)
 player.getBalance(type --[['cash' | 'bank']])
 player.removeBalance(type, amount)
 player.addBalance(type, amount)
 player.setJob(job, grade)
 -- PlayerData

 local job = player.job --{name = job.name, label = job.label, onDuty = job.onduty, isBoss = job.isboss, grade = {name = job.grade.level, label = job.grade.label, salary = job.payment}}
 local gang = player.gang --{name = gang.name, label = gang.label, isBoss = gang.isboss, grade = {name = gang.grade.level, label = gang.grade.label}}
 local charinfo = player.charinfo --{firstname = data.firstname, lastname = data.lastname}
 print(player.id) -- citizenid
 -- Global
 coreModule.CommandAdd(name, permission, cb, suggestion, flags)
 coreModule.Players --players data (still will do synced methods for all framework, now every framework have their players data)
```
## Framework.notify
```lua
 Framework.notify(src, data) -- data: {description: string, status, duration: number}
```
## Framework.inventory (integrated into core module even if you use ox_inventory)

```lua
 local player = coreModule.GetPlayer(src)

 player.removeItem(item, amount)
 player.addItem(item, amount)
 player.getItem(item)
 local items = player.items --all player items
```
