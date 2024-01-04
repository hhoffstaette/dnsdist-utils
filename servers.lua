
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

function setDefaultServerOptions(options)
  DefaultServerOptions = options
end

function addServer(options)
  local merged  = mergedTable(DefaultServerOptions, options)
  newServer(merged)
end

