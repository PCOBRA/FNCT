fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'Vehicle Upgrade System with Horns and Pearlescent Paint'
version '1.0.0'

client_scripts {
    'client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua', -- Yêu cầu mysql-async
    'server.lua'
}

dependencies {
    'es_extended',
    'ox_inventory',
    'ox_lib',
    'mysql-async'
}

files {
    'sql.sql' -- Bao gồm file SQL để tham khảo, nhưng không tự động chạy
}