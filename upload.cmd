@call nodemcu-tool upload espress.lua --compile --optimize
@call nodemcu-tool upload http_not_found.lua --compile --optimize
@call nodemcu-tool upload http_request.lua --compile --optimize
@call nodemcu-tool upload http_response_send.lua --compile --optimize
@call nodemcu-tool upload http_response_sendfile.lua --compile --optimize
@call nodemcu-tool upload http_response.lua --compile --optimize
@call nodemcu-tool upload plugins/auth_api_key.lua --compile --optimize
@call nodemcu-tool upload plugins/router.lua --compile --optimize
@call nodemcu-tool upload plugins/routes_auto.lua --compile --optimize
@call nodemcu-tool upload status-codes/http-200
@call nodemcu-tool upload status-codes/http-400
@call nodemcu-tool upload status-codes/http-401
@call nodemcu-tool upload status-codes/http-403
@call nodemcu-tool upload status-codes/http-404
@call nodemcu-tool upload status-codes/http-405
@call nodemcu-tool upload status-codes/http-503
@call nodemcu-tool upload mime-types/type-css
@call nodemcu-tool upload mime-types/type-html
@call nodemcu-tool upload mime-types/type-jpg
@call nodemcu-tool upload mime-types/type-js
@call nodemcu-tool upload mime-types/type-json
@call nodemcu-tool upload mime-types/type-png
@call nodemcu-tool upload mime-types/type-ico

pause
