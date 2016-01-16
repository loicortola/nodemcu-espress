# Sample simple-static

This sample serves all files in the static/ folder.


## Procedure
Upload the following files to your NodeMCU:

1. Espress base files
 * espress.lua  
 * http_not_found.lua  
 * http_request.lua  
 * http_response.lua  
 * http_response_sendfile.lua  
 * plugins/routes_auto.lua => routes_auto.lua
 
2. Relevant Espress status-codes and mime-types  
 * mime-types/type-html => type-html  
 * status-codes/http-200 => http-200
 * status-codes/http-404 => http-404

3. Sample files
 * init.lua  
 * server.lua  
 * static/hello.html  => static/hello.html

Replace the wifi settings with your own in init.lua

Access the http://IP/hello.html file