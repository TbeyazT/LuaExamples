local DecalToSpam = "http://www.roblox.com/asset/?id=10544517975"
local Workspace = game:GetService("Workspace")
local Options = {"Front", "Back", "Bottom", "Left", "Right", "Top"}


for _, Part in pairs(Workspace:GetDescendants()) do
	if Part:IsA("BasePart") and Part.Name ~= "Terrain" and Part.Name ~= "Camera" then
		for i = 1, #Options do
			local NewDecal = Instance.new("Decal")
			NewDecal.Texture = DecalToSpam
			NewDecal.ZIndex = 10
			NewDecal.Face = Options[i]
			NewDecal.Parent = Part
		end
	end
end