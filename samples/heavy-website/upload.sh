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
nodemcu-tool upload static/audi.jpg -k --port $1 --baud $baud
nodemcu-tool upload static/bmw.jpg -k --port $1 --baud $baud
nodemcu-tool upload static/cars.html -k --port $1 --baud $baud
nodemcu-tool upload static/chevrolet.jpg -k --port $1 --baud $baud
nodemcu-tool upload static/corvette.jpg -k --port $1 --baud $baud
nodemcu-tool upload static/favicon.ico -k --port $1 --baud $baud
nodemcu-tool upload static/honda.jpg -k --port $1 --baud $baud
nodemcu-tool upload static/mustang.jpg -k --port $1 --baud $baud
nodemcu-tool upload static/peugeot.jpg -k --port $1 --baud $baud
