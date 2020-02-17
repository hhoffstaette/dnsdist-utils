
MinTTL = 0

local function minTTL(section, qclass, qtype, ttl)
  return math.max(ttl, MinTTL)
end

local function checkTTL(dnsResponse)
  dnsResponse:editTTLs(minTTL)
  return DNSResponseAction.Allow
end

function setMinTTL(value)
  MinTTL = value
  addResponseAction(AllRule(), LuaResponseAction(checkTTL))
end

