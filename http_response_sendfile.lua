------------------------------------------------------------------------------
-- send file
------------------------------------------------------------------------------
return function(res, filename, status)
 local buffersize = 512
 local offset = 0
 local buf
 local more = true
 print("Opening file " .. filename)
 if not file.open(filename, "r") then
  res.statuscode = 404
  res:send("404 - Not Found")
 else
  buf = "HTTP/1.1 " .. tostring(status or res.statuscode) .. " " .. dofile('http-' .. tostring(status or res.statuscode)) .. "\r\n"
  --   Write response headers
  res:addheader("Server", "NodeMCU")
  res:addheader("Transfer-Encoding", "chunked")
  for key, value in pairs(res.headers) do
   -- send header
   buf = buf .. key .. ": " .. value .. "\r\n"
  end
  buf = buf .. "\r\n"
  res.conn:send(buf)

  -- Send file body
  local function sendnextchunk()
   collectgarbage("collect")
   file.seek("set", offset)
   buf = file.read(buffersize)
   res.conn:send(("%X\r\n"):format(#buf) .. buf .. "\r\n")
   more = (#buf == buffersize)
   if more then
    offset = offset + buffersize
   else
    file.close()
   end
  end

  res.conn:on("sent", function(conn)
   if (more) then
    sendnextchunk()
   else
    -- Manually free resources for gc
    buf = nil
    buffersize = nil
    offset = nil
    sendnextchunk = nil
    -- Close connection
    conn:send("0\r\n\r\n")
    conn:close()
   end
  end)
 end
end