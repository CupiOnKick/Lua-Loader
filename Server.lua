
local Server = {}

local Players
local serverFrame

function Server.init(parentGui, services)
    Players = services.Players

    serverFrame = Instance.new("Frame")
    serverFrame.Name = "ServerFrame"
    serverFrame.Size = UDim2.new(0, 300, 0, 450)
    serverFrame.Position = UDim2.new(0.5, -770, 0.5, -225)
    serverFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    serverFrame.BackgroundTransparency = 0.05
    serverFrame.BorderSizePixel = 0
    serverFrame.Visible = false
    serverFrame.ClipsDescendants = true
    serverFrame.ZIndex = 50
    serverFrame.Parent = parentGui

    local playerScrolling = Instance.new("ScrollingFrame")
    playerScrolling.Size = UDim2.new(1, -40, 1, -130)
    playerScrolling.Position = UDim2.new(0, 20, 0, 60)
    playerScrolling.BackgroundTransparency = 1
    playerScrolling.BorderSizePixel = 0
    playerScrolling.ScrollBarThickness = 4
    playerScrolling.ScrollBarImageColor3 = Color3.fromRGB(220, 38, 38)
    playerScrolling.ZIndex = 56
    playerScrolling.Parent = serverFrame
    local playerListLayout = Instance.new("UIListLayout")
    playerListLayout.Padding = UDim.new(0, 8)
    playerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    playerListLayout.Parent = playerScrolling

    local bottomButtons = Instance.new("Frame")
    bottomButtons.Size = UDim2.new(1, -40, 0, 45)
    bottomButtons.Position = UDim2.new(0, 20, 1, -60)
    bottomButtons.BackgroundTransparency = 1
    bottomButtons.ZIndex = 56
    bottomButtons.Parent = serverFrame
    local buttonsLayout = Instance.new("UIListLayout")
    buttonsLayout.FillDirection = Enum.FillDirection.Horizontal
    buttonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    buttonsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    buttonsLayout.Padding = UDim.new(0, 10)
    buttonsLayout.Parent = bottomButtons

    local mimicBtn = Instance.new("TextButton")
    mimicBtn.Size = UDim2.new(0, 75, 0, 40)
    mimicBtn.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
    mimicBtn.Text = "Mimic"
    mimicBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    mimicBtn.TextSize = 15
    mimicBtn.Font = Enum.Font.GothamBold
    mimicBtn.BorderSizePixel = 0
    mimicBtn.AutoButtonColor = false
    mimicBtn.ZIndex = 57
    mimicBtn.Parent = bottomButtons

    Server.frame = serverFrame
    Server.playerScrolling = playerScrolling
end

function Server.show()
    if Server.frame then Server.frame.Visible = true end
end

function Server.hide()
    if Server.frame then Server.frame.Visible = false end
end

return Server
