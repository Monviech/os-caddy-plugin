# How to build the caddy binary with xcaddy for OPNsense:

- Install a ```FreeBSD 13.2-RELEASE AMD64``` build system
- Install go
- ```curl -L "https://go.dev/dl/go1.21.6.freebsd-amd64.tar.gz" -o go1.21.6.freebsd-amd64.tar.gz```
- ```rm -rf /usr/local/go && tar -C /usr/local -xzf go1.21.6.freebsd-amd64.tar.gz```
- Register go and xcaddy in ```cshrc``` shell
- ```vi ~/.cshrc```
```
setenv PATH "${PATH}:/usr/local/go/bin"
setenv PATH "${PATH}:${HOME}/go/bin"
```
- Try out if go is available:
```go version```
- Install xcaddy:
```go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest```
- ```cd ~/go/pkg/mod```
- Use ```xcaddy build``` as specified below:

# Current Build

```v2.7.6 h1:w0NymbG2m9PcvKWsrXO6EEkY9Ru4FJK8uQbYcev1p3A=```
```
xcaddy build --with github.com/caddyserver/ntlm-transport --with github.com/mholt/caddy-dynamicdns --with github.com/caddy-dns/cloudflare --with github.com/caddy-dns/duckdns --with github.com/caddy-dns/digitalocean --with github.com/caddy-dns/dnspod --with github.com/caddy-dns/hetzner --with github.com/caddy-dns/godaddy --with github.com/caddy-dns/gandi --with github.com/caddy-dns/vultr --with github.com/caddy-dns/ionos --with github.com/caddy-dns/desec --with github.com/caddy-dns/porkbun
```

### Build Errors:

If you have build errors, go into the specified files and try to fix them, for example right now there can be a few ```int``` and ```uint``` errors. They're easy to fix, just change int to uint at the right spot.

### Test the build:

- ```chmod +x ./caddy```
- ```./caddy version```
- ```./caddy list-modules```

If that works, then caddy is compiled successfully. If not, and theres a panic, then the compilation went wrong, probably due to a faulty module, or a duplicate module.
