fx_version 'bodacious'
game 'gta5'

files {
    'json/**/*'
}

client_scripts {
    'client/main.lua',
    'client/menu.lua'
}

server_scripts {
 	'@mysql-async/lib/MySQL.lua',
    'server/main.lua'
}