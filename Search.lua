local Search = {}

local HttpService
local searchFrame

function Search.init(parentGui, services)
    HttpService = services.HttpService

    searchFrame = Instance.new("Frame")
    searchFrame.Size = UDim2.new(0, 400, 0, 300)
    searchFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    searchFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    searchFrame.BackgroundTransparency = 0.05
    searchFrame.BorderSizePixel = 0
    searchFrame.Visible = false
    searchFrame.ClipsDescendants = true
    searchFrame.ZIndex = 70
    searchFrame.Parent = parentGui

    local searchInput = Instance.new("TextBox")
    searchInput.Size = UDim2.new(0.8, 0, 0, 40)
    searchInput.Position = UDim2.new(0, 20, 0, 20)
    searchInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    searchInput.Text = "Enter username"
    searchInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchInput.TextSize = 16
    searchInput.Font = Enum.Font.GothamBold
    searchInput.ZIndex = 71
    searchInput.Parent = searchFrame

    local searchResultsScrolling = Instance.new("ScrollingFrame")
    searchResultsScrolling.Size = UDim2.new(1, -40, 1, -80)
    searchResultsScrolling.Position = UDim2.new(0, 20, 0, 70)
    searchResultsScrolling.BackgroundTransparency = 1
    searchResultsScrolling.BorderSizePixel = 0
    searchResultsScrolling.ScrollBarThickness = 4
    searchResultsScrolling.ScrollBarImageColor3 = Color3.fromRGB(220, 38, 38)
    searchResultsScrolling.ZIndex = 71
    searchResultsScrolling.Parent = searchFrame
    local searchResultsLayout = Instance.new("UIListLayout")
    searchResultsLayout.Padding = UDim.new(0, 8)
    searchResultsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    searchResultsLayout.Parent = searchResultsScrolling

    searchInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            for _, child in ipairs(searchResultsScrolling:GetChildren()) do
                if child:IsA("Frame") then child:Destroy() end
            end
            local query = searchInput.Text
            local ok, response = pcall(function()
                return HttpService:JSONDecode(HttpService:GetAsync("https://users.roblox.com/v1/users/search?keyword=" .. HttpService:UrlEncode(query) .. "&limit=10"))
            end)
            local users = (ok and response and response.data) or {}
            for _, user in ipairs(users) do
                local uframe = Instance.new("Frame")
                uframe.Size = UDim2.new(1, 0, 0, 50)
                uframe.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
                uframe.BorderSizePixel = 0
                uframe.ZIndex = 72
                uframe.Parent = searchResultsScrolling
                local unameLabel = Instance.new("TextLabel")
                unameLabel.Text = user.name .. " (@" .. user.displayName .. ")"
                unameLabel.TextColor3 = Color3.fromRGB(255,255,255)
                unameLabel.TextSize = 15
                unameLabel.Font = Enum.Font.GothamBold
                unameLabel.BackgroundTransparency = 1
                unameLabel.Size = UDim2.new(1, -20, 1, 0)
                unameLabel.Position = UDim2.new(0, 10, 0, 0)
                unameLabel.TextXAlignment = Enum.TextXAlignment.Left
                unameLabel.TextTruncate = Enum.TextTruncate.AtEnd
                unameLabel.ZIndex = 73
                unameLabel.Parent = uframe

                uframe.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local ok2, presenceResponse = pcall(function()
                            return HttpService:JSONDecode(HttpService:PostAsync("https://presence.roblox.com/v1/presence/users", HttpService:JSONEncode({userIds = {user.id}}), Enum.HttpContentType.ApplicationJson))
                        end)
                        if ok2 and presenceResponse and presenceResponse.userPresences then
                            local presence = presenceResponse.userPresences[1]
                            local onlineStatus = presence.userPresenceType == 0 and "Offline" or "Online"
                            local placeId = presence.placeId
                            local joinAllowed = "Off"
                            if placeId then
                                local ok3, gameDetailsResponse = pcall(function()
                                    return HttpService:JSONDecode(HttpService:GetAsync("https://games.roblox.com/v1/games/multiget-place-details?placeIds=" .. placeId))
                                end)
                                if ok3 and gameDetailsResponse and gameDetailsResponse[1] then
                                    joinAllowed = gameDetailsResponse[1].isPlayable and "On" or "Off"
                                end
                            end
                            unameLabel.Text = user.name .. " (@" .. user.displayName .. ") - " .. onlineStatus .. " - Joins: " .. joinAllowed
                        end
                    end
                end)
            end
            searchResultsScrolling.CanvasSize = UDim2.new(0,0,0,#users * 58)
        end
    end)

    Search.frame = searchFrame
end

function Search.show()
    if Search.frame then Search.frame.Visible = true end
end

function Search.hide()
    if Search.frame then Search.frame.Visible = false end
end

return Search
