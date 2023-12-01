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

# How to install:
- #### DISCLAIMER: This plugin is in need of independant testing. Please contribute by testing it and give feedback. Especially the new DNS-01 challenge for Cloudflare.
- ##### BETA VERSION 1.0.6b. Tested by myself on DEC740 Hardware and OPNsense 23.7.9-amd64. I can't test the DNS-01 challenge myself.
- ```fetch -o /usr/local/etc/pkg/repos/os-caddy-plugin.conf https://os-caddy-plugin.pischem.com/repo-config/os-caddy-plugin.conf```
- ```pkg update```
- Afterwards the "os-caddy" plugin can be installed from the GUI.
- Make sure the Firewall doesn't listen on port 80/443, since Caddy uses 80 for ACME, and you need 443 to create a proper Reverse Proxy entry.

# How to build from source:
- As build system use a FreeBSD 13.2 - https://github.com/opnsense/tools
- Use xcaddy to build your own caddy binary
- Check the +MANIFEST file and put all dependant files into the right paths on your build system. Make sure to check your own file hashes with ```sha256 /path/to/file```. 
- Use ```pkg create -M ./+MANIFEST``` in the folder of the ```+MANIFEST``` file.
- For os-caddy.pkg make sure you have the OPNsense tools build system properly set up. 
- Build the os-caddy.pkg by going into /usr/plugins/devel/caddy/ and invoking ```make package``` 

# Custom configuration files
- The Caddyfile has an additional import from the path ```/usr/local/etc/caddy/caddy.d/```. You can place your own custom configuration files inside that adhere to the Caddyfile syntax. ```*.global``` will be imported into the global block of the Caddyfile. ```*.conf``` will be imported at the end of the Caddyfile, you can put your own reverse_proxy or other settings there.
You don't have to make the binary chmod +x, the setup script does that automatically on service start and restart.

# Use custom caddy binary
- If you want to use your own modules, build your own caddy binary directly in the OPNsense shell. Go on the Caddy Website https://caddyserver.com/download and select the packages you want. The package should be one for ```freebsd``` - for example ```freebsd amd64```. Afterwards save the download link and go to ```/usr/local/bin/``` in the OPNsense shell. Use the following command to download and build the new binary. Example needs to be adjusted to your personal download link:
```
curl -L "https://caddyserver.com/api/download?os=freebsd&arch=amd64&p=github.com%2Fcaddy-dns%2Fcloudflare&idempotency=1620845780975" -o caddy
```

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
