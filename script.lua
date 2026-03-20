-- [[ SLAXTB - Ultra Luxury Fixed ]]
-- [[ تم إصلاح تعليق الشاشة السوداء ]]

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "SLAXTB_ULTRA"
gui.ResetOnSpawn = false

-- إطار الانميشن
local introFrame = Instance.new("Frame", gui)
introFrame.Size = UDim2.new(1, 0, 1, 0)
introFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
introFrame.ZIndex = 100
introFrame.BackgroundTransparency = 0 -- يبدأ أسود بالكامل

local logo = Instance.new("TextLabel", introFrame)
logo.Size = UDim2.new(1, 0, 0, 120)
logo.Position = UDim2.new(0, 0, 0.45, 0)
logo.Text = "SLAXTB"
logo.Font = Enum.Font.SpecialElite
logo.TextColor3 = Color3.fromRGB(255, 40, 70)
logo.TextScaled = true
logo.BackgroundTransparency = 1
logo.TextTransparency = 1

-- واجهة التحكم (تكون مخفية في البداية)
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 160, 0, 60)
mainFrame.Position = UDim2.new(0.05, 0, -0.2, 0) -- مكانها فوق الشاشة عشان تنزل بانميشن
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.Visible = false
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 15)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Thickness = 2
mainStroke.Color = Color3.fromRGB(255, 40, 70)

local toggleBtn = Instance.new("TextButton", mainFrame)
toggleBtn.Size = UDim2.new(1, -10, 1, -10)
toggleBtn.Position = UDim2.new(0, 5, 0, 5)
toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
toggleBtn.Text = "SLAX: OFF"
toggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 18
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 12)

-- [ وظيفة الهجوم ]
local active = false
toggleBtn.MouseButton1Click:Connect(function()
    active = not active
    toggleBtn.Text = active and "SLAX: ON" or "SLAX: OFF"
    TweenService:Create(toggleBtn, TweenInfo.new(0.3), {BackgroundColor3 = active and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(150, 30, 50)}):Play()
    mainStroke.Color = active and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 40, 70)
end)

-- [ تشغيل الانميشن مع حماية من التعليق ]
task.spawn(function()
    -- ظهور الشعار
    TweenService:Create(logo, TweenInfo.new(1), {TextTransparency = 0}):Play()
    task.wait(2)
    
    -- اختفاء الشاشة السوداء غصب عنها (Safe Exit)
    local fadeOut = TweenService:Create(introFrame, TweenInfo.new(1), {BackgroundTransparency = 1})
    local textFade = TweenService:Create(logo, TweenInfo.new(1), {TextTransparency = 1})
    
    fadeOut:Play()
    textFade:Play()
    
    fadeOut.Completed:Connect(function()
        introFrame:Destroy() -- حذف الشاشة السوداء نهائياً
        mainFrame.Visible = true
        mainFrame:TweenPosition(UDim2.new(0.05, 0, 0.1, 0), "Out", "Back", 0.6)
    end)
end)

-- نظام اللحاق والهجوم (القنبلة)
RunService.Heartbeat:Connect(function()
    if active and player.Character and player.Character:FindFirstChildOfClass("Tool") then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local target = nil
            local dist = 500
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (root.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then dist = d target = v end
                end
            end
            if target then
                player.Character.Humanoid:MoveTo(target.Character.HumanoidRootPart.Position)
                if (root.Position - target.Character.HumanoidRootPart.Position).Magnitude < 15 then
                    player.Character:FindFirstChildOfClass("Tool"):Activate()
                end
            end
        end
    end
end)

-- نظام السحب (Drag)
local dragging, dragStart, startPos
toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = mainFrame.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input) dragging = false end)
