-- [[ SLAXTB - Project ]]
-- [[ المطور: SLAX | قناة: Ezz.i1 ]]

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- التأكد من وجود الشخصية
local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

-- إنشاء الواجهة
local gui = Instance.new("ScreenGui")
gui.Name = "SLAXTB_OFFICIAL"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

-- [[ تصميم الواجهة ]]
local MainFrame = Instance.new("Frame", gui)
MainFrame.Size = UDim2.new(0, 200, 0, 130)
MainFrame.Position = UDim2.new(0.5, -100, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local Corner = Instance.new("UICorner", MainFrame)
Corner.CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(255, 40, 70) -- أحمر نيون

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "SLAXTB"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.BackgroundTransparency = 1

local ActionBtn = Instance.new("TextButton", MainFrame)
ActionBtn.Size = UDim2.new(0, 150, 0, 40)
ActionBtn.Position = UDim2.new(0.5, -75, 0, 55)
ActionBtn.BackgroundColor3 = Color3.fromRGB(255, 40, 70)
ActionBtn.Text = "OFF"
ActionBtn.TextColor3 = Color3.new(1, 1, 1)
ActionBtn.Font = Enum.Font.GothamBold
ActionBtn.TextSize = 18
Instance.new("UICorner", ActionBtn)

-- زر الصورة (سلاكس)
local SlaxBtn = Instance.new("ImageButton", gui)
SlaxBtn.Size = UDim2.new(0, 60, 0, 60)
SlaxBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
SlaxBtn.Image = "rbxassetid://124253717157226" 
SlaxBtn.BackgroundTransparency = 1
SlaxBtn.Draggable = true
Instance.new("UICorner", SlaxBtn).CornerRadius = UDim.new(1, 0)

-- [[ ميكانيكية السكربت - الهجوم واللحاق ]]
local enabled = false

ActionBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    ActionBtn.Text = enabled and "ON" or "OFF"
    ActionBtn.BackgroundColor3 = enabled and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(255, 40, 70)
end)

SlaxBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- محرك العمل المستمر
RunService.Stepped:Connect(function()
    if not enabled then return end
    
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local root = char.HumanoidRootPart
    local hum = char.Humanoid
    local tool = char:FindFirstChildOfClass("Tool")
    
    local target = nil
    local dist = 1000 -- مدى البحث

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local tHum = v.Character:FindFirstChild("Humanoid")
            if tHum and tHum.Health > 0 then
                local d = (root.Position - v.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    dist = d
                    target = v.Character.HumanoidRootPart
                end
            end
        end
    end

    if target then
        -- اللحاق بالهدف
        hum:MoveTo(target.Position)
        
        -- تفعيل الأداة (الهجوم) إذا كان قريب
        if dist < 10 and tool then
            tool:Activate()
        end
    end
end)

warn("SLAXTB: Script is Active and Ready!")
