wifi.setmode(wifi.STATION)
-- Replace here with your wifi config
wifi.sta.config("ssid", "key")
wifi.sta.connect()
print("---------------------------")
print("Connecting to Wifi")
tmr.alarm(1, 1000, 1, function()
 if wifi.sta.getip() == nil then
  print("IP unavailable, Waiting...")
 else
  tmr.stop(1)
  print("MAC address is: " .. wifi.ap.getmac())
  print("IP is " .. wifi.sta.getip())
  dofile("server.lc")
 end
end)
