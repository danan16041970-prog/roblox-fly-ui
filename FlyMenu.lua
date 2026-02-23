local player = game.Players.LocalPlayer
local noclip = false

game:GetService("UserInputService").InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.N then
		noclip = not noclip
		
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = not noclip
			end
		end
	end
end)
