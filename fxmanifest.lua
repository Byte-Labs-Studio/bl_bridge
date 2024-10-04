fx_version "cerulean"
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'
version '1.3.1'

dependencies {
  '/onesync',
}

shared_scripts {
  'require.lua',
  'init.lua',
}

files {
  'utils.lua',
  'client/**/*.lua',
  'imports/client.lua',
}
