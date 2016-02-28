-- espress dependency
local espress = require 'espress'

local port = 80

-- create server instance
local server = espress.createserver()

-- use auto router (all files uploaded as static/*.* will be read)
server:use("routes_auto.lc")
server:listen(port)