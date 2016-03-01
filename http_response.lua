return function(prototype, conn)
 ------------------------------------------------------------------------------
 -- add header (should be called before send)
 ------------------------------------------------------------------------------
 

 ------------------------------------------------------------------------------
 -- send response
 ------------------------------------------------------------------------------
 
 return {
  conn = conn,
  headers = {},
  addheader = prototype.addheader,
  send = prototype.send,
  sendfile = prototype.sendfile,
  sendredirect = prototype.sendredirect,
  statuscode = 200
 }
 
end