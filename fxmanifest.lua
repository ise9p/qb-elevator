fx_version 'cerulean'
game 'gta5'

author 'se9p'
description 'QBCore Elevator Script'
version '1.0.0'



shared_script {
    '@ox_lib/init.lua',
    'config.lua'
}
client_script {
    'client/*.lua',
}


dependencies {
    'qb-core',  
}

lua54 'yes'
