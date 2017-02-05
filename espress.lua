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
 -- Request prototype functions
 local reqprototype
 -- Response prototype functions
 local resprototype
 -- Request handler chain
 local handlers
 -- Chain processor
 local processrequest
 -- Request buffer
 local requestbuffer

 local getondisconnect = function(holder)
  return function(res, conn)
   tmr.wdclr()
   print("Finished chain for element " .. holder.id)
   requestbuffer:remove(holder.id)
   holder:destructor()
   holder = nil
   if (requestbuffer:hasnext()) then
    processrequest(requestbuffer:next())
   end
   collectgarbage("collect")
   if (node ~= nil) then
    print("Garbage Collector is sweeping. Available memory is now " .. node.heap() .. " bytes.")
   end
  end
 end

 local getonreceive = function(holder)

  holder.tmp = {}
  holder.tmp.buf = ""
  holder.tmp.parsedlines = 0
  holder.tmp.headerslength = 0
  holder.tmp.bodylength = 0

  -- Metadata parser
  return function(conn, chunk)
   tmr.wdclr()
   -- concat chunks in buffer
   holder.tmp.buf = holder.tmp.buf .. chunk
   -- this will be used to remove headers from request body
   -- Read line from chunk
   while #holder.tmp.buf > 0 do
    -- Ensure current line is complete
    local e = holder.tmp.buf:find("\r\n", 1, true)
    -- Leave if line not done
    if not e then break end
    -- Parse current line
    local line = holder.tmp.buf:sub(1, e - 1)
    holder.tmp.buf = holder.tmp.buf:sub(e + 2)
    holder.tmp.headerslength = holder.tmp.headerslength + e + 1

    if holder.tmp.parsedlines == 0 then
     -- FIRST LINE
     local f = loadfile('http_request.lc')
     holder.req = f()(reqprototype, line)
     f = nil
     local f = loadfile('http_response.lc')
     holder.res = f()(resprototype, conn, getondisconnect(holder))
     f = nil
     collectgarbage("collect")
    elseif #line > 0 then
     -- HEADER LINES
     -- Parse header
     local _, _, k, v = line:find("^([%w-]+):%s*(.+)")
     if k then
      -- Valid header
      k = k:lower()
      --print("Adding header " .. k)
      if k == "content-length" then
       holder.tmp.bodylength = tonumber(v)
      end
      if not (k == "pragma" or k == "cache-control" or k == "connection") then
       -- Add header into request (keep out some useless headers for memory)
       holder.req:addheader(k, v)
      end
     end
    else
     -- BODY
     local body = chunk:sub(holder.tmp.headerslength + 1)
     -- Buffer no longer needed
     chunk = nil
     holder.tmp.buf = nil
     if holder.tmp.bodylength == 0 then
      -- Clean unneeded methods
      holder.req.parseparams = nil
      holder.req.addheader = nil
      holder.tmp = nil
      collectgarbage("collect")
      -- Handle request if no body present
      requestbuffer:push(holder)
      if not (requestbuffer:isbusy()) then
       processrequest(requestbuffer:next())
      else
       print("Stored request into buffer." .. ((node ~= nil) and ' Available memory: ' .. node.heap() .. ' bytes' or ''))
      end
     else
      -- If we are sending a form, we need to parse it
      if holder.req.headers["content-type"] == "application/x-www-form-urlencoded" then
       holder.req:parseparams(body)
       holder.req.parseparams = nil
       holder.req.addheader = nil
      end
      -- Change receive hook to body parser if body present
      local f = loadfile("http_getondata.lc")
      local onreceive = f()(requestbuffer, processrequest)(holder)
      f = nil
      conn:on("receive", onreceive)
      onreceive(conn, body)
      onreceive = nil
      collectgarbage("collect")
     end
     break
    end
    holder.tmp.parsedlines = holder.tmp.parsedlines + 1
   end
  end
 end

 ------------------------------------------------------------------------------
 -- HTTP server
 ------------------------------------------------------------------------------
 local srv
 local createserver = function()
  local f = loadfile('http_prototypes.lc')
  reqprototype, resprototype = f()
  f = loadfile('espress_init.lc')
  local hdlr = f()(getonreceive)
  handlers = hdlr.handlers
  f = loadfile('http_request_processor.lc')
  processrequest = f()(handlers)
  f = loadfile('http_request_buffer.lc')
  requestbuffer = f()
  f = nil
  collectgarbage("collect")
  return hdlr
 end

 return {
  createserver = createserver
 }
end
