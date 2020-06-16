fx_version 'bodacious'
game 'gta5'

resource_version '1.0'

files {
    'json/**/*'
}

dependencies {'ghmattimysql'}

client_scripts {
    'client/main.lua',
    'client/menu.lua'
}

server_scripts {
    'server/main.lua'
}