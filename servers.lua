
-- From: https://stackoverflow.com/a/76160226/99851
local function mergedTable(...)
  local result = {}
  for i, tbl in ipairs({...}) do
    for k, v in pairs(tbl) do
      if type(k) ~= "number" then
        result[k] = v
      else
        table.insert(result, v)
      end
    end
  end
  return result
end

local DefaultServerOptions = {}

local function forEachServer(nameOrAddress, callback)
  for index,server in pairs(getServers()) do
    if string.match(server:getNameWithAddr(), nameOrAddress) ~= nil then
      callback(server)
    end
  end
end

function setDefaultServerOptions(options)
  DefaultServerOptions = options
end

function addServer(options)
  local merged  = mergedTable(DefaultServerOptions, options)
  return newServer(merged)
end

function disableServer(nameOrAddress)
  forEachServer(nameOrAddress, function (server) server:setDown() end)
end

function enableServer(nameOrAddress)
  forEachServer(nameOrAddress, function (server) server:setAuto(true) end)
end

