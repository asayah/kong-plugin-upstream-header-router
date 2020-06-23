package = "kong-plugin-upstreamrouter"
version = "0.1.0-1"
local pluginName = package:match("^kong%-plugin%-(.+)$")  -- "upstreamrouter"

supported_platforms = {"linux", "macosx"}
source = {
  url = "http://github.com/Kong/kong-plugin.git",
  tag = "0.1.0"
}

description = {
  summary = "Kong plugin to route traffic to different upstreams depending on header"
}

dependencies = {
}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins."..pluginName..".handler"] = "kong/plugins/"..pluginName.."/handler.lua",
    ["kong.plugins."..pluginName..".schema"] = "kong/plugins/"..pluginName.."/schema.lua",
  }
}
