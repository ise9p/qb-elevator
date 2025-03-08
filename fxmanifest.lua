fx_version 'cerulean'
game 'gta5'

author 'se9p'
description 'QBCore Elevator Script'
version '1.0.1'


shared_script {
    '@ox_lib/init.lua',
    'config.lua'
}

client_script {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
}
dependencies {
    'qb-core',  
}

lua54 'yes'
