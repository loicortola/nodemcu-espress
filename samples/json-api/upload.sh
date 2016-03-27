#/bin/sh
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

nodemcu-tool upload server.lua --port $1 --compile --optimize --baud $baud
nodemcu-tool upload init.lua --port $1 --optimize --baud $baud
nodemcu-tool upload routes/askme.post.lua -k --port $1 --compile --optimize --baud $baud
nodemcu-tool upload routes/hello.get.lua -k --port $1 --compile --optimize --baud $baud
