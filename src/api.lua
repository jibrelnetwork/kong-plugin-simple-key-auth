local utils = require "kong.tools.utils"
local responses = require "kong.tools.responses"

return {
  ["/simple-key-auth/"] = {
    GET = function(self)
      return responses.send_HTTP_OK({key = utils.random_string()})
    end,

    PUT = function(self)
      return responses.send_HTTP_NOT_FOUND()
    end,

    POST = function(self)
      return responses.send_HTTP_NOT_FOUND()
    end
  }
}
