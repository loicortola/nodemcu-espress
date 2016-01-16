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
 local httphandler = function(self)
  return function(conn)
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
    print("Garbage Collector is sweeping " .. node.heap())
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
    collectgarbage("collect")
    if chunk then
     req.body = req.body .. chunk
     if #req.body >= bodylength then
      local f = loadfile(self.handlers.handler)
      f()(req, res, self.handlers.next, self.handlers.opts)
      f = nil
      collectgarbage("collect")
     end
    end
   end

   -- Metadata parser
   onreceive = function(conn, chunk)
    collectgarbage("collect")
    -- concat chunks in buffer
    buf = buf .. chunk
    -- Read line from chunk
    while #buf > 0 do
     local e = buf:find("\r\n", 1, true)
     -- Leave if line not done
     if not e then break end

     local line = buf:sub(1, e - 1)
     buf = buf:sub(e + 2)

     if parsedlines == 0 then
      -- FIRST LINE
      local f = loadfile('http_request.lua')
      req = f()(conn, line)
      f = nil
      local f = loadfile('http_response.lua')
      res = f()(conn)
      f = nil
      collectgarbage("collect")
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
      -- Buffer no longer needed
      buf = nil
      if bodylength == 0 then
       collectgarbage("collect")
       -- Handle request if no body present
       local f = loadfile(self.handlers.handler)
       f()(req, res, self.handlers.next, self.handlers.opts)
       f = nil
       collectgarbage("collect")
      else
       -- Change receive hook to body parser if body present
       conn:on("receive", ondata)
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
 end

 ------------------------------------------------------------------------------
 -- HTTP server
 ------------------------------------------------------------------------------
 local srv
 local createserver = function(port)
  if srv then srv:close()
  end
  srv = net.createServer(net.TCP, 5)
  local hdlr = {}
  hdlr.use = function(self, handler, opts)
   if self.handlers == nil then
    self.handlers = { handler = handler, opts = opts }
   else
    local tmp = self.handlers
    while not (tmp == nil) do
     local next = tmp.next
     if next == nil then
      self.handlers.next = { handler = handler, opts = opts }
     end
     tmp = next
    end
   end
   collectgarbage("collect")
  end
  -- Listen
  srv:listen(port, httphandler(hdlr))
  print(node.heap())
  print("Server listening on port " .. tostring(port))
  return hdlr
 end

 return {
  createserver = createserver
 }
end
