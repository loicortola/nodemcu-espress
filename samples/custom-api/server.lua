-- espress dependency
local espress = require 'espress'

local port = 80

-- create server instance and listen on port
local server = espress.createserver(port)
-- use api-key handler
server:use("auth_api_key.lua", {apikey = "1234-my-key"})
-- use auto router (all files uploaded as routes/foo.get.lua or routes/bar.post.lua will be read)
server:use("routes_custom.lua")