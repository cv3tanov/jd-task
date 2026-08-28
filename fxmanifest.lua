
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'cvetanov'
description 'Оптимизиран интерфейс за текуща задача'
version '3.0.2'

ui_page 'web/ui.html'

files { 'web/ui.html', 'web/styles.css', 'web/scripts.js' }

client_scripts {
    'config.lua',
    'client.lua'
}
