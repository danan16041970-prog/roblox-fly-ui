-- LocalScript di StarterPlayerScripts
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

local function drawESP(target)
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,100,0,50)
    billboard.Adornee = target
    billboard.AlwaysOnTop = true

    local label = Instance.new("TextLabel")
    label.Text = target.Name
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,0,0)
    label.Parent = billboard

    billboard.Parent = player:WaitForChild("PlayerGui")
end

-- Contoh pakai untuk semua NPC di map
for _, npc in pairs(workspace.NPCs:GetChildren()) do
    if npc:FindFirstChild("HumanoidRootPart") then
        drawESP(npc.HumanoidRootPart)
    end
end
