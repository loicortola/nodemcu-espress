do
 ------------------------------------------------------------------------------
 -- send not found
 ------------------------------------------------------------------------------
 local sendnotfound = function(res)
  -- File does not exist, return 404
  res.conn:send("HTTP/1.1 404 Not Found\r\n")
  --   write response headers
  res:addheader("Server", "NodeMCU")
  res.conn:send("\r\n")
  res.conn:close()
 end
 return sendnotfound
end