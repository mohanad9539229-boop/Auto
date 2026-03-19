-- [[ SLAXTBT2 - Project ]]
-- [[ المطور: SLAX | قناة: Ezz.i1 ]]

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- إنشاء الواجهة
local gui = Instance.new("ScreenGui")
gui.Name = "SLAXTBT2_OFFICIAL"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

-- [[ تصميم الواجهة الجديد ]]
local MainFrame = Instance.new("Frame", gui)
MainFrame.Size = UDim2.new(0, 220, 0, 140)
MainFrame.Position = UDim2.new(0.5, -110, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true
MainFrame.Active = true

local Corner = Instance.new("UICorner", MainFrame)
Corner.CornerRadius = UDim.new(0, 15)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(255, 50, 75) -- لون أحمر نيون

-- العنوان
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "SLAXTBT2"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1

-- زر التشغيل
local ActionBtn = Instance.new("TextButton", MainFrame)
ActionBtn.Size = UDim2.new(0, 160, 0, 45)
ActionBtn.Position = UDim2.new(0.5, -80, 0, 50)
ActionBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ActionBtn.Text = "OFF"
ActionBtn.TextColor3 = Color3.fromRGB(255, 50, 75)
ActionBtn.Font = Enum.Font.GothamBold
ActionBtn.TextSize = 18
Instance.new("UICorner", ActionBtn)

local BtnStroke = Instance.new("UIStroke", ActionBtn)
BtnStroke.Thickness = 1
BtnStroke.Color = Color3.fromRGB(255, 50, 75)

-- زر الصورة الشخصية (العلامة التجارية)
local SlaxBtn = Instance.new("ImageButton", gui)
SlaxBtn.Size = UDim2.new(0, 60, 0, 60)
SlaxBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
SlaxBtn.Image = "rbxassetid://124253717157226" -- صورتك
SlaxBtn.BackgroundTransparency = 1
SlaxBtn.Draggable = true
Instance.new("UICorner", SlaxBtn).CornerRadius = UDim.new(1, 0)

-- [[ منطق التشغيل واللحاق باللاعبين ]]
local enabled = false

local function toggle()
    enabled = not enabled
    if enabled then
        ActionBtn.Text = "ON"
        ActionBtn.TextColor3 = Color3.fromRGB(50, 255, 100)
        BtnStroke.Color = Color3.fromRGB(50, 255, 100)
    else
        ActionBtn.Text = "OFF"
        ActionBtn.TextColor3 = Color3.fromRGB(255, 50, 75)
        BtnStroke.Color = Color3.fromRGB(255, 50, 75)
    end
end

ActionBtn.MouseButton1Click:Connect(toggle)
SlaxBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- محرك اللحاق والهجوم (تم إصلاح الكود المقطوع)
RunService.RenderStepped:Connect(function()
    if not enabled then return end
    
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum then return end
    
    local tool = char:FindFirstChildOfClass("Tool")
    
    -- البحث عن أقرب هدف
    local bestTarget = nil
    local bestDist = 500

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local tRoot = v.Character.HumanoidRootPart
            local tHum = v.Character:FindFirstChild("Humanoid")
            if tHum and tHum.Health > 0 then
                local dist = (root.Position - tRoot.Position).Magnitude
                if dist < bestDist then
                    bestDist = dist
                    bestTarget = v
                end
            end
        end
    end

    -- الهجوم
    if bestTarget and bestTarget.Character then
        local targetRoot = bestTarget.Character.HumanoidRootPart
        hum:MoveTo(targetRoot.Position)
        if tool then
            tool:Activate() -- هجوم تلقائي
        end
    end
end)

warn("SLAXTBT2: Loaded Successfully!")
