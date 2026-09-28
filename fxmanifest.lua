fx_version 'cerulean'
game 'gta5'

author 'LZ7 Development'
description 'Standalone FiveM elevator resource with configurable destinations and a NUI keypad'
version '1.0.0'

lua54 'yes'

shared_script 'config.lua'

client_script 'client/main.lua'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/elevator.ogg'
}
