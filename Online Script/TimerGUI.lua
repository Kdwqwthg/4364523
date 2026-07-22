local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local lastTimerText = ""
local currentTimerPath = nil -- "round" или "ingame"

local function findTimerText()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return nil, nil end

    local gameGui = playerGui:FindFirstChild("Game")
    if not gameGui then return nil, nil end

    local hud = gameGui:FindFirstChild("HUD")
    if not hud then return nil, nil end

    local overlay = hud:FindFirstChild("Overlay")
    if not overlay then return nil, nil end

    local roundOverlay = overlay:FindFirstChild("RoundOverlay")
    if not roundOverlay then return nil, nil end

    -- Первый путь: RoundTimer.RoundTimer.Timer
    local roundTimer = roundOverlay:FindFirstChild("RoundTimer")
    if roundTimer then
        local innerRoundTimer = roundTimer:FindFirstChild("RoundTimer")
        if innerRoundTimer then
            local timerLabel = innerRoundTimer:FindFirstChild("Timer")
            if timerLabel and timerLabel:IsA("TextLabel") then
                return timerLabel, "round"
            end
        end
    end

    -- Второй путь: IngameRoundTimer.Timer
    local ingameTimer = roundOverlay:FindFirstChild("IngameRoundTimer")
    if ingameTimer then
        local timerLabel = ingameTimer:FindFirstChild("Timer")
        if timerLabel and timerLabel:IsA("TextLabel") then
            return timerLabel, "ingame"
        end
    end

    return nil, nil
end

local function isTimerActive(text)
    if not text or text == "" then return false end
    -- Проверяем на нули: 00:00, 0:00, 0:0, 00:00:00 и т.д.
    local cleaned = text:gsub(":", ""):gsub("%s", "")
    if cleaned == "0000" or cleaned == "000" or cleaned == "00" or cleaned == "0" then
        return false
    end
    -- Проверяем на прочерки или пустые значения
    if text:find("^-") or text:find("–") then
        return false
    end
    return true
end

local function createTimerGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DraconicTimer"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 200, 0, 40)
    container.Position = UDim2.new(1, -210, 0, 10)
    container.BackgroundTransparency = 1
    container.Parent = screenGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundTransparency = 0.7
    mainFrame.Parent = container

    local backgroundGradient = Instance.new("UIGradient")
    backgroundGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    }
    backgroundGradient.Rotation = 0
    backgroundGradient.Parent = mainFrame

    local gradientAnimation
    gradientAnimation = RunService.RenderStepped:Connect(function(delta)
        backgroundGradient.Rotation = (backgroundGradient.Rotation + 90 * delta) % 360
    end)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(139, 0, 0)
    stroke.Thickness = 2
    stroke.Parent = mainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame

    local timerText = Instance.new("TextLabel")
    timerText.Size = UDim2.new(1, -10, 1, 0)
    timerText.Position = UDim2.new(0, 5, 0, 0)
    timerText.BackgroundTransparency = 1
    timerText.TextColor3 = Color3.fromRGB(255, 255, 255)
    timerText.Font = Enum.Font.GothamBold
    timerText.TextSize = 16
    timerText.TextXAlignment = Enum.TextXAlignment.Center
    timerText.Text = "JOIN GAME"
    timerText.Parent = mainFrame

    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                      startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = container.Position

            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    connection:Disconnect()
                end
            end)
        end
    end)

    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)

    mainFrame.MouseEnter:Connect(function()
        stroke.Color = Color3.fromRGB(255, 50, 50)
    end)

    mainFrame.MouseLeave:Connect(function()
        stroke.Color = Color3.fromRGB(139, 0, 0)
    end)

    local lastUpdate = 0

    RunService.RenderStepped:Connect(function()
        local currentTime = tick()
        if currentTime - lastUpdate >= 0.3 then
            lastUpdate = currentTime
            
            local label, path = findTimerText()
            
            if label and label.Text and label.Text ~= "" then
                local currentText = label.Text
                
                -- Если текущий таймер показывает нули или не меняется - пытаемся переключиться
                if not isTimerActive(currentText) then
                    -- Пытаемся найти другой таймер
                    local altLabel, altPath = findTimerText()
                    if altLabel and altLabel.Text and altLabel.Text ~= "" and isTimerActive(altLabel.Text) then
                        timerText.Text = altLabel.Text
                        timerText.TextColor3 = Color3.fromRGB(255, 255, 255)
                        lastTimerText = altLabel.Text
                        currentTimerPath = altPath
                    else
                        timerText.Text = "JOIN GAME"
                        timerText.TextColor3 = Color3.fromRGB(255, 100, 100)
                        lastTimerText = ""
                        currentTimerPath = nil
                    end
                else
                    -- Таймер активен - показываем его
                    timerText.Text = currentText
                    timerText.TextColor3 = Color3.fromRGB(255, 255, 255)
                    lastTimerText = currentText
                    currentTimerPath = path
                end
            else
                timerText.Text = "JOIN GAME"
                timerText.TextColor3 = Color3.fromRGB(255, 100, 100)
                lastTimerText = ""
                currentTimerPath = nil
            end
        end
    end)

    container.Destroying:Connect(function()
        if gradientAnimation then
            gradientAnimation:Disconnect()
        end
    end)

    return screenGui
end

if not LocalPlayer.PlayerGui:FindFirstChild("DraconicTimer") then
    createTimerGUI()
end
