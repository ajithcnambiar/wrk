count = 0
local counter = 1
local threads = {}

setup = function (thread)
    thread:set("id", counter)
    table.insert(threads, thread)
    counter = counter + 1
 end

 function init(args)
   request_ids = {}
end

request = function()
   count = count + 1
   wrk.headers["X-Request-Id"] = tostring(count) .. tostring( {} ):sub(8)
   request_ids[wrk.headers["X-Request-Id"]] = os.time()
   return wrk.format(nil, nil)
end

response = function(status, headers, body)
    request_ids[headers["X-Request-Id"]] = nil
end

function done(summary, latency, requests)
    for index, thread in ipairs(threads) do
       local request_ids = thread:get("request_ids")
       for k, v in pairs(request_ids) do
         io.write("lost request_id = " .. k .. " " .. v .. "\n")
       end
    end
 end

 -- ./wrk -c12 -d3 -t4 -T5 -s request.lua 'https://localhost:9090/' > res