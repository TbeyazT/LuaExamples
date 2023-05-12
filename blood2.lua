local bloodModule = {}

--// Services \\--
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")
local debris = game:GetService("Debris")

--asel_aselarya burdaydı 🙄

local modulesFolder = replicatedStorage:WaitForChild("Modules")
local remotesFolder = replicatedStorage
local objectsFolder = replicatedStorage:WaitForChild("Objects")
local bindsFolder = replicatedStorage
-- HELLO HİDDEN DEV İ NEVER LKE YOU İF U SEE THİS
local raycastHitboxModule = modulesFolder:WaitForChild("RaycastHitboxV4")
local raycastHitbox = require(raycastHitboxModule)

local threadModule = modulesFolder:WaitForChild("Thread")
local thread = require(threadModule)

local remotes = {
	Headshot = remotesFolder:FindFirstChild("Test")
}

local goreFolder = objectsFolder:WaitForChild("Gore")
local blood = goreFolder:WaitForChild("Blood")
local splatter = goreFolder:WaitForChild("Splatter")
local headGore = goreFolder:WaitForChild("HeadGore")
local organs = goreFolder:WaitForChild("Organs")

local particlesFolder = objectsFolder:WaitForChild("Particles")
local smoke = particlesFolder:WaitForChild("Smoke")
local bloodParticles = particlesFolder:WaitForChild("blood")

local camera = workspace.CurrentCamera
local debrisFolder = workspace:WaitForChild("Debris")


local ignore = {}
local canFlow = true

local bloodEnded = false

--// Functions \\--

local function weld(part1, part2)
	local newWeld = Instance.new("WeldConstraint", part1)
	newWeld.Part0 = part1
	newWeld.Part1 = part2
end

local function CreateHeadReferences(targetCharacter)
	local torso = targetCharacter.Parent:WaitForChild("Torso")

	local headPrevious = Instance.new("Part", torso)
	headPrevious.Name = "HeadPrevious"
	headPrevious.Size = Vector3.new(0.5, 0.5, 0.5)
	headPrevious.Anchored = true
	headPrevious.CanCollide = false
	headPrevious.CanTouch = false
	headPrevious.Transparency = 1
	headPrevious.CFrame = torso.CFrame + Vector3.new(0, 1, 0)

	local headReference = Instance.new("Part", torso)
	headReference.Name = "HeadReference"
	headReference.Size = Vector3.new(0.5, 0.5, 0.5)
	headReference.CanCollide = false
	headReference.CanTouch = false
	headReference.Anchored = false
	headReference.Transparency = 1
	headReference.CFrame = torso.CFrame + Vector3.new(0, 1, 0)

	weld(headReference, torso)

	return headPrevious, headReference
end

local function createSplatter(splatterInstance)
	local dripSounds = {
		splatterInstance.Splash1,
		splatterInstance.Splash2,
		splatterInstance.Splash3,
		splatterInstance.Splash4,
		splatterInstance.Splash5
	}

	dripSounds[math.random(1, #dripSounds)]:Play()

	local randomSize = math.random(3, 8) / 10
	tweenService:Create(splatterInstance, TweenInfo.new(1.25, Enum.EasingStyle.Quint), {
		Size = Vector3.new(randomSize, 0.1, randomSize)
	}):Play()
end

local function spawnBlood(amount, headReference)
	bloodEnded = false
	ignore = {debrisFolder}
	
	for _, v in ipairs(workspace.chars:GetChildren()) do
		if v:FindFirstChildOfClass("Humanoid") then
			table.insert(ignore, v)
		end
	end

	for i = 1, amount, 1 do
		if canFlow == false then
			break
		end

		local bloodInstance = blood:Clone()
		bloodInstance.Name = "blood"
		bloodInstance.Parent = debrisFolder
		bloodInstance.CFrame = headReference.CFrame
		bloodInstance.Velocity = headReference.CFrame.UpVector * math.clamp((amount - i) / 5, 10, 40) + Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))

		local hitbox = raycastHitbox.new(bloodInstance)
		hitbox.RaycastParams = RaycastParams.new()
		hitbox.RaycastParams.FilterDescendantsInstances = ignore
		hitbox.RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist

		hitbox.DetectionMode = raycastHitbox.DetectionMode.PartMode

		hitbox.OnHit:Connect(function(hit, _, result)
			if hit and hit.CanTouch == false then return end

			local lastPosition = result.Position
			local normal = result.Normal

			if hit then
				local splatterInstance = splatter:Clone()
				splatterInstance.Parent = debrisFolder
				splatterInstance.CFrame = CFrame.new(lastPosition, lastPosition - normal) * CFrame.Angles(math.rad(-90), 0, 0)
				splatterInstance.Anchored = true
				bloodInstance.Anchored = true
				splatterInstance.Name = "blood"


				createSplatter(splatterInstance)
				
				local clean = script.Clean:Clone()
				clean.Parent = splatterInstance
				clean.Enabled = true
				clean.Name = "scripty"


				hitbox:HitStop()
			end
		end)

		hitbox:HitStart(3)
		debris:AddItem(bloodInstance, 3)

		thread:Wait()
	end

	bloodEnded = true
end

local function spawnParticles(headPrevious, headReference)
	local smokeInstance = smoke:Clone()
	smokeInstance.Parent = headPrevious
	smokeInstance.Enabled = true

	local bloodParticlesInstance = bloodParticles:Clone()
	bloodParticlesInstance.Parent = headReference
	bloodParticlesInstance.Enabled = true

	coroutine.resume(coroutine.create(function()
		thread:Wait(4)
		smokeInstance.Enabled = false
		thread:Wait(smokeInstance.Lifetime.Max)
		smokeInstance:Destroy()
	end))

	coroutine.resume(coroutine.create(function()
		while bloodEnded == false do wait() end
		
		bloodParticlesInstance.Enabled = false
		thread:Wait(bloodParticlesInstance.Lifetime.Max)
		bloodParticlesInstance:Destroy()
	end))
end

--[[
local function spawnRinging()
	local startTick = tick()

	coroutine.resume(coroutine.create(function()
		sfx.Ringing:Play()
		tweenService:Create(lighting.Blur, TweenInfo.new(1, Enum.EasingStyle.Quint), {
			Size = 5
		}):Play()
		tweenService:Create(lighting.ColorCorrection, TweenInfo.new(1, Enum.EasingStyle.Quint), {
			Brightness = 0.5
		}):Play()

		thread:Wait(sfx.Ringing.TimeLength / 1.25)

		tweenService:Create(lighting.Blur, TweenInfo.new(3, Enum.EasingStyle.Quint), {
			Size = 0
		}):Play()
		tweenService:Create(lighting.ColorCorrection, TweenInfo.new(3, Enum.EasingStyle.Quint), {
			Brightness = 0
		}):Play()
	end))
end

--]]

local function spawnGore(headReference)
	local headGoreInstance = headGore:Clone()
	headGoreInstance:SetPrimaryPartCFrame(headReference.CFrame)
	headGoreInstance.Parent = debrisFolder

	local organsInstance = organs:Clone()
	organsInstance:SetPrimaryPartCFrame(headReference.CFrame)
	organsInstance.Parent = debrisFolder

	coroutine.resume(coroutine.create(function()
		for _, v in ipairs(organsInstance:GetChildren()) do
			if string.match(v.Name, "Hitbox") then
				v.Velocity = Vector3.new(math.random(-18, 18), math.random(24, 32), math.random(-18, 18))
			end
		end
	end))

	weld(headGoreInstance.PrimaryPart, headReference)
end

function bloodModule:Create(SpawnNumber,Effects,NormalChar,targetCharacter)
	local thing = targetCharacter
	spawnBlood(SpawnNumber, thing)
	--[[
	if replicatedStorage:WaitForChild("plrSettings"):WaitForChild(NormalChar.Name):WaitForChild("BloodEnabled").Value == true then
		wait()
		spawnBlood(SpawnNumber, thing)
	end
	--]]
	if targetCharacter == NormalChar then
		warn("forgiving what you are")
	else
		wait(.1)
		if Effects then
			print("not done now")
		end
	end
end

return bloodModule
