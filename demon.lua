local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FXZ_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(1, 0, 1, 0)
MainContainer.Position = UDim2.new(-1, 0, 0, 0)
MainContainer.BackgroundTransparency = 1
MainContainer.Visible = false
MainContainer.Parent = ScreenGui

local ToggleButton = Instance.new("ImageButton")
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0.5, -20)
ToggleButton.Image = "rbxassetid://127852236522608"
ToggleButton.BackgroundTransparency = 1
ToggleButton.ZIndex = 10
ToggleButton.Parent = ScreenGui

local dragging, dragInput, dragStart, startPos

local function updateInput(input)
	if not dragging then return end
	local delta = input.Position - dragStart
	ToggleButton.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
end

ToggleButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = ToggleButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

ToggleButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput then
		updateInput(input)
	end
end)

local SideMenu = Instance.new("Frame")
SideMenu.Size = UDim2.new(0, 200, 1, 0)
SideMenu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SideMenu.BorderSizePixel = 2
SideMenu.BorderColor3 = Color3.fromRGB(255, 0, 0)
SideMenu.Parent = MainContainer

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -200, 1, 0)
ContentFrame.Position = UDim2.new(0, 200, 0, 0)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainContainer

local ContentBackground = Instance.new("ImageLabel")
ContentBackground.Size = UDim2.new(1, 0, 1, 0)
ContentBackground.Image = "rbxassetid://127999374636975"
ContentBackground.BackgroundTransparency = 1
ContentBackground.ImageTransparency = 0.15
ContentBackground.ScaleType = Enum.ScaleType.Crop
ContentBackground.ZIndex = 0
ContentBackground.Parent = ContentFrame

local MainSection = Instance.new("Frame")
MainSection.Size = UDim2.new(1, 0, 1, 0)
MainSection.BackgroundTransparency = 1
MainSection.ZIndex = 1
MainSection.Parent = ContentFrame

local TelegramIcon = Instance.new("ImageLabel")
TelegramIcon.Size = UDim2.new(0, 70, 0, 70)
TelegramIcon.Position = UDim2.new(0, 20, 0, 20)
TelegramIcon.Image = "rbxassetid://127999374636975"
TelegramIcon.BackgroundTransparency = 1
TelegramIcon.Parent = MainSection

local TelegramLink = Instance.new("TextLabel")
TelegramLink.Size = UDim2.new(0, 400, 0, 40)
TelegramLink.Position = UDim2.new(0, 100, 0, 30)
TelegramLink.BackgroundTransparency = 1
TelegramLink.Text = "رابط التليجرام: https://t.me/R_amI11"
TelegramLink.TextColor3 = Color3.fromRGB(0, 170, 255)
TelegramLink.Font = Enum.Font.SourceSansBold
TelegramLink.TextSize = 22
TelegramLink.TextXAlignment = Enum.TextXAlignment.Left
TelegramLink.Parent = MainSection

local DevInfo = Instance.new("TextLabel")
DevInfo.Size = UDim2.new(0, 400, 0, 30)
DevInfo.Position = UDim2.new(0, 100, 0, 70)
DevInfo.BackgroundTransparency = 1
DevInfo.Text = "المطور: FXZ_Rami | @Sajwaad"
DevInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
DevInfo.Font = Enum.Font.SourceSans
DevInfo.TextSize = 18
DevInfo.TextXAlignment = Enum.TextXAlignment.Left
DevInfo.Parent = MainSection

local Sections = {}
local SectionFrames = {}
local sectionNames = {"القائمة الرئيسية", "اللاعب", "التخريب", "السكن", "السكربتات"}

for i, name in ipairs(sectionNames) do
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -20, 0, 40)
	button.Position = UDim2.new(0, 10, 0, (i - 1) * 50 + 10)
	button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.SourceSansBold
	button.TextSize = 20
	button.Text = name
	button.Parent = SideMenu

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundTransparency = 1
	frame.Visible = false
	frame.Parent = ContentFrame
	SectionFrames[name] = frame

	button.MouseButton1Click:Connect(function()
		for _, f in pairs(SectionFrames) do
			f.Visible = false
		end
		frame.Visible = true
	end)
end

SectionFrames["القائمة الرئيسية"].Visible = true
MainSection.Visible = true

local function createScriptButton(parent, name, color, scriptFunc)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 200, 0, 50)
	button.Position = UDim2.new(0, 20, 0, #parent:GetChildren() * 60)
	button.BackgroundColor3 = color
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.SourceSansBold
	button.TextSize = 18
	button.Text = name
	button.Parent = parent

	button.MouseButton1Click:Connect(scriptFunc)
end

createScriptButton(SectionFrames["التخريب"], "تطشير الأبواب", Color3.fromRGB(0, 170, 255), function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/muskarnu/Demon-Hub/5f9e7e91c008845aad2a3c0cf6e0b418da74e5d2/bring%20part.lua"))()
end)

createScriptButton(SectionFrames["السكربتات"], "تعزيز الفريمات", Color3.fromRGB(100, 200, 255), function()
	loadstring(game:HttpGet("https://pastebin.com/raw/YXhDJ7G4"))()
end)

local open = false
local openTween = TweenService:Create(MainContainer, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})
local closeTween = TweenService:Create(MainContainer, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(-1, 0, 0, 0)})

ToggleButton.MouseButton1Click:Connect(function()
	open = not open
	if open then
		MainContainer.Visible = true
		openTween:Play()
	else
		closeTween:Play()
		closeTween.Completed:Wait()
		MainContainer.Visible = false
	end
end)
