fx_version "cerulean"
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

dependencies {
  '/onesync',
  'ox_lib',
}

shared_script {
  '@ox_lib/init.lua',
  'init.lua'
}

files {
  'client/main.lua',
  'server/main.lua',
}
