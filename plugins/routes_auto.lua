local function getextension(str)
 local i = str:match(".*%.()")
 if i == nil then return nil else return str:sub(i) end
end

local handler = function(req, res, next, opts)

 print("Request received: ", req.method, req.url)
 -- /api/myservice or /my-static-content.html
 local url = req.url
 if url:sub(0, 4) == "/api" then
  -- [GET] /api/myservice will call routes/myservice.get.lua
  local filename = "routes" .. url:sub(5) .. "." .. req.method:lower() .. ".lua"
  print(filename)
  local f = loadfile(filename)
  f()(req, res)
  f = nil
 else
  -- [GET] /index.html will return static/index.html 
  print(getextension(url))
  local f = loadfile("type-" .. getextension(url))
  res:addheader("Content-Type", f())
  f = nil
  res:sendfile("static" .. url)
 end
end

return handler