local Fetcher = {}
local HttpService = game:GetService("HttpService")

local function apiUrl(owner, repo, path)
    path = path or ""
    if path ~= "" and path:sub(1,1) == "/" then path = path:sub(2) end
    return ("https://api.github.com/repos/%s/%s/contents/%s"):format(owner, repo, path)
end

local function isLuaFile(name)
    return name:sub(-4):lower() == ".lua"
end

local function fetchUrl(url)
    local ok, res = pcall(function()
        return HttpService:GetAsync(url, true)
    end)
    if ok then return res end
    return nil, res
end

local function fetchContents(owner, repo, path, out)
    out = out or {}
    local url = apiUrl(owner, repo, path)
    local body, err = fetchUrl(url)
    if not body then return nil, "Failed to list contents: " .. tostring(err) end
    local ok, items = pcall(function() return HttpService:JSONDecode(body) end)
    if not ok or type(items) ~= "table" then return nil, "Invalid JSON returned for contents" end
    for _, item in ipairs(items) do
        if item.type == "file" and isLuaFile(item.name) then
            local content, ferr = fetchUrl(item.download_url)
            if content then out[item.name] = content else warn("Failed to download file:", item.download_url, ferr) end
        elseif item.type == "dir" then
            local subPath = (path == "" or not path) and item.path or (path .. "/" .. item.name)
            fetchContents(owner, repo, subPath, out)
        end
    end
    return out
end

function Fetcher.fetchAndLoad(owner, repo, path)
    path = path or ""
    local files, err = fetchContents(owner, repo, path, {})
    if not files then return nil, err end
    local loaded = {}
    for filename, content in pairs(files) do
        local moduleName = filename:gsub("%.lua$", "")
        local ok, f = pcall(function()
            return loadstring and loadstring(content) or load(content)
        end)
        if ok and type(f) == "function" then
            local ok2, result = pcall(f)
            if ok2 then loaded[moduleName] = result else warn("Fetcher: error executing module ", moduleName, result) end
        else
            warn("Fetcher: failed to compile module", moduleName)
        end
    end
    return loaded
end

-- Returns a map of filename -> download_url for all .lua files under the repo path
function Fetcher.fetchList(owner, repo, path)
    path = path or ""
    local url = apiUrl(owner, repo, path)
    local body, err = fetchUrl(url)
    if not body then return nil, err end
    local ok, items = pcall(function() return HttpService:JSONDecode(body) end)
    if not ok or type(items) ~= "table" then return nil, "Invalid JSON" end
    local out = {}
    for _, item in ipairs(items) do
        if item.type == "file" and isLuaFile(item.name) then
            out[item.name] = item.download_url
        elseif item.type == "dir" then
            local subPath = (path == "" or not path) and item.path or (path .. "/" .. item.name)
            local ok2, sub = pcall(function() return Fetcher.fetchList(owner, repo, subPath) end)
            if ok2 and type(sub) == "table" then
                for k,v in pairs(sub) do out[k] = v end
            end
        end
    end
    return out
end

return Fetcher
