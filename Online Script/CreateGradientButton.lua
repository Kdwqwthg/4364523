local RunService = game:GetService("RunService")

local buttonRegistry = {}
local currentTheme = nil

local THEME_COLORS = {
    ["Dark"] = {
        GradientStart = Color3.fromRGB(60, 60, 60),
        GradientMid = Color3.fromRGB(20, 20, 20),
        GradientEnd = Color3.fromRGB(60, 60, 60),
        Stroke = Color3.fromRGB(40, 40, 40),
        Text = Color3.fromRGB(255, 255, 255),
    },
    ["Darker"] = {
        GradientStart = Color3.fromRGB(40, 40, 40),
        GradientMid = Color3.fromRGB(10, 10, 10),
        GradientEnd = Color3.fromRGB(40, 40, 40),
        Stroke = Color3.fromRGB(25, 25, 25),
        Text = Color3.fromRGB(255, 255, 255),
    },
    ["Light"] = {
        GradientStart = Color3.fromRGB(220, 220, 220),
        GradientMid = Color3.fromRGB(255, 255, 255),
        GradientEnd = Color3.fromRGB(220, 220, 220),
        Stroke = Color3.fromRGB(180, 180, 180),
        Text = Color3.fromRGB(0, 0, 0),
    },
    ["Blue"] = {
        GradientStart = Color3.fromRGB(0, 120, 255),
        GradientMid = Color3.fromRGB(0, 40, 100),
        GradientEnd = Color3.fromRGB(0, 120, 255),
        Stroke = Color3.fromRGB(0, 80, 180),
        Text = Color3.fromRGB(255, 255, 255),
    },
    ["Green"] = {
        GradientStart = Color3.fromRGB(0, 200, 80),
        GradientMid = Color3.fromRGB(0, 50, 20),
        GradientEnd = Color3.fromRGB(0, 200, 80),
        Stroke = Color3.fromRGB(0, 130, 50),
        Text = Color3.fromRGB(255, 255, 255),
    },
    ["Red"] = {
        GradientStart = Color3.fromRGB(255, 60, 60),
        GradientMid = Color3.fromRGB(80, 0, 0),
        GradientEnd = Color3.fromRGB(255, 60, 60),
        Stroke = Color3.fromRGB(180, 30, 30),
        Text = Color3.fromRGB(255, 255, 255),
    },
    ["Purple"] = {
        GradientStart = Color3.fromRGB(150, 0, 255),
        GradientMid = Color3.fromRGB(50, 0, 80),
        GradientEnd = Color3.fromRGB(150, 0, 255),
        Stroke = Color3.fromRGB(100, 0, 180),
        Text = Color3.fromRGB(255, 255, 255),
    },
    ["Pink"] = {
        GradientStart = Color3.fromRGB(255, 100, 180),
        GradientMid = Color3.fromRGB(80, 0, 40),
        GradientEnd = Color3.fromRGB(255, 100, 180),
        Stroke = Color3.fromRGB(180, 50, 120),
        Text = Color3.fromRGB(255, 255, 255),
    },
    ["Orange"] = {
        GradientStart = Color3.fromRGB(255, 140, 0),
        GradientMid = Color3.fromRGB(100, 40, 0),
        GradientEnd = Color3.fromRGB(255, 140, 0),
        Stroke = Color3.fromRGB(180, 90, 0),
        Text = Color3.fromRGB(255, 255, 255),
    },
    ["Yellow"] = {
        GradientStart = Color3.fromRGB(255, 220, 0),
        GradientMid = Color3.fromRGB(100, 80, 0),
        GradientEnd = Color3.fromRGB(255, 220, 0),
        Stroke = Color3.fromRGB(180, 150, 0),
        Text = Color3.fromRGB(0, 0, 0),
    },
    ["Aqua"] = {
        GradientStart = Color3.fromRGB(0, 200, 255),
        GradientMid = Color3.fromRGB(0, 50, 100),
        GradientEnd = Color3.fromRGB(0, 200, 255),
        Stroke = Color3.fromRGB(0, 130, 180),
        Text = Color3.fromRGB(255, 255, 255),
    },
    ["Blood Red"] = {
        GradientStart = Color3.fromRGB(255, 0, 0),
        GradientMid = Color3.fromRGB(0, 0, 0),
        GradientEnd = Color3.fromRGB(255, 0, 0),
        Stroke = Color3.fromRGB(139, 0, 0),
        Text = Color3.fromRGB(255, 255, 255),
    },
    ["Amethyst"] = {
        GradientStart = Color3.fromRGB(160, 0, 255),
        GradientMid = Color3.fromRGB(40, 0, 70),
        GradientEnd = Color3.fromRGB(160, 0, 255),
        Stroke = Color3.fromRGB(110, 0, 180),
        Text = Color3.fromRGB(255, 255, 255),
    },
    ["Cherry"] = {
        GradientStart = Color3.fromRGB(255, 100, 150),
        GradientMid = Color3.fromRGB(80, 0, 30),
        GradientEnd = Color3.fromRGB(255, 100, 150),
        Stroke = Color3.fromRGB(180, 50, 100),
        Text = Color3.fromRGB(255, 255, 255),
    },
    ["Ocean"] = {
        GradientStart = Color3.fromRGB(0, 120, 255),
        GradientMid = Color3.fromRGB(0, 30, 80),
        GradientEnd = Color3.fromRGB(0, 120, 255),
        Stroke = Color3.fromRGB(0, 80, 160),
        Text = Color3.fromRGB(255, 255, 255),
    },
    ["Sunset"] = {
        GradientStart = Color3.fromRGB(255, 150, 0),
        GradientMid = Color3.fromRGB(100, 30, 0),
        GradientEnd = Color3.fromRGB(255, 150, 0),
        Stroke = Color3.fromRGB(180, 90, 0),
        Text = Color3.fromRGB(255, 255, 255),
    },
    ["Mint"] = {
        GradientStart = Color3.fromRGB(100, 255, 180),
        GradientMid = Color3.fromRGB(0, 80, 50),
        GradientEnd = Color3.fromRGB(100, 255, 180),
        Stroke = Color3.fromRGB(50, 180, 120),
        Text = Color3.fromRGB(0, 0, 0),
    },
    ["Lavender"] = {
        GradientStart = Color3.fromRGB(200, 150, 255),
        GradientMid = Color3.fromRGB(70, 40, 120),
        GradientEnd = Color3.fromRGB(200, 150, 255),
        Stroke = Color3.fromRGB(140, 100, 200),
        Text = Color3.fromRGB(255, 255, 255),
    },
    ["Coffee"] = {
        GradientStart = Color3.fromRGB(120, 80, 60),
        GradientMid = Color3.fromRGB(50, 30, 20),
        GradientEnd = Color3.fromRGB(120, 80, 60),
        Stroke = Color3.fromRGB(80, 50, 35),
        Text = Color3.fromRGB(255, 255, 255),
    },
    ["Rose"] = {
        GradientStart = Color3.fromRGB(255, 80, 120),
        GradientMid = Color3.fromRGB(120, 20, 50),
        GradientEnd = Color3.fromRGB(255, 80, 120),
        Stroke = Color3.fromRGB(200, 40, 80),
        Text = Color3.fromRGB(255, 255, 255),
    },
    ["Default"] = {
        GradientStart = Color3.fromRGB(100, 100, 100),
        GradientMid = Color3.fromRGB(30, 30, 30),
        GradientEnd = Color3.fromRGB(100, 100, 100),
        Stroke = Color3.fromRGB(80, 80, 80),
        Text = Color3.fromRGB(255, 255, 255),
    },
}

local function getThemeColors(themeName)
    return THEME_COLORS[themeName] or THEME_COLORS["Default"]
end

local function applyThemeToButton(entry, themeName)
    local colors = getThemeColors(themeName)

    pcall(function()
        entry.gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, colors.GradientStart),
            ColorSequenceKeypoint.new(0.5, colors.GradientMid),
            ColorSequenceKeypoint.new(1, colors.GradientEnd)
        }
    end)

    pcall(function()
        entry.stroke.Color = colors.Stroke
    end)

    pcall(function()
        entry.label.TextColor3 = colors.Text
    end)
end

local function applyThemeToAll(themeName)
    currentTheme = themeName
    for _, entry in ipairs(buttonRegistry) do
        if entry.button and entry.button.Parent then
            applyThemeToButton(entry, themeName)
        end
    end
end

local function createGradientButton(parent, position, size, text, onClickCallback)
    local button = Instance.new("Frame")
    button.Name = "GradientBtn"
    button.BackgroundTransparency = 0.7
    button.Size = size
    button.Position = position
    button.Draggable = true
    button.Active = true
    button.Selectable = true
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.2, 0)
    corner.Parent = button

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    }
    gradient.Rotation = 0
    gradient.Parent = button

    local gradientAnimation
    gradientAnimation = RunService.RenderStepped:Connect(function(delta)
        gradient.Rotation = (gradient.Rotation + 90 * delta) % 360
    end)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(139, 0, 0)
    stroke.Thickness = 2
    stroke.Parent = button

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 16
    label.Font = Enum.Font.GothamBold
    label.Parent = button

    local clicker = Instance.new("TextButton")
    clicker.Size = UDim2.new(1, 0, 1, 0)
    clicker.BackgroundTransparency = 1
    clicker.Text = ""
    clicker.ZIndex = 5
    clicker.Parent = button

    local entry = {
        button = button,
        gradient = gradient,
        stroke = stroke,
        label = label,
        clicker = clicker,
    }
    table.insert(buttonRegistry, entry)

    if currentTheme then
        applyThemeToButton(entry, currentTheme)
    end

    button.Destroying:Connect(function()
        if gradientAnimation then
            gradientAnimation:Disconnect()
        end

        for i, e in ipairs(buttonRegistry) do
            if e == entry then
                table.remove(buttonRegistry, i)
                break
            end
        end
    end)

    local activeTouchId = nil
    local startPos = nil
    local startButtonPos = nil

    local function updateButtonPosition(touchPos)
        if not startPos or not startButtonPos then return end
        local delta = touchPos - startPos
        button.Position = UDim2.new(startButtonPos.X.Scale, startButtonPos.X.Offset + delta.X,
                                    startButtonPos.Y.Scale, startButtonPos.Y.Offset + delta.Y)
    end

    local function resetDrag()
        activeTouchId = nil
        startPos = nil
        startButtonPos = nil
        local colors = getThemeColors(currentTheme)
        stroke.Color = colors.Stroke
    end

    clicker.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            local touchId = input.UserInputState

            if activeTouchId ~= nil then
                return
            end

            activeTouchId = touchId
            startPos = input.Position
            startButtonPos = button.Position

            local colors = getThemeColors(currentTheme)
            stroke.Color = colors.GradientStart

            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resetDrag()
                    connection:Disconnect()
                end
            end)

        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            if activeTouchId ~= nil then return end

            activeTouchId = "mouse"
            startPos = input.Position
            startButtonPos = button.Position

            local colors = getThemeColors(currentTheme)
            stroke.Color = colors.GradientStart

            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resetDrag()
                    connection:Disconnect()
                end
            end)
        end
    end)

    clicker.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            if activeTouchId ~= nil then
                updateButtonPosition(input.Position)
            end
        elseif input.UserInputType == Enum.UserInputType.MouseMovement then
            if activeTouchId ~= nil then
                updateButtonPosition(input.Position)
            end
        end
    end)

    if onClickCallback then
        clicker.MouseButton1Click:Connect(onClickCallback)
    end

    return button, clicker, stroke
end

local function setTheme(themeName)
    applyThemeToAll(themeName)
end

local function getTheme()
    return currentTheme
end

return {
    createGradientButton = createGradientButton,
    setTheme = setTheme,
    getTheme = getTheme,
}
