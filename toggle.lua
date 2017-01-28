wifi.setmode(wifi.STATION)
wifi.sta.config ( "Bogert-2G" , "gotoronto" ); 
wifi.sta.setip({ip="192.168.0.230",netmask="255.255.255.0",gateway="192.168.0.1"});
print(wifi.sta.getip())
pin1 = 3
pin2 = 4
gpio.mode(pin1, gpio.OUTPUT)
gpio.mode(pin2, gpio.OUTPUT)
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
        buf = buf.."<h1> Garage Door Opener</h1>";
        buf = buf.."<p>GPIO0 <a href=\"?pin=ON1\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF1\"><button>OFF</button></a></p>";
        buf = buf.."<p>GPIO2 <a href=\"?pin=ON2\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF2\"><button>OFF</button></a></p>";

        gpio.write(pin1, gpio.LOW);        
        tmr.alarm(0, 500, 0, function()
        gpio.write(pin1, gpio.HIGH);
        end )

        gpio.write(pin2, gpio.HIGH);        
        tmr.alarm(0, 500, 0, function()
        gpio.write(pin2, gpio.LOW);
        end )        
        
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)
