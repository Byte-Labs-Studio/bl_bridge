# Byte Labs - Bridge
An extendible and modular bridge for FiveM Frameworks. Made to unify and simplify the process of creating and maintaining resources for multiple frameworks.

Website: [Byte Labs](https://byte-labs.net)
Discord: [Byte Labs](https://discord.gg/fqsqSjZfxE)

# Instruction (Follow [Docs](https://docs.byte-labs.net/bl_bridge))

### Do `none` to disable wanted module like `setr bl:inventory 'none'` if we want to disable inventory module
## CFG
``` 
# Frameworks 'qb' | 'esx' | 'nd'
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

