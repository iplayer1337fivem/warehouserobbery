fx_version 'cerulean'
game 'gta5'

author 'KostaZ'
description 'Advanced Warehouse Robbery for Qbox, QBCore and ESX'
version '2.0.0'

lua54 'yes'

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
    'client/main.lua'
}

files {
    'config/*.lua',
    'locales/*.json',
    'client/utils.lua',
    'server/utils.lua'
}

dependencies {
    'ox_lib',
    'ultra-voltlab'
}


