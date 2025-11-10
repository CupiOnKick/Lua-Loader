-- Dashboard.lua
local Dashboard = {}

local TweenService
local Players
local HttpService

local screenGui
local mainFrame

function Dashboard.init(parentGui, services)
    TweenService = services.TweenService
    Players = services.Players
    HttpService = services.HttpService
    screenGui = parentGui

    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 900, 0, 60)
    tabContainer.Position = UDim2.new(0.5, -450, 0.5, -395)
    tabContainer.BackgroundTransparency = 1
    tabContainer.ZIndex = 50
    tabContainer.Parent = screenGui

    -- Dashboard Tab Card
    local dashboardTabCard = Instance.new("Frame")
    dashboardTabCard.Name = "DashboardTabCard"
    dashboardTabCard.Size = UDim2.new(0.5, -10, 1, 0)
    dashboardTabCard.Position = UDim2.new(0, 0, 0, 0)
    dashboardTabCard.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dashboardTabCard.BackgroundTransparency = 0.85
    dashboardTabCard.BorderSizePixel = 0
    dashboardTabCard.Parent = tabContainer
    local dashboardTabBtn = Instance.new("TextButton")
    dashboardTabBtn.Size = UDim2.new(1, 0, 1, 0)
    dashboardTabBtn.BackgroundTransparency = 1
    dashboardTabBtn.Text = "Dashboard"
    dashboardTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dashboardTabBtn.TextSize = 20
    dashboardTabBtn.Font = Enum.Font.GothamBold
    dashboardTabBtn.ZIndex = 60
    dashboardTabBtn.Parent = dashboardTabCard

    -- Main UI Frame
    mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 900, 0, 650)
    mainFrame.Position = UDim2.new(0.5, -450, 0.5, -325)
    mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.ClipsDescendants = true
    mainFrame.ZIndex = 50
    mainFrame.Parent = screenGui

    -- Dashboard Frame
    local dashboardFrame = Instance.new("Frame")
    dashboardFrame.Name = "DashboardFrame"
    dashboardFrame.Size = UDim2.new(1, 0, 1, 0)
    dashboardFrame.Position = UDim2.new(0, 0, 0, 0)
    dashboardFrame.BackgroundTransparency = 1
    dashboardFrame.ZIndex = 55
    dashboardFrame.Visible = true
    dashboardFrame.Parent = mainFrame

    -- Clock Card
    local clockCard = Instance.new("Frame")
    clockCard.Size = UDim2.new(0, 120, 0, 40)
    clockCard.Position = UDim2.new(0, 20, 1, -60)
    clockCard.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
    clockCard.BackgroundTransparency = 0
    clockCard.BorderSizePixel = 0
    clockCard.ZIndex = 56
    clockCard.Parent = dashboardFrame
    local clockLabel = Instance.new("TextLabel")
    clockLabel.Text = ""
    clockLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    clockLabel.TextSize = 18
    clockLabel.Font = Enum.Font.GothamBold
    clockLabel.BackgroundTransparency = 1
    clockLabel.Size = UDim2.new(1, 0, 1, 0)
    clockLabel.ZIndex = 57
    clockLabel.Parent = clockCard

    task.spawn(function()
        while true do
            local time = os.date("*t")
            local hour = time.hour % 12
            if hour == 0 then hour = 12 end
            local ampm = time.hour >= 12 and "PM" or "AM"
            clockLabel.Text = string.format("%02d:%02d:%02d %s", hour, time.min, time.sec, ampm)
            task.wait(1)
        end
    end)

    -- Search Button (shows Search module when clicked via event later)
    local searchButton = Instance.new("TextButton")
    searchButton.Size = UDim2.new(0, 200, 0, 50)
    searchButton.Position = UDim2.new(0, 20, 0, 20)
    searchButton.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
    searchButton.Text = "Search Roblox Users"
    searchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchButton.TextSize = 18
    searchButton.Font = Enum.Font.GothamBold
    searchButton.BorderSizePixel = 0
    searchButton.AutoButtonColor = false
    searchButton.ZIndex = 56
    searchButton.Parent = dashboardFrame

    Dashboard._mainFrame = mainFrame
    Dashboard._searchButton = searchButton
end

function Dashboard.show()
    if Dashboard._mainFrame then
        Dashboard._mainFrame.Visible = true
    end
end

function Dashboard.hide()
    if Dashboard._mainFrame then
        Dashboard._mainFrame.Visible = false
    end
end

return Dashboard
