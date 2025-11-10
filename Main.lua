local remoteUrl = "https://raw.githubusercontent.com/CupiOnKick/Lua-Loader/refs/heads/main/Main.lua"
local function fetchRemoteContent(url)
    local content
    -- Try common game HTTP helpers first
    local ok, res = pcall(function()
        if game.HttpGetAsync then return game:HttpGetAsync(url) end
    end)
    if ok and type(res) == "string" and #res > 0 then content = res end
    if not content then
        ok, res = pcall(function()
            if game.HttpGet then return game:HttpGet(url) end
        end)
        if ok and type(res) == "string" and #res > 0 then content = res end
    end
    if not content then
        local HttpService = game:GetService("HttpService")
        ok, res = pcall(function()
            return HttpService:GetAsync(url)
        end)
        if ok and type(res) == "string" and #res > 0 then content = res end
    end
    return content
end

local function tryRunRemote()
    local content = fetchRemoteContent(remoteUrl)
    if not content then return false end
    local loader = loadstring or load
    if not loader then
        warn("No loadstring/load available to execute remote code")
        return false
    end
    local ok, chunk = pcall(function() return loader(content) end)
    if not ok then
        warn("Failed to compile remote Main.lua:", chunk)
        return false
    end
    if type(chunk) == "function" then
        local ok2, err = pcall(chunk)
        if not ok2 then warn("Remote Main.lua errored when running:", err) end
        return ok2
    end
    return true
end

local remoteOk = false
local ok, err = pcall(tryRunRemote)
if ok and remoteOk == false then
    remoteOk = tryRunRemote()
end
if ok and remoteOk then
    return true
end

-- Remote did not run successfully; proceed with local loader
local Utils = require(script.Parent:WaitForChild("Utils"))
local Fetcher = require(script.Parent:WaitForChild("Fetcher"))
local services = Utils.getServices()
local player = Utils.getLocalPlayer()

local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Utils.createScreenGui("IcarusHub", playerGui)

local splash = Instance.new("Frame")
splash.Size = UDim2.new(0, 400, 0, 200)
splash.Position = UDim2.new(0.5, -200, 0.5, -100)
splash.BackgroundColor3 = Color3.fromRGB(18,18,18)
splash.BorderSizePixel = 0
splash.Parent = screenGui
local label = Instance.new("TextLabel")
label.Size = UDim2.new(1,0,1,0)
label.BackgroundTransparency = 1
label.Text = "Icarus Hub"
label.TextColor3 = Color3.fromRGB(255,255,255)
label.Font = Enum.Font.GothamBold
label.TextSize = 36
label.Parent = splash


local Modules = {}
local moduleNames = {"Dashboard", "Settings", "Profile", "Server", "Search", "Notifications"}


local useRemote = true
local remoteList = nil
if useRemote then
    local ok, listOrErr = pcall(function()
        return Fetcher.fetchList("CupiOnKick", "Lua-Loader", "")
    end)
    if ok and type(listOrErr) == "table" then
        remoteList = listOrErr
        print("Fetcher: remote file list obtained, files:")
        for fname,_ in pairs(remoteList) do print(" -", fname) end
    else
        warn("Fetcher: could not fetch remote file list; will use local modules. Reason:", listOrErr)
    end
end

-- If we have a remote list, we'll sequentially load each file (showing timing on the splash)
if remoteList then
    task.spawn(function()
        -- prepare deterministic order
        local names = {}
        for fname in pairs(remoteList) do table.insert(names, fname) end
        table.sort(names, function(a,b) return a:lower() < b:lower() end)

        label.Text = "Loading remote modules..."
        for _, filename in ipairs(names) do
            local download_url = remoteList[filename]
            label.Text = "Downloading " .. filename .. "..."

            -- Prefer game:HttpGetAsync as requested
            local content
            local ok, res = pcall(function()
                return (game.HttpGetAsync and game:HttpGetAsync(download_url))
            end)
            if not (ok and type(res) == "string") then
                ok, res = pcall(function()
                    return (game.HttpGet and game:HttpGet(download_url))
                end)
            end
            if not (ok and type(res) == "string") then
                local HttpService = game:GetService("HttpService")
                ok, res = pcall(function() return HttpService:GetAsync(download_url) end)
            end
            if ok and type(res) == "string" then content = res end

            if content then
                local startTime = os.clock()
                local loader = loadstring or load
                if loader then
                    local ok2, chunkOrErr = pcall(function() return loader(content) end)
                    if ok2 and type(chunkOrErr) == "function" then
                        local ok3, execErr = pcall(chunkOrErr)
                        local elapsed = os.clock() - startTime
                        label.Text = string.format("Loaded %s in %.3f s", filename, elapsed)
                        print("Loaded remote file:", filename, "time:", elapsed)
                        if not ok3 then warn("Error executing remote file", filename, execErr) end
                    else
                        warn("Failed to compile remote file:", filename, chunkOrErr)
                    end
                else
                    warn("No loader available to run remote file:", filename)
                end
            else
                warn("Failed to download remote file:", filename)
            end

            -- wait 3 seconds before loading next
            task.wait(3)
        end

        -- after remote sequential load, continue with initializing local modules as fallback
        label.Text = "Remote load complete. Initializing UI..."
        task.wait(1)
        Utils.tweenObject(splash, {BackgroundTransparency = 1}, 0.4)
        Utils.tweenObject(label, {TextTransparency = 1}, 0.4)
        task.wait(0.45)
        splash:Destroy()

        for _, name in ipairs(moduleNames) do
            local ok2, mod = pcall(function()
                return require(script.Parent:FindFirstChild(name) or script.Parent:WaitForChild(name))
            end)
            if ok2 and type(mod) == "table" and mod.init then
                local suc, err = pcall(function() mod.init(screenGui, services) end)
                if not suc then warn("Failed to init local module after remote load:", name, err) end
            end
        end
    end)
    return true
else
    -- no remote list: load local modules into Modules table
    for _, name in ipairs(moduleNames) do
        local ok, mod = pcall(function()
            return require(script.Parent:FindFirstChild(name) or script.Parent:WaitForChild(name))
        end)
        if ok and type(mod) == "table" and mod.init then
            table.insert(Modules, mod)
        end
    end
end


task.spawn(function()
    task.wait(1.2)

    Utils.tweenObject(splash, {BackgroundTransparency = 1}, 0.4)
    Utils.tweenObject(label, {TextTransparency = 1}, 0.4)
    task.wait(0.45)
    splash:Destroy()

    for _, mod in ipairs(Modules) do
        local ok, err = pcall(function()
            mod.init(screenGui, services)
        end)
        if not ok then
            warn("Failed to init module:", err)
        end
    end
end)

return true
