local handler = function(req, res, next, opts)
 local bypass = false
 -- bypass if url is not in includes 
 if opts.includes and not (req.url:sub(1, opts.includes:len()) == opts.includes) then
  bypass = true
 end
 -- bypass if url is in excludes
 if opts.excludes and req.url:sub(1, opts.excludes:len()) == opts.excludes then
  bypass = true
 end

 -- apikey is declared in opts.apikey
 if bypass or (req.headers["x-api-key"] == opts.apikey) or (req.params["api-key"] == opts.apikey)then
  print("Api-Key header valid or bypassed")
  local f = loadfile(next.handler)
  f()(req, res, next.next, next.opts)
  f = nil
 elseif req.headers["x-api-key"] == nil then
  print("Api-Key header is not set. Api-Key is required")
  res.statuscode = 400
  res:send()
 else
  print("Api-Key header is not valid.")
  res.statuscode = 401
  res:send()
 end
end
return handler