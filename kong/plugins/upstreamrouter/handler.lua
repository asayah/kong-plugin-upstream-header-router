local PLUGIN_NAME = "upstreamrouter"
local tooling = require("kong.plugins." .. PLUGIN_NAME .. ".tooling")

local plugin = {
  PRIORITY = 1000,
  VERSION = "0.1",
}

function plugin:access(plugin_conf)

  local h = kong.request.get_headers()
  local upstream = tooling.get_redirect_uri(h, plugin_conf["activations"])
  kong.log.debug("Upstream override found: ", upstream)

  -- logic can be enhanced with: instread of retrieving only one upstream, we retrieve a list of matching upstreams in a decreasing order.
  -- if upstream doesn't exist, select next one it the list.

  if upstream ~= nil and upstream ~= '' then
    local ok, err = kong.service.set_upstream(upstream)
    if not ok then
      kong.log.err(err)
      return
    end
  end
end


return plugin
