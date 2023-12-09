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
- ##### DISCLAIMER: Please don't use this in any productive enviroments (yet). As of version 1.1.0b, all code is in line with OPNsense integrated functions. Some parts were developed with the use of AI assistance (ChatGPT4 and Copilot).
- ##### BETA VERSION 1.1.0b. Tested by myself on DEC740 Hardware and OPNsense 23.7.9-amd64.
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

#### How to create an easy reverse proxy:
##### In Services - Caddy Web Server - Reverse Proxy:

##### Tab Reverse Proxy - Reverse Proxy Domains:
- Press + to create a new Reverse Proxy Domain
- "Enable" or "disable" this new entry
- "From Domain" can either be a domain name or an IP address. If a domain name is chosen, Caddy will automatically try to get an ACME certificate, and the header will be automatically passed to the "Handle" Server in the backend.
- "From Port" should be 443 or a different port like 7443 etc... it's the port the OPNsense will listen on. Don't forget to create Firewall rules that allow Traffic to this port on WAN or LAN to "This Firewall". You can leave this empty if you want to use the default ports of Caddy (443).
- "DNS-01 challenge", enable this if you want to use the DNS-01 ACME Challenge instead of HTTP challenge. This can be set per entry, so you can have both types of challenges at the same time for different entries. This option needs the "General Settings" - "DNS Provider" and "API KEY" set.

##### Tab Handle - Handle:
- Press + to create a new Handle. A handle is like a "location" in nginx.
- "Enable" or "disable" this new entry
- "Domain" Select the domain you have created in "Reverse Proxy Domains"
- "Subdomain" leave this on None. It is not needed without having a wildcard certificate, and a *.example.com Domain.
- "Handle Type" Only handle can be chosen as of now. It's the most common option.
- "Handle Path" Leave this empty if you want to create a "catch all". The catch all will always be generated at the last spot of the Caddyfile. That means, you can create multiple handle entries, and have each of them point at different locations like /example/* or /foo/* or /foo/bar/*. There is input validation here.
- "To Domain" should be an internal domain name or an IP Address of the Backend Server that should receive the traffic of the "Domain".
- "To Port" should be the port the Backend Server listens on, for example 443 or 7443. It doesn't have to be the same port as the "From Port".

Press - Apply - and the new configuration will be active. After 1 to 2 minutes the Certificate will be installed.

#### How to create a wildcard subdomain reverse proxy:
- Do everything the same as above, but create your Reverse Proxy Domain like this "*.example.com" and activate the DNS-01 Challenge.
- Go to the Subdomain Tab and create all subdomains that you need in relation to the "*.example.com" domain. So for example "foo.example.com" and "bar.example.com". But NOT "foo.bar.example.com", since for that you would need the "*.bar.example.com" domain and certificate.
- In the Handle Tab you can now select your "*.example.com" domain, and if Subdomain is "None", the handles are added to the base domain, for example if you want a catch all for all non referenced subdomains.
- If you create a Handle with "*.example.com" and "foo.example.com" as Subdomain, a nested handle will be generated. You can do all the same configurations as if the subdomain is a normal domain, with multiple handles and handle paths.

For inspiration, check this Caddyfile:
https://github.com/Monviech/os-caddy-plugin/pull/32

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
The Rest API is now fully integreated with the OPNsense syntax.
https://docs.opnsense.org/development/api.html

All API Actions can be found in the API controller files.

Example:
/api/caddy/ReverseProxy/get
