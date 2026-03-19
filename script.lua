-- [[ SLAX HUB - Project TBT2 ]]
-- [[ المطور الرسمي: سلاكس | قناة: Ezz.i1 ]]

local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- إنشاء الواجهة الأساسية
local gui = Instance.new("ScreenGui")
gui.Name = "SLAX_MODERN_TBT2"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

-- [[ 1. تصميم الكارت الرئيسي ]]
local MainFrame = Instance.new("Frame", gui)
MainFrame.Size = UDim2.new(0, 240, 0, 160)
MainFrame.Position = UDim2.new(0.5, -120, 0.4, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35) -- لون ليلي عميق
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Draggable = true
MainFrame.Active = true

-- زوايا منحنية
local Corner = Instance.new("UICorner", MainFrame)
Corner.CornerRadius = UDim.new(0, 12)

-- خط النيون العلوي
local NeonLine = Instance.new("Frame", MainFrame)
NeonLine.Size = UDim2.new(1, 0, 0, 3)
NeonLine.BackgroundColor3 = Color3.fromRGB(255, 50, 75) -- لون النيون الخاص بك
NeonLine.BorderSizePixel = 0

-- العنوان
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Text = "SLAX HUB - TBT2"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

-- زر التفعيل (بتصميم نيون)
local ActionBtn = Instance.new("TextButton", MainFrame)
ActionBtn.Size = UDim2.new(0, 180, 0, 45)
ActionBtn.Position = UDim2.new(0.5, -90, 0, 60)
ActionBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
ActionBtn.Text = "إيقاف 🔴"
ActionBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
ActionBtn.Font = Enum.Font.GothamBold
ActionBtn.TextSize = 16
ActionBtn.BorderSizePixel = 0

local BtnCorner = Instance.new("UICorner", ActionBtn)
BtnCorner.CornerRadius = UDim.new(0, 8)

local BtnStroke = Instance.new("UIStroke", ActionBtn)
BtnStroke.Thickness = 2
BtnStroke.Color = Color3.fromRGB(255, 50, 75)
BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- حقوق المطور
local Credits = Instance.new("TextLabel", MainFrame)
Credits.Size = UDim2.new(1, 0, 0, 30)
Credits.Position = UDim2.new(0, 0, 1, -30)
Credits.Text = "Slax | Ezz.i1"
Credits.TextColor3 = Color3.fromRGB(100, 100, 110)
Credits.Font = Enum.Font.Gotham
Credits.TextSize = 12
Credits.BackgroundTransparency = 1

-- [[ 2. زر صورتك الشخصية (العلامة التجارية) ]]
local SlaxBtn = Instance.new("ImageButton", gui)
SlaxBtn.Size = UDim2.new(0, 60, 0, 60)
SlaxBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
SlaxBtn.Image = "rbxassetid://124253717157226" -- صورتك
SlaxBtn.BackgroundTransparency = 1
SlaxBtn.Draggable = true

local SlaxCorner = Instance.new("UICorner", SlaxBtn)
SlaxCorner.CornerRadius = UDim.new(1, 0)

-- [[ 3. المنطق البرمجي (الهجوم التلقائي) ]]
local enabled = false

local function toggle()
    enabled = not enabled
    if enabled then
        ActionBtn.Text = "تشغيل 🟢"
        ActionBtn.TextColor3 = Color3.fromRGB(100, 255, 150)
        BtnStroke.Color = Color3.fromRGB(100, 255, 150)
    else
        ActionBtn.Text = "إيقاف 🔴"
        ActionBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        BtnStroke.Color = Color3.fromRGB(255, 50, 75)
    end
end

ActionBtn.MouseButton1Click:Connect(toggle)

SlaxBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    -- إضافة تأثير حركة بسيط عند الفتح
    if MainFrame.Visible then
        MainFrame:TweenSize(UDim2.new(0, 240, 0, 160), "Out", "Back", 0.3, true)
    end
end)

-- محرك الهجوم (نفس الكود اللي أرسلته أنت)
task.spawn(function()
    while true do
        task.wait(0.1)
        if not enabled then continue end
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            -- ابحث عن أقرب لاعب وهات الأداة
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") then
                    if v.Character.Humanoid.Health > 0 then
                        char.Humanoid:MoveTo(v.Character.HumanoidRootPart.Position)
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then tool:Activate() end
                    end
                end
            end
        end
    end
end)

print("SLAX HUB: Modern TBT2 UI Loaded!")
