local plr = game:GetService("Players").LocalPlayer
local plrGui = plr.PlayerGui
local camera = workspace.CurrentCamera
local char = plr.Character or plr.CharacterAdded:Wait()
local rs = game:GetService("ReplicatedStorage")
local ts = game:GetService("TweenService")
local menu = workspace:WaitForChild("Menu")
local Users = require(rs:WaitForChild("Modules").users)
local camPart = menu.Camera
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local mainUi = plrGui:WaitForChild("MainUI")
local setting = mainUi.SettingsFrame
local mouse = plr:GetMouse()
local originalCFrame = camera.CFrame
local menuValue = char:WaitForChild("PlayerStuff").Values.inMenu
local easingStyle = Enum.EasingStyle.Linear
local easingDirection = Enum.EasingDirection.In
local bloodValue = rs:WaitForChild("plrSettings"):WaitForChild(plr.Name):WaitForChild("BloodEnabled")
local buttonTween = {
	one =ts:Create(mainUi.Overlay, TweenInfo.new(2, easingStyle, easingDirection), {BackgroundTransparency = 0}),
	two = 	ts:Create(mainUi.Overlay, TweenInfo.new(2, easingStyle, easingDirection), {BackgroundTransparency = 1})
}

local bloodButton = {
	PosRight =ts:Create(setting.BloodSet.Frame, TweenInfo.new(0.7, easingStyle, easingDirection), {Position = UDim2.new(0.59, 0,0.121, -1)}),
	PosLeft =ts:Create(setting.BloodSet.Frame, TweenInfo.new(0.7, easingStyle, easingDirection), {Position = UDim2.new(-0.004, 0,0.091, -1)}),
	Color1 =ts:Create(setting.BloodSet.Frame, TweenInfo.new(0.7, easingStyle, easingDirection), {BackgroundColor3 = Color3.fromRGB(85, 170, 127)}),
	Color2 =ts:Create(setting.BloodSet.Frame, TweenInfo.new(0.7, easingStyle, easingDirection), {BackgroundColor3 = Color3.fromRGB(113, 1, 1)})
}
wait()
mainUi.Main.Visible = true
mainUi.Overlay.Visible = true
local icon = require(rs:WaitForChild("Modules").Icon)
icon.new()
:setImage(6663675885)
:setTip("Settings")
:bindEvent("selected", function(icon)
	if setting.Visible == false then
		setting.Visible = true
	end
end)
:bindEvent("deselected", function(icon)
	if setting.Visible == true then
		setting.Visible = false
	end
end)

game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack,false)


camera.CameraType = Enum.CameraType.Scriptable
camera.CameraSubject = camPart
camera.CFrame = camPart.CFrame
local playerS = game:GetService("Players")

local function credits ()
	local credits = mainUi.Main.CreditsFrame
end

mainUi.Main.Solbar.PlayButton.MouseButton1Click:Connect(function()
	buttonTween.one:Play()
	buttonTween.one.Completed:Wait()
	buttonTween.two:Play()
	plrGui.stats.Enabled = true
	game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack,true)
	camera.CameraSubject = hum
	camera.CameraType = Enum.CameraType.Custom
	menuValue.Value = false
	mainUi.Main.Visible = false
	buttonTween.two.Completed:Wait()
	mainUi.Overlay.Visible = false
end)

mainUi.Main.Solbar.CreditsButton.MouseButton1Click:Connect(function()
	if mainUi.Main.CreditsFrame.Visible == false then
		mainUi.Main.CreditsFrame.Visible = true
	else
		mainUi.Main.CreditsFrame.Visible = false
	end
end)

mainUi.Main.Solbar.SettingsButton.MouseButton1Click:Connect(function()
	if setting.Visible == false then
		setting.Visible = true
	else
		setting.Visible = false
	end
end)

setting.BloodSetButton.MouseButton1Click:Connect(function()
	if bloodValue.Value == false then
		bloodButton.PosRight:Play()
		bloodButton.Color1:Play()
	else
		bloodButton.PosLeft:Play()
		bloodButton.Color2:Play()
	end
end)