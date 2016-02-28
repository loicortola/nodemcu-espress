return function(req, res)
 res:addheader("Content-Type", "application/json; charset=utf-8")
 
 if req.body then
  
  local success, json = pcall(cjson.decode, req.body)
  if not success then
   error(json)
  end
  -- Decode json object from body
  print(json.question)
  if not (json.question == nil) then
   -- Create and encode result as json string
   local result = { question = json.question, answer = "Thanks for your input." }
   res:send(cjson.encode(result))
   return
  end
 end
 
 res.statuscode = 400
 -- Create and encode result as json string
 local result = { answer = "I have not received any question." }
 res:send(cjson.encode(result))
 
end