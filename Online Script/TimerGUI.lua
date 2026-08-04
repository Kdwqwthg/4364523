local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

local function CreateTimerGUI()
    local MainInterface = Instance.new("ScreenGui")
    local TimerContainer = Instance.new("Frame")
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
    
    TimerContainer.Name = "TimerContainer"
    TimerContainer.Parent = MainInterface
    TimerContainer.AnchorPoint = Vector2.new(0.5, 0)
    TimerContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TimerContainer.BackgroundTransparency = 1.000
    TimerContainer.BorderColor3 = Color3.fromRGB(27, 42, 53)
    TimerContainer.Position = UDim2.new(0.5, 0, 0, 0)
    TimerContainer.Size = UDim2.new(1, 0, 1, 0)
    TimerContainer.Visible = false

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
    
    local backgroundAnimation
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

    return CountdownText, StatusText, MainInterface, TimerContainer, backgroundAnimation
end

local TimerLabel, StatusLabel, MainInterface, TimerContainer, backgroundAnimation = CreateTimerGUI()

-- ========== ПОЛУЧЕНИЕ ТАЙМЕРА ПО ПУТИ ==========
local function getTimerText()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local gameGui = pg:FindFirstChild("Game")
    if not gameGui then return nil end
    local hud = gameGui:FindFirstChild("HUD")
    if not hud then return nil end
    local overlay = hud:FindFirstChild("Overlay")
    if not overlay then return nil end
    local roundOverlay = overlay:FindFirstChild("RoundOverlay")
    if not roundOverlay then return nil end
    local roundTimer = roundOverlay:FindFirstChild("RoundTimer")
    if not roundTimer then return nil end
    local ingame = roundTimer:FindFirstChild("IngameRoundTimer")
    if ingame then
        local timer = ingame:FindFirstChild("Timer")
        if timer and timer:IsA("TextLabel") then
            return timer
        end
    end
    return nil
end

local timerConnection
local lastText = ""
local waitTimer = 0
local isWaiting = false

local function updateTimer()
    local timerObject = getTimerText()
    
    if timerObject then
        local currentText = timerObject.Text or ""
        
        -- Если текст не меняется (время стоит) и это не пустая строка
        if currentText == lastText and currentText ~= "" then
            if not isWaiting then
                waitTimer = tick()
                isWaiting = true
            end
            
            -- Если прошло 2 секунды без изменений → WAIT
            if tick() - waitTimer >= 2 then
                TimerLabel.Text = "WAIT"
                TimerLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
            else
                TimerLabel.Text = currentText
                TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        else
            -- Текст изменился (время пошло) или новая строка
            isWaiting = false
            waitTimer = 0
            lastText = currentText
            
            if currentText == "" then
                TimerLabel.Text = "0:00"
                TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                TimerLabel.Text = currentText
                TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
            
            if not timerConnection then
                timerConnection = timerObject:GetPropertyChangedSignal("Text"):Connect(function()
                    if TimerContainer and TimerContainer.Visible then
                        updateTimer()
                    end
                end)
            end
        end
        
        MainInterface.Visible = true
        TimerContainer.Visible = true
        
    else
        -- Таймера нет → JOIN GAME
        TimerLabel.Text = "JOIN GAME"
        TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        MainInterface.Visible = true
        TimerContainer.Visible = true
        isWaiting = false
        waitTimer = 0
        lastText = ""
        
        if timerConnection then
            timerConnection:Disconnect()
            timerConnection = nil
        end
    end
end

-- ========== ЗАПУСК ==========
task.wait(1)
updateTimer()

-- Следим за появлением таймера
local descendantConnection
descendantConnection = LocalPlayer.PlayerGui.DescendantAdded:Connect(function(descendant)
    if descendant.Name == "Timer" and descendant:IsA("TextLabel") then
        task.wait(0.2)
        updateTimer()
    end
end)

-- Периодическая проверка
local checkLoop
checkLoop = RunService.Heartbeat:Connect(function()
    updateTimer()
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
    if checkLoop then
        checkLoop:Disconnect()
        checkLoop = nil
    end
    if backgroundAnimation then
        backgroundAnimation:Disconnect()
        backgroundAnimation = nil
    end
end

TimerContainer.Destroying:Connect(function()
    if backgroundAnimation then
        backgroundAnimation:Disconnect()
        backgroundAnimation = nil
    end
end)
