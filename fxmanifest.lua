fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name "um-error-tracker"
description "um-error-tracker"
author "uyuyorum {um}"
version "1.0.0"

shared_scripts {
	'@ox_lib/init.lua',
}

client_scripts {
	'lua/trackerlist.lua',
	'lua/client.lua'
}

server_script 'lua/server.lua'

ui_page 'web/build/index.html'

files {
	'web/build/**'
}