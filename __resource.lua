resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
description "vRP showroom"
--ui_page "ui/index.html"

dependency "vrp"

server_scripts{ 
  "@vrp/lib/utils.lua",
  "server.lua"
}

client_scripts{ 
  "lib/Proxy.lua",
  "client.lua"
}