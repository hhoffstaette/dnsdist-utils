
local MinTTL = 0

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
  -- remove a previous rule
  if MinTTL > 0 then
  	rmResponseRule("minTTL")
  end

  -- keep the value
  MinTTL = value

  -- only add the rule if the new TTL is >0
  if value > 0 then
    addResponseAction(AllRule(), LuaResponseAction(checkTTL), {name="minTTL"})
  end
end

