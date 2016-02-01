------------------------------------------------------------------------------
-- send
------------------------------------------------------------------------------
return function(res, data, status)
 local conn = res.conn
 local buf
 --   write protocol headers
 buf="HTTP/1.1 " .. tostring(status or res.statuscode) .. " " .. dofile('http-' .. tostring(status or res.statuscode)) .. "\r\n"
 --   write response headers
 res:addheader("Server", "NodeMCU")
 if data then
  res:addheader("Content-Length", string.len(data))
 end
 for key, value in pairs(res.headers) do
  -- send header
  buf=buf .. key .. ": " .. value .. "\r\n"
 end
 buf=buf.."\r\n"
 --   write body if relevant
 if data then
  buf=buf..data
  buf=buf.."\r\n"
 end
 -- send 
 conn:send(buf)
 buf=nil
 -- close connection
 conn:close()
end