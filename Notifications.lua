
local Notifications = {}

local TweenService
local container
local notifications = {}
local notificationQueue = {}

function Notifications.init(parentGui, services)
    TweenService = services.TweenService
    container = Instance.new("Frame")
    container.Size = UDim2.new(0, 250, 0, 150)
    container.Position = UDim2.new(1, -270, 1, -170)
    container.BackgroundTransparency = 1
    container.ZIndex = 80
    container.Parent = parentGui
    local notificationList = Instance.new("UIListLayout")
    notificationList.Padding = UDim.new(0, 10)
    notificationList.SortOrder = Enum.SortOrder.LayoutOrder
    notificationList.VerticalAlignment = Enum.VerticalAlignment.Bottom
    notificationList.Parent = container
end

local function createNotification(text)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(1, 0, 0, 50)
    notif.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
    notif.BackgroundTransparency = 0
    notif.BorderSizePixel = 0
    notif.ZIndex = 81
    notif.Position = UDim2.new(1, 0, 0, 0)
    local notifLabel = Instance.new("TextLabel")
    notifLabel.Text = text
    notifLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifLabel.TextSize = 14
    notifLabel.Font = Enum.Font.GothamBold
    notifLabel.BackgroundTransparency = 1
    notifLabel.Size = UDim2.new(1, -20, 1, 0)
    notifLabel.Position = UDim2.new(0, 10, 0, 0)
    notifLabel.TextXAlignment = Enum.TextXAlignment.Left
    notifLabel.TextWrapped = true
    notifLabel.ZIndex = 82
    notifLabel.Parent = notif
    notif.Parent = container
    -- Slide in
    TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    return notif
end

function Notifications.showNotification(text)
    if not container then return end
    if #notifications >= 2 then
        table.insert(notificationQueue, text)
    else
        local notif = createNotification(text)
        table.insert(notifications, notif)
        task.delay(5, function()
            TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(1, 0, 0, 0)}):Play()
            task.wait(0.5)
            notif:Destroy()
            table.remove(notifications, 1)
            if #notificationQueue > 0 then
                local nextText = table.remove(notificationQueue, 1)
                Notifications.showNotification(nextText)
            end
        end)
    end
end

return Notifications
