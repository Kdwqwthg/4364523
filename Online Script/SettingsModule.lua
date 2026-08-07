local Settings = {}

function Settings.init(deps)
    local Window = deps.Window
    local Fluent = deps.Fluent
    local Options = deps.Options
    local SaveManager = deps.SaveManager
    local InterfaceManager = deps.InterfaceManager
    local FloatingButton = deps.FloatingButton
    local createSimpleTimer = deps.createSimpleTimer
    local LocalPlayer = deps.LocalPlayer

    local SettingsTab = Window:AddTab({ Title = "Settings", Icon = "solar/settings-bold", Favoriteable = true })

SettingsTab:AddSection("Configuration", "solar/settings-bold")

SettingsTab:AddSection("FPS, Ping, Timer Settings", "solar/chart-bold")

local function setFPSTimerVisible(state)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local timerGUI = PlayerGui:FindFirstChild("DraconicFPS")

    if state then
        if not timerGUI then
            createSimpleTimer()
        else
            timerGUI.Enabled = true
        end
    elseif timerGUI then
        timerGUI.Enabled = false
    end
end

local FPSTimerToggle = SettingsTab:AddToggle("FPSTimerToggle", {
    Title = "Show FPS, Ping, Timer",
    Description = "Display FPS and session timer",
    Default = true,
    Callback = setFPSTimerVisible
})

FPSTimerToggle:OnChanged(setFPSTimerVisible)

task.spawn(function()
    task.wait(1.35)
    if Options.FPSTimerToggle then
        setFPSTimerVisible(Options.FPSTimerToggle.Value)
    end
end)

SettingsTab:AddSection("Interface Manager", "solar/widget-bold")
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("DraconicXEvade")
InterfaceManager:BuildInterfaceSection(SettingsTab)

SettingsTab:AddSection("Save Manager", "solar/diskette-bold")
SaveManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("DraconicXEvade/Config")
SaveManager:BuildConfigSection(SettingsTab)

task.spawn(function()
    task.wait(1)
    SaveManager:LoadAutoloadConfig()
end)

SettingsTab:AddSection("GUI Button Sizes", "solar/widget-2-bold")

RespawnButtonSizeInput = SettingsTab:AddInput("RespawnButtonSizeInput", {
    Title = "Respawn Button Size",
    Default = "180",
    Placeholder = "Enter size (150-400)",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        if Value and tonumber(Value) then
            local size = tonumber(Value)
            local CoreGui = game:GetService("CoreGui")
            local existingScreenGui = CoreGui:FindFirstChild("DraconicRespawnButtonGUI")

            if existingScreenGui then
                local button = existingScreenGui:FindFirstChild("GradientBtn")
                if button then
                    local newWidth = math.max(150, math.min(size, 400))
                    local newHeight = math.max(60, math.min(size * 0.4, 160))
                    button.Size = UDim2.new(0, newWidth, 0, newHeight)
                end
            end
        end
    end
})

InstantReviveButtonSizeInput = SettingsTab:AddInput("InstantReviveButtonSizeInput", {
    Title = "Instant Revive Button Size",
    Default = "180",
    Placeholder = "Enter size (150-400)",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        if Value and tonumber(Value) then
            local size = tonumber(Value)
            local CoreGui = game:GetService("CoreGui")
            local existingScreenGui = CoreGui:FindFirstChild("InstantReviveButtonGUI")

            if existingScreenGui then
                local button = existingScreenGui:FindFirstChild("GradientBtn")
                if button then
                    local uiScale = button:FindFirstChild("UIScale")
                    if uiScale then
                        uiScale:Destroy()
                    end
                    local newWidth = math.max(150, math.min(size, 400))
                    local newHeight = math.max(60, math.min(size * 0.4, 160))
                    button.Size = UDim2.new(0, newWidth, 0, newHeight)
                end
            end
        end
    end
})

CarryButtonSizeInput = SettingsTab:AddInput("CarryButtonSizeInput", {
    Title = "Carry Button Size",
    Default = "180",
    Placeholder = "Enter size (150-400)",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        if Value and tonumber(Value) then
            local size = tonumber(Value)
            local CoreGui = game:GetService("CoreGui")
            local existingScreenGui = CoreGui:FindFirstChild("AutoCarryButtonGUI")

            if existingScreenGui then
                local button = existingScreenGui:FindFirstChild("GradientBtn")
                if button then
                    local newWidth = math.max(150, math.min(size, 400))
                    local newHeight = math.max(60, math.min(size * 0.4, 160))
                    button.Size = UDim2.new(0, newWidth, 0, newHeight)
                end
            end
        end
    end
})

SlideButtonScaleInput = SettingsTab:AddInput("SlideButtonScaleInput", {
    Title = "Sprint Slide Button Size",
    Default = "180",
    Placeholder = "Enter size (150-400)",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        if Value and tonumber(Value) then
            local size = tonumber(Value)
            local CoreGui = game:GetService("CoreGui")
            local existingScreenGui = CoreGui:FindFirstChild("SlideButtonGUI")

            if existingScreenGui then
                local button = existingScreenGui:FindFirstChild("GradientBtn")
                if button then
                    local uiScale = button:FindFirstChild("UIScale")
                    if uiScale then
                        uiScale:Destroy()
                    end
                    local newWidth = math.max(150, math.min(size, 400))
                    local newHeight = math.max(60, math.min(size * 0.4, 160))
                    button.Size = UDim2.new(0, newWidth, 0, newHeight)
                end
            end
        end
    end
})

GravityButtonSizeInput = SettingsTab:AddInput("GravityButtonSizeInput", {
    Title = "Gravity Button Size",
    Default = "180",
    Placeholder = "Enter size (150-400)",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        if Value and tonumber(Value) then
            local size = tonumber(Value)
            local CoreGui = game:GetService("CoreGui")
            local existingScreenGui = CoreGui:FindFirstChild("GravityButtonGUI")

            if existingScreenGui then
                local button = existingScreenGui:FindFirstChild("GradientBtn")
                if button then
                    local uiScale = button:FindFirstChild("UIScale")
                    if uiScale then
                        uiScale:Destroy()
                    end
                    local newWidth = math.max(150, math.min(size, 400))
                    local newHeight = math.max(60, math.min(size * 0.4, 160))
                    button.Size = UDim2.new(0, newWidth, 0, newHeight)
                end
            end
        end
    end
})

BhopButtonScaleInput = SettingsTab:AddInput("BhopButtonScaleInput", {
    Title = "Auto Jump Button Size",
    Default = "180",
    Placeholder = "Enter size (150-400)",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        if Value and tonumber(Value) then
            local size = tonumber(Value)
            local CoreGui = game:GetService("CoreGui")
            local existingScreenGui = CoreGui:FindFirstChild("BhopButtonGUI")

            if existingScreenGui then
                local button = existingScreenGui:FindFirstChild("GradientBtn")
                if button then
                    local uiScale = button:FindFirstChild("UIScale")
                    if uiScale then
                        uiScale:Destroy()
                    end
                    local newWidth = math.max(150, math.min(size, 400))
                    local newHeight = math.max(60, math.min(size * 0.4, 160))
                    button.Size = UDim2.new(0, newWidth, 0, newHeight)
                end
            end
        end
    end
})

LagSwitchScaleInput = SettingsTab:AddInput("LagSwitchScaleInput", {
    Title = "Lag Switch Button Size",
    Default = "180",
    Placeholder = "Enter size (150-400)",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        if Value and tonumber(Value) then
            local size = tonumber(Value)
            local CoreGui = game:GetService("CoreGui")
            local existingScreenGui = CoreGui:FindFirstChild("LagSwitchButtonGUI")

            if existingScreenGui then
                local button = existingScreenGui:FindFirstChild("GradientBtn")
                if button then
                    local uiScale = button:FindFirstChild("UIScale")
                    if uiScale then
                        uiScale:Destroy()
                    end
                    local newWidth = math.max(150, math.min(size, 400))
                    local newHeight = math.max(60, math.min(size * 0.4, 160))
                    button.Size = UDim2.new(0, newWidth, 0, newHeight)
                end
            end
        end
    end
})

SettingsTab:AddSection("Floating Menu Button", "solar/widget-2-bold")

FloatingButtonSizeInput = SettingsTab:AddInput("FloatingButtonSizeInput", {
    Title = "Floating Button Size",
    Default = "120",
    Placeholder = "Width px (80-400), base 120",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        if Value and tonumber(Value) and FloatingButton.setSize then
            FloatingButton.setSize(Value)
        end
    end
})

FloatingButtonSizeInput:OnChanged(function(Value)
    if Value and tonumber(Value) and FloatingButton.setSize then
        FloatingButton.setSize(Value)
    end
end)

FloatingButtonInvisibleToggle = SettingsTab:AddToggle("FloatingButtonInvisibleToggle", {
    Title = "Floating Button invisible",
    Description = "Hides icon but keeps it clickable",
    Default = false,
    Callback = function(Value)
        if FloatingButton.setStealth then
            FloatingButton.setStealth(Value)
        end
    end
})

FloatingButtonInvisibleToggle:OnChanged(function(Value)
    if FloatingButton.setStealth then
        FloatingButton.setStealth(Value)
    end
end)

task.spawn(function()
    task.wait(1.35)
    if Options.FloatingButtonSizeInput and tonumber(Options.FloatingButtonSizeInput.Value) and FloatingButton.setSize then
        FloatingButton.setSize(Options.FloatingButtonSizeInput.Value)
    end
    if Options.FloatingButtonInvisibleToggle and Options.FloatingButtonInvisibleToggle.Value and FloatingButton.setStealth then
        FloatingButton.setStealth(true)
    end
end)

SettingsTab:AddSection("Button Positions", "solar/cursor-bold")

local ButtonPositions = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kdwqwthg/4364523/refs/heads/main/Online%20Script/ButtonPositions.lua"))()

SettingsTab:AddButton({
    Title = "Save Button Positions",
    Description = "Save current positions of all GUI buttons",
    Callback = function()
        local success, msg = ButtonPositions:Save()
        Fluent:Notify({
            Title = "Button Positions",
            Content = msg,
            Duration = 3
        })
    end
})

SettingsTab:AddButton({
    Title = "Load Button Positions",
    Description = "Load saved button positions from file",
    Callback = function()
        local success, msg = ButtonPositions:Load()
        Fluent:Notify({
            Title = "Button Positions",
            Content = msg,
            Duration = 3
        })
    end
})

SettingsTab:AddButton({
    Title = "Reset Button Positions",
    Description = "Reset all buttons to default positions",
    Callback = function()
        Window:Dialog({
            Title = "Reset Button Positions",
            Content = "Are you sure you want to reset all button positions to default?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        ButtonPositions:Reset()
                        Fluent:Notify({
                            Title = "Button Positions",
                            Content = "All buttons reset to default positions!",
                            Duration = 3
                        })
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                    end
                }
            }
        })
    end
})

local InfoTab = Window:AddTab({ Title = "Info", Icon = "solar/info-circle-bold", Favoriteable = true })

InfoTab:AddSection("Telegram Support", "solar/chat-round-bold")

InfoTab:AddParagraph({
    Title = "Telegram Support",
    Content = "Join our Telegram channel for updates and support"
})

InfoTab:AddButton({
    Title = "Copy Telegram Link",
    Description = "Click to copy Telegram link to clipboard",
    Callback = function()
        local telegramLink = "https://t.me/DraconicHub"
        
        
        setclipboard(telegramLink)
        
        Fluent:Notify({
            Title = "Telegram",
            Content = "Link copied to clipboard!",
            Duration = 3
        })
    end
})

InfoTab:AddSection("Discord Support", "solar/users-group-rounded-bold")

InfoTab:AddParagraph({
    Title = "Discord Server Support",
    Content = "Join our Discord Server for updates and support"
})

InfoTab:AddButton({
    Title = "Copy Discord Link",
    Description = "Click to copy Discord link to clipboard",
    Callback = function()
        local telegramLink = "https://discord.gg/F74VB7u"
        
        
        setclipboard(telegramLink)
        
        Fluent:Notify({
            Title = "Discord",
            Content = "Link copied to clipboard!",
            Duration = 3
        })
    end
})

Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()

end

return Settings
