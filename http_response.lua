return function(prototype, conn, ondisconnect)
 ------------------------------------------------------------------------------
 -- add header (should be called before send)
 ------------------------------------------------------------------------------

 local destructor = function(res)
  res.conn = nil
  res.headers = nil
  res.addheader = nil
  res.send = nil
  res.sendfile = nil
  res.sendredirect = nil
  res.statuscode = nil
  res.ondisconnect = nil
  res.destructor = nil
 end
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
  statuscode = 200,
  close = ondisconnect,
  destructor = destructor
 }

end
