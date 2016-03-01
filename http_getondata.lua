-- Data parser
return function(requestbuffer, proceedchain)
 local getondata = function(holder)
  return function(conn, chunk)
   -- Prevent MCU from resetting
   tmr.wdclr()
   if chunk then
    holder.req.body = holder.req.body .. chunk
    if #holder.req.body >= holder.req.bodylength then
     requestbuffer:push(holder)
     if not (requestbuffer:isbusy()) then
      proceedchain(requestbuffer:next())
     end
    end
   end
  end
 end
end