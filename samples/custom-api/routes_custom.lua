local f = loadfile('router.lua')
-- load router
local router = f()
f = nil
collectgarbage("collect")
router.post("/question", "routes/askme.post.lua")
router.get("/hello", "routes/hello.get.lua")
local h = router.handler
router = nil
return h