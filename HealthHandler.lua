local plr = game:GetService("Players").LocalPlayer
local plrGui = plr.PlayerGui
local char = plr.Character or plr.CharacterAdded:Wait()
local Humanoid = char:WaitForChild("Humanoid")
local StatFrame = plr.PlayerGui:WaitForChild("stats").Frame

StatFrame.HealthText.Text = math.floor(Humanoid.Health).."/"..math.floor(Humanoid.MaxHealth)

Humanoid.HealthChanged:Connect(function()
	local color1 = Color3.fromRGB(26, 255, 0);
	local color2 = Color3.fromRGB(100,7,7);

	StatFrame.HealthText.Text = math.floor(Humanoid.Health).."/"..math.floor(Humanoid.MaxHealth)

	if char:WaitForChild("PlayerStuff").Values.Downed.Value == true then
		plr.PlayerGui:WaitForChild("Stats").Frame.heart.ImageColor3 = color2
		StatFrame.HealthText.Text = "DOWNED"
	else
		local newColor = color2:Lerp(color1, Humanoid.Health/Humanoid.MaxHealth);

		StatFrame.heart.ImageColor3 = newColor
	end
end)