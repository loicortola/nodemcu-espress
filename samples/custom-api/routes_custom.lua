local f = loadfile('router.lc')
-- load router
local router = f()
f = nil
router.post("/question", "routes/askme.post.lc")
router.get("/hello", "routes/hello.get.lc")
local h = router.handler
router = nil
collectgarbage("collect")

return h