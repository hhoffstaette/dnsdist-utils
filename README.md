# dnsdist-hosts

The awesome [dnsdist](https://dnsdist.org/) DNS proxy/load balancer has almost every feature one could need for DNS, except of course the one that is useful for a small, forwarding-proxy-only home lab: exporting a central list of inhouse hosts to your own DNS, like e.g [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) does by default. Lua scripting to the rescue!

## Usage
* Add ``hosts.lua`` either to your /etc/dnsdist directory or alternatively somewhere on your default Lua module path (e.g. ``/usr/local/share/lua/5.1/``)
* Edit ``dnsdist.conf`` to include the directory (if necessary):
```
-- Add dnsdist config dir to Lua search path
package.path = package.path .. ";/etc/dnsdist/?.lua"
```
* Load the module:
```
-- Load hosts module
require "hosts"
```
* Pass ``dnsdist``'s function to create a spoofed DNS entry into the ``forEachHost`` function:
```
-- Add entries from /etc/hosts
forEachHost(function(ip, hostname) addAction(hostname, SpoofAction({ip})) end)
```

Done! Your ``dnsdist`` instance will now serve all non-``localhost`` entries,
which you can inspect on the console via ``showRules()`` or the Web UI.
