-- espress dependency
local espress = require 'espress'

local port = 80

-- create server instance and listen on port
local server = espress.createserver()
-- use api-key handler
server:use("auth_api_key.lc", {apikey = "1234-my-key"})
-- use auto router (all files uploaded as routes/foo.get.lc or routes/bar.post.lc will be read)
server:use("routes_custom.lc")
-- start listening
server:listen(port)