return function(req, res)
 print("Username is " .. req.params.username)
 print("Password is " .. req.params.password)
 local rights = ""
 if type(req.params.rights) == "table" then
  for _, r in pairs(req.params.rights) do
   rights = rights .. " " .. r
  end
 else
  rights = req.params.rights
 end
 print("Selected rights are " .. rights)
 res:sendredirect("/register_success.html")
end