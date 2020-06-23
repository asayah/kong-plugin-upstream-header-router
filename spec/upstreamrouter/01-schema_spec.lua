local PLUGIN_NAME = "upstreamrouter"

local validate do
  local validate_entity = require("spec.helpers").validate_plugin_config_schema
  local plugin_schema = require("kong.plugins."..PLUGIN_NAME..".schema")

  function validate(data)
    return validate_entity(data, plugin_schema)
  end
end


describe(PLUGIN_NAME .. ": (schema)", function()


  it("Validate spec", function()
    local ok, err = validate({
        ["activations"]  =  {{
              upstream = "google.com",
              headers = {
                host = "test1.com",
                foo  = "test3"
              },
            }}
        })
    assert.is_nil(err)
    assert.is_truthy(ok)
  end)


end)
