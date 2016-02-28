# Sample simple-api

This sample serves all endpoints in the routes/ folder, secured by an api-key.


## Procedure
Upload the following files to your NodeMCU:

1. Espress base files
 * plugins/auth_api_key.lc => auth_api_key.lc
 * espress.lc  
 * http_default_handler.lc  
 * http_request.lc  
 * http_response.lc  
 * http_response_send.lc
 * plugins/routes_auto.lc => routes_auto.lc
 
2. Relevant Espress status-codes
 * status-codes/http-200 => http-200
 * status-codes/http-401 => http-401
 * status-codes/http-404 => http-404
 * status-codes/http-405 => http-405
 * status-codes/http-500 => http-500

3. Sample files
 * **init.lua**  
 * server.lua => server.lc  
 * routes/askme.post.lua  => routes/askme.post.lc
 * routes/hello.get.lua  => routes/hello.get.lc
 
Replace the wifi settings with your own in **init.lua**

Access both resources like this:  

[GET] http://IP/api/hello  
[POST] http://IP/api/askme  

**N.B.: Don't forget to add an Api-Key header (default value is 1234-my-key)**