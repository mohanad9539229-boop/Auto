-- [[ SLAXTB - Official Script ]]
-- [[ المطور: SLAX | قناة: Ezz.i1 ]]

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- إنشاء الواجهة (نفس إعداداتك الأصلية)
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

-- [ قسم الانترو الفخم ]
local introFrame = Instance.new("Frame", gui)
introFrame.Size = UDim2.new(1, 0, 1, 0)
introFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
introFrame.ZIndex = 200

local titleLabel = Instance.new("TextLabel", introFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 90)
titleLabel.Position = UDim2.new(0, 0, 0.5, -70)
titleLabel.Text = "SLAXTB" -- الاسم الجديد
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.BackgroundTransparency = 1
titleLabel.ZIndex = 206

-- [ واجهة التحكم العائمة ]
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 140, 0, 70)
frame.Position = UDim2.new(0.02, 0, 0.02, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 17, 26)
frame.BackgroundTransparency = 1
frame.Visible = false
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(1, -10, 1, -10)
button.Position = UDim2.new(0, 5, 0, 5)
button.BackgroundColor3 = Color3.fromRGB(160, 25, 45)
button.Text = "OFF"
button.TextColor3 = Color3.fromRGB(255, 120, 140)
button.TextScaled = true
button.Font = Enum.Font.GothamBold
button.BackgroundTransparency = 1
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)

-- [ محرك الهجوم واللحاق ]
local enabled = false
local currentTarget = nil

button.MouseButton1Click:Connect(function()
    enabled = not enabled
    button.Text = enabled and "ON" or "OFF"
    button.BackgroundColor3 = enabled and Color3.fromRGB(20, 140, 70) or Color3.fromRGB(160, 25, 45)
end)

-- وظيفة البحث عن الأهداف (تحديث كل 0.1 ثانية)
task.spawn(function()
    while true do
        task.wait(0.1)
        if not enabled then currentTarget = nil continue end
        
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        
        local bestTarget = nil
        local bestDist = math.huge

        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local tHum = v.Character:FindFirstChild("Humanoid")
                if tHum and tHum.Health > 0 then
                    local d = (root.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if d < bestDist then
                        bestDist = d
                        bestTarget = v
                    end
                end
            end
        end
        currentTarget = bestTarget
    end
end)

-- محرك الحركة الفعلي (RenderStepped لضمان السلاسة)
RunService.RenderStepped:Connect(function()
    if not enabled or not currentTarget or not currentTarget.Character then return end
    
    local char = player.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local tRoot = currentTarget.Character:FindFirstChild("HumanoidRootPart")
    
    if hum and root and tRoot then
        hum:MoveTo(tRoot.Position)
        -- إذا كنت قريب جداً، فعل الأداة (تلقائي)
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and (root.Position - tRoot.Position).Magnitude < 10 then
            tool:Activate()
        end
    end
end)

-- [ تشغيل الانترو المختصر ]
task.spawn(function()
    task.wait(2)
    TweenService:Create(introFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
    TweenService:Create(titleLabel, TweenInfo.new(1), {TextTransparency = 1}):Play()
    task.wait(1)
    introFrame:Destroy()
    frame.Visible = true
    TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    TweenService:Create(button, TweenInfo.new(0.5), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
end)

warn("SLAXTB: Original Logic Loaded Successfully!")
