fx_version "adamant"

game       "gta5"

author      "Jaareet#0097 with the help of Medinaa#7364"
description "J-UI / FiveM HUD"

shared_scripts {
    "cfg.lua"
}

server_scripts {
    "server.lua",
}

client_scripts {
    "client.lua",
}

ui_page {
    "nui/index.html",
}

files {
    --<-- CSS -->--
    "nui/dist/css/style.css",
    --<-- JS -->--
    "nui/dist/js/script.js",
    --<-- Images -->--
    "nui/dist/img/*.*",
    --<-- Media -->--
    "nui/dist/media/*.*",
    --<-- HTML -->--
    "nui/index.html",
}