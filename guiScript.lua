--i hope u hire me lol😎😎😎

--//locals//--
local holder = script.Parent.Holder
local ts = game:GetService("TweenService")
local mainUi = holder["Main pet menu"]
local hoverSound = script.ui_hover_ugd
local uiClick = script.UIClick
local imageButton = script.Parent.ImageButton
local CloseButton = mainUi["Exit  Button"]

--//Tweens//--
--/Locals/--
local easingStyle = Enum.EasingStyle.Back
local easingDirection = Enum.EasingDirection.Out
local mainUiTweenPosStarting = UDim2.new(0.143, 0,1, 0)
local mainUiTweenPosEnding = UDim2.new(0.144, 0,0, 0)
local endingSizeimage = UDim2.new(0.069, 0,0.173, 0)
local StartingSizeimage = UDim2.new(0.051, 0,0.137, 0)
local close = {
	endingSizeimage = UDim2.new(0.116, 0,0.156, 0),
	StartingSizeimage = UDim2.new(0.098, 0,0.149, 0)
}
--/Tweens/--
local hoverButtonGradient = ts:Create(imageButton.UIGradient, TweenInfo.new(0.2, easingStyle, easingDirection), {Offset = Vector2.new(0,1)})
local hoverButtonGradient2 = ts:Create(imageButton.UIGradient, TweenInfo.new(0.2, easingStyle, easingDirection), {Offset = Vector2.new(0,0)})
local hoverButtonSize1 = ts:Create(imageButton, TweenInfo.new(0.2, easingStyle, easingDirection), {Size = StartingSizeimage})
local hoverButtonSize2 = ts:Create(imageButton, TweenInfo.new(0.2, easingStyle, easingDirection), {Size = endingSizeimage})
local closeButtonTweens = {
	ButtonSize1 = ts:Create(CloseButton, TweenInfo.new(0.2, easingStyle, easingDirection), {Size = close.StartingSizeimage}),
	ButtonSize2 = ts:Create(CloseButton, TweenInfo.new(0.2, easingStyle, easingDirection), {Size = close.endingSizeimage})
}
local MainUiTweenstart = ts:Create(holder, TweenInfo.new(0.7, easingStyle, easingDirection), {Position = mainUiTweenPosStarting})
local MainUiTweenEnding = ts:Create(holder, TweenInfo.new(0.7, easingStyle, easingDirection), {Position = mainUiTweenPosEnding})
--//functions//--


imageButton.MouseEnter:Connect(function()
	hoverSound:Play()
	hoverButtonSize2:Play()
	hoverButtonGradient:Play()
end)

imageButton.MouseLeave:Connect(function()
	hoverButtonSize1:Play()
	hoverButtonGradient2:Play()
end)

imageButton.MouseButton1Click:Connect(function()
	MainUiTweenEnding:Play()
	uiClick:Play()
end)

CloseButton.MouseEnter:Connect(function()
	closeButtonTweens.ButtonSize2:Play()
	hoverSound:Play()
end)

CloseButton.MouseLeave:Connect(function()
	closeButtonTweens.ButtonSize1:Play()
end)

CloseButton.MouseButton1Click:Connect(function()
	uiClick:Play()
	MainUiTweenstart:Play()
end)