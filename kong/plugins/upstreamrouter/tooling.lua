local tooling = {}

function tooling.get_redirect_uri(headers, activation_rules)
  local host
  local max_matched = 0
  -- we check which activation rule match the most with the passed headers
  for key, activation_rule in pairs(activation_rules) do
    local activation_rule_headers = activation_rule["headers"]
    local match = 0
    for header, header_value in pairs(activation_rule_headers) do
      if deepcompare(headers[header], header_value, true) then
        match = match + 1
      end
    end
    if match > max_matched then
      max_matched = match
      host = activation_rule["upstream"]
    end
  end

  return host
end

function deepcompare(t1, t2, ignore_mt)
  local ty1 = type(t1)
  local ty2 = type(t2)
  if ty1 ~= ty2 then return false end
  -- non-table types can be directly compared
  if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
  -- as well as tables which have the metamethod __eq
  local mt = getmetatable(t1)
  if not ignore_mt and mt and mt.__eq then return t1 == t2 end
  for k1, v1 in pairs(t1) do
    local v2 = t2[k1]
    if v2 == nil or not deepcompare(v1, v2) then return false end
  end
  for k2, v2 in pairs(t2) do
    local v1 = t1[k2]
    if v1 == nil or not deepcompare(v1, v2) then return false end
  end
  return true
end

return tooling


