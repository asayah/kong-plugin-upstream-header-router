local typedefs = require "kong.db.schema.typedefs"
local plugin_name = ({ ... })[1]:match("^kong%.plugins%.([^%.]+)")

local schema = {
  name = plugin_name,
  fields = {
    { consumer = typedefs.no_consumer },
    { protocols = typedefs.protocols_http },
    {
      config = {
        type = "record",
        fields = {
          {
            activations = {
              type = "array",
              required = true,
              elements = {
                type = "record",
                required = false,
                fields = {
                  {
                    headers = {
                      type = "map",
                      keys = {
                        type = "string"
                      },
                      values = {
                        type = "string",
                      },
                    }
                  },
                  {
                    upstream = {
                      type = "string"
                    }
                  },
                },
              },
            },
          },
        },
        entity_checks = {},
      },
    },
  },
}

pcall(function()
  table.insert(schema.fields, { run_on = typedefs.run_on_first })
end)

return schema
