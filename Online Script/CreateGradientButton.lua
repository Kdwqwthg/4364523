local RunService = game:GetService("RunService")

local buttonRegistry = {}
local currentTheme = nil

local THEME_COLORS = {
    ["Ash Gray"] = {
        GradientStart = Color3.fromRGB(150, 150, 150),
        GradientMid = Color3.fromRGB(60, 60, 60),
        GradientEnd = Color3.fromRGB(150, 150, 150),
        Stroke = Color3.fromRGB(90, 90, 90),
        Text = Color3.fromRGB(255, 255, 255),
    },
    ["Pearl White"] = {
        GradientStart = Color3.fromRGB(255, 255, 255),
        GradientMid = Color3.fromRGB(220, 220, 220),
        GradientEnd = Color3.fromRGB(255, 255, 255),
        Stroke = Color3.fromRGB(180, 180, 180),
        Text = Color3.fromRGB(20, 20, 20),
    },
    ["Charcoal"] = {
        GradientStart = Color3.fromRGB(40, 40, 40),
        GradientMid = Color3.fromRGB(20, 20, 20),
        GradientEnd = Color3.fromRGB(40, 40, 40),
        Stroke = Color3.fromRGB(60, 60, 60),
        Text = Color3.fromRGB(255, 255, 255),
    },
    ["Blood Red"] = {
        GradientStart = Color3.fromRGB(159, 0, 0),
        GradientMid = Color3.fromRGB(71, 0, 0),
        GradientEnd = Color3.fromRGB(141, 0, 0),
        Stroke = Color3.fromRGB(155, 18, 28),
        Text = Color3.fromRGB(255, 230, 230),
    },
    ["Deep Violet"] = {
        GradientStart = Color3.fromRGB(160, 120, 220),
        GradientMid = Color3.fromRGB(40, 25, 65),
        GradientEnd = Color3.fromRGB(40, 25, 65),
        Stroke = Color3.fromRGB(110, 90, 130),
        Text = Color3.fromRGB(240, 240, 240),
    },
    ["Neon Purple"] = {
        GradientStart = Color3.fromRGB(171, 32, 253),
        GradientMid = Color3.fromRGB(32, 5, 137),
        GradientEnd = Color3.fromRGB(125, 18, 255),
        Stroke = Color3.fromRGB(60, 0, 150),
        Text = Color3.fromRGB(252, 245, 255),
    },
    ["Deep Ocean"] = {
        GradientStart = Color3.fromRGB(0, 200, 255),
        GradientMid = Color3.fromRGB(0, 60, 90),
        GradientEnd = Color3.fromRGB(0, 120, 180),
        Stroke = Color3.fromRGB(0, 100, 150),
        Text = Color3.fromRGB(240, 248, 255),
    },
    ["Midnight Blue"] = {
        GradientStart = Color3.fromRGB(140, 120, 240),
        GradientMid = Color3.fromRGB(25, 15, 60),
        GradientEnd = Color3.fromRGB(80, 60, 170),
        Stroke = Color3.fromRGB(60, 45, 140),
        Text = Color3.fromRGB(220, 220, 255),
    },
    ["Royal Blue"] = {
        GradientStart = Color3.fromRGB(50, 120, 230),
        GradientMid = Color3.fromRGB(20, 40, 85),
        GradientEnd = Color3.fromRGB(13, 75, 170),
        Stroke = Color3.fromRGB(10, 65, 150),
        Text = Color3.fromRGB(220, 235, 255),
    },
    ["Galaxy Purple"] = {
        GradientStart = Color3.fromRGB(195, 100, 255),
        GradientMid = Color3.fromRGB(48, 18, 85),
        GradientEnd = Color3.fromRGB(130, 50, 195),
        Stroke = Color3.fromRGB(125, 45, 190),
        Text = Color3.fromRGB(242, 232, 255),
    },
    ["Cosmic Violet"] = {
        GradientStart = Color3.fromRGB(115, 90, 175),
        GradientMid = Color3.fromRGB(35, 25, 65),
        GradientEnd = Color3.fromRGB(60, 42, 120),
        Stroke = Color3.fromRGB(55, 38, 115),
        Text = Color3.fromRGB(230, 225, 245),
    },
    ["AMOLED"] = {
        GradientStart = Color3.fromRGB(30, 30, 30),
        GradientMid = Color3.fromRGB(0, 0, 0),
        GradientEnd = Color3.fromRGB(30, 30, 30),
        Stroke = Color3.fromRGB(60, 60, 60),
        Text = Color3.fromRGB(255, 255, 255),
    },
    ["RGB"] = {
        GradientStart = Color3.fromRGB(0, 255, 180),
        GradientMid = Color3.fromRGB(120, 0, 255),
        GradientEnd = Color3.fromRGB(255, 0, 150),
        Stroke = Color3.fromRGB(0, 255, 180),
        Text = Color3.fromRGB(220, 255, 245),
    },
    ["Neon Cyber"] = {
        GradientStart = Color3.fromRGB(57, 255, 20),
        GradientMid = Color3.fromRGB(5, 30, 5),
        GradientEnd = Color3.fromRGB(35, 160, 15),
        Stroke = Color3.fromRGB(35, 160, 15),
        Text = Color3.fromRGB(200, 255, 190),
    },
    ["Arctic Frost"] = {
        GradientStart = Color3.fromRGB(255, 255, 255),
        GradientMid = Color3.fromRGB(200, 235, 255),
        GradientEnd = Color3.fromRGB(190, 225, 248),
        Stroke = Color3.fromRGB(150, 200, 235),
        Text = Color3.fromRGB(20, 40, 70),
    },
    ["Cotton Candy"] = {
        GradientStart = Color3.fromRGB(220, 180, 255),
        GradientMid = Color3.fromRGB(255, 180, 220),
        GradientEnd = Color3.fromRGB(250, 198, 232),
        Stroke = Color3.fromRGB(228, 172, 213),
        Text = Color3.fromRGB(75, 25, 55),
    },
    ["Orange"] = {
        GradientStart = Color3.fromRGB(255, 140, 30),
        GradientMid = Color3.fromRGB(30, 10, 0),
        GradientEnd = Color3.fromRGB(40, 18, 4),
        Stroke = Color3.fromRGB(180, 80, 10),
        Text = Color3.fromRGB(255, 240, 220),
    },
    ["Cyanic"] = {
        GradientStart = Color3.fromRGB(57, 197, 187),
        GradientMid = Color3.fromRGB(10, 40, 50),
        GradientEnd = Color3.fromRGB(18, 55, 65),
        Stroke = Color3.fromRGB(35, 155, 150),
        Text = Color3.fromRGB(210, 248, 246),
    },
    ["Amber Glow"] = {
        GradientStart = Color3.fromRGB(255, 170, 40),
        GradientMid = Color3.fromRGB(50, 22, 4),
        GradientEnd = Color3.fromRGB(60, 30, 6),
        Stroke = Color3.fromRGB(185, 120, 25),
        Text = Color3.fromRGB(255, 245, 225),
    },
    ["Bloomings"] = {
        GradientStart = Color3.fromRGB(255, 100, 180),
        GradientMid = Color3.fromRGB(80, 25, 60),
        GradientEnd = Color3.fromRGB(220, 60, 130),
        Stroke = Color3.fromRGB(200, 70, 150),
        Text = Color3.fromRGB(255, 240, 248),
    },
    ["Crimson"] = {
        GradientStart = Color3.fromRGB(220, 30, 60),
        GradientMid = Color3.fromRGB(18, 3, 8),
        GradientEnd = Color3.fromRGB(50, 5, 15),
        Stroke = Color3.fromRGB(160, 20, 45),
        Text = Color3.fromRGB(255, 235, 240),
    },
    ["Gold"] = {
        GradientStart = Color3.fromRGB(255, 210, 120),
        GradientMid = Color3.fromRGB(60, 40, 10),
        GradientEnd = Color3.fromRGB(60, 40, 10),
        Stroke = Color3.fromRGB(120, 90, 30),
        Text = Color3.fromRGB(240, 240, 240),
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
