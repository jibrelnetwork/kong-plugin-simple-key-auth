local utils = require "kong.tools.utils"

return {
  ["/simple-key-auth/"] = {
    GET = function(self, helpers)
      return helpers.responces.send_HTTP_OK(utils.random_string())
    end,

    PUT = function(self, helpers)
      return helpers.responces.send_HTTP_NOT_FOUND()
    end,

    POST = function(self, helpers)
      return helpers.responces.send_HTTP_NOT_FOUND()
    end
  }
}
