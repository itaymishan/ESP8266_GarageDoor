wifi.setmode(wifi.STATION);
wifi.sta.config ( "Bogert-2G" , "gotoronto" ); 
wifi.sta.setip({ip="192.168.0.230",netmask="255.255.255.0",gateway="192.168.0.1"});
gpio.mode(3, gpio.OUTPUT);
gpio.write(3, gpio.HIGH);

-- A simple http server 
srv=net.createServer(net.TCP); 
srv:listen(80,function(conn) conn:on("receive",function(conn,payload)

print(payload);

gpio.write(3, gpio.LOW);

tmr.alarm(0, 5000, 0, function()

gpio.write(3, gpio.HIGH);

end )

conn:send(payload);

end)

conn:on("sent",function(conn) conn:close() end)

end)
