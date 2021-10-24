
MinTTL = 0

local function minTTL(section, qclass, qtype, ttl)
  return math.max(ttl, MinTTL)
end

local function checkTTL(dnsResponse)
  if dnsResponse.rcode == DNSRCode.NOERROR then
    dnsResponse:editTTLs(minTTL)
  end
  return DNSResponseAction.None
end

function setMinTTL(value)
  MinTTL = value
  addResponseAction(AllRule(), LuaResponseAction(checkTTL), {name="minTTL"})
end

