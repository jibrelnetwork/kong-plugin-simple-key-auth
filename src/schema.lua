local utils = require "kong.tools.utils"


local function default_key_names(t)
  if not t.key_names then
    return { "apikey" }
  end
end


local function check_keys(keys)
  for _, key in ipairs(keys) do
    local res, err = utils.validate_header_name(key, false)

    if not res then
      return false, "'" .. key .. "' is illegal: " .. err
    end
  end

  return true
end


return {
  no_consumer = true,
  fields = {
    key_names = {
      required = true,
      type = "array",
      default = default_key_names,
      func = check_keys,
    },
    key_in_body = {
      type = "boolean",
      default = false,
    },
  }
}
