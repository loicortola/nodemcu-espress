-- espress dependency
local espress = require 'espress'

local port = 80

-- create server instance and listen on port
local server = espress.createserver(port)

-- use auto router (all files uploaded as static/*.* will be read)
server:use("routes_auto.lua")