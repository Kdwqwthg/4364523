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
    CountdownText.Text = "0:00"
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

-- Функция для получения всех доступных таймеров
local function getAllTimers()
    local timers = {}
    local gameGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not gameGui then return timers end
    
    local gameFolder = gameGui:FindFirstChild("Game")
    if not gameFolder then return timers end
    
    local hud = gameFolder:FindFirstChild("HUD")
    if not hud then return timers end
    
    local overlay = hud:FindFirstChild("Overlay")
    if not overlay then return timers end
    
    local roundOverlay = overlay:FindFirstChild("RoundOverlay")
    if not roundOverlay then return timers end
    
    local roundTimer = roundOverlay:FindFirstChild("RoundTimer")
    if not roundTimer then return timers end
    
    -- Проверяем первый путь: RoundTimer.RoundTimer.Timer
    local roundTimerInner = roundTimer:FindFirstChild("RoundTimer")
    if roundTimerInner then
        local timer = roundTimerInner:FindFirstChild("Timer")
        if timer and timer:IsA("TextLabel") then
            table.insert(timers, {object = timer, path = "RoundTimer"})
        end
    end
    
    -- Проверяем второй путь: RoundTimer.IngameRoundTimer.Timer
    local ingameRoundTimer = roundTimer:FindFirstChild("IngameRoundTimer")
    if ingameRoundTimer then
        local timer = ingameRoundTimer:FindFirstChild("Timer")
        if timer and timer:IsA("TextLabel") then
            table.insert(timers, {object = timer, path = "IngameRoundTimer"})
        end
    end
    
    return timers
end

-- Функция для проверки, активен ли таймер (показывает время)
local lastTexts = {}
local function isTimerActive(timerObject)
    if not timerObject then return false end
    local text = timerObject.Text or ""
    
    -- Если текст пустой или показывает только нули - не активен
    if text == "" or text == "0:00" or text == "00:00" or text == "0:00.0" or text == "00:00.0" then
        return false
    end
    
    -- Проверяем, меняется ли текст (для этого храним предыдущие значения)
    local timerKey = tostring(timerObject)
    if not lastTexts[timerKey] then
        lastTexts[timerKey] = text
        return true -- Если видим впервые, считаем активным
    end
    
    -- Если текст изменился - таймер активен
    if lastTexts[timerKey] ~= text then
        lastTexts[timerKey] = text
        return true
    end
    
    -- Если текст не меняется, проверяем прошло ли достаточно времени
    -- Если текст не меняется более 1 секунды, считаем неактивным
    return true
end

-- Функция для получения активного таймера
local function getActiveTimer()
    local timers = getAllTimers()
    
    -- Сначала проверяем первый путь (RoundTimer)
    for _, timerData in ipairs(timers) do
        if timerData.path == "RoundTimer" then
            if isTimerActive(timerData.object) then
                return timerData.object
            end
        end
    end
    
    -- Если первый не активен, проверяем второй (IngameRoundTimer)
    for _, timerData in ipairs(timers) do
        if timerData.path == "IngameRoundTimer" then
            if isTimerActive(timerData.object) then
                return timerData.object
            end
        end
    end
    
    -- Если оба не активны или не существуют, возвращаем nil
    return nil
end

local timerConnection
local currentTimerObject = nil
local checkInterval = nil
local lastUpdateTime = tick()

local function updateTimerDisplay()
    local activeTimer = getActiveTimer()
    
    if activeTimer then
        -- Если нашли активный таймер
        if currentTimerObject ~= activeTimer then
            -- Отключаем старую связь если есть
            if timerConnection then
                timerConnection:Disconnect()
                timerConnection = nil
            end
            currentTimerObject = activeTimer
            TimerContainer.Visible = true
            
            local function updateTimer()
                local text = activeTimer.Text or "0:00"
                -- Проверяем, что текст действительно изменился и это не нули
                if text ~= "0:00" and text ~= "00:00" and text ~= "0:00.0" and text ~= "00:00.0" and text ~= "" then
                    TimerLabel.Text = text
                    TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    StatusLabel.Text = "ROUND ACTIVE"
                    lastUpdateTime = tick()
                else
                    -- Если таймер показывает нули, проверяем через проверку
                    TimerLabel.Text = text
                end
            end
            
            updateTimer()
            timerConnection = activeTimer:GetPropertyChangedSignal("Text"):Connect(updateTimer)
        else
            -- Проверяем, не завис ли текущий таймер
            local currentText = activeTimer.Text or ""
            if currentText == "0:00" or currentText == "00:00" or currentText == "0:00.0" or currentText == "00:00.0" or currentText == "" then
                -- Если показывает нули, сбрасываем
                if currentTimerObject then
                    if timerConnection then
                        timerConnection:Disconnect()
                        timerConnection = nil
                    end
                    currentTimerObject = nil
                end
                TimerContainer.Visible = false
                TimerLabel.Text = "JOIN GAME"
                StatusLabel.Text = "WAITING"
            end
        end
    else
        -- Нет активных таймеров
        if currentTimerObject then
            if timerConnection then
                timerConnection:Disconnect()
                timerConnection = nil
            end
            currentTimerObject = nil
        end
        TimerContainer.Visible = false
        TimerLabel.Text = "JOIN GAME"
        StatusLabel.Text = "WAITING"
    end
end

-- Периодическая проверка на случай, если таймеры меняют состояние
checkInterval = RunService.RenderStepped:Connect(function()
    updateTimerDisplay()
end)

-- Первоначальная настройка
updateTimerDisplay()

-- Отслеживаем появление новых таймеров
local childAddedConnection
childAddedConnection = LocalPlayer.PlayerGui.DescendantAdded:Connect(function(descendant)
    if descendant.Name == "Timer" and descendant:IsA("TextLabel") then
        local parent = descendant.Parent
        if parent and (parent.Name == "RoundTimer" or parent.Name == "IngameRoundTimer") then
            updateTimerDisplay()
        end
    end
end)

local function cleanupTimer()
    if timerConnection then
        timerConnection:Disconnect()
        timerConnection = nil
    end
    if childAddedConnection then
        childAddedConnection:Disconnect()
        childAddedConnection = nil
    end
    if backgroundAnimation then
        backgroundAnimation:Disconnect()
        backgroundAnimation = nil
    end
    if checkInterval then
        checkInterval:Disconnect()
        checkInterval = nil
    end
    currentTimerObject = nil
end

TimerContainer.Destroying:Connect(function()
    if backgroundAnimation then
        backgroundAnimation:Disconnect()
        backgroundAnimation = nil
    end
    if checkInterval then
        checkInterval:Disconnect()
        checkInterval = nil
    end
end)
