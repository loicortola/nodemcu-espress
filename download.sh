#/bin/bash
baud=$2
if [ -z "$1" ]; then
 echo "This script requires an argument: USB device port"
 exit 1;
fi
if [ -z "$2" ]; then
 echo "Setting baudrate to default: 115200"
 baud=115200 
 #Default nodemcu 1.5+ baudrate
fi

nodemcu-tool download espress.lc --port $1 --baud $baud
nodemcu-tool download espress_init.lc --port $1 --baud $baud
nodemcu-tool download http_default_handler.lc --port $1 --baud $baud
nodemcu-tool download http_getondata.lc --port $1 --baud $baud
nodemcu-tool download http_prototypes.lc --port $1 --baud $baud
nodemcu-tool download http_request.lc --port $1 --baud $baud
nodemcu-tool download http_request_buffer.lc --port $1 --baud $baud
nodemcu-tool download http_request_processor.lc --port $1 --baud $baud
nodemcu-tool download http_response.lc --port $1 --baud $baud
nodemcu-tool download http_response_send.lc --port $1 --baud $baud
nodemcu-tool download http_response_sendfile.lc --port $1 --baud $baud
nodemcu-tool download auth_api_key.lc --port $1 --baud $baud
nodemcu-tool download router.lc --port $1 --baud $baud
nodemcu-tool download routes_auto.lc --port $1 --baud $baud
