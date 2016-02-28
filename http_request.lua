return function(conn, line)
 ------------------------------------------------------------------------------
 -- add header (should be called before send)
 ------------------------------------------------------------------------------
 -- Here, we parse the first line
 -- NB: just version 1.1 assumed
 local _, method, url, querystring, url_no_qs, params

 -- Header parsing function
 local addheader = function(req, name, value)
  local h = req.headers
  h[name] = value
 end
 
 -- Params parsing function (for querystring and form body)
 local parseparams = function(req, content)
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
  parseparams(params, querystring)
 end
 -- remove modules from cache
 package.loaded['http_request'] = nil
 -- Return request object
 return {
  conn = conn,
  method = method,
  body = "",
  headers = {},
  addheader = addheader,
  parseparams = parseparams,
  url = url,
  params = params
 }
end
