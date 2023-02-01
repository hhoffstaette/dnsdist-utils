
-- check whether a file exists and can be opened for reading
local function file_exists(name)
  local f = io.open(name, "r")
  return f ~= nil and io.close(f)
end

-- read all lines from given file & invoke callback with (ip, hostname) as argument;
-- nonexisting files are ignored.
local function forEachHost(file, callback)
  if not file_exists(file) then return end
  for line in io.lines(file) do
    -- ignore empty lines and comments
    if string.len(line) ~= 0 and string.find(line, "^#") == nil then
      -- ignore any localhost entries
      if not string.match(line, "localhost") then
        -- separate IP and all names
        for ip, space, host in string.gmatch(line, "(%g+)(%s+)(%g.+)") do
          -- create entries for every name
          for name in string.gmatch(host, "(%g+)") do
            callback(ip, name)
          end
        end
      end
    end
  end
end

-- read all lines from given file & invoke callback with (domain) as argument;
-- nonexisting files are ignored.
local function forEachDomain(file, callback)
  if not file_exists(file) then return end
  for line in io.lines(file) do
    -- ignore empty lines and comments
    if string.len(line) ~= 0 and string.find(line, "^#") == nil then
      -- create entries for every name
      for domain in string.gmatch(line, "(%g+)") do
        callback(domain)
      end
    end
  end
end

-- create spoof rules for all entries in the given hosts file
function addHosts(file)
  forEachHost(file, function(ip, hostname) addAction(hostname, SpoofAction({ip}, {ttl=3600}), {name=hostname}) end)
end

-- create nxdomain rule for a single host/domain
function blockDomain(domain)
  addAction(domain, RCodeAction(DNSRCode.NXDOMAIN), {name=domain, ttl=86400})
end

-- create nxdomain rules for all entries in the given file
function blockDomains(file)
  forEachDomain(file, function(domain) blockDomain(domain) end)
end

