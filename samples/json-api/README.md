# Sample simple-api

This sample serves all endpoints in the routes/ folder, and returns application/json results parsed along with CJSON.

**N.B.: You need to have a NodeMCU built with the CJSON module for this sample to work.**

## Procedure
Upload the following files to your NodeMCU:

1. Espress base files
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
[POST] http://IP/api/askme  with the following JSON body: 
```json
{ 
  "question": "How are you?"
}
```