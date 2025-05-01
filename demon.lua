local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "EV_GUI"
gui.ResetOnSpawn = false

-- الواجهة
local mainContainer = Instance.new("Frame")
mainContainer.Size = UDim2.new(1, 0, 1, 0)
mainContainer.Position = UDim2.new(-1, 0, 0, 0)
mainContainer.BackgroundTransparency = 1
mainContainer.Visible = false
mainContainer.Parent = gui

local sideMenu = Instance.new("Frame")
sideMenu.Size = UDim2.new(0, 200, 1, 0)
sideMenu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
sideMenu.BorderSizePixel = 2
sideMenu.BorderColor3 = Color3.fromRGB(255, 0, 0)
sideMenu.Parent = mainContainer

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -200, 1, 0)
contentFrame.Position = UDim2.new(0, 200, 0, 0)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainContainer

local contentBg = Instance.new("ImageLabel")
contentBg.Size = UDim2.new(1, 0, 1, 0)
contentBg.Image = "rbxassetid://127999374636975"
contentBg.BackgroundTransparency = 1
contentBg.ImageTransparency = 0.15
contentBg.ScaleType = Enum.ScaleType.Crop
contentBg.ZIndex = 0
contentBg.Parent = contentFrame

local sectionNames = {"القائمة الرئيسية", "اللاعب", "التخريب", "السكن", "السكربتات"}
local SectionFrames = {}

for i, name in ipairs(sectionNames) do
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -20, 0, 40)
	button.Position = UDim2.new(0, 10, 0, (i - 1) * 50 + 10)
	button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.SourceSansBold
	button.TextSize = 20
	button.Text = name
	button.Parent = sideMenu

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundTransparency = 1
	frame.Visible = false
	frame.Parent = contentFrame
	SectionFrames[name] = frame

	button.MouseButton1Click:Connect(function()
		for _, f in pairs(SectionFrames) do
			f.Visible = false
		end
		frame.Visible = true
	end)
end

SectionFrames["القائمة الرئيسية"].Visible = true

-- الحقوق فقط في القائمة الرئيسية
local TelegramIcon = Instance.new("ImageLabel")
TelegramIcon.Size = UDim2.new(0, 70, 0, 70)
TelegramIcon.Position = UDim2.new(0, 20, 0, 20)
TelegramIcon.Image = "rbxassetid://127999374636975"
TelegramIcon.BackgroundTransparency = 1
TelegramIcon.Parent = SectionFrames["القائمة الرئيسية"]

local TelegramLink = Instance.new("TextLabel")
TelegramLink.Size = UDim2.new(0, 400, 0, 40)
TelegramLink.Position = UDim2.new(0, 100, 0, 30)
TelegramLink.BackgroundTransparency = 1
TelegramLink.Text = "رابط التليجرام: @R_amI11"
TelegramLink.TextColor3 = Color3.fromRGB(0, 170, 255)
TelegramLink.Font = Enum.Font.SourceSansBold
TelegramLink.TextSize = 22
TelegramLink.TextXAlignment = Enum.TextXAlignment.Left
TelegramLink.Parent = SectionFrames["القائمة الرئيسية"]

local DevInfo = Instance.new("TextLabel")
DevInfo.Size = UDim2.new(0, 400, 0, 30)
DevInfo.Position = UDim2.new(0, 100, 0, 70)
DevInfo.BackgroundTransparency = 1
DevInfo.Text = "المطور: Ev_Rami | @Sajwaad"
DevInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
DevInfo.Font = Enum.Font.SourceSans
DevInfo.TextSize = 18
DevInfo.TextXAlignment = Enum.TextXAlignment.Left
DevInfo.Parent = SectionFrames["القائمة الرئيسية"]

-- قسم اللاعب: زر "طيران"
local FlyBtn = Instance.new("TextButton")
FlyBtn.Size = UDim2.new(0, 200, 0, 50)
FlyBtn.Position = UDim2.new(0, 20, 0, 20)
FlyBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
FlyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
FlyBtn.Font = Enum.Font.SourceSansBold
FlyBtn.TextSize = 18
FlyBtn.Text = "طيران"
FlyBtn.Parent = SectionFrames["اللاعب"]
FlyBtn.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/muskarnu/Demon-Hub/ded891eae3a34fdede62fee7161bb048fa803f93/Fly"))()
end)
-- قسم اللاعب: زر "النقل المستمر"
local playerSection = SectionFrames["اللاعب"]

local teleportBtn = Instance.new("TextButton")
teleportBtn.Size = UDim2.new(0, 200, 0, 50)
teleportBtn.Position = UDim2.new(0, 10, 0, 120)
teleportBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportBtn.Font = Enum.Font.SourceSansBold
teleportBtn.TextSize = 24
teleportBtn.Text = "مضاد جوي (OFF)"
teleportBtn.Parent = playerSection

local toggled = false
local running = false
local originalPosition = nil
local teleportDistance = 12^12 -- مسافة كبيرة

teleportBtn.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

    if humanoidRootPart then
        if not toggled then
            toggled = true
            running = true
            originalPosition = humanoidRootPart.CFrame

            teleportBtn.Text = "مضاد جوي (ON)"
            teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)

            task.spawn(function()
                while running do
                    humanoidRootPart.CFrame = originalPosition * CFrame.new(teleportDistance, 0, 0)
                    task.wait(0.01)
                    humanoidRootPart.CFrame = originalPosition
                    task.wait(0.01)
                end
            end)
        else
            toggled = false
            running = false

            if originalPosition then
                humanoidRootPart.CFrame = originalPosition
            end

            teleportBtn.Text = "النقل المستمر (OFF)"
            teleportBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
    end
end)
-- قسم اللاعب: زر "المضاد الأرضي"
local AntiGroundBtn = Instance.new("TextButton")
AntiGroundBtn.Size = UDim2.new(0, 200, 0, 50)
AntiGroundBtn.Position = UDim2.new(0, 10, 0, 190) -- أسفل زر النقل المستمر
AntiGroundBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 127)
AntiGroundBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiGroundBtn.Font = Enum.Font.SourceSansBold
AntiGroundBtn.TextSize = 18
AntiGroundBtn.Text = "المضاد الأرضي"
AntiGroundBtn.Parent = playerSection
AntiGroundBtn.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/muskarnu/Demon-Hub/44c52f1d3f259f70840a406b1476c25830bddb1b/AntiRami"))()
end)
-- قسم السكن: زر "نسخ الشخصية"
local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0, 200, 0, 50)
CopyBtn.Position = UDim2.new(0, 20, 0, 20)
CopyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.Font = Enum.Font.SourceSansBold
CopyBtn.TextSize = 18
CopyBtn.Text = "نسخ الشخصية"
CopyBtn.Parent = SectionFrames["السكن"]
CopyBtn.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Luarmor123/YHUB-Community/refs/heads/main/BrookhavenCopyAvatar.lua"))()
end)

-- قسم التخريب: زر "تفجير الأبواب"
local DoorBtn = Instance.new("TextButton")
DoorBtn.Size = UDim2.new(0, 200, 0, 50)
DoorBtn.Position = UDim2.new(0, 20, 0, 20)
DoorBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
DoorBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
DoorBtn.Font = Enum.Font.SourceSansBold
DoorBtn.TextSize = 18
DoorBtn.Text = "تفجير الأبواب"
DoorBtn.Parent = SectionFrames["التخريب"]
DoorBtn.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/muskarnu/Demon-Hub/5f9e7e91c008845aad2a3c0cf6e0b418da74e5d2/bring%20part.lua"))()
end)

-- قسم التخريب: زر "تحكم بلاق السيرفر"
local LagControlBtn = Instance.new("TextButton")
LagControlBtn.Size = UDim2.new(0, 200, 0, 50)
LagControlBtn.Position = UDim2.new(0, 20, 0, 80) -- تحته بمسافة
LagControlBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
LagControlBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
LagControlBtn.Font = Enum.Font.SourceSansBold
LagControlBtn.TextSize = 18
LagControlBtn.Text = "تحكم بلاق السيرفر"
LagControlBtn.Parent = SectionFrames["التخريب"]
LagControlBtn.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/muskarnu/Demon-Hub/6871e63c88cb35875240a4acfe065b0ab633004b/Ddos"))()
end)

-- قسم السكربتات: زر "تعزيز الفريمات"
local FPSBtn = Instance.new("TextButton")
FPSBtn.Size = UDim2.new(0, 200, 0, 50)
FPSBtn.Position = UDim2.new(0, 20, 0, 20)
FPSBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
FPSBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
FPSBtn.Font = Enum.Font.SourceSansBold
FPSBtn.TextSize = 18
FPSBtn.Text = "تعزيز الفريمات"
FPSBtn.Parent = SectionFrames["السكربتات"]
FPSBtn.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://pastebin.com/raw/YXhDJ7G4"))()
end)
-- قسم السكربتات: زر "فتح Dex Explorer"
local DexBtn = Instance.new("TextButton")
DexBtn.Size = UDim2.new(0, 200, 0, 50)
DexBtn.Position = UDim2.new(0, 20, 0, 90) -- تحته بمسافة عن زر الفريمات
DexBtn.BackgroundColor3 = Color3.fromRGB(170, 85, 255)
DexBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DexBtn.Font = Enum.Font.SourceSansBold
DexBtn.TextSize = 18
DexBtn.Text = "ملفات السيرفر"
DexBtn.Parent = SectionFrames["السكربتات"]
DexBtn.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/peyton2465/Dex/master/out.lua"))()
end)
-- زر التبديل
local toggleButton = Instance.new("ImageButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(0, 20, 0.5, -20)
toggleButton.Image = "rbxassetid://127852236522608"
toggleButton.BackgroundTransparency = 1
toggleButton.ZIndex = 999999
toggleButton.Parent = gui

-- سحب الزر بحرية
local dragging = false
local dragStart, startPos

toggleButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = toggleButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		toggleButton.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
	end
end)

-- فتح/اغلاق الواجهة
local open = false
local openTween = TweenService:Create(mainContainer, TweenInfo.new(0.4), {Position = UDim2.new(0, 0, 0, 0)})
local closeTween = TweenService:Create(mainContainer, TweenInfo.new(0.4), {Position = UDim2.new(-1, 0, 0, 0)})

toggleButton.MouseButton1Click:Connect(function()
	open = not open
	if open then
		mainContainer.Visible = true
		openTween:Play()
	else
		closeTween:Play()
		closeTween.Completed:Wait()
		mainContainer.Visible = false
	end
end)
