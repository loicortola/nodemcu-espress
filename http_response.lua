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
  local f = loadfile("http_response_send.lc")
  f()(res, data, status)
  f = nil
 end

 local sendfile = function(res, filename, status)
  local f = loadfile("http_response_sendfile.lc")
  f()(res, filename, status)
  f = nil
 end

 local sendredirect = function(res, path)
  res:addheader("Location", path)
  res.statuscode = 302
  res:send()
 end
 
 return {
  conn = conn,
  headers = {},
  addheader = addheader,
  send = send,
  sendfile = sendfile,
  sendredirect = sendredirect,
  statuscode = 200
 }
 
end