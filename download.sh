#/bin/bash
nodemcu-tool download espress.lc --port $1
nodemcu-tool download espress_init.lc --port $1
nodemcu-tool download http_default_handler.lc --port $1
nodemcu-tool download http_getondata.lc --port $1
nodemcu-tool download http_prototypes.lc --port $1
nodemcu-tool download http_request.lc --port $1
nodemcu-tool download http_request_buffer.lc --port $1
nodemcu-tool download http_request_processor.lc --port $1
nodemcu-tool download http_response.lc --port $1
nodemcu-tool download http_response_send.lc --port $1
nodemcu-tool download http_response_sendfile.lc --port $1
nodemcu-tool download auth_api_key.lc --port $1
nodemcu-tool download router.lc --port $1
nodemcu-tool download routes_auto.lc --port $1
nodemcu-tool download http-200
nodemcu-tool download http-400
nodemcu-tool download http-401
nodemcu-tool download http-403
nodemcu-tool download http-404
nodemcu-tool download http-405
nodemcu-tool download http-503
