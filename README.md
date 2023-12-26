# Caddy Plugin for OPNsense

- This personal project aims to provide a simple plugin for [OPNsense](https://github.com/opnsense) to enable support for [Caddy](https://github.com/caddyserver/caddy).
- The scope is the reverse proxy features. The goal is a simple to configure plugin that just works for general needs and to prevent creeping featuritis.

![Handle](https://github.com/Monviech/os-caddy-plugin/assets/79600909/12e4fcd7-7faa-4c81-a0ea-e35a451cea4c)

More Screenshots and generated Caddyfile example: https://github.com/Monviech/os-caddy-plugin/pull/32

# License

- This project is licensed under the BSD 2-Clause "Simplified" license. See the LICENSE file for details. 
- Caddy is licensed under the Apache License, Version 2.0. 
- OPNsense is licensed under the BSD 2-Clause “Simplified” license.

# Acknowledgments

- Thanks to the Caddy community/developers for creating a fantastic open source web server.
- Thanks to the OPNsense community/developers for creating a powerful and flexible open source firewall and routing platform.
- Thanks for answering programming questions and being very helpful: [AdShellevis](https://github.com/Adschellevis)
- Thanks for answering my questions in the OPNsense forum: [mimugmail](https://forum.opnsense.org/index.php?action=profile;u=15464)
- Thanks for giving me good examples of Caddy configurations that shaped the direction this plugin: [gspannu](https://github.com/gspannu)

# How to install:
##### DISCLAIMER: Even though I use this productively on multiple OPNsense Firewalls (and also a HA pair with config sync), I give no guarantee whatsoever. Please read the license file for the full disclaimer. Most code is in line with OPNsense integrated functions. Some parts were developed with the use of AI assistance (ChatGPT4 and Copilot).
##### Second Release is os-caddy-1.3.0. Tested by myself on DEC740 Hardware with OPNsense CE 23.7.10_1-amd64, and on DEC2750 Hardware in HA with OPNsense BE 23.10.1-amd64.
##### Caddy Version is v2.7.6 h1:w0NymbG2m9PcvKWsrXO6EEkY9Ru4FJK8uQbYcev1p3A=
- Connect to your OPNsense via SSH, select option 8 to get into the shell, and invoke the following commands:
```
fetch -o /usr/local/etc/pkg/repos/os-caddy-plugin.conf https://os-caddy-plugin.pischem.com/repo-config/os-caddy-plugin.conf
```
```
pkg update
```
- Afterwards the "os-caddy" plugin can be installed from the OPNsense System - Firmware - Plugins, search for "os-caddy".

# How to use Caddy after the installation:

##### Attention:
- Make sure that port `80` and `443` aren't occupied. You have to change the default listen port to `8443` for example. Go to `System: Settings: Administration` to change the `TCP Port`. Then also enable `HTTP Redirect - Disable web GUI redirect rule`. 
- If you have already other reverse proxy or webserver plugins installed, make sure they don't use the same ports as Caddy
- Create Firewall rules that allow 80 and 443 TCP to "This Firewall" on WAN.
- There is a lot of input validation. If you read all the hints, help texts and error messages, its unlikely that you create a configuration that won't work.

### How to create an easy reverse proxy:
##### Services - Caddy Web Server - General Settings:
- `Enable` Caddy and press `Apply`

##### Services - Caddy Web Server - Reverse Proxy - Domain:
- Press `+` to create a new Reverse Proxy Domain
- `Reverse Proxy Domain` - `foo.example.com`
- `Description` - `foo.exmaple.com`
- `Save`

##### Services - Caddy Web Server - Reverse Proxy - Handle:
- Press `+` to create a new Handle
- `Reverse Proxy Domain` - `foo.example.com`
- `Backend Server Domain` - `192.168.10.1`
- `Save`
- `Apply`

Done, leave all other fields to default or empty. You don't need the advanced mode options. After just a few seconds the Let's Encrypt Certificate will be installed and everything just works. Check the Logfile for that.
Now you have a "Internet <-- HTTPS --> OPNsense (Caddy) <-- HTTP --> Backend Server" Reverse Proxy.

### A more detailed explanation:
##### Services - Caddy Web Server - General Settings:
- `Enable` or `disable` Caddy
- `ACME Email` address: e.g. `info@example.com`, it's optional.
- `Auto HTTPS` - `On (default)` creates automatic Let's Encrypt Certificates for all Domains that don't have more specific options set, like custom certificates.
- `DNS Provider` (advanced) - Choose either `none (default)` for normal HTTP ACME or a DNS Provider - e.g. `Cloudflare` or `Hetzner` - to enable the `DNS-01` ACME challenge. If your provider is missing, just open an issue on github and I will add it over time.
- `DNS API Key` (advanced) -  Leave empty if you don't use a DNS Provider, or put your `API Key` here.
- `Trusted Proxies` (advanced) - Leave empty if you don't use a CDN in front of your OPNsense. If you use Cloudflare or another CDN provider, create an access list with the IP addresses of that CDN and add it here. Add the same Access List to the domain this CDN tries to reach.

##### Tab Reverse Proxy - Domains:
- Press `+` to create a new Reverse Proxy Domain
- `Enable` this new entry
- `Reverse Proxy Domain` - can either be a domain name or an IP address. If a domain name is chosen, Caddy will automatically try to get an ACME certificate, and the header will be automatically passed to the `Handle` Server in the backend.
- `Reverse Proxy Port` (advanced) - should be the port the OPNsense will listen on. Don't forget to create Firewall rules that allow traffic to this port on `WAN` or `LAN` to `This Firewall`. You can leave this empty if you want to use the default ports of Caddy (`80` and `443`) with automatic redirection from HTTP to HTTPS.
- `Access List` (advanced) - Restrict the access to this domain to a list of IP addresses you define in the `Access Lists` Tab. This doesn't influence the Let's Encrypt certificate generation, so you can be as restrictive as you want here.
- `Description` - The description is mandatory. Create descriptions for each domain. Since there could be multiples of the same domain with different ports, do it like this: `foo.example.com` and `foo.example.com.8443`.
- `DNS-01 challenge` (advanced) - enable this if you want to use the `DNS-01` ACME challenge instead of HTTP challenge. This can be set per entry, so you can have both types of challenges at the same time for different entries. This option needs the `General Settings` - `DNS Provider` and `API KEY` set.
- `Custom Certificate` (advanced) - Use a Certificate you imported or generated in `System - Trust - Certificates`. The chain is generated automatically. `Certificate + Intermediate CA + Root CA`, `Certificate + Root CA` and `self signed Certificate` are all fully supported.

##### Tab Handle - Handle:
Please note that the order that handles are created in the scope of each domain or domain/subdomain influence functionality. The first matching handle wins. So if you put an empty catch-all handle in front of a more specific handle like /ui/opnsense, the catch-all will match first. Right now there isn't an easy way to move the position of handles in the grid, so you have to delete and re-add them if you want to change their order. Most of the time, creating just one empty catch-all handle is the best choice.
- Press `+` to create a new `Handle`. A Handle is like a location in nginx.
- `Enable` this new entry.
- `Reverse Proxy Domain` - Select the domain you have created in `Reverse Proxy Domains`.
- `Reverse Proxy Subdomain` (advanced) - Leave this on `None`. It is not needed without having a wildcard certificate, or a `*.example.com` Domain.
- `Handle Type` (advanced) - `Handle` or `Handle Path` can be chosen. If in doubt, always use `Handle`, the most common option. `Handle Path` is used to strip the handle path from the URI. For example if you have example.com/opnsense internally, but want to call it with just example.com externally.
- `Handle Path` (advanced) - Leave this empty if you want to create a catch all location. You can create multiple Handle entries, and have each of them point at different locations like `/foo/*` or `/foo/bar/*` or `/foo*` or `*foo`
- `Backend Server Domain` - Should be an internal domain name or an IP Address of the Backend Server that should receive the traffic of the `Reverse Proxy Domain`.
- `Backend Server Port` (advanced) - Should be the port the Backend Server listens on. This can be left empty to use Caddy default ports 80 and 443.
- `TLS` (advanced) - If your Backend Server only accepts HTTPS, enable this option. If the Backend Server has a globally trusted certificate, this is all you need.
- `TLS Trusted CA Certificates` (advanced) - Choose a CA certificate to trust for the Backend Server connection. Caddy doesn't allow a "skip certificate check" due to safety reasons. So, import your self-signed certificate or your self signed CA certificate into the OPNsense "System - Trust - Authorities" store, and select it here. This will make Caddy trust the connection and the TLS will work.
- `NTLM` (advanced) - If your Backend Server needs NTLM authentication, enable this option together with `TLS`. For example, Exchange Server.

##### Tab Reverse Proxy - Access Lists:
- Press `+` to create a new Access List
- `Access List name` - Choose a name for the Access List, for example `private_ips`.
- `Client IP Addresses` - Enter any number of IPv4 and IPv6 addresses or networks that this access list should contain. For example for matching only internal networks, add `192.168.0.0/16` `172.16.0.0/12` `10.0.0.0/8` `127.0.0.1/8` `fd00::/8` `::1`.
- `Invert List` - Invert the logic of the access list. If unchecked, the Client IP Addresses will be ALLOWED, all other IP addresses will be blocked. When checked, the Client IP Addresses will be BLOCKED, all other IP addresses will be allowed.
- Afterwards, go back to Domains or Subdomains and add the Access List you have created to them (advanced mode). All handles created under these Domains will get an additional matcher. That means, the requests still reach Caddy, but if the IP Addresses don't match with the Access List logic, the request doesn't match any handle and will be dropped before being reverse proxied to any Backend Server. If you are using a CDN, make sure the Access List in General - Trusted Proxies and on each Domain used for that CDN are the same.

#### How to create a wildcard subdomain reverse proxy:
- Do everything the same as above, but create your Reverse Proxy Domain like this `*.example.com` and activate the `DNS-01` challenge checkbox.
- OR - `Custom Certificate` - Use a Certificate you imported or generated in `System - Trust - Certificates`. It has to be a wildcard certificate.
- Go to the `Reverse Proxy Subdomain` Tab and create all subdomains that you need in relation to the `*.example.com` domain. So for example `foo.example.com` and `bar.example.com`.
- Create descriptions for each subdomain. Since there could be multiples of the same subdomain with different ports, do it like this: `foo.example.com` and `foo.example.com.8443`.
- In the `Handle` Tab you can now select your `*.example.com` `Reverse Proxy Domain`, and if `Reverse Proxy Subdomain` is `None`, the Handles are added to the base `Reverse Proxy Domain`. For example, if you want a catch all Handle for all non referenced subdomains.
- If you create a Handle with `*.example.com` as `Reverse Proxy Domain` and `foo.example.com` as `Reverse Proxy Subdomain`, a nested Handle will be generated. You can do all the same configurations as if the subdomain is a normal domain, with multiple Handles and Handle paths.

##### Troubleshooting:
- Check `/var/log/caddy/caddy.log` file to find errors. There is also a Caddy Log File in the GUI.
- A good indicator that Caddy is indeed running is this log entry: `serving initial configuration`
- If the Caddy configuration file is invalid, you can see a cycling log without the `serving initial configuration`. If that's the case, stop Caddy, and try to troubleshoot in the SSH shell. Run Caddy with `caddy run --config /usr/local/etc/caddy/Caddyfile` and look for the error message. That this happens is rare, though I couldn't test all possible configuration combinations.
- Check the Service Widget and the "General Settings" Service Control buttons. If everything works they should show a green "Play" sign. If Caddy is stopped there is a red "Stop" sign. If Caddy is disabled, there is no widget and no control buttons.
- You won't find the custom certificates in /usr/local/etc/caddy/certificates/temp since they're deleted every time caddy has loaded them (at least when Auto HTTPS is activated).

# How to build from source:
- As build system use a FreeBSD 13.2 - https://github.com/opnsense/tools
- Use xcaddy to build your own caddy binary. Even better - use curl and the caddy download website. https://caddyserver.com/download
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
- /api/caddy/ReverseProxy/get
- /api/caddy/General/get
- /api/caddy/log/get
- /api/caddy/service/status
