# dnsdist-utils

The awesome [dnsdist](https://dnsdist.org/) DNS proxy/load balancer has almost every feature one could need for DNS, except of course the one that is useful for a small, forwarding-proxy-only home lab: exporting a central list of inhouse hosts to your own DNS, like e.g [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) does by default. Lua scripting to the rescue!

## Usage
- Add the ``.lua`` files either:
  - somewhere on your default Lua module path (e.g. ``/usr/local/share/lua/5.1/``)
  - to your /etc/dnsdist directory and edit ``dnsdist.conf`` to include the directory:
```
-- Add dnsdist config dir to Lua search path
package.path = package.path .. ";/etc/dnsdist/?.lua"
```
- Expose entries from ``/etc/hosts``:
```
require "hosts"
addHosts("/etc/hosts")
```
- Block a single domain, either interactively on the console or explicitly in the config:
```
blockDomain("instagramm.net")
```
- Block domains from a file:
```
blockDomains("/etc/dnsdist/blocked.conf")
```
The list of blocked domains is a plain file with one entry per line, e.g.:
```
#
# blocked domains
#
badwarez.net
facebork.net
gurgle.com
```

- Extend DNS record TTLs, e.g. to set the minimum TTL for DNS responses to 3600 seconds:
```
require "ttl"
setMinTTL(3600)
```

- Easily set common default options for upstream servers:
```
require "servers"

-- set default options once instead of repeating them for every server
setDefaultServerOptions({
	healthCheckMode="lazy",
	checkInterval=60,
	maxCheckFailures=2,
	lazyHealthCheckFailedInterval=60,
	lazyHealthCheckUseExponentialBackOff=true,
	lazyHealthCheckThreshold=3,
	weight=1000})

-- add server with default options
addServer({address="1.1.1.1"})
-- add server with overridden default option
addServer({address="8.8.8.8", weight=2000})
```

Done! Your ``dnsdist`` instance will now serve all non-``localhost`` entries,
which you can inspect on the console via ``showRules()`` or the Web UI.
