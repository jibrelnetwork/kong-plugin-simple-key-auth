# kong-plugin-key-auth

Add Key Authentication to your APIs. Consumers then add their key either in a querystring parameter or a header to authenticate their requests.

## Use Kong with the plugin

$ make install-dev

This command installs plugin locally to a ./lua_modules directory. The PATH to moudles installed in this folder will be something like:

/path/to/kong-plugin-key_auth/lua_modules/share/lua/5.1/?.lua 

## Configuration

Configuring the plugin is straightforward, you can add it on top of an API by executing the following request on your Kong server:

$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=kong-plugin-key-auth"
    
**api**: The id or name of the API that this plugin configuration will target

You can also apply it for every API using the http://kong:8001/plugins/ endpoint.

| Parameter                           | Default    | Description                                                                                                                                                                                                                                    |
|-------------------------------------|------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **name**                            |            | The name of the plugin, in this case: **kong-plugin-key-auth**.                                                                                                                                                                                |
| **config.key_names** *(optional)*   | **apikey** | Describes an array of comma separated parameter names where the plugin will look for a key. The key names may only contain [a-z], [A-Z], [0-9] and [-].                                                                                        |
| **config.key_in_body** *(optional)* | **false**  | If enabled, the plugin will read the request body (if said request has one and its MIME type is supported) and try to find the key in it. Supported MIME types are application/www-form-urlencoded, application/json, and multipart/form-data. |

## Get an API Key

$ curl -X GET http://kong:8001/simple-key-auth -d ''

 { "key": "62a7d3b7-b995-49f9-c9c8-bac4d781fb59"}
 
## Using the API Key

Simply make a request with the key as a querystring parameter:

$ curl http://kong:8000/{api path}?apikey=<some_key>

Or in a header:

$ curl http://kong:8000/{api path} \
    -H 'apikey: <some_key>'
