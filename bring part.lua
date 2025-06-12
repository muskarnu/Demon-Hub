-- Gui to Lua
-- Version: 3.2

-- Instances:

local Gui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Box = Instance.new("TextBox")
local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
local Label = Instance.new("TextLabel")
local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")
local Button = Instance.new("TextButton")
local UITextSizeConstraint_3 = Instance.new("UITextSizeConstraint")
local ToggleButton = Instance.new("ImageButton")

-- Properties:

Gui.Name = "Gui"
Gui.Parent = gethui()
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Main.Name = "Main"
Main.Parent = Gui
Main.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
Main.BorderColor3 = Color3.fromRGB(120, 0, 0)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.335, 0, 0.542, 0)
Main.Size = UDim2.new(0.240, 0, 0.167, 0)
Main.Active = true
Main.Draggable = true

Box.Name = "Box"
Box.Parent = Main
Box.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
Box.BorderSizePixel = 0
Box.Position = UDim2.new(0.098, 0, 0.219, 0)
Box.Size = UDim2.new(0.801, 0, 0.365, 0)
Box.Font = Enum.Font.SourceSansSemibold
Box.PlaceholderText = "Player here"
Box.Text = ""
Box.TextColor3 = Color3.fromRGB(255, 255, 255)
Box.TextScaled = true
Box.TextWrapped = true

UITextSizeConstraint.Parent = Box
UITextSizeConstraint.MaxTextSize = 31

Label.Name = "Label"
Label.Parent = Main
Label.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
Label.BorderSizePixel = 0
Label.Size = UDim2.new(1, 0, 0.161, 0)
Label.Font = Enum.Font.Nunito
Label.Text = "Sajwaad|المطورRami"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.TextScaled = true
Label.TextWrapped = true

UITextSizeConstraint_2.Parent = Label
UITextSizeConstraint_2.MaxTextSize = 21

Button.Name = "Button"
Button.Parent = Main
Button.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
Button.BorderSizePixel = 0
Button.Position = UDim2.new(0.183, 0, 0.657, 0)
Button.Size = UDim2.new(0.629, 0, 0.277, 0)
Button.Font = Enum.Font.Nunito
Button.Text = " مغناطيس| Off"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextScaled = true
Button.TextWrapped = true

UITextSizeConstraint_3.Parent = Button
UITextSizeConstraint_3.MaxTextSize = 28

-- Toggle Button
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = Gui
ToggleButton.BackgroundTransparency = 0.3
ToggleButton.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0.01, 0, 0.45, 0)
ToggleButton.Size = UDim2.new(0.05, 0, 0.09, 0)
ToggleButton.Image = "rbxassetid://107728948792167"
ToggleButton.Active = true
ToggleButton.Draggable = true

-- Scripts:

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local character
local humanoidRootPart
local player = nil
local blackHoleActive = false
local DescendantAddedConnection

local Folder = Instance.new("Folder", Workspace)
local Part = Instance.new("Part", Folder)
local Attachment1 = Instance.new("Attachment", Part)
Part.Anchored = true
Part.CanCollide = false
Part.Transparency = 1

if not getgenv().Network then
    getgenv().Network = {
        BaseParts = {},
        Velocity = Vector3.new(14.4626, 14.4626, 14.4626)
    }

    Network.RetainPart = function(Part)
        if Part:IsA("BasePart") and Part:IsDescendantOf(Workspace) then
            table.insert(Network.BaseParts, Part)
            Part.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
            Part.CanCollide = false
        end
    end

    RunService.Heartbeat:Connect(function()
        sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
        for _, Part in pairs(Network.BaseParts) do
            if Part:IsDescendantOf(Workspace) then
                Part.Velocity = Network.Velocity
            end
        end
    end)
end

local function ForcePart(v)
    if v:IsA("BasePart") and not v.Anchored and not v.Parent:FindFirstChildOfClass("Humanoid") and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then
        for _, x in ipairs(v:GetChildren()) do
            if x:IsA("BodyMover") or x:IsA("RocketPropulsion") then
                x:Destroy()
            end
        end
        if v:FindFirstChild("Attachment") then v:FindFirstChild("Attachment"):Destroy() end
        if v:FindFirstChild("AlignPosition") then v:FindFirstChild("AlignPosition"):Destroy() end
        if v:FindFirstChild("Torque") then v:FindFirstChild("Torque"):Destroy() end
        v.CanCollide = false
        local Torque = Instance.new("Torque", v)
        Torque.Torque = Vector3.new(100000, 100000, 100000)
        local AlignPosition = Instance.new("AlignPosition", v)
        local Attachment2 = Instance.new("Attachment", v)
        Torque.Attachment0 = Attachment2
        AlignPosition.MaxForce = math.huge
        AlignPosition.MaxVelocity = math.huge
        AlignPosition.Responsiveness = 200
        AlignPosition.Attachment0 = Attachment2
        AlignPosition.Attachment1 = Attachment1
    end
end

local function toggleBlackHole()
    blackHoleActive = not blackHoleActive
    if blackHoleActive then
        Button.Text = "مغناطيس | On"
        for _, v in ipairs(Workspace:GetDescendants()) do
            ForcePart(v)
        end
        DescendantAddedConnection = Workspace.DescendantAdded:Connect(function(v)
            if blackHoleActive then ForcePart(v) end
        end)
        spawn(function()
            while blackHoleActive and RunService.RenderStepped:Wait() do
                Attachment1.WorldCFrame = humanoidRootPart.CFrame
            end
        end)
    else
        Button.Text = "مغناطيس | Off"
        if DescendantAddedConnection then DescendantAddedConnection:Disconnect() end
    end
end

local function getPlayer(name)
    local lowerName = string.lower(name)
    for _, p in pairs(Players:GetPlayers()) do
        if string.find(string.lower(p.Name), lowerName) or string.find(string.lower(p.DisplayName), lowerName) then
            return p
        end
    end
end

Box.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        player = getPlayer(Box.Text)
        if player then
            Box.Text = player.Name
        end
    end
end)

Button.MouseButton1Click:Connect(function()
    if player then
        character = player.Character or player.CharacterAdded:Wait()
        humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        toggleBlackHole()
    end
end)

ToggleButton.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)
