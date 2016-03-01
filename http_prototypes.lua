do
 local reqprototype = {
  addheader = function(req, name, value)
   local h = req.headers
   h[name] = value
  end,
  parseparams = function(req, content)
   for name, value in string.gfind(content, "([^&=]+)=([^&=]+)") do
    if not (req.params[name] == nil) then
     -- If params already declared, put it in an array
     if not (type(req.params[name]) == "table") then
      -- At first, save previous and create array
      local previous = req.params[name]
      req.params[name] = {}
      table.insert(req.params[name], previous)
     end
     -- If already an array, simply push into it
     table.insert(req.params[name], value)
    else
     req.params[name] = value
    end
   end
  end
 }

 local resprototype = {
  addheader = reqprototype.addheader,
  send = function(res, data, status)
   local f = loadfile("http_response_send.lc")
   f()(res, data, status)
   f = nil
  end,
  sendfile = function(res, filename, status)
   local f = loadfile("http_response_sendfile.lc")
   f()(res, filename, status)
   f = nil
  end,
  sendredirect = function(res, path)
   res:addheader("Location", path)
   res.statuscode = 302
   res:send()
  end
 }
 return reqprototype, resprototype
end