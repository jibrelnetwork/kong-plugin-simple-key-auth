local responses = require "kong.tools.responses"
local constants = require "kong.constants"
local singletons = require "kong.singletons"
local public_tools = require "kong.tools.public"
local BasePlugin = require "kong.plugins.base_plugin"

local ngx_set_header = ngx.req.set_header
local ngx_get_headers = ngx.req.get_headers
local set_uri_args = ngx.req.set_uri_args
local get_uri_args = ngx.req.get_uri_args
local clear_header = ngx.req.clear_header
local ngx_req_read_body = ngx.req.read_body
local ngx_req_set_body_data = ngx.req.set_body_data
local ngx_encode_args = ngx.encode_args
local get_method = ngx.req.get_method
local type = type

local _realm = 'Key realm="' .. _KONG._NAME .. '"'

local KeyAuthHandler = BasePlugin:extend()

KeyAuthHandler.PRIORITY = 1003


function KeyAuthHandler:new()
  KeyAuthHandler.super.new(self, "key-auth")
end


local function do_authentication(conf)
  local key
  local headers = ngx_get_headers()
  local uri_args = get_uri_args()
  local body_data

  -- read in the body if we want to examine POST args
  if conf.key_in_body then
    ngx_req_read_body()
    body_data = public_tools.get_body_args()
  end

  -- search in headers & querystring
  for i = 1, #conf.key_names do
    local name = conf.key_names[i]
    local v = headers[name]
    if not v then
      -- search in querystring
      v = uri_args[name]
    end

    -- search the body, if we asked to
    if not v and conf.key_in_body then
      v = body_data[name]
    end

    if type(v) == "string" then
      key = v
      break
    elseif type(v) == "table" then
      -- duplicate API key, HTTP 401
      return false, {status = 401, message = "Duplicate API key found"}
    end
  end

  -- this request is missing an API key, HTTP 401
  if not key then
    ngx.header["WWW-Authenticate"] = _realm
    return false, { status = 401, message = "No API key found in request" }
  end

  return true
end


function KeyAuthHandler:access(conf)
  KeyAuthHandler.super.access(self)

  local ok, err = do_authentication(conf)
  if not ok then
    return responses.send(err.status, err.message)
  end
end


return KeyAuthHandler
