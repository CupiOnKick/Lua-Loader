
local Settings = {}

local HttpService
local settingsFrame
local inputs = {}

function Settings.init(parentGui, services)
    HttpService = services.HttpService

    settingsFrame = Instance.new("ScrollingFrame")
    settingsFrame.Name = "SettingsFrame"
    settingsFrame.Size = UDim2.new(1, -40, 1, -40)
    settingsFrame.Position = UDim2.new(0, 20, 0, 20)
    settingsFrame.BackgroundTransparency = 1
    settingsFrame.BorderSizePixel = 0
    settingsFrame.ScrollBarThickness = 6
    settingsFrame.ScrollBarImageColor3 = Color3.fromRGB(220, 38, 38)
    settingsFrame.ZIndex = 55
    settingsFrame.Visible = false
    settingsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    settingsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    settingsFrame.Parent = parentGui

    local settingsLayout = Instance.new("UIListLayout")
    settingsLayout.Padding = UDim.new(0, 15)
    settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    settingsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    settingsLayout.Parent = settingsFrame

    local function createSettingCard(title, inputType, defaultValue, callback)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 50)
        card.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
        card.BackgroundTransparency = 0
        card.BorderSizePixel = 0
        card.ZIndex = 56
        card.Parent = settingsFrame

        local cardCorner = Instance.new("UICorner")
        cardCorner.CornerRadius = UDim.new(0, 8)
        cardCorner.Parent = card

        local label = Instance.new("TextLabel")
        label.Text = title
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 16
        label.Font = Enum.Font.GothamBold
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0.6, -20, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 57
        label.Parent = card

        if inputType == "textbox" then
            local input = Instance.new("TextBox")
            input.Text = defaultValue
            input.TextColor3 = Color3.fromRGB(255, 255, 255)
            input.TextSize = 15
            input.Font = Enum.Font.GothamBold
            input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            input.Size = UDim2.new(0.35, 0, 0, 32)
            input.Position = UDim2.new(0.63, 0, 0.5, -16)
            input.ZIndex = 57
            input.Parent = card

            local inputCorner = Instance.new("UICorner")
            inputCorner.CornerRadius = UDim.new(0, 6)
            inputCorner.Parent = input

            if callback then
                input.FocusLost:Connect(function()
                    callback(input.Text)
                end)
            end

            return input
        elseif inputType == "button" then
            local button = Instance.new("TextButton")
            button.Text = defaultValue
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 15
            button.Font = Enum.Font.GothamBold
            button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            button.Size = UDim2.new(0.35, 0, 0, 32)
            button.Position = UDim2.new(0.63, 0, 0.5, -16)
            button.ZIndex = 57
            button.AutoButtonColor = false
            button.Parent = card

            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 6)
            buttonCorner.Parent = button

            if callback then
                button.MouseButton1Click:Connect(callback)
            end

            return button
        end
    end

    -- Example settings
    inputs.openBindInput = createSettingCard("Open/Close UI", "textbox", "E", nil)
    inputs.profileBindInput = createSettingCard("Toggle Profile", "textbox", "P", nil)
    inputs.serverBindInput = createSettingCard("Toggle Server List", "textbox", "L", nil)
    inputs.flyBindInput = createSettingCard("Toggle Fly", "textbox", "F", nil)

    Settings.inputs = inputs
    Settings.frame = settingsFrame
end

function Settings.show()
    if Settings.frame then Settings.frame.Visible = true end
end

function Settings.hide()
    if Settings.frame then Settings.frame.Visible = false end
end

return Settings
