

## CFG
``` 
# Frameworks 'qb' | 'esx'
setr bl:framework 'qb' 

# Inventories 'ox' | 'qb'
setr bl:inventory 'ox'

# Context 'ox' | 'qb'
setr bl:context 'ox'

# Target 'ox' | 'qb'
setr bl:target 'ox'

# Radial 'ox' | 'qb'
setr bl:radial 'ox'

# Notification 'ox' | 'qb'
setr bl:notify 'ox'

# Progressbar 'ox' | 'qb'
setr bl:progressbar 'ox'

# TextUI 'ox' | 'qb'
setr bl:textui 'ox'
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
 coreModule.RegisterUsableItem(name, cb)
 coreModule.Players --players data (still will do synced methods for all framework, now every framework have their players data)
```
## Framework.notify (data like https://overextended.dev/ox_lib/Modules/Interface/Client/notify)
```lua
 Framework.notify(src, data)
```
## Framework.inventory note: integrated into core module even if you use ox_inventory

```lua
 local player = coreModule.GetPlayer(src)

 player.removeItem(item, amount)
 player.addItem(item, amount)
 player.getItem(item)
 local items = player.items --all player items
```
## Client
## Framework.core

```lua
 -- getPlayerData
 local playerData = Framework.core.getPlayerData()
 --[[
     playerData.cid
     playerData.money
     playerData.inventory
     playerData.job 
     playerData.gang (not for esx!)
     playerData.firstName
     playerData.lastName
]]

```
## Framework.context

```lua
 local Context = Framework.context
 @type data: {
        title = string,
        description = string,
        icon = Icon(string, ),
        disabled = boolean,
        event = string,
        args = {xirvin = 'dick'}
 },
 Context.openContext(data)
 Context.closeContext()
```
## Framework.notify (like server just without src as first param)

## Framework.target (options is exactly the same as https://overextended.dev/ox_target)
```lua
-- Example
local Target = Framework.target

local id = Target.addBoxZone(options)
local id = Target.addCircleZone(options)
Target.removeZone(id)
```
