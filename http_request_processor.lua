-- Chain proceeding function
return function(handlers)
 return function(holder)
  collectgarbage("collect")
  print("Processing element " .. holder.id)
  local success, err = pcall(function()
   local f = loadfile(handlers.handler)
   f()(holder.req, holder.res, handlers.next, handlers.opts)
   f = nil
  end)
  if not success then
   print("Error occured during execution: " .. err)
   holder.req = nil
   holder.res.statuscode = 500
   holder.res:send("500 - Internal Server Error: " .. err)
  end
 end
end