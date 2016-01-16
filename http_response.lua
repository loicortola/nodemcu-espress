return function(conn)
 ------------------------------------------------------------------------------
 -- add header (should be called before send)
 ------------------------------------------------------------------------------
 local addheader = function(res, name, value)
  local h = res.headers
  h[name] = value
 end

 ------------------------------------------------------------------------------
 -- send response
 ------------------------------------------------------------------------------
 local send = function(res, data, status)
  local f = loadfile("http_response_send.lua")
  f()(res, data, status)
  f = nil
 end

 local sendfile = function(res, filename, status)
  local f = loadfile("http_response_sendfile.lua")
  f()(res, filename, status)
  f = nil
 end
 
 return {
  conn = conn,
  headers = {},
  addheader = addheader,
  send = send,
  sendfile = sendfile,
  statuscode = 200
 }
end