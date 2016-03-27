local function getextension(str)
 local i = str:match(".*%.()")
 if i == nil then return nil else return str:sub(i) end
end

local handler = function(req, res, next, opts)

 print("Request received: ", req.method, req.url)
 -- /api/myservice or /my-static-content.html
 local url = req.url
 if url == "/" then
    url = "/index.html"
 end
 if url:sub(0, 4) == "/api" then
  -- [GET] /api/myservice will call routes/myservice.get.lc
  local filename = "routes" .. url:sub(5) .. "." .. req.method:lower() .. ".lc"
  if not file.open(filename, "r") then 
   print("File " .. filename .. " not found")
   local f = loadfile(next.handler)
   f()(req, res, next.next, next.opts)
   f = nil
   return nil
  end
  local f = loadfile(filename)
  f()(req, res)
  f = nil
 else
  -- [GET] /index.html will return static/index.html
  local type = loadfile("type-" .. getextension(url))
  if type == nil then
   type = "octet-stream"
  else
   type = type() 
  end
  res:addheader("Content-Type", type)
  res:sendfile("static" .. url)
 end
end

return handler