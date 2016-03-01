#/bin/sh
nodemcu-tool upload espress.lua --port $1 --compile --optimize
nodemcu-tool upload espress_init.lua --port $1 --compile --optimize
nodemcu-tool upload http_default_handler.lua --port $1 --compile --optimize
nodemcu-tool upload http_getondata.lua --port $1 --compile --optimize
nodemcu-tool upload http_prototypes.lua --port $1 --compile --optimize
nodemcu-tool upload http_request.lua --port $1 --compile --optimize
nodemcu-tool upload http_request_buffer.lua --port $1 --compile --optimize
nodemcu-tool upload http_request_processor.lua --port $1 --compile --optimize
nodemcu-tool upload http_response_send.lua --port $1 --compile --optimize
nodemcu-tool upload http_response_sendfile.lua --port $1 --compile --optimize
nodemcu-tool upload http_response.lua --port $1 --compile --optimize
nodemcu-tool upload plugins/auth_api_key.lua --port $1 --compile --optimize
nodemcu-tool upload plugins/router.lua --port $1 --compile --optimize
nodemcu-tool upload plugins/routes_auto.lua --port $1 --compile --optimize
nodemcu-tool upload status-codes/http-200 --port $1
nodemcu-tool upload status-codes/http-302 --port $1
nodemcu-tool upload status-codes/http-400 --port $1
nodemcu-tool upload status-codes/http-401 --port $1
nodemcu-tool upload status-codes/http-403 --port $1
nodemcu-tool upload status-codes/http-404 --port $1
nodemcu-tool upload status-codes/http-405 --port $1
nodemcu-tool upload status-codes/http-500 --port $1
nodemcu-tool upload status-codes/http-503 --port $1
nodemcu-tool upload mime-types/type-css --port $1
nodemcu-tool upload mime-types/type-html --port $1
nodemcu-tool upload mime-types/type-jpg --port $1
nodemcu-tool upload mime-types/type-js --port $1
nodemcu-tool upload mime-types/type-json --port $1
nodemcu-tool upload mime-types/type-png --port $1
nodemcu-tool upload mime-types/type-ico --port $1
