
local Utils = {}

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

function Utils.getServices()
    return {
        Players = Players,
        HttpService = HttpService,
        TweenService = TweenService
    }
end

function Utils.getLocalPlayer()
    return Players.LocalPlayer
end

function Utils.createScreenGui(name, parent)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = name or "IcarusHubGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = parent
    return screenGui
end

function Utils.tweenObject(obj, props, duration, style, direction)
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    local info = TweenInfo.new(duration or 0.3, style, direction)
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

return Utils
