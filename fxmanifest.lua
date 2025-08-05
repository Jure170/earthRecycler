fx_version 'cerulean'
game 'gta5'
version "1.9.3"
lua54 'yes'
shared_scripts {
	'@ox_lib/init.lua',
    'config.lua',
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/ComboZone.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
    'config.lua',
	'server/*'
}

client_script {
    'config.lua',
    'client/*'
}