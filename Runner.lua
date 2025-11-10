local success, result = pcall(function()
    local main = require(script.Parent:WaitForChild("Main"))
    return main
end)
if not success then
    warn("IcarusHub Runner: failed to require Main - ", result)
else
    print("IcarusHub Runner: Main required successfully")
end
