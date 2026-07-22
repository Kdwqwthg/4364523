--22
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

local TimerLabel = nil
local StatusLabel = nil
local MainInterface = nil
local TimerContainer = nil
local backgroundAnimation = nil
local timerConnection = nil
local currentTimerObject = nil
local activePath = nil

-- ========== СОЗДАНИЕ GUI ==========
local function CreateTimerGUI()
    MainInterface = Instance.new("ScreenGui")
    TimerContainer = Instance.new("Frame")
    local AspectRatio = Instance.new("UIAspectRatioConstraint")
    local SizeLimit = Instance.new("UISizeConstraint")
    local TimerDisplay = Instance.new("Frame")
    local RoundedCorners = Instance.new("UICorner")
    local BorderOutline = Instance.new("UIStroke")
    local PanelBackground = Instance.new("ImageLabel")
    local BackgroundCorners = Instance.new("UICorner")
    local OverlayImage = Instance.new("ImageLabel")
    local StatusText = Instance.new("TextLabel")
    local TextGradient = Instance.new("UIGradient")
    local StatusBorder = Instance.new("UIStroke")
    local CountdownText = Instance.new("TextLabel")
    local TimerGradient = Instance.new("UIGradient")
    local CountdownBorder = Instance.new("UIStroke")

    MainInterface.Name = "MainInterface"
    MainInterface.Parent = PlayerGui
    MainInterface.ResetOnSpawn = false
    MainInterface.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MainInterface.Enabled = true
    MainInterface.DisplayOrder = 2
    MainInterface.Visible = true
    
    TimerContainer.Name = "TimerContainer"
    TimerContainer.Parent = MainInterface
    TimerContainer.AnchorPoint = Vector2.new(0.5, 0)
    TimerContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TimerContainer.BackgroundTransparency = 1.000
    TimerContainer.BorderColor3 = Color3.fromRGB(27, 42, 53)
    TimerContainer.Position = UDim2.new(0.5, 0, 0, 0)
    TimerContainer.Size = UDim2.new(1, 0, 1, 0)
    TimerContainer.Visible = true

    AspectRatio.Parent = TimerContainer
    SizeLimit.Parent = TimerContainer
    SizeLimit.MaxSize = Vector2.new(900, 900)

    TimerDisplay.Name = "TimerDisplay"
    TimerDisplay.Parent = TimerContainer
    TimerDisplay.AnchorPoint = Vector2.new(0.5, 0.5)
    TimerDisplay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TimerDisplay.BackgroundTransparency = 1.000
    TimerDisplay.BorderColor3 = Color3.fromRGB(27, 42, 53)
    TimerDisplay.BorderSizePixel = 0
    TimerDisplay.Position = UDim2.new(0.5, 0, 0.1, 0)
    TimerDisplay.Size = UDim2.new(0.300000012, 0,0.100000001, 0)
    TimerDisplay.ZIndex = 10000

    RoundedCorners.CornerRadius = UDim.new(0, 12)
    RoundedCorners.Parent = TimerDisplay

    BorderOutline.Parent = TimerDisplay
    BorderOutline.Thickness = 2
    BorderOutline.Color = Color3.fromRGB(139, 0, 0)
    BorderOutline.Transparency = 0.1

    local BackgroundFrame = Instance.new("Frame")
    BackgroundFrame.Name = "BackgroundFrame"
    BackgroundFrame.Parent = TimerDisplay
    BackgroundFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    BackgroundFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BackgroundFrame.BackgroundTransparency = 0.7
    BackgroundFrame.BorderSizePixel = 0
    BackgroundFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
    BackgroundFrame.ZIndex = 9998
    
    local BackgroundCorner = Instance.new("UICorner")
    BackgroundCorner.CornerRadius = UDim.new(0, 12)
    BackgroundCorner.Parent = BackgroundFrame
    
    local BackgroundGradient = Instance.new("UIGradient")
    BackgroundGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(139, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(139, 0, 0))
    }
    BackgroundGradient.Rotation = 0
    BackgroundGradient.Parent = BackgroundFrame
    
    backgroundAnimation = RunService.RenderStepped:Connect(function(delta)
        BackgroundGradient.Rotation = (BackgroundGradient.Rotation + 90 * delta) % 360
    end)

    PanelBackground.Name = "PanelBackground"
    PanelBackground.Parent = TimerDisplay
    PanelBackground.AnchorPoint = Vector2.new(0.5, 0.5)
    PanelBackground.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    PanelBackground.BackgroundTransparency = 1.000
    PanelBackground.BorderColor3 = Color3.fromRGB(27, 42, 53)
    PanelBackground.Position = UDim2.new(0.5, 0, 0.5, 0)
    PanelBackground.Size = UDim2.new(1, 0, 1, 0)
    PanelBackground.ZIndex = 9999
    PanelBackground.Image = ""
    PanelBackground.ImageColor3 = Color3.fromRGB(255, 255, 255)
    PanelBackground.ImageTransparency = 1.000

    BackgroundCorners.CornerRadius = UDim.new(0, 12)
    BackgroundCorners.Parent = PanelBackground

    OverlayImage.Parent = TimerDisplay
    OverlayImage.AnchorPoint = Vector2.new(0.5, 0.5)
    OverlayImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    OverlayImage.BackgroundTransparency = 1.000
    OverlayImage.BorderColor3 = Color3.fromRGB(27, 42, 53)
    OverlayImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    OverlayImage.Size = UDim2.new(1, 0, 1, 0)
    OverlayImage.ZIndex = 10001
    OverlayImage.Image = ""
    OverlayImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
    OverlayImage.ImageTransparency = 1.000
    OverlayImage.ScaleType = Enum.ScaleType.Crop

    StatusText.Name = "StatusText"
    StatusText.Parent = TimerDisplay
    StatusText.AnchorPoint = Vector2.new(0.5, 0.5)
    StatusText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    StatusText.BackgroundTransparency = 1.000
    StatusText.BorderColor3 = Color3.fromRGB(27, 42, 53)
    StatusText.Position = UDim2.new(0.5, 0, 0.3, 0)
    StatusText.Size = UDim2.new(0.9, 0, 0.3, 0)
    StatusText.ZIndex = 10002
    StatusText.Font = Enum.Font.GothamBold
    StatusText.Text = "ROUND ACTIVE"
    StatusText.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusText.TextScaled = true
    StatusText.TextSize = 14.000
    StatusText.TextStrokeTransparency = 0.850
    StatusText.TextWrapped = true

    TextGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(220, 220, 220))}
    TextGradient.Rotation = 90
    TextGradient.Parent = StatusText

    StatusBorder.Parent = StatusText
    StatusBorder.Thickness = 1
    StatusBorder.Color = Color3.fromRGB(255, 255, 255)
    StatusBorder.Transparency = 0.7

    CountdownText.Name = "CountdownText"
    CountdownText.Parent = TimerDisplay
    CountdownText.AnchorPoint = Vector2.new(0.5, 0.5)
    CountdownText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CountdownText.BackgroundTransparency = 1.000
    CountdownText.BorderColor3 = Color3.fromRGB(27, 42, 53)
    CountdownText.Position = UDim2.new(0.5, 0, 0.7, 0)
    CountdownText.Size = UDim2.new(0.9, 0, 0.5, 0)
    CountdownText.ZIndex = 10002
    CountdownText.Font = Enum.Font.GothamBold
    CountdownText.Text = "JOIN GAME"
    CountdownText.TextColor3 = Color3.fromRGB(255, 255, 255)
    CountdownText.TextScaled = true
    CountdownText.TextSize = 14.000
    CountdownText.TextStrokeTransparency = 0.850
    CountdownText.TextWrapped = true

    TimerGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(220, 220, 220))}
    TimerGradient.Rotation = 90
    TimerGradient.Parent = CountdownText

    CountdownBorder.Parent = CountdownText
    CountdownBorder.Thickness = 1
    CountdownBorder.Color = Color3.fromRGB(255, 255, 255)
    CountdownBorder.Transparency = 0.7

    TimerLabel = CountdownText
    StatusLabel = StatusText

    -- ========== ПЕРЕТАСКИВАНИЕ ==========
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    
    local function updatePosition(input)
        local delta = input.Position - dragStart
        TimerContainer.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
    
    TimerDisplay.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = TimerContainer.Position
            
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    connection:Disconnect()
                end
            end)
        end
    end)
    
    TimerDisplay.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.Touch) then
            updatePosition(input)
        end
    end)

    return CountdownText, StatusText, MainInterface, TimerContainer
end

CreateTimerGUI()

-- ========== ПОИСК ТАЙМЕРА ПО ДВУМ ПУТЯМ ==========
local function getRoundTimer()
    local gameGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not gameGui then return nil end
    local gameFolder = gameGui:FindFirstChild("Game")
    if not gameFolder then return nil end
    local hud = gameFolder:FindFirstChild("HUD")
    if not hud then return nil end
    local overlay = hud:FindFirstChild("Overlay")
    if not overlay then return nil end
    local roundOverlay = overlay:FindFirstChild("RoundOverlay")
    if not roundOverlay then return nil end
    local roundTimer = roundOverlay:FindFirstChild("RoundTimer")
    if not roundTimer then return nil end
    return roundTimer
end

local function getTimerFromPath(pathType)
    local roundTimer = getRoundTimer()
    if not roundTimer then return nil end
    
    if pathType == 1 then
        return roundTimer:FindFirstChild("Timer")
    elseif pathType == 2 then
        local ingame = roundTimer:FindFirstChild("IngameRoundTimer")
        if ingame then
            return ingame:FindFirstChild("Timer")
        end
    end
    return nil
end

local function getActiveTimer()
    local timer1 = getTimerFromPath(1)
    if timer1 and timer1:IsA("TextLabel") then
        local text = timer1.Text or ""
        if text ~= "" and text ~= "0:00" then
            activePath = 1
            return timer1
        end
    end
    
    local timer2 = getTimerFromPath(2)
    if timer2 and timer2:IsA("TextLabel") then
        local text = timer2.Text or ""
        if text ~= "" and text ~= "0:00" then
            activePath = 2
            return timer2
        end
    end
    
    if timer1 and timer1:IsA("TextLabel") then
        activePath = 1
        return timer1
    end
    
    activePath = 0
    return nil
end

local function updateTimerDisplay()
    local timerObject = getActiveTimer()
    
    if timerObject and timerObject:IsA("TextLabel") then
        MainInterface.Visible = true
        TimerContainer.Visible = true
        
        local function updateText()
            local text = timerObject.Text or "JOIN GAME"
            if text ~= "" then
                TimerLabel.Text = text
                TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                TimerLabel.Text = "JOIN GAME"
                TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
        
        updateText()
        
        if timerConnection then
            timerConnection:Disconnect()
            timerConnection = nil
        end
        
        currentTimerObject = timerObject
        timerConnection = timerObject:GetPropertyChangedSignal("Text"):Connect(function()
            local newTimer = getActiveTimer()
            if newTimer and newTimer ~= currentTimerObject then
                updateTimerDisplay()
            else
                updateText()
            end
        end)
        
    else
        MainInterface.Visible = true
        TimerContainer.Visible = true
        TimerLabel.Text = "JOIN GAME"
        TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        if timerConnection then
            timerConnection:Disconnect()
            timerConnection = nil
        end
        currentTimerObject = nil
        activePath = 0
    end
end

-- ========== ЗАПУСК ==========
task.wait(1)
updateTimerDisplay()

local descendantConnection
descendantConnection = LocalPlayer.PlayerGui.DescendantAdded:Connect(function(descendant)
    if descendant.Name == "Timer" and descendant:IsA("TextLabel") then
        task.wait(0.5)
        updateTimerDisplay()
    end
end)

local function checkBothTimers()
    local timer1 = getTimerFromPath(1)
    local timer2 = getTimerFromPath(2)
    
    if timer1 and timer1:IsA("TextLabel") then
        if not timerConnection or currentTimerObject ~= timer1 then
            updateTimerDisplay()
        end
    elseif timer2 and timer2:IsA("TextLabel") then
        if not timerConnection or currentTimerObject ~= timer2 then
            updateTimerDisplay()
        end
    end
end

local checkLoop
checkLoop = game:GetService("RunService").Heartbeat:Connect(function()
    if not currentTimerObject then
        updateTimerDisplay()
    end
end)

-- ========== ТУМБЛЕР ДЛЯ ТАЙМЕРА ==========
local TimerDisplayToggle = Tabs.Main:AddToggle("TimerDisplayToggle", {
    Title = "Show Timer",
    Default = false
})

TimerDisplayToggle:OnChanged(function(state)
    if state then
        if MainInterface then
            MainInterface.Enabled = true
            MainInterface.Visible = true
        end
        if TimerContainer then
            TimerContainer.Visible = true
        end
        updateTimerDisplay()
        
        if not checkLoop then
            checkLoop = game:GetService("RunService").Heartbeat:Connect(function()
                if not currentTimerObject then
                    updateTimerDisplay()
                end
            end)
        end
        
        Fluent:Notify({
            Title = "Timer",
            Content = "Timer Enabled",
            Duration = 2
        })
    else
        if MainInterface then
            MainInterface.Enabled = false
            MainInterface.Visible = false
        end
        if TimerContainer then
            TimerContainer.Visible = false
        end
        if checkLoop then
            checkLoop:Disconnect()
            checkLoop = nil
        end
        Fluent:Notify({
            Title = "Timer",
            Content = "Timer Disabled",
            Duration = 2
        })
    end
end)

local function cleanupTimer()
    if timerConnection then
        timerConnection:Disconnect()
        timerConnection = nil
    end
    if descendantConnection then
        descendantConnection:Disconnect()
        descendantConnection = nil
    end
    if backgroundAnimation then
        backgroundAnimation:Disconnect()
        backgroundAnimation = nil
    end
    if checkLoop then
        checkLoop:Disconnect()
        checkLoop = nil
    end
end

TimerContainer.Destroying:Connect(function()
    if backgroundAnimation then
        backgroundAnimation:Disconnect()
        backgroundAnimation = nil
    end
end)

-- Применяем начальное состояние
task.wait(0.5)
if TimerDisplayToggle.Value then
    if MainInterface then
        MainInterface.Enabled = true
        MainInterface.Visible = true
    end
    if TimerContainer then
        TimerContainer.Visible = true
    end
    updateTimerDisplay()
end
