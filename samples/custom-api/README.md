# Sample simple-api

This sample serves custom endpoints configured in routes_custom.lua, and secured by an api-key.


## Procedure
Upload the following files to your NodeMCU:

1. Espress base files
 * plugins/auth_api_key.lua => auth_api_key.lua
 * espress.lua  
 * http_not_found.lua  
 * http_request.lua  
 * http_response.lua  
 * http_response_send.lua  
 * plugins/router.lua => router.lua
 
2. Relevant Espress status-codes
 * status-codes/http-200 => http-200
 * status-codes/http-401 => http-401
 * status-codes/http-404 => http-404
 * status-codes/http-405 => http-405

3. Sample files
 * init.lua  
 * server.lua  
 * routes_custom.lua  
 * routes/askme.post.lua  => routes/askme.post.lua
 * routes/hello.get.lua  => routes/hello.get.lua
 
Replace the wifi settings with your own in init.lua

Access both resources like this:  

[POST] http://IP/question  
[GET] http://IP/hello 

**N.B.: Don't forget to add an Api-Key header (default value is 1234-my-key)**