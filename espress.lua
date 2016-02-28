------------------------------------------------------------------------------
-- HTTP server module
-- LICENCE: http://opensource.org/licenses/MIT
-- Author: Loic Ortola https://github.com/loicortola
------------------------------------------------------------------------------
-- HTTP status codes as defined in RFC 2616 + common ones along with their message
do
 ------------------------------------------------------------------------------
 -- HTTP parser
 ------------------------------------------------------------------------------
 local executerequest = function(self, conn)
  print("Begin request: " .. node.heap())
  
  -- Keep reference to callback
  local req, res, ondisconnect, onheader, ondata, onreceive
  local buf = ""
  local parsedlines = 0
  local bodylength = 0

  ondisconnect = function(conn)
   -- Manually set everything to nil to allow gc
   req = nil
   res = nil
   ondisconnect = nil
   onheader = nil
   ondata = nil
   onreceive = nil
   buf = nil
   parsedlines = nil
   bodylength = nil
   collectgarbage("collect")
   print("Garbage Collector is sweeping. Available memory is now " .. node.heap() .. " bytes.")
  end

  -- Header parser
  onheader = function(k, v)
   --print("Adding header " .. k)
   if k == "content-length" then
    bodylength = tonumber(v)
   end
   -- Delegate to request object
   if req then
    req:addheader(k, v)
   end
  end

  -- Body parser
  ondata = function(conn, chunk)
   -- Prevent MCU from resetting
   tmr.wdclr()
   if chunk then
    req.body = req.body .. chunk
    if #req.body >= bodylength then
     local f = loadfile(self.handlers.handler)
     local next = self.handlers.next
     local success, err = pcall(function() f()(req, res, next, self.handlers.opts) end)
     if not success then
      print("Error occured during execution: " .. err)
      res.statuscode = 500
      res:send("500 - Internal Server Error: " .. err)
     end
     f = nil
     next = nil
    end
   end
  end

  -- Metadata parser
  onreceive = function(conn, chunk)
   -- concat chunks in buffer
   buf = buf .. chunk
   -- this will be used to remove headers from request body
   local headerslength = 0
   -- Read line from chunk
   while #buf > 0 do
    -- Ensure current line is complete
    local e = buf:find("\r\n", 1, true)
    -- Leave if line not done
    if not e then break end
    -- Parse current line
    local line = buf:sub(1, e - 1)
    buf = buf:sub(e + 2)
    headerslength = headerslength + e + 1

    if parsedlines == 0 then
     -- FIRST LINE
     local f = loadfile('http_request.lc')
     req = f()(conn, line)
     f = nil
     local f = loadfile('http_response.lc')
     res = f()(conn)
     f = nil
    elseif #line > 0 then
     -- HEADER LINES
     -- Parse header
     local _, _, k, v = line:find("^([%w-]+):%s*(.+)")
     if k then
      -- Valid header
      k = k:lower()
      onheader(k, v)
     end
    else
     -- BODY
     tmr.wdclr()
     local body = chunk:sub(headerslength + 1)
     -- Buffer no longer needed
     buf = nil
     if bodylength == 0 then
      -- Handle request if no body present
      local f = loadfile(self.handlers.handler)
      local next = self.handlers.next
      local success, err = pcall(function() f()(req, res, next, self.handlers.opts) end)
      if not success then
       print("Error occured during execution: " .. err)
       res.statuscode = 500
       res:send("500 - Internal Server Error: " .. err)
      end
      --FIXME collectgarbage("collect")
     else
      -- If we are sending a form, we need to parse it
      if req.headers["content-type"] == "application/x-www-form-urlencoded" then
       req:parseparams(body)
      end
      -- Change receive hook to body parser if body present
      conn:on("receive", ondata)
      ondata(conn, body)
      onreceive = nil
     end
     break
    end
    parsedlines = parsedlines + 1
   end
  end

  conn:on("receive", onreceive)
  conn:on("disconnection", ondisconnect)
 end
 
 
 local httphandler = function(self)
  return function(conn)
   executerequest(self, conn)
   
  end
 end

 ------------------------------------------------------------------------------
 -- HTTP server
 ------------------------------------------------------------------------------
 local srv
 local createserver = function()
  local hdlr = {}
  hdlr.use = function(self, handler, opts)
   if self.handlers == nil then
    self.handlers = { handler = handler, opts = opts }
   else
    local tmp = self.handlers
    while not (tmp == nil) do
     print("In handler " .. tmp.handler)
     local next = tmp.next
     if next == nil then
      print("Next handler " .. handler .. " will be after " .. tmp.handler)
      tmp.next = { handler = handler, opts = opts }
     end
     tmp = next
    end
   end
   collectgarbage("collect")
  end
  -- Listen
  hdlr.listen = function(self, port)
   -- Last handler returns 404 - NOT FOUND
   self:use("http_default_handler.lc")
   -- Forget about "use" method after listening
   self.use = nil
   if srv then srv:close()
   end
   srv = net.createServer(net.TCP, 5)
   srv:listen(port, httphandler(hdlr))
   print("Server listening on port " .. tostring(port))
   collectgarbage("collect")
   print("Available memory is " .. node.heap() .. " bytes.")
  end
  
  return hdlr
 end

 return {
  createserver = createserver
 }
end
