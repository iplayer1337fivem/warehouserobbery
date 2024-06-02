fx_version 'cerulean'
game 'gta5'

author 'KostaZ'
description 'Advanced Warehouse Robbery for Qbox, QBCore and ESX'
version '1.0.0'

ox_lib 'locale'

shared_scripts {
    '@ox_lib/init.lua'
}

server_scripts { 
    'bridge/server/*.lua',
    'server/*.lua' 
}

client_scripts { 
    '@qbx_core/modules/playerdata.lua', -- Comment this line if you are not using Qbox
    'bridge/client/*.lua',
    'client/*.lua'
}

files {
    'config/*.lua',
    'locales/*.json'
}

dependencies {
    'ox_lib',
    'ultra-voltlab'
}

lua54 'yes'
