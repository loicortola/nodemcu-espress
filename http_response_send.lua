------------------------------------------------------------------------------
-- send
------------------------------------------------------------------------------
return function(res, data, status)
 local conn = res.conn
 print(node.heap())
 --   write protocol headers
 conn:send("HTTP/1.1 " .. tostring(status or res.statuscode) .. " " .. dofile('http-' .. tostring(status or res.statuscode)) .. "\r\n")
 --   write response headers
 res:addheader("Server", "NodeMCU")
 if data then
  res:addheader("Content-Length", string.len(data))
 end
 for key, value in pairs(res.headers) do
  -- send header
  res.conn:send(key .. ": " .. value .. "\r\n")
 end
 conn:send("\r\n")
 --   write body if relevant
 if data then
  conn:send(data)
  conn:send("\r\n")
 end
 -- close connection
 conn:close()
end