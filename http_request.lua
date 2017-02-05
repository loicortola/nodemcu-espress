return function(prototype, line)
 ------------------------------------------------------------------------------
 -- add header (should be called before send)
 ------------------------------------------------------------------------------
 -- Here, we parse the first line
 -- NB: just version 1.1 assumed
 local _, method, url, querystring, url_no_qs, params

 -- parse method and url
 _, _, method, url = line:find("^([A-Z]+) (.-) HTTP/1.1$")
 -- parse querystring
 _, _, url_no_qs, querystring = url:find("([^%s]+)%?([^%s]+)")

 if url_no_qs then
  url = url_no_qs
 end
 -- parse params
 params = {}
 if querystring then
  prototype.parseparams(params, querystring)
 end
 -- remove modules from cache
 package.loaded['http_request'] = nil

 local destructor = function(req)
   req.method = nil
   req.body = nil
   req.headers = nil
   req.addheader = nil
   req.parseparams = nil
   req.url = nil
   req.params = nil
 end

 -- Return request object
 return {
  method = method,
  body = "",
  headers = {},
  addheader = prototype.addheader,
  parseparams = prototype.parseparams,
  url = url,
  params = params,
  destructor = destructor
 }
end
