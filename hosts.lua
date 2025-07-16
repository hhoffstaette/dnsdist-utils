
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

-- create a unique action name for the given host entry to prevent
-- duplicate metrics for hosts with both v4/v6 addresses
local function actionName(hostentry, ip)
    -- v6 address?
    if string.find(ip, ":") ~= nil then
        -- split host & domain
        host = string.match(hostentry, "[^.*%.]+")
        domain = string.match(hostentry, "[.*%.].*")
        if domain == nil then domain = "" end
        -- add suffix to host
        return host .. "_v6" .. domain
    end

    -- host entry is v4
    return hostentry
end

-- create spoof rules for all entries in the given hosts file
function addHosts(file)
  local addHost = function(ip, hostname)
    addAction(hostname, SpoofAction(ip, {ttl=86400}), {name=actionName(hostname, ip)})
  end

  forEachHost(file, addHost)
end

-- create nxdomain rule for a single host/domain
function blockDomain(domain)
  addAction(domain, RCodeAction(DNSRCode.NXDOMAIN), {name=domain})
end

-- create nxdomain rules for all entries in the given file
function blockDomains(file)
  forEachDomain(file, function(domain) blockDomain(domain) end)
end

