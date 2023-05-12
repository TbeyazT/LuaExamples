local Blood = {}

local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Resource = ReplicatedStorage:WaitForChild("Resources")

local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")

local Debris_Folder = workspace:WaitForChild("Debris")

local Ignore = {Debris_Folder, script.Parent.Parent}

function Cast(Origin, Direction)
	local Rays = Ray.new(Origin, Direction)
	Hit, RayPosition, Normal = workspace:FindPartOnRayWithIgnoreList(Rays, Ignore, false, true)

	if Hit ~= nil then
		if Hit:FindFirstAncestorWhichIsA("Model"):FindFirstChild("Humanoid") then
			table.insert(Ignore, Hit)
			return Cast(Origin, Direction)
		else
			return Hit, RayPosition, Normal
		end
	end
end

function Blood:Create(Torso)
	spawn(function()
		local Force = Vector3.new(0, 0, 0)
		local Set_Position = (Torso.CFrame * CFrame.new(0, 0, 0)).p
		local Drop = Resource:WaitForChild("Drop"):Clone()
		Drop.CFrame = Torso.CFrame * CFrame.new(math.random(-15, 15)/10, 1, math.random(-15, 15)/10)
		local X, Y, Z = math.random(20, 30)/10, math.random(30, 50)/10, math.random(20, 30)/10
		local _X, _Z = math.random(-30, -20)/6, math.random(-30, -20)/10
		Force = Vector3.new(math.random(_X, X), Y, math.random(_Z, Z))
		Drop.Velocity = Force * 9
		Drop.Parent = Debris_Folder
		Drop:SetNetworkOwner(nil)
		spawn(function()
			repeat wait()
				Cast(Drop.Position, Vector3.new(10/150, 10/150, 10/150))
				Cast(Drop.Position, Vector3.new(-10/150, -10/150, -10/150))

				if Hit then
					local Radious = math.random(math.random(7, 25))/5
					local Blood_Ground = Resource:FindFirstChild("Blood"):Clone()
					Blood_Ground.CFrame = (CFrame.new(RayPosition, RayPosition - Normal) * CFrame.Angles(math.rad(90), 0, 0)) * CFrame.new(0,0,0)
					Blood_Ground.CanCollide = false
					Blood_Ground.Parent = Debris_Folder
					local Clean = script:FindFirstChild("Clean")
					if Clean then
						local Clean_Clone = Clean:Clone()
						Clean_Clone.Disabled = false
						Clean_Clone.Parent = Blood_Ground
					end
					TweenService:Create(Blood_Ground, TweenInfo.new(math.random(1, 1.1), Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0), {Size = Vector3.new(Radious, 0.035, Radious)}):Play(1043479800)
					Drop:Destroy()
					break
				end
			until Hit ~= nil or Drop:FindFirstChild("Delete")
			Debris:AddItem(Drop, 3)
		end)
	end)
end

return Blood
