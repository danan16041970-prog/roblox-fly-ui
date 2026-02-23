local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local espEnabled = false
local espObjects = {}

local function createESP(character)
	if not character:FindFirstChild("HumanoidRootPart") then return end
	
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "DevESP"
	billboard.Size = UDim2.new(0,120,0,40)
	billboard.Adornee = character.HumanoidRootPart
	billboard.AlwaysOnTop = true
	billboard.StudsOffset = Vector3.new(0,3,0)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,0,1,0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255,0,0)
	label.TextStrokeTransparency = 0
	label.TextScaled = true
	label.Text = character.Name
	label.Parent = billboard

	billboard.Parent = player:WaitForChild("PlayerGui")
	table.insert(espObjects, billboard)
end

local function clearESP()
	for _, v in pairs(espObjects) do
		if v then v:Destroy() end
	end
	espObjects = {}
end

local function enableESP()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character then
			createESP(plr.Character)
		end
	end
end

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.E then
		espEnabled = not espEnabled
		
		if espEnabled then
			enableESP()
		else
			clearESP()
		end
	end
end)

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		if espEnabled then
			createESP(char)
		end
	end)
end)
