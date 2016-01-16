return function(req, res)
 res:addheader("Content-Type", "application/json; charset=utf-8")
 if req.params.question then
  local question = req.params.question
  print("Question is " .. question)
  res:send("{answer:\"Thanks for your input.\"}")
 else
  res:send("{answer:\"I have not received any question.\"}")
 end
end