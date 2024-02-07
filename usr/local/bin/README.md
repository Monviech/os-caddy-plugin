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
xcaddy build \
  --with github.com/caddyserver/ntlm-transport \
  --with github.com/mholt/caddy-dynamicdns \
  --with github.com/caddy-dns/cloudflare \
  --with github.com/caddy-dns/route53 \
  --with github.com/caddy-dns/duckdns \
  --with github.com/caddy-dns/digitalocean \
  --with github.com/caddy-dns/dnspod \
  --with github.com/caddy-dns/alidns \
  --with github.com/caddy-dns/hetzner \
  --with github.com/caddy-dns/godaddy \
  --with github.com/caddy-dns/googleclouddns \
  --with github.com/caddy-dns/gandi \
  --with github.com/caddy-dns/azure \
  --with github.com/caddy-dns/vultr \
  --with github.com/caddy-dns/porkbun \
  --with github.com/caddy-dns/openstack-designate \
  --with github.com/caddy-dns/netcup \
  --with github.com/caddy-dns/google-domains \
  --with github.com/caddy-dns/ovh \
  --with github.com/caddy-dns/namecheap \
  --with github.com/caddy-dns/netlify \
  --with github.com/caddy-dns/acmedns \
  --with github.com/caddy-dns/desec \
  --with github.com/caddy-dns/namesilo \
  --with github.com/caddy-dns/powerdns \
  --with github.com/caddy-dns/vercel \
  --with github.com/caddy-dns/ddnss \
  --with github.com/caddy-dns/njalla \
  --with github.com/caddy-dns/metaname \
  --with github.com/caddy-dns/linode \
  --with github.com/caddy-dns/tencentcloud \
  --with github.com/caddy-dns/dinahosting \
  --with github.com/caddy-dns/ionos \
  --with github.com/caddy-dns/hexonet \
  --with github.com/caddy-dns/mailinabox
```

### Build Errors:

If you have build errors, go into the specified files and try to fix them, for example right now there can be a few ```int``` and ```uint``` errors. They're easy to fix, just change int to uint at the right spot.

### Test the build:

- ```chmod +x ./caddy```
- ```./caddy version```
- ```./caddy list-modules```

If that works, then caddy is compiled successfully. If not, and theres a panic, then the compilation went wrong, probably due to a faulty module, or a duplicate module.

### Current Build in detail:
```
go      go1.21.6
path    caddy
mod     caddy   (devel)
dep     cloud.google.com/go/compute/metadata    v0.2.3  h1:mg4jlk7mCAj6xXp9UJ4fjI9VUI5rubuGBW5aJ7UnBMY=
dep     filippo.io/edwards25519 v1.0.0  h1:0wAIcmJUqRdI8IJ/3eGi5/HwXZWPujYXXlkrQogz0Ek=
dep     github.com/AndreasBriese/bbloom v0.0.0-20190825152654-46b345b51c96      h1:cTp8I5+VIoKjsnZuH8vjyaysT/ses3EvZeaV/1UkF2M=
dep     github.com/Azure/azure-sdk-for-go/sdk/azcore    v1.7.2  h1:t5+QXLCK9SVi0PPdaY0PrFvYUo24KwA0QwxnaHRSVd4=
dep     github.com/Azure/azure-sdk-for-go/sdk/azidentity        v1.3.1  h1:LNHhpdK7hzUcx/k1LIcuh5k7k1LGIWLQfCjaneSj7Fc=
dep     github.com/Azure/azure-sdk-for-go/sdk/internal  v1.3.0  h1:sXr+ck84g/ZlZUOZiNELInmMgOsuGwdjjVkEIde0OtY=
dep     github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/dns/armdns        v1.1.0  h1:8iR6OLffWWorFdzL2JFCab5xpD8VKEE2DUBBl+HNTDY=
dep     github.com/AzureAD/microsoft-authentication-library-for-go      v1.1.1  h1:WpB/QDNLpMw72xHJc34BNNykqSOeEJDAWkhf0u12/Jk=
dep     github.com/BurntSushi/toml      v1.3.2  h1:o7IhLm0Msx3BaB+n3Ag7L8EVlByGnpq14C4YWiu/gL8=
dep     github.com/Masterminds/goutils  v1.1.1  h1:5nUrii3FMTL5diU80unEVvNevw1nH4+ZV4DSLVJLSYI=
dep     github.com/Masterminds/semver/v3        v3.2.0  h1:3MEsd0SM6jqZojhjLWWeBY+Kcjy9i6MQAeY7YgDP83g=
dep     github.com/Masterminds/sprig/v3 v3.2.3  h1:eL2fZNezLomi0uOLqjQoN6BfsDD+fyLtgbJMAj9n6YA=
dep     github.com/alecthomas/chroma/v2 v2.9.1  h1:0O3lTQh9FxazJ4BYE/MOi/vDGuHn7B+6Bu902N2UZvU=
dep     github.com/antchfx/htmlquery    v1.2.5  h1:1lXnx46/1wtv1E/kzmH8vrfMuUKYgkdDBA9pIdMJnk4=
dep     github.com/antchfx/xpath        v1.2.1  h1:qhp4EW6aCOVr5XIkT+l6LJ9ck/JsUH/yyauNgTQkBF8=
dep     github.com/antlr/antlr4/runtime/Go/antlr/v4     v4.0.0-20230305170008-8188dc5388df      h1:7RFfzj4SSt6nnvCPbCqijJi1nWCd+TqAT3bYCStRC18=
dep     github.com/aryann/difflib       v0.0.0-20210328193216-ff5ff6dc229b      h1:uUXgbcPDK3KpW29o4iy7GtuappbWT0l5NaMo9H9pJDw=
dep     github.com/asaskevich/govalidator       v0.0.0-20210307081110-f21760c49a8d      h1:Byv0BzEl3/e6D5CLfI0j/7hiIEtvGVFPCZ7Ei2oq8iQ=
dep     github.com/aws/aws-sdk-go-v2    v1.17.8 h1:GMupCNNI7FARX27L7GjCJM8NgivWbRgpjNI/hOQjFS8=
dep     github.com/aws/aws-sdk-go-v2/config     v1.18.21        h1:ENTXWKwE8b9YXgQCsruGLhvA9bhg+RqAsL9XEMEsa2c=
dep     github.com/aws/aws-sdk-go-v2/credentials        v1.13.20        h1:oZCEFcrMppP/CNiS8myzv9JgOzq2s0d3v3MXYil/mxQ=
dep     github.com/aws/aws-sdk-go-v2/feature/ec2/imds   v1.13.2 h1:jOzQAesnBFDmz93feqKnsTHsXrlwWORNZMFHMV+WLFU=
dep     github.com/aws/aws-sdk-go-v2/internal/configsources     v1.1.32 h1:dpbVNUjczQ8Ae3QKHbpHBpfvaVkRdesxpTOe9pTouhU=
dep     github.com/aws/aws-sdk-go-v2/internal/endpoints/v2      v2.4.26 h1:QH2kOS3Ht7x+u0gHCh06CXL/h6G8LQJFpZfFBYBNboo=
dep     github.com/aws/aws-sdk-go-v2/internal/ini       v1.3.33 h1:HbH1VjUgrCdLJ+4lnnuLI4iVNRvBbBELGaJ5f69ClA8=
dep     github.com/aws/aws-sdk-go-v2/service/internal/presigned-url     v1.9.26 h1:uUt4XctZLhl9wBE1L8lobU3bVN8SNUP7T+olb0bWBO4=
dep     github.com/aws/aws-sdk-go-v2/service/route53    v1.27.7 h1:f/EOUu/Qw1IAMP6GJDzV50/hICt9/JOdhYAjego/8nk=
dep     github.com/aws/aws-sdk-go-v2/service/sso        v1.12.8 h1:5cb3D6xb006bPTqEfCNaEA6PPEfBXxxy4NNeX/44kGk=
dep     github.com/aws/aws-sdk-go-v2/service/ssooidc    v1.14.8 h1:NZaj0ngZMzsubWZbrEFSB4rgSQRbFq38Sd6KBxHuOIU=
dep     github.com/aws/aws-sdk-go-v2/service/sts        v1.18.9 h1:Qf1aWwnsNkyAoqDqmdM3nHwN78XQjec27LjM6b9vyfI=
dep     github.com/aws/smithy-go        v1.13.5 h1:hgz0X/DX0dGqTYpGALqXJoRKRj5oQ7150i5FdTePzO8=
dep     github.com/beorn7/perks v1.0.1  h1:VlbKKnNfV8bJzeqoa4cOKqO6bYr3WgKZxO8Z16+hsOM=
dep     github.com/caddy-dns/acmedns    v0.3.0  h1:NXD4YAeKbS76vQ5U2Hti2CEXV+bwhTJo39X49aEgzPs=
dep     github.com/caddy-dns/alidns     v1.0.23 h1:B2JSeQrx2S3xgO5bte7SANmBhyoFfSd9v/Blo631gRc=
dep     github.com/caddy-dns/azure      v0.4.0  h1:p88DDmJUqg0S/OJnpfaOzvosCz5HSk8ALdSjbaniTeU=
dep     github.com/caddy-dns/cloudflare v0.0.0-20240206200437-2fa0c8ac916a      h1:4jAOVUkPj/FFqtzaMXTNtP//QOvjsKjz9Pv8pwFVqrs=
dep     github.com/caddy-dns/ddnss      v0.0.0-20221206165031-7f65108b0a62      h1:/baL3n4BUp9LxyXyKPgjnklMuSgyKETTR50rOVfV5hA=
dep     github.com/caddy-dns/desec      v0.0.0-20230823122717-e1e64971fe34      h1:ItULLZUDZ2AsyH9389/sDBZYs/EzSlUYuFtLkpzycX4=
dep     github.com/caddy-dns/digitalocean       v0.0.0-20220527005842-9c71e343246b      h1:tbEjYPwMtRyAsZzGl8rrDx8EJLnravnVG6Bp56oVJnM=
dep     github.com/caddy-dns/dinahosting        v1.0.0  h1:F6REY/1YfsLK33UKLLrVkuJISWGUWOTJvZTnfF5Ne18=
dep     github.com/caddy-dns/dnspod     v0.0.4  h1:txebUF94u/Y8Wt6+hZCmBlD7UQFaNbUUMcAEq8PjgRk=
dep     github.com/caddy-dns/duckdns    v0.4.0  h1:+lBAfTZ1UtxHKzhWIi6vIeoPW+sTvOxfvALnlApWsWo=
dep     github.com/caddy-dns/gandi      v1.0.3  h1:oEgvfeuWC+50QaSsGmaBKY0DfokSoX1D8C3HG+bSEUE=
dep     github.com/caddy-dns/godaddy    v1.0.3  h1:57QoTMGqVImiU2mnl7VxZSWB3EfsGhfRmMuq7mRKtoQ=
dep     github.com/caddy-dns/google-domains     v0.0.0-20230209201753-f8efef531ada      h1:IwX/XEg3WuMTZqn+MXOKn0G/ZJdElO5a8Fg2ARsVdrQ=
dep     github.com/caddy-dns/googleclouddns     v1.0.4  h1:HTH+DTl6sC/wO0CpCKTTxbw9FhZ4F+uv8KTdpcnJuo0=
dep     github.com/caddy-dns/hetzner    v0.0.1  h1:30L6KEb7jrDTIepIldFCzt0lkLxjWTJKjkwfpCcN5VQ=
dep     github.com/caddy-dns/hexonet    v0.1.0  h1:7GEkDV3KAgbiMNRUQc4cc+QqCsrFsbye/X+Qu9RJJZE=
dep     github.com/caddy-dns/ionos      v1.0.1  h1:LPu/jJR0RgY3Zx6FFrgrN5WLMPuFPmW/+i2iFdvxhm4=
dep     github.com/caddy-dns/linode     v0.7.2  h1:qjyF4L/Uuoq/K4eWxnyqTBcHQ8fyibBIdNTJEAa2UwY=
dep     github.com/caddy-dns/mailinabox v0.0.1  h1:zXwHKhgBkB8CV0UJbXBwgfvA16Tz7qyZhm0hwpgQDDY=
dep     github.com/caddy-dns/metaname   v0.2.0  h1:8dm9pEwrukWMIt9Mmb9frFsf9DxJ1SBM2/X1Y97LJbk=
dep     github.com/caddy-dns/namecheap  v0.0.0-20240114194457-7095083a3538      h1:AUeHquAJ99hvZmIT4OTWONbrzIk1ie7VAylaksDpfNc=
dep     github.com/caddy-dns/namesilo   v0.0.0-20220905070036-1c65d36b4154      h1:IYsLP++M5LG/Nsql2ANIkgodPDB1l7J1NngGDitjULI=
dep     github.com/caddy-dns/netcup     v0.1.0  h1:Xq+iYVVnZYBufZiaiMKMnhiQKcz+RRRV8FncYC4dEAo=
dep     github.com/caddy-dns/netlify    v1.0.2  h1:pB4r9eOwHmq3Nz503j5jYuu2v8uklMB0nPUBeXEycwM=
dep     github.com/caddy-dns/njalla     v0.0.0-20221007081012-57869f89026a      h1:QcH+Rj/096OwRd4dU5EeLTu86jWBun7/8FIUBZVRS8M=
dep     github.com/caddy-dns/openstack-designate        v0.1.0  h1:/JfynoWe6EoDiQZRGjW/LEh0+yhRrM6/vOuE6juYVi8=
dep     github.com/caddy-dns/ovh        v0.0.2  h1:8EQaUw0wWlFnQVigBKTL+o5fCkHqPBh69WCu9peqvIg=
dep     github.com/caddy-dns/porkbun    v0.1.4  h1:hipjnBdVm/fT5ekhsOp2Mtx5HNz96pT2VabM8BKHOqw=
dep     github.com/caddy-dns/powerdns   v1.0.0  h1:6kEq+Wxq9BjWmJzd1Fdvi6HABHzurjWmTpEh0UtVw7g=
dep     github.com/caddy-dns/route53    v1.3.3  h1:Jt1Y3Orh4laiAooAsJCfzGTG8FvR/c2w6vHeHmxxMA4=
dep     github.com/caddy-dns/tencentcloud       v0.1.0  h1:/BGcHJQIIfqEIfhnLQygZkrB39LQ3SmNkaSxqChjf2k=
dep     github.com/caddy-dns/vercel     v0.0.2  h1:qAXchoXz470kPErbHHNxukMtxaOUxcJLbkye1Eb1bSw=
dep     github.com/caddy-dns/vultr      v0.0.0-20230331143537-35618104157e      h1:IDWuNW4rdOP12IgnwvfjUHRHA5CkD8DpCTwA694ccg4=
dep     github.com/caddyserver/caddy/v2 v2.7.6  h1:w0NymbG2m9PcvKWsrXO6EEkY9Ru4FJK8uQbYcev1p3A=
dep     github.com/caddyserver/certmagic        v0.20.0 h1:bTw7LcEZAh9ucYCRXyCpIrSAGplplI0vGYJ4BpCQ/Fc=
dep     github.com/caddyserver/ntlm-transport   v0.1.2  h1:no1+MveY7d0qrI03olC9sy6ddmPyOpZb1J1iB6ELrzI=
dep     github.com/cenkalti/backoff/v4  v4.2.1  h1:y4OZtCnogmCPw98Zjyt5a6+QwPLGkiQsYW5oUqylYbM=
dep     github.com/cespare/xxhash       v1.1.0  h1:a6HrQnmkObjyL+Gs60czilIUGqrzKutQD6XZog3p+ko=
dep     github.com/cespare/xxhash/v2    v2.2.0  h1:DC2CZ1Ep5Y4k3ZQ899DldepgrayRUGE6BBZ/cd9Cj44=
dep     github.com/chzyer/readline      v1.5.1  h1:upd/6fQk4src78LMRzh5vItIt361/o4uq553V8B5sGI=
dep     github.com/cpuguy83/go-md2man/v2        v2.0.2  h1:p1EgwI/C7NhT0JmVkwCD2ZBK8j4aeHQX2pMHHBfMQ6w=
dep     github.com/dgraph-io/badger     v1.6.2  h1:mNw0qs90GVgGGWylh0umH5iag1j6n/PeJtNvL6KY/x8=
dep     github.com/dgraph-io/badger/v2  v2.2007.4       h1:TRWBQg8UrlUhaFdco01nO2uXwzKS7zd+HVdwV/GHc4o=
dep     github.com/dgraph-io/ristretto  v0.1.0  h1:Jv3CGQHp9OjuMBSne1485aDpUkTKEcUqF+jm/LuerPI=
dep     github.com/dgryski/go-farm      v0.0.0-20200201041132-a6ae2369ad13      h1:fAjc9m62+UWV/WAFKLNi6ZS0675eEUC9y3AlwSbQu1Y=
dep     github.com/digitalocean/godo    v1.41.0 h1:WYy7MIVVhTMZUNB+UA3irl2V9FyDJeDttsifYyn7jYA=
dep     github.com/dlclark/regexp2      v1.10.0 h1:+/GIL799phkJqYW+3YbOd8LCcbHzT0Pbo8zl70MHsq0=
dep     github.com/dustin/go-humanize   v1.0.1  h1:GzkhY7T5VNhEkwH0PVJgjz+fX1rhBrR7pRT3mDkpeCY=
dep     github.com/felixge/httpsnoop    v1.0.3  h1:s/nj+GCswXYzN5v2DpNMuMQYe+0DDwt5WVCU6CWBdXk=
dep     github.com/fxamacker/cbor/v2    v2.5.0  h1:oHsG0V/Q6E/wqTS2O1Cozzsy69nqCiguo5Q1a1ADivE=
dep     github.com/go-chi/chi/v5        v5.0.10 h1:rLz5avzKpjqxrYwXNfmjkrYYXOyLJd37pz53UFHC6vk=
dep     github.com/go-kit/kit   v0.10.0 h1:dXFJfIHVvUcpSgDOV+Ne6t7jXri8Tfv2uOLHUZ2XNuo=
dep     github.com/go-logfmt/logfmt     v0.5.1  h1:otpy5pqBCBZ1ng9RQ0dPu4PN7ba75Y/aA+UpowDyNVA=
dep     github.com/go-logr/logr v1.3.0  h1:2y3SDp0ZXuc6/cjLSZ+Q3ir+QB9T/iG5yYRXqsagWSY=
dep     github.com/go-logr/stdr v1.2.2  h1:hSWxHoqTgW2S2qGc0LTAI563KZ5YKYRhT3MFKZMbjag=
dep     github.com/go-openapi/analysis  v0.21.4 h1:ZDFLvSNxpDaomuCueM0BlSXxpANBlFYiBvr+GXrvIHc=
dep     github.com/go-openapi/errors    v0.20.3 h1:rz6kiC84sqNQoqrtulzaL/VERgkoCyB6WdEkc2ujzUc=
dep     github.com/go-openapi/jsonpointer       v0.19.6 h1:eCs3fxoIi3Wh6vtgmLTOjdhSpiqphQ+DaPn38N2ZdrE=
dep     github.com/go-openapi/jsonreference     v0.20.2 h1:3sVjiK66+uXK/6oQ8xgcRKcFgQ5KXa2KvnJRumpMGbE=
dep     github.com/go-openapi/loads     v0.21.2 h1:r2a/xFIYeZ4Qd2TnGpWDIQNcP80dIaZgf704za8enro=
dep     github.com/go-openapi/runtime   v0.19.24        h1:TqagMVlRAOTwllE/7hNKx6rQ10O6T8ZzeJdMjSTKaD4=
dep     github.com/go-openapi/spec      v0.20.8 h1:ubHmXNY3FCIOinT8RNrrPfGc9t7I1qhPtdOGoG2AxRU=
dep     github.com/go-openapi/strfmt    v0.21.3 h1:xwhj5X6CjXEZZHMWy1zKJxvW9AfHC9pkyUjLvHtKG7o=
dep     github.com/go-openapi/swag      v0.22.3 h1:yMBqmnQ0gyZvEb/+KzuWZOXgllrXT4SADYbvDaXHv/g=
dep     github.com/go-openapi/validate  v0.20.0 h1:pzutNCCBZGZlE+u8HD3JZyWdc/TVbtVwlWUp8/vgUKk=
dep     github.com/go-resty/resty/v2    v2.7.0  h1:me+K9p3uhSmXtrBZ4k9jcEAfJmuC8IivWHwaLZwPrFY=
dep     github.com/go-sql-driver/mysql  v1.7.1  h1:lUIinVbN1DY0xBg0eMOzmmtGoHwWBbvnWubQUrtU8EI=
dep     github.com/golang-jwt/jwt/v5    v5.0.0  h1:1n1XNM9hk7O9mnQoNBGolZvzebBQ7p93ULHRc28XJUE=
dep     github.com/golang/glog  v1.1.2  h1:DVjP2PbBOzHyzA+dn3WhHIq4NdVu3Q+pvivFICf/7fo=
dep     github.com/golang/groupcache    v0.0.0-20210331224755-41bb18bfe9da      h1:oI5xCqsCo564l8iNU+DwB5epxmsaqB+rhGL0m5jtYqE=
dep     github.com/golang/protobuf      v1.5.3  h1:KhyjKVUg7Usr/dYsdSqoFveMYd5ko72D+zANwlG1mmg=
dep     github.com/golang/snappy        v0.0.4  h1:yAGX7huGHXlcLOEtBnF4w7FQwA26wojNCwOYAEhLjQM=
dep     github.com/google/cel-go        v0.15.1 h1:iTgVZor2x9okXtmTrqO8cg4uvqIeaBcWhXtruaWFMYQ=
dep     github.com/google/certificate-transparency-go   v1.1.6  h1:SW5K3sr7ptST/pIvNkSVWMiJqemRmkjJPPT0jzXdOOY=
dep     github.com/google/go-querystring        v1.1.0  h1:AnCroh3fv4ZBgVIf1Iwtovgjaw/GiKJo8M8yD/fhyJ8=
dep     github.com/google/go-tpm        v0.9.0  h1:sQF6YqWMi+SCXpsmS3fd21oPy/vSddwZry4JnmltHVk=
dep     github.com/google/go-tspi       v0.3.0  h1:ADtq8RKfP+jrTyIWIZDIYcKOMecRqNJFOew2IT0Inus=
dep     github.com/google/s2a-go        v0.1.7  h1:60BLSyTrOV4/haCDW4zb1guZItoSq8foHCXrAnjBo/o=
dep     github.com/google/uuid  v1.3.1  h1:KjJaJ9iWZ3jOFZIf1Lqf4laDRCasjl0BCmnEGxkdLb4=
dep     github.com/googleapis/enterprise-certificate-proxy      v0.2.5  h1:UR4rDjcgpgEnqpIEvkiqTYKBCKLNmlge2eVjoZfySzM=
dep     github.com/googleapis/gax-go/v2 v2.12.0 h1:A+gCJKdRfqXkr+BIRGtZLibNXf0m1f9E4HG56etFpas=
dep     github.com/gophercloud/gophercloud      v0.15.0 h1:jQeAWj0s1p83+TrUXhJhEOK4oe2g6YcBcFwEyMNIjEk=
dep     github.com/grpc-ecosystem/grpc-gateway/v2       v2.18.0 h1:RtRsiaGvWxcwd8y3BiRZxsylPT8hLWZ5SPcfI+3IDNk=
dep     github.com/hashicorp/go-cleanhttp       v0.5.2  h1:035FKYIWjmULyFRBKPs8TBQoi0x6d9G4xc9neXJWAZQ=
dep     github.com/hashicorp/go-retryablehttp   v0.7.2  h1:AcYqCvkpalPnPF2pn0KamgwamS42TqUDDYFRKq/RAd0=
dep     github.com/hexonet/go-sdk       v3.5.1+incompatible     h1:XYN7KIZUSt/IeSVSMQCZClp3RiVGkr+smvrJ2U3KWlI=
dep     github.com/huandu/xstrings      v1.3.3  h1:/Gcsuc1x8JVbJ9/rlye4xZnVAbEkGauT8lbebqcQws4=
dep     github.com/imdario/mergo        v0.3.12 h1:b6R2BslTbIEToALKP7LxUvijTsNI9TAe80pLWN2g/HU=
dep     github.com/jackc/chunkreader/v2 v2.0.1  h1:i+RDz65UE+mmpjTfyz0MoVTnzeYxroil2G82ki7MGG8=
dep     github.com/jackc/pgconn v1.14.0 h1:vrbA9Ud87g6JdFWkHTJXppVce58qPIdP7N8y0Ml/A7Q=
dep     github.com/jackc/pgio   v1.0.0  h1:g12B9UwVnzGhueNavwioyEEpAmqMe1E/BN9ES+8ovkE=
dep     github.com/jackc/pgpassfile     v1.0.0  h1:/6Hmqy13Ss2zCq62VdNG8tM1wchn8zjSGOBJ6icpsIM=
dep     github.com/jackc/pgproto3/v2    v2.3.2  h1:7eY55bdBeCz1F2fTzSz69QC+pG46jYq9/jtSPiJ5nn0=
dep     github.com/jackc/pgservicefile  v0.0.0-20221227161230-091c0ba34f0a      h1:bbPeKD0xmW/Y25WS6cokEszi5g+S0QxI/d45PkRi7Nk=
dep     github.com/jackc/pgtype v1.14.0 h1:y+xUdabmyMkJLyApYuPj38mW+aAIqCe5uuBB51rH3Vw=
dep     github.com/jackc/pgx/v4 v4.18.0 h1:Ltaa1ePvc7msFGALnCrqKJVEByu/qYh5jJBYcDtAno4=
dep     github.com/jmespath/go-jmespath v0.4.0  h1:BEgLn5cpjn8UN1mAw4NjwDrS35OdebyEtFe+9YPoQUg=
dep     github.com/josharian/intern     v1.0.0  h1:vlS4z54oSdjm0bgjRigI+G1HpF+tI+9rE5LLzOg8HmY=
dep     github.com/klauspost/compress   v1.17.0 h1:Rnbp4K9EjcDuVuHtd0dgA4qNuv9yKDYKK1ulpJwgrqM=
dep     github.com/klauspost/cpuid/v2   v2.2.5  h1:0E5MSMDEoAulmXNFquVs//DdoomxaoTY1kUhbc/qbZg=
dep     github.com/kylelemons/godebug   v1.1.0  h1:RPNrshWIDI6G2gRW9EHilWtl7Z6Sb1BR0xunSBf0SNc=
dep     github.com/libdns/acmedns       v0.2.0  h1:zTXdHZwe3r2issdVRyqt5/4X2yHpiBVmFnTrwBA29ik=
dep     github.com/libdns/alidns        v1.0.2-x2       h1:KwuC1AmihOJjoFWXFRFaQx1PcD/jRpY04jo7yNK5zfk=
dep     github.com/libdns/azure v0.3.0  h1:LW04LPmAd25ieFrsd/sd3QCajzaTn1vD78l7hgkHaAw=
dep     github.com/libdns/cloudflare    v0.1.0  h1:93WkJaGaiXCe353LHEP36kAWCUw0YjFqwhkBkU2/iic=
dep     github.com/libdns/ddnss v0.1.0  h1:rZ49EOSIsS3Qu50NfQmJKGb8++UQDO/o2hRCMg2Tu18=
dep     github.com/libdns/desec v0.2.3  h1:2VP7vUoLMV/vOW/vOhqD5MZaDzA1DbjDbF+HU2oh3jc=
dep     github.com/libdns/digitalocean  v0.0.0-20220518195853-a541bc8aa80f      h1:Y0JkwI0Uip+Zrh71aHLmNz150cKnWuC+535v/zLS8zo=
dep     github.com/libdns/dinahosting   v1.0.0  h1:8W31EPiA0AHdxUTmqbi8HhlL9+A+QsE9wyaFPASEpwg=
dep     github.com/libdns/dnspod        v0.0.3  h1:xJHDIujgLjvZnpB8/rMoCHUqA/KxSGBqRUXxSIzNzAA=
dep     github.com/libdns/duckdns       v0.2.0  h1:vd3pE09G2qTx1Zh1o3LmrivWSByD3Z5FbL7csX5vDgE=
dep     github.com/libdns/gandi v1.0.3  h1:FIvipWOg/O4zi75fPRmtcolRKqI6MgrbpFy2p5KYdUk=
dep     github.com/libdns/godaddy       v0.0.0-20221029040642-6024bc932fda      h1:AhSwrWdIKx1r+XxPot6xbyGBX3VR3OKLVR4Usd0gUzc=
dep     github.com/libdns/googleclouddns        v1.1.0  h1:murPR1LfTZZObLV2OLxUVmymWH25glkMFKpDjkk2m0E=
dep     github.com/libdns/hetzner       v0.0.1  h1:WsmcsOKnfpKmzwhfyqhGQEIlEeEaEUvb7ezoJgBKaqU=
dep     github.com/libdns/hexonet       v0.1.0  h1:syYO+ufmHGuSQjPdwKr0pXvzrEPqLwZfqKJ9cUPjBWk=
dep     github.com/libdns/ionos v1.0.2  h1:/lfNHP847Mj47DYg1y9kkZ4jbvRAt6fOEeVK8kDKwis=
dep     github.com/libdns/libdns        v0.2.2-0.20230227175549-2dc480633939    h1:EvTiXkv78P20yfk4CUPmAkH3Cmumt3s/48WWiC2babY=
dep     github.com/libdns/linode        v0.4.1  h1:Fr22y3aWBzaj3AlFbCQ743eC+5Hss+sJ+OEjtlK61AA=
dep     github.com/libdns/mailinabox    v0.0.1  h1:In/g4FO2g31PwLEPM9KS+MftAP8G7fa53bcbShg7gAs=
dep     github.com/libdns/metaname      v0.3.0  h1:HJudLYthdv52TupOPczojip/nEQHW7xqk5+whGReva4=
dep     github.com/libdns/namecheap     v0.0.0-20211109042440-fc7440785c8e      h1:WCcKyxiiK/sJnST1ulVBKNg4J8luCYDdgUrp2ySMO2s=
dep     github.com/libdns/namesilo      v0.1.0  h1:0cNGxzxa1NEfI9Dv+f4cINVfVEAraY6b1HhioSCEn/U=
dep     github.com/libdns/netcup        v0.1.0  h1:SJzIHgq0JBIp5cwRZUTwGnl1rr6Stza/vv5q80pMjxM=
dep     github.com/libdns/netlify       v1.0.2  h1:jUq14uvb/royYBvQ4RZPzFtlSFuNB9Y19BjG/7sbtRQ=
dep     github.com/libdns/njalla        v0.0.0-20221007075422-a00222abbcb3      h1:UIOX5X1ZFWPVd2MqUmiF68LeQuxMQSrqkxMCTFJdFlk=
dep     github.com/libdns/openstack-designate   v0.1.0  h1:sDwitArDEzdQQgSGtZfSQFvnJoHOkgoZSULmSOYcRfs=
dep     github.com/libdns/ovh   v0.0.2  h1:9ZBoPi9/BHweKMY609CdvmLVxy3v8WStJJcf+VG5lNI=
dep     github.com/libdns/porkbun       v0.1.2  h1:D1JN8wqwwU9jlFWWisBNSWAMRYdqjsre6XxfaJwZ0mQ=
dep     github.com/libdns/powerdns      v0.1.2  h1:H4Y5PtKZw3Es+S+IYyfvOmqHhaofDyRY+3MRVGHFBu0=
dep     github.com/libdns/route53       v1.3.3  h1:16sTxbbRGm0zODz0p0aVHHIyTqtHzEn3j0s4dGzQvNI=
dep     github.com/libdns/tencentcloud  v1.0.0  h1:u4LXnYu/lu/9P5W+MCVPeSDnwI+6w+DxYhQ1wSnQOuU=
dep     github.com/libdns/vercel        v0.0.2  h1:slfQWxgUdYFgKfPbK1vLE7k1CZSspHFlwC+nEWlm79w=
dep     github.com/libdns/vultr v1.0.0  h1:W8B4+k2bm9ro3bZLSZV9hMOQI+uO6Svu+GmD+Olz7ZI=
dep     github.com/linode/linodego      v1.23.0 h1:s0ReCZtuN9Z1IoUN9w1RLeYO1dMZUGPwOQ/IBFsBHtU=
dep     github.com/luv2code/gomiabdns   v1.0.0  h1:ScHg5bOkGyJ1YbgnSrQ9UlMvP7I29kCyBbKCaD31EZ4=
dep     github.com/mailru/easyjson      v0.7.7  h1:UGYAvKxe3sBsEDzO8ZeWOSlIQfWFlxbzLZe7hwFURr0=
dep     github.com/manifoldco/promptui  v0.9.0  h1:3V4HzJk1TtXW1MTZMP7mdlwbBpIinw3HztaIlYthEiA=
dep     github.com/mastercactapus/proxyprotocol v0.0.4  h1:qSY75IZF30ZqIU9iW1ip3I7gTnm8wRAnGWqPxCBVgq0=
dep     github.com/mattn/go-colorable   v0.1.8  h1:c1ghPdyEDarC70ftn0y+A/Ee++9zz8ljHG1b13eJ0s8=
dep     github.com/mattn/go-isatty      v0.0.16 h1:bq3VjFmv/sOjHtdEhmkEV4x1AJtvUvOJ2PFAZ5+peKQ=
dep     github.com/matttproud/golang_protobuf_extensions        v1.0.4  h1:mmDVorXM7PCGKw94cs5zkfA9PSy5pEvNWRP0ET0TIVo=
dep     github.com/mgutz/ansi   v0.0.0-20200706080929-d51e80ef957d      h1:5PJl274Y63IEHC+7izoQE9x6ikvDFZS2mDVS3drnohI=
dep     github.com/mholt/acmez  v1.2.0  h1:1hhLxSgY5FvH5HCnGUuwbKY2VQVo8IU7rxXKSnZ7F30=
dep     github.com/mholt/caddy-dynamicdns       v0.0.0-20231219030520-b7b54f0510fc      h1:uubYrwZw8bKLNWsgPqOryw8eaBktpBPUHX7n/LgGaqc=
dep     github.com/micromdm/scep/v2     v2.1.0  h1:2fS9Rla7qRR266hvUoEauBJ7J6FhgssEiq2OkSKXmaU=
dep     github.com/miekg/dns    v1.1.55 h1:GoQ4hpsj0nFLYe+bWiCToyrBEJXkQfOOIvFGFy0lEgo=
dep     github.com/mitchellh/copystructure      v1.2.0  h1:vpKXTN4ewci03Vljg/q9QvCGUDttBOGBIa15WveJJGw=
dep     github.com/mitchellh/go-ps      v1.0.0  h1:i6ampVEEF4wQFF+bkYfwYgY+F/uYJDktmvLPf7qIgjc=
dep     github.com/mitchellh/mapstructure       v1.5.0  h1:jeMsZIYE/09sWLaz43PL7Gy6RuMjD2eJVyuac5Z2hdY=
dep     github.com/mitchellh/reflectwalk        v1.0.2  h1:G2LzWKi524PWgd3mLHV8Y5k7s6XUvT0Gef6zxSIeXaQ=
dep     github.com/mittwald/go-powerdns v0.5.2  h1:kfqr9ZNIuxOjjBaoJcOFiy/19VmKEUgfJPmObDglPJU=
dep     github.com/netlify/open-api/v2  v2.12.2 h1:JEZqhd9I+FQcDJwLeD9w8p4C09KnhhsWxdNEm4SByVY=
dep     github.com/nrdcg/dnspod-go      v0.4.0  h1:c/jn1mLZNKF3/osJ6mz3QPxTudvPArXTjpkmYj0uK6U=
dep     github.com/oklog/ulid   v1.3.1  h1:EGfNDEx6MqHz8B3uNV6QAib1UR2Lm97sHi3ocA6ESJ4=
dep     github.com/ovh/go-ovh   v1.3.0  h1:mvZaddk4E4kLcXhzb+cxBsMPYp2pHqiQpWYkInsuZPQ=
dep     github.com/pkg/browser  v0.0.0-20210911075715-681adbf594b8      h1:KoWmjvw+nsYOo29YJK9vDA65RGE3NrOnUtO7a+RF9HU=
dep     github.com/pkg/errors   v0.9.1  h1:FEBLx1zS214owpjy7qsBeixbURkuhQAwrK5UwLGTwt4=
dep     github.com/prometheus/client_golang     v1.16.0 h1:yk/hx9hDbrGHovbci4BY+pRMfSuuat626eFsHb7tmT8=
dep     github.com/prometheus/client_model      v0.4.0  h1:5lQXD3cAg1OXBf4Wq03gTrXHeaV0TQvGfUooCfx1yqY=
dep     github.com/prometheus/common    v0.44.0 h1:+5BrQJwiBB9xsMygAB3TNvpQKOwlkc25LbISbrdOOfY=
dep     github.com/prometheus/procfs    v0.11.1 h1:xRC8Iq1yyca5ypa9n1EZnWZkt7dwcoRPQwX/5gwaUuI=
dep     github.com/quic-go/qpack        v0.4.0  h1:Cr9BXA1sQS2SmDUWjSofMPNKmvF6IiIfDRmgU0w1ZCo=
dep     github.com/quic-go/quic-go      v0.40.0 h1:GYd1iznlKm7dpHD7pOVpUvItgMPo/jrMgDWZhMCecqw=
dep     github.com/rs/xid       v1.5.0  h1:mKX4bl4iPYJtEIxp6CYiUuLQ/8DYMoz0PUdtGgMFRVc=
dep     github.com/russross/blackfriday/v2      v2.1.0  h1:JIOH55/0cWyOuilr9/qlrm0BSXldqnqwMsf35Ld67mk=
dep     github.com/shopspring/decimal   v1.2.0  h1:abSATXmQEYyShuxI4/vyW3tV1MrKAJzCZ/0zLUXYbsQ=
dep     github.com/shurcooL/sanitized_anchor_name       v1.0.0  h1:PdmoCO6wvbs+7yrJyMORt4/BmY5IYyJwS/kOiWx8mHo=
dep     github.com/sirupsen/logrus      v1.9.3  h1:dueUQJ1C2q9oE3F7wvmSGAaVtTmUizReu6fjN8uqzbQ=
dep     github.com/slackhq/nebula       v1.6.1  h1:/OCTR3abj0Sbf2nGoLUrdDXImrCv0ZVFpVPP5qa0DsM=
dep     github.com/smallstep/certificates       v0.25.0 h1:WWihtjQ7SprnRxDV44mBp8t5SMsNO5EWsQaEwy1rgFg=
dep     github.com/smallstep/go-attestation     v0.4.4-0.20230627102604-cf579e53cbd2    h1:UIAS8DTWkeclraEGH2aiJPyNPu16VbT41w4JoBlyFfU=
dep     github.com/smallstep/nosql      v0.6.0  h1:ur7ysI8s9st0cMXnTvB8tA3+x5Eifmkb6hl4uqNV5jc=
dep     github.com/smallstep/truststore v0.12.1 h1:guLUKkc1UlsXeS3t6BuVMa4leOOpdiv02PCRTiy1WdY=
dep     github.com/spf13/cast   v1.4.1  h1:s0hze+J0196ZfEMTs80N7UlFt0BDuQ7Q+JDnHiMWKdA=
dep     github.com/spf13/cobra  v1.7.0  h1:hyqWnYt1ZQShIddO5kBpj3vu05/++x6tJ6dg8EC572I=
dep     github.com/spf13/pflag  v1.0.5  h1:iy+VFUOCP1a+8yFto/drg2CJ5u0yRoB7fZw3DKv/JXA=
dep     github.com/stoewer/go-strcase   v1.2.0  h1:Z2iHWqGXH00XYgqDmNgQbIBxf3wrNq0F3feEy0ainaU=
dep     github.com/tailscale/tscert     v0.0.0-20230806124524-28a91b69a046      h1:8rUlviSVOEe7TMk7W0gIPrW8MqEzYfZHpsNWSf8s2vg=
dep     github.com/tencentcloud/tencentcloud-sdk-go/tencentcloud/common v1.0.597        h1:C0GHdLTfikLVoEzfhgPfrZ7LwlG0xiCmk6iwNKE+xs0=
dep     github.com/urfave/cli   v1.22.14        h1:ebbhrRiGK2i4naQJr+1Xj92HXZCrK7MsyTS/ob3HnAk=
dep     github.com/vultr/govultr/v3     v3.0.2  h1:rrYiuF9adB3rjnhp0ev+mkJXKEzuYa/AGfezYPr3EMs=
dep     github.com/x448/float16 v0.8.4  h1:qLwI1I70+NjRFUR3zs1JPUCgaCXSh3SW62uAKT1mSBM=
dep     github.com/yuin/goldmark        v1.5.6  h1:COmQAWTCcGetChm3Ig7G/t8AFAN00t+o8Mt4cf7JpwA=
dep     github.com/yuin/goldmark-highlighting/v2        v2.0.0-20230729083705-37449abec8cc      h1:+IAOyRda+RLrxa1WC7umKOZRsGq4QrFFMYApOeHzQwQ=
dep     github.com/zeebo/blake3 v0.2.3  h1:TFoLXsjeXqRNFxSbk35Dk4YtszE/MQQGK10BH4ptoTg=
dep     gitlab.com/NebulousLabs/fastrand        v0.0.0-20181126182046-603482d69e40      h1:dizWJqTWjwyD8KGcMOwgrkqu1JIkofYgKkmDeNE7oAs=
dep     gitlab.com/NebulousLabs/go-upnp v0.0.0-20211002182029-11da932010b6      h1:WKij6HF8ECp9E7K0E44dew9NrRDGiNR5u4EFsXnJUx4=
dep     go.etcd.io/bbolt        v1.3.7  h1:j+zJOnnEjF/kyHlDDgGnVL/AIqIJPq8UoB2GSNfkUfQ=
dep     go.mongodb.org/mongo-driver     v1.11.1 h1:QP0znIRTuL0jf1oBQoAoM0C6ZJfBK4kx0Uumtv1A7w8=
dep     go.mozilla.org/pkcs7    v0.0.0-20210826202110-33d05740a352      h1:CCriYyAfq1Br1aIYettdHZTy8mBTIPo7We18TuO/bak=
dep     go.opencensus.io        v0.24.0 h1:y73uSU6J157QMP2kn2r30vwW1A2W2WFwSCGnAVxeaD0=
dep     go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp   v0.45.0 h1:x8Z78aZx8cOF0+Kkazoc7lwUNMGy0LrzEMxTm4BbTxg=
dep     go.opentelemetry.io/contrib/propagators/autoprop        v0.42.0 h1:s2RzYOAqHVgG23q8fPWYChobUoZM6rJZ98EnylJr66w=
dep     go.opentelemetry.io/contrib/propagators/aws     v1.17.0 h1:IX8d7l2uRw61BlmZBOTQFaK+y22j6vytMVTs9wFrO+c=
dep     go.opentelemetry.io/contrib/propagators/b3      v1.17.0 h1:ImOVvHnku8jijXqkwCSyYKRDt2YrnGXD4BbhcpfbfJo=
dep     go.opentelemetry.io/contrib/propagators/jaeger  v1.17.0 h1:Zbpbmwav32Ea5jSotpmkWEl3a6Xvd4tw/3xxGO1i05Y=
dep     go.opentelemetry.io/contrib/propagators/ot      v1.17.0 h1:ufo2Vsz8l76eI47jFjuVyjyB3Ae2DmfiCV/o6Vc8ii0=
dep     go.opentelemetry.io/otel        v1.21.0 h1:hzLeKBZEL7Okw2mGzZ0cc4k/A7Fta0uoPgaJCr8fsFc=
dep     go.opentelemetry.io/otel/exporters/otlp/otlptrace       v1.21.0 h1:cl5P5/GIfFh4t6xyruOgJP5QiA1pw4fYYdv6nc6CBWw=
dep     go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracegrpc v1.21.0 h1:tIqheXEFWAZ7O8A7m+J0aPTmpJN3YQ7qetUAdkkkKpk=
dep     go.opentelemetry.io/otel/metric v1.21.0 h1:tlYWfeo+Bocx5kLEloTjbcDwBuELRrIFxwdQ36PlJu4=
dep     go.opentelemetry.io/otel/sdk    v1.21.0 h1:FTt8qirL1EysG6sTQRZ5TokkU8d0ugCj8htOgThZXQ8=
dep     go.opentelemetry.io/otel/trace  v1.21.0 h1:WD9i5gzvoUPuXIXH24ZNBudiarZDKuekPqi/E8fpfLc=
dep     go.opentelemetry.io/proto/otlp  v1.0.0  h1:T0TX0tmXU8a3CbNXzEKGeU5mIVOdf0oykP+u2lIVU/I=
dep     go.step.sm/cli-utils    v0.8.0  h1:b/Tc1/m3YuQq+u3ghTFP7Dz5zUekZj6GUmd5pCvkEXQ=
dep     go.step.sm/crypto       v0.35.1 h1:QAZZ7Q8xaM4TdungGSAYw/zxpyH4fMYTkfaXVV9H7pY=
dep     go.step.sm/linkedca     v0.20.1 h1:bHDn1+UG1NgRrERkWbbCiAIvv4lD5NOFaswPDTyO5vU=
dep     go.uber.org/multierr    v1.11.0 h1:blXXJkSxSSfBVBlC76pxqeO+LN3aDfLQo+309xJstO0=
dep     go.uber.org/zap v1.25.0 h1:4Hvk6GtkucQ790dqmj7l1eEnRdKm3k3ZUrUMS2d5+5c=
dep     golang.org/x/crypto     v0.17.0 h1:r8bRNjWL3GshPW3gkd+RpvzWrZAwPS49OmTGZ/uhM4k=
dep     golang.org/x/exp        v0.0.0-20230905200255-921286631fa9      h1:GoHiUyI/Tp2nVkLI2mCxVkOjsbSXD66ic0XW0js0R9g=
dep     golang.org/x/net        v0.17.0 h1:pVaXccu2ozPjCXewfr1S7xza/zcXTity9cCdXQYSjIM=
dep     golang.org/x/oauth2     v0.12.0 h1:smVPGxink+n1ZI5pkQa8y6fZT0RW0MgCO5bFpepy4B4=
dep     golang.org/x/sync       v0.4.0  h1:zxkM55ReGkDlKSM+Fu41A+zmbZuaPVbGMzvvdUPznYQ=
dep     golang.org/x/sys        v0.15.0 h1:h48lPFYpsTvQJZF4EKyI4aLHaev3CxivZmv7yZig9pc=
dep     golang.org/x/term       v0.15.0 h1:y/Oo/a/q3IXu26lQgl04j/gjuBDOBlx7X6Om1j2CPW4=
dep     golang.org/x/text       v0.14.0 h1:ScX5w1eTa3QqT8oi6+ziP7dTV1S2+ALU0bI+0zXKWiQ=
dep     google.golang.org/api   v0.142.0        h1:mf+7EJ94fi5ZcnpPy+m0Yv2dkz8bKm+UL0snTCuwXlY=
dep     google.golang.org/genproto/googleapis/api       v0.0.0-20231016165738-49dd2c1f3d0b      h1:CIC2YMXmIhYw6evmhPxBKJ4fmLbOFtXQN/GV3XOZR8k=
dep     google.golang.org/genproto/googleapis/rpc       v0.0.0-20231016165738-49dd2c1f3d0b      h1:ZlWIi1wSK56/8hn4QcBp/j9M7Gt3U/3hZw3mC7vDICo=
dep     google.golang.org/grpc  v1.59.0 h1:Z5Iec2pjwb+LEOqzpB2MR12/eKFhDPhuqW91O+4bwUk=
dep     google.golang.org/protobuf      v1.31.0 h1:g0LDEJHgrBl9N9r17Ru3sqWhkIx2NB67okBHPwC7hs8=
dep     gopkg.in/ini.v1 v1.66.6 h1:LATuAqN/shcYAOkv3wl2L4rkaKqkcgTBQjOyYDvcPKI=
dep     gopkg.in/natefinch/lumberjack.v2        v2.2.1  h1:bBRl1b0OH9s/DuPhuXpNl+VtCaJXFZ5/uEFST95x9zc=
dep     gopkg.in/square/go-jose.v2      v2.6.0  h1:NGk74WTnPKBNUhNzQX7PYcTLUjoq7mzKk2OKbvwk2iI=
dep     gopkg.in/yaml.v3        v3.0.1  h1:fxVm/GzAzEWqLHuvctI91KS9hhNmmWOoWu0XTYJS7CA=
build   -buildmode=exe
build   -compiler=gc
build   -trimpath=true
build   CGO_ENABLED=0
build   GOARCH=amd64
build   GOOS=freebsd
build   GOAMD64=v1
```
