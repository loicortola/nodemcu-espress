local routes = {}

local addhandler = function(url, method, callback)
 if not (routes[url]) then
  routes[url] = {}
 end
 routes[url][method] = callback
end

local makehandler = function(method)
 return function(url, callback)
  addhandler(url, method, callback)
 end
end

local handler = function(req, res, next, opts)
 print("Request received: ", req.method, req.url)
 if routes[req.url] then
  print(routes[req.url][req.method])
  local h = loadfile(routes[req.url][req.method])
  if h then
   h()(req, res)
   h = nil
  else
   h = nil
   res.statuscode = 405
   res:send()
  end
 else
  res.statuscode = 404
  res:send()
 end
end

return { handler = handler, get = makehandler('GET'), post = makehandler('POST'), put = makehandler('PUT'), delete = makehandler('DELETE'), options = makehandler('OPTIONS'), head = makehandler('HEAD') }