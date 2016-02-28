# Sample simple-static

This sample serves all files in the static/ folder.


## Procedure
Upload the following files to your NodeMCU:

1. Espress base files
 * espress.lc  
 * http_default_handler.lc  
 * http_request.lc  
 * http_response.lc  
 * http_response_sendfile.lc  
 * plugins/routes_auto.lc => routes_auto.lc
 
2. Relevant Espress status-codes and mime-types  
 * mime-types/type-html => type-html  
 * status-codes/http-200 => http-200
 * status-codes/http-404 => http-404
 * status-codes/http-500 => http-500

3. Sample files
 * init**.lua**  
 * server.lc  
 * static/register.post.lua => routes/register.post.lc  
 * static/register.html  => static/register.html  
 * static/register_success.html  => static/register_success.html  
 * static/favicon.ico => static/favicon.ico  
 * static/lock-icon.png => static/lock-icon.png  

Replace the wifi settings with your own in **init.lua**

Access the http://IP/hello.html file