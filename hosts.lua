
-- read all entries from /etc/hosts & invoke callback with (ip, hostname) as argument
function add_hosts(callback)
  hosts = "/etc/hosts"

  for line in io.lines(hosts) do
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

