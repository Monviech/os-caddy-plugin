# Caddy Plugin for OPNsense

- This personal project aims to provide a simple plugin for [OPNsense](https://github.com/opnsense) to enable support for [Caddy](https://github.com/caddyserver/caddy).
- The scope will be the reverse proxy features.

# License

- This project is licensed under the BSD 2-Clause "Simplified" license. See the LICENSE file for details. 
- Caddy is licensed under the Apache License, Version 2.0. 
- OPNsense is licensed under the BSD 2-Clause “Simplified” license.

# Acknowledgments

- Thanks to the Caddy community/developers for creating a fantastic open source web server.
- Thanks to the OPNsense community/developers for creating a powerful and flexible open source firewall and routing platform.
- Thanks for answering programming questions and being very helpful: [AdShellevis](https://github.com/Adschellevis)
- Thanks for answering my questions in the OPNsense forum: [mimugmail](https://forum.opnsense.org/index.php?action=profile;u=15464)

# How to install:
- ##### DISCLAIMER: Please don't use this in any productive enviroments (yet), it was developed with the use of AI assistance for Javascript and more complex PHP code (ChatGPT4 and Copilot). It was a learning experience from an Administrator to understand the concepts around the OPNsense Firewall better. 
- ##### BETA VERSION 1.0.7b. Tested by myself on DEC740 Hardware and OPNsense 23.7.9-amd64.
- ```fetch -o /usr/local/etc/pkg/repos/os-caddy-plugin.conf https://os-caddy-plugin.pischem.com/repo-config/os-caddy-plugin.conf```
- ```pkg update```
- Afterwards the "os-caddy" plugin can be installed from the GUI.
- Make sure the Firewall doesn't listen on port 80/443, since Caddy uses 80 for ACME, and you need 443 to create a proper Reverse Proxy entry.

# How to use Caddy after the installation:

##### Attention:
Make sure that port 80 and 443 aren't occupied on the Firewall. You have to change the default listen port to 8443 for example. Go to "System: Settings: Administration" to change the "TCP Port". Then also enable "HTTP Redirect - Disable web GUI redirect rule". If you have already HA-Proxy, opnwaf, nginx or the ACME plugin installed, make sure they don't use the same ports as Caddy. Create Firewall rules that allow 80 and 443 TCP to "This Firewall" on WAN.


##### In Services - Caddy Web Server - General Settings:

- Enable Caddy
- Set "ACME E-Mail" address: e.g. info@example.com
- Leave "Auto HTTPS" on "On (default)"
- "DNS Provider" - Choose either "none (default)" for normal HTTP ACME or a DNS Provider - e.g. "Cloudflare" - to enable the DNS-01 ACME Challenge. If your provider is missing, just open an issue on github and I will add it over time.
- "DNS API Key" - Leave empty if you don't use a DNS Provider, or put your API Key here.
- Press "Apply" to enable and start Caddy.

##### In Services - Caddy Web Server - Reverse Proxy:

- Press + to create a new Reverse Proxy Entry
- "Enable" or "disable" this new entry
- "From Domain" can either be a domain name or an IP address. If a domain name is chosen, Caddy will automatically try to get an ACME certificate, and the header will be automatically passed to the "To Domain" Server in the backend.
- "From Port" should be 443 or a different port like 7443 etc... it's the port the OPNsense will listen on. Don't forget to create Firewall rules that allow Traffic to this port on WAN or LAN to "This Firewall".
- "To Domain" should be an internal domain name or an IP Address of the Backend Server that should receive the traffic of the "From Domain".
- "To Port" should be the port the Backend Server listens on, for example 443 or 7443. It doesn't have to be the same port as the "From Port".
- "Description" should be a description. It's mandatory because the generated Caddyfile uses it to list the entries.
- "DNS-01 challenge", enable this if you want to use the DNS-01 ACME Challenge instead of HTTP challenge. This can be set per entry, so you can have both types of challenges at the same time for different entries. This option needs the "General Settings" - "DNS Provider" and "API KEY" set.
- Press Save if you want to save, or Cancel. You will be redirected back to the previous page.
- Hit apply and the new Configuration will be active. After 1 to 2 minutes the Certificate will be installed and everything works.

##### Troubleshooting:
- Check the /var/log/caddy/caddy.log file to find errors. In a later Version I plan to implement Logging into the GUI.
- Check the Service Widget and the "General Settings" Service Control buttons. If everything works they should show a green "Play" sign. If Caddy is stopped there is a red "Stop" sign. If Caddy is disabled, there is no widget and no control buttons.

# How to build from source:
- As build system use a FreeBSD 13.2 - https://github.com/opnsense/tools
- Use xcaddy to build your own caddy binary
- Check the +MANIFEST file and put all dependant files into the right paths on your build system. Make sure to check your own file hashes with ```sha256 /path/to/file```. 
- Use ```pkg create -M ./+MANIFEST``` in the folder of the ```+MANIFEST``` file.
- For os-caddy.pkg make sure you have the OPNsense tools build system properly set up. 
- Build the os-caddy.pkg by going into /usr/plugins/devel/caddy/ and invoking ```make package``` 

# Custom configuration files
- The Caddyfile has an additional import from the path ```/usr/local/etc/caddy/caddy.d/```. You can place your own custom configuration files inside that adhere to the Caddyfile syntax. ```*.global``` will be imported into the global block of the Caddyfile. ```*.conf``` will be imported at the end of the Caddyfile, you can put your own reverse_proxy or other settings there.

# Use custom caddy binary
- If you want to use your own modules, build your own caddy binary directly in the OPNsense shell. Go on the Caddy Website https://caddyserver.com/download and select the packages you want. The package should be one for ```freebsd``` - for example ```freebsd amd64```. Afterwards save the download link and go to ```/usr/local/bin/``` in the OPNsense shell. Use the following command to download and build the new binary. Example needs to be adjusted to your personal download link:
```
curl -L "https://caddyserver.com/api/download?os=freebsd&arch=amd64&p=github.com%2Fcaddy-dns%2Fcloudflare&idempotency=1620845780975" -o caddy
```
You don't have to make the binary chmod +x, the setup script does that automatically on service start and restart.

# Using the REST API to control the plugin:
REST API:
- /api/caddy/ReverseProxy/add
- /api/caddy/ReverseProxy/set
- /api/caddy/ReverseProxy/get
- /api/caddy/ReverseProxy/del
- /api/caddy/General/set
- /api/caddy/General/get

After changing something, please use the ServiceController API down below to restart the service, so that the template reloads.

Examples:

- add
```
curl -v -k -X POST "https://192.168.3.1/api/caddy/ReverseProxy/add" \
     -H "Authorization: Basic API-KEY" \
     -H "Content-Type: application/json" \
     -d '{"reverse": {"Enabled": "1", "FromDomain": "example.com", "FromPort": "443", "ToDomain": "192.168.1.2", "ToPort": "443", "Description": "Test"}}' \
     --insecure
```
- del
```
curl -X POST "https://192.168.3.1/api/caddy/ReverseProxy/del/a34e1497-121e-46a5-9e88-bdb51534eae1" \
     -H "Authorization: Basic API-SECRET" \
     -H "Content-Type: application/json" \
     -d '{}' \
     --insecure 
```
- set
```
curl -X PUT "https://192.168.3.1/api/caddy/ReverseProxy/set/a34e1497-121e-46a5-9e88-bdb51534eae1" \
     -H "Authorization: Basic API-SECRET" \
     -H "Content-Type: application/json" \
     -d '{"reverse":{"Enabled": "1","FromDomain": "example.com","FromPort": "443","ToDomain": "192.168.1.2","ToPort": "443","Description": "Test"}}' \
     --insecure
```

Controlling the Service:

- /api/caddy/service/start
- /api/caddy/service/stop
- /api/caddy/service/restart

Examples:

- restart
```
curl -v -X POST "https://192.168.3.1/api/caddy/service/restart" \
     -H "Authorization: Basic API-KEY" \
     -H "Content-Type: application/json" \
     --data '{}' \
     --insecure
```
