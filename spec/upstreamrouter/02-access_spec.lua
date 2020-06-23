local helpers = require "spec.helpers"
local PLUGIN_NAME = "upstreamrouter"
local tooling = require("kong.plugins."..PLUGIN_NAME..".tooling")
local cjson   = require "cjson"


local route_config = {
  ["activations"]  =  {{
    upstream = "test1",
    headers = {
      test = "header1",
      specialheader = "specialheader"
    },
  },
    {
      upstream = "test2",
      headers = {
        test = "header2",
        specialheader = "specialheader"
      },
    },
    {
      upstream = "mockbin",
      headers = {
        test = "header3",
        specialheader = "specialheader"
      },
    },
  },
}



for _, strategy in helpers.each_strategy() do
  describe(PLUGIN_NAME .. ": (access) [#" .. strategy .. "]", function()
    local client

    lazy_setup(function()
      local bp = helpers.get_db_utils(strategy, nil, { PLUGIN_NAME })

      local service = bp.services:insert {
        protocol = helpers.mock_upstream_protocol,
        host     ="httpbin.org",
        port     = 80,
        name     = "httpbin"
      }

      local route1 = bp.routes:insert({
        hosts = { "httpbin.org" },
        service = service
      })

      local upstream = bp.upstreams:insert({
        name = "mockbin",
        host_header = "mockbin.org"
      })

      bp.targets:insert({
          target = helpers.mock_upstream_host .. ":" .. helpers.mock_upstream_port,
          upstream = { id = upstream.id }
      })

      bp.plugins:insert {
        name = PLUGIN_NAME,
        route = { id = route1.id },
        config = route_config,
      }

      assert(helpers.start_kong({
        database   = strategy,
        nginx_conf = "spec/fixtures/custom_nginx.template",
        plugins = "bundled," .. PLUGIN_NAME,
      }))
    end)

    lazy_teardown(function()
      helpers.stop_kong(nil, true)
    end)

    before_each(function()
      client = helpers.proxy_client()
    end)

    after_each(function()
      if client then client:close() end
    end)



    describe("request", function()
      it("redirect request on match", function()
        local headers = {
          test = "header3",
          specialheader = "specialheader",
          host = "httpbin.org"

        }
        local r = client:get("/request", {
          headers = headers
        })

       local upstream = tooling.get_redirect_uri(headers, route_config["activations"])
        assert.are.equal(upstream, "mockbin")

        local body = assert.res_status(200, r)
        local json = cjson.decode(body)
        assert.equal("http://mockbin.org:15555/request", json.url)
      end)
    end)


  end)
end
