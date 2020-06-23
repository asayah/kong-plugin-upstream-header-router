local PLUGIN_NAME = "upstreamrouter"
local tooling = require("kong.plugins."..PLUGIN_NAME..".tooling")

describe(PLUGIN_NAME .. ": (tooling)", function()


  it("Validate tooling", function()

    local activations_rules = {
    { upstream = "host1.com",
      headers = {
        host = "test1.com",
        foo  = "test"
      }
    }
  }


  local  headers = {
    foo = "test",
    host = "test1.com",

  }

    local upstream = tooling.get_redirect_uri(headers, activations_rules)
    assert.is_truthy(upstream)
    assert.are.equal(upstream, "host1.com")

  end)


end)
