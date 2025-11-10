
local Profile = {}

local HttpService
local Players
local player
local profileFrame

function Profile.init(parentGui, services)
    HttpService = services.HttpService
    Players = services.Players
    player = Players.LocalPlayer

    profileFrame = Instance.new("Frame")
    profileFrame.Name = "ProfileFrame"
    profileFrame.Size = UDim2.new(0, 300, 0, 450)
    profileFrame.Position = UDim2.new(0.5, 470, 0.5, -225)
    profileFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    profileFrame.BackgroundTransparency = 0.05
    profileFrame.BorderSizePixel = 0
    profileFrame.Visible = false
    profileFrame.ClipsDescendants = true
    profileFrame.ZIndex = 50
    profileFrame.Parent = parentGui

    local profileContainer = Instance.new("Frame")
    profileContainer.Size = UDim2.new(1, -40, 1, -40)
    profileContainer.Position = UDim2.new(0, 20, 0, 20)
    profileContainer.BackgroundTransparency = 1
    profileContainer.ZIndex = 55
    profileContainer.Parent = profileFrame

    local profileTitle = Instance.new("TextLabel")
    profileTitle.Text = "Profile"
    profileTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    profileTitle.TextSize = 22
    profileTitle.Font = Enum.Font.GothamBold
    profileTitle.BackgroundTransparency = 1
    profileTitle.Size = UDim2.new(1, 0, 0, 30)
    profileTitle.Position = UDim2.new(0, 0, 0, 15)
    profileTitle.ZIndex = 56
    profileTitle.Parent = profileFrame

    local userThumbnail = Instance.new("ImageLabel")
    userThumbnail.Size = UDim2.new(0, 140, 0, 140)
    userThumbnail.Position = UDim2.new(0, 10, 0, 50)
    userThumbnail.BackgroundTransparency = 1
    userThumbnail.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=420&h=420"
    userThumbnail.ZIndex = 57
    userThumbnail.Parent = profileContainer

    local usernameLabel = Instance.new("TextLabel")
    usernameLabel.Text = player.Name
    usernameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    usernameLabel.TextSize = 18
    usernameLabel.Font = Enum.Font.GothamBold
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Size = UDim2.new(1, 0, 0, 25)
    usernameLabel.ZIndex = 56
    usernameLabel.Parent = profileContainer

    local profileInfoCard = Instance.new("Frame")
    profileInfoCard.Size = UDim2.new(1, 0, 0, 120)
    profileInfoCard.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
    profileInfoCard.BorderSizePixel = 0
    profileInfoCard.ZIndex = 56
    profileInfoCard.Parent = profileContainer

    local profileInfo = Instance.new("TextLabel")
    profileInfo.Text = "UserID: " .. player.UserId .. "\nFriends Online: Loading...\nJoined: Loading...\nFriends Joined: Loading..."
    profileInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
    profileInfo.TextSize = 14
    profileInfo.Font = Enum.Font.GothamBold
    profileInfo.BackgroundTransparency = 1
    profileInfo.Size = UDim2.new(1, -20, 1, 0)
    profileInfo.Position = UDim2.new(0, 10, 0, 0)
    profileInfo.TextXAlignment = Enum.TextXAlignment.Left
    profileInfo.TextYAlignment = Enum.TextYAlignment.Top
    profileInfo.TextWrapped = true
    profileInfo.ZIndex = 57
    profileInfo.Parent = profileInfoCard

    -- Fetch profile info (wrapped safely)
    task.spawn(function()
        local ok, userInfo = pcall(function()
            return HttpService:JSONDecode(HttpService:GetAsync("https://users.roblox.com/v1/users/" .. player.UserId))
        end)
        if not ok or not userInfo then return end
        local joinedDate = os.date("%Y-%m-%d", os.time{year = tonumber(userInfo.created:sub(1,4)), month = tonumber(userInfo.created:sub(6,7)), day = tonumber(userInfo.created:sub(9,10))})
        local friendsCount = 0
        pcall(function()
            friendsCount = HttpService:JSONDecode(HttpService:GetAsync("https://friends.roblox.com/v1/users/" .. player.UserId .. "/friends/count")).count
        end)
        profileInfo.Text = "UserID: " .. player.UserId .. "\nFriends Online: N/A\nJoined: " .. joinedDate .. "\nFriends Joined: " .. friendsCount
    end)

    Profile.frame = profileFrame
end

function Profile.show()
    if Profile.frame then Profile.frame.Visible = true end
end

function Profile.hide()
    if Profile.frame then Profile.frame.Visible = false end
end

return Profile
