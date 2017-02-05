------------------------------------------------------------------------------
-- send file
------------------------------------------------------------------------------
return function(res, filename, status)
 local buffersize = 256
 local offset = 0
 local buf
 local more = true
 tmr.wdclr()
 print("Opening file " .. filename)
 if not file.open(filename, "r") then
  -- Try gzip
  if file.open(filename .. ".gz", "r") then
   res:addheader("Content-Encoding", "gzip")
  else
   res.statuscode = 404
   res:send("404 - Not Found")
   return
  end
 end

 -- A file was found, and opened
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
  tmr.wdclr()
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
   -- Remove default sent callback
   conn:on("sent", nil)
   -- Send last chunk and close connection
   conn:on("sent", function(conn)
     -- Close connection
     conn:on('sent', nil)
     -- Call termination callback
     res:close()
   end
   )
   conn:send("0\r\n\r\n")
  end
 end)
end
