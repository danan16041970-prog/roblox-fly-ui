-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- =================
-- ScreenGui
-- =================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyMenuGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- =================
-- Frame utama (dragable)
-- =================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.25,0,0.2,0)
mainFrame.Position = UDim2.new(0.37,0,0.4,0)
mainFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- =================
-- Judul
-- =================
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0.3,0)
title.Position = UDim2.new(0,0,0,0)
title.Text = "Fly Menu"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.BackgroundTransparency = 1
title.Parent = mainFrame

-- =================
-- Fungsi buat tombol
-- =================
local function createButton(parent, text, size, position, color, callback)
    local button = Instance.new("TextButton")
    button.Size = size
    button.Position = position
    button.Text = text
    button.TextScaled = true
    button.BackgroundColor3 = color
    button.Parent = parent
    button.MouseButton1Click:Connect(callback)
    return button
end

-- =================
-- Fly Toggle
-- =================
local flying = false
local flySpeed = 50
local flyButton

flyButton = createButton(mainFrame, "Fly: OFF", UDim2.new(0.8,0,0.4,0), UDim2.new(0.1,0,0.35,0), Color3.fromRGB(0,255,128), function()
    flying = not flying
    if flying then
        flyButton.Text = "Fly: ON"
    else
        flyButton.Text = "Fly: OFF"
    end
end)

-- =================
-- Dragable Function
-- =================
local dragging = false
local dragInput, mousePos, framePos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        mainFrame.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)

-- =================
-- Fly Control
-- =================
local function flyControl()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end

    local bodyVelocity = hrp:FindFirstChild("FlyVelocity")
    if flying and not bodyVelocity then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Name = "FlyVelocity"
        bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.Parent = hrp
    elseif not flying and bodyVelocity then
        bodyVelocity:Destroy()
    end
end

-- =================
-- Update Fly
-- =================
RunService.RenderStepped:Connect(function()
    if flying then
        flyControl()
        local char = player.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local direction = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + hrp.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - hrp.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - hrp.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + hrp.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0,1,0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                direction = direction - Vector3.new(0,1,0)
            end
            local bodyVelocity = hrp:FindFirstChild("FlyVelocity")
            if bodyVelocity and direction.Magnitude > 0 then
                bodyVelocity.Velocity = direction.Unit * flySpeed
            elseif bodyVelocity then
                bodyVelocity.Velocity = Vector3.new(0,0,0)
            end
        end
    end
end)
