91
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ========== UI 创建 ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OmegaUI"
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 600)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 22, 30)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- 圆角 + 玻璃效果
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 18)
corner.Parent = mainFrame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 45, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 25, 38))
})
gradient.Parent = mainFrame

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(60, 70, 200)
titleBar.BackgroundTransparency = 0.3
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ OMEGA SYSTEM v4.0"
titleLabel.TextColor3 = Color3.new(1,1,1)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

-- 关闭按钮
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -50, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.TextScaled = true
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() screenGui.Enabled = false end)

-- 标签页按钮 (水平)
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 45)
tabBar.Position = UDim2.new(0, 0, 0, 50)
tabBar.BackgroundTransparency = 1
tabBar.Parent = mainFrame

local tabs = {"战斗", "建造", "传送", "经济", "管理"}
local tabBtns = {}
for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.2, 0, 1, 0)
    btn.Position = UDim2.new((i-1)*0.2, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
    btn.BackgroundTransparency = 0.6
    btn.Text = name
    btn.TextColor3 = Color3.new(0.8,0.8,0.9)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamMedium
    btn.BorderSizePixel = 0
    btn.Parent = tabBar
    tabBtns[i] = btn
end

-- 内容容器 (滚动)
local contentScroller = Instance.new("ScrollingFrame")
contentScroller.Size = UDim2.new(1, 0, 1, -95)
contentScroller.Position = UDim2.new(0, 0, 0, 95)
contentScroller.BackgroundTransparency = 1
contentScroller.CanvasSize = UDim2.new(0, 0, 0, 800)
contentScroller.ScrollBarThickness = 6
contentScroller.ScrollBarImageColor3 = Color3.fromRGB(80, 90, 200)
contentScroller.Parent = mainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 12)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = contentScroller

-- ========== 功能模块 ==========
local function createModule(title, desc, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -24, 0, 70)
    frame.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = contentScroller
    Instance.new("UICorner").CornerRadius = UDim.new(0, 10).Parent = frame

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 0.5, 0)
    lbl.Position = UDim2.new(0.02, 0, 0.1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextScaled = true
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.GothamSemibold
    lbl.Parent = frame

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(0.6, 0, 0.3, 0)
    sub.Position = UDim2.new(0.02, 0, 0.55, 0)
    sub.BackgroundTransparency = 1
    sub.Text = desc
    sub.TextColor3 = Color3.fromRGB(160,170,190)
    sub.TextScaled = true
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Font = Enum.Font.Gotham
    sub.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, 0, 0.6, 0)
    btn.Position = UDim2.new(0.72, 0, 0.2, 0)
    btn.BackgroundColor3 = Color3.fromRGB(70, 120, 250)
    btn.Text = "执行"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    Instance.new("UICorner").CornerRadius = UDim.new(0, 8).Parent = btn
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
end

-- 填充