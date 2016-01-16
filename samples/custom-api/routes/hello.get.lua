return function(req, res)
 res:addheader("Content-Type", "application/json; charset=utf-8")
 res:send("{message: \"Hello World\"}")
end