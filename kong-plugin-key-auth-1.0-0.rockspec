package = "kong-plugin-key-auth"
version = "1.0-0"
supported_platforms = {"linux", "macosx"}
source = {
  url = "git://github.com/jibrelnetwork/kong-plugin-key-auth",
  tag = "1.0.0"
}
description = {
  summary = "The Kong Key Auth plugin.",
  license = "MIT",
  homepage = "https://www.github.com/jibrelnetwork/kong-plugin-key-auth",
  detailed = [[
  	Simple key authentication
  ]],
}
dependencies = {
  "lua ~> 5.1",
  "stringy ~> 0.4-1"
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.key-auth.handler"] = "src/handler.lua",
    ["kong.plugins.key-auth.schema"] = "src/schema.lua",
    ["kong.plugins.key-auth.api"] = "src/api.lua"
  }
}