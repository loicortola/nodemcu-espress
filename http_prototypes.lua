do
 local reqprototype = {
  addheader = function(req, name, value)
   local h = req.headers
   h[name] = value
  end,
  parseparams = function(req, content)
   local params = req.params
   -- sometimes, params can be passed instead of request.
   if req.params == nil then
    params = req
   end
   for name, value in string.gfind(content, "([^&=]+)=([^&=]+)") do
    if not (params[name] == nil) then
     -- If params already declared, put it in an array
     if not (type(params[name]) == "table") then
      -- At first, save previous and create array
      local previous = params[name]
      params[name] = {}
      table.insert(params[name], previous)
     end
     -- If already an array, simply push into it
     table.insert(params[name], value)
    else
     params[name] = value
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