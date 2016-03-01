# Sample simple-static-gzip

This sample is meant to demonstrate how gzip behaves when sending gzip files.

## Procedure
Upload the following files to your NodeMCU:

1. Espress base files
 * espress.lc  
 * espress_init.lc  
 * http_default_handler.lc  
 * http_getondata.lc
 * http_prototypes.lc
 * http_request.lc  
 * http_request_buffer.lc
 * http_request_processor.lc  
 * http_response.lc  
 * http_response_send.lc
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
 * static/hello.html.gz  => static/hello.html.gz
 * static/favicon.ico.gz  => static/favicon.ico.gz

Replace the wifi settings with your own in **init.lua**

Access the http://IP/register.html file.
The file posts the form on the http://IP/api/register endpoint, displays the form results in the console, and redirects to http://IP/register_success.html once everything is done.
