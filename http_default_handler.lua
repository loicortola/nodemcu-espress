local handler = function(req, res, next, opts)
 res.statuscode = 404
 res:send("404 - Not Found")
end

return handler