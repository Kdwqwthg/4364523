local Misc = {}

function Misc.init(deps)
    local Window = deps.Window
    local Fluent = deps.Fluent
    local Options = deps.Options
    local createGradientButton = deps.createGradientButton
    local RunService = deps.RunService or game:GetService("RunService")
    local Players = deps.Players or game:GetService("Players")
    local LocalPlayer = deps.LocalPlayer or Players.LocalPlayer
    local ReplicatedStorage = deps.ReplicatedStorage or game:GetService("ReplicatedStorage")
    local featureStates = deps.featureStates

    MiscTab = Window:AddTab({ Title = "Misc", Icon = "star", Favoriteable = true })
    MiscTab:AddSection("Player Adjustments", "solar/user-rounded-bold")

    local currentSettings = {
    Speed = 1500,
    JumpPower = 3.5,
    JumpCap = 2,
    JumpSpeedMultiplier = 1.5,
    FOV = 70
}

local BaseStatsModule = nil

for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
    if obj:IsA("ModuleScript") and obj.Name == "BaseStats" then
        local success, module = pcall(function() return require(obj) end)
        if success and module then
            BaseStatsModule = module
            break
        end
    end
end

if not BaseStatsModule then
    for _, obj in ipairs(getgc(true)) do
        if type(obj) == "table" and rawget(obj, "Speed") ~= nil and rawget(obj, "JumpCap") ~= nil then
            BaseStatsModule = obj
            break
        end
    end
end

local function applyFOV(value)
    local Event = ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("UserData") and ReplicatedStorage.Shared.UserData:FindFirstChild("Events") and ReplicatedStorage.Shared.UserData.Events:FindFirstChild("Requests") and ReplicatedStorage.Shared.UserData.Events.Requests:FindFirstChild("SetSetting")
    if Event then
        Event:FireServer("FOV", value)
    end
    local camera = workspace.CurrentCamera
    if camera then
        camera.FieldOfView = value
    end
end

local function applyAll()
    if BaseStatsModule then
        BaseStatsModule.Speed = currentSettings.Speed
        BaseStatsModule.JumpHeight = currentSettings.JumpPower
        BaseStatsModule.JumpCap = currentSettings.JumpCap
        BaseStatsModule.JumpSpeedMultiplier = currentSettings.JumpSpeedMultiplier
    end
    
    local char = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild(LocalPlayer.Name)
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = currentSettings.Speed
            humanoid.JumpPower = currentSettings.JumpPower
        end
        char:SetAttribute("JumpCap", currentSettings.JumpCap)
    end
    
    applyFOV(currentSettings.FOV)
end


MiscTab:AddInput("SpeedInput", {
    Title = "Player Speed",
    Default = "1500",
    Placeholder = "Default 1500",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local val = tonumber(Value)
        if val and val >= 1 and val <= 100000000 then
            currentSettings.Speed = val
            applyAll()
        end
    end
})

MiscTab:AddInput("JumpPowerInput", {
    Title = "Player Jump",
    Default = "3.5",
    Placeholder = "Default 3.5",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local val = tonumber(Value)
        if val and val >= 0.1 and val <= 100000000 then
            currentSettings.JumpPower = val
            applyAll()
        end
    end
})

MiscTab:AddInput("JumpCapInput", {
    Title = "Player Jump Cap",
    Default = "2",
    Placeholder = "Default 2",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local val = tonumber(Value)
        if val and val >= 0.1 and val <= 100000000 then
            currentSettings.JumpCap = val
            applyAll()
        end
    end
})

MiscTab:AddInput("StrafeInput", {
    Title = "Player Strafe Acceleration",
    Default = "1.5",
    Placeholder = "Default 1.5",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local val = tonumber(Value)
        if val and val >= 0.1 and val <= 100 then
            currentSettings.JumpSpeedMultiplier = val
            applyAll()
        end
    end
})

MiscTab:AddInput("FovInput", {
    Title = "Player FOV",
    Default = "70",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local val = tonumber(Value)
        if val and val >= 70 and val <= 120 then
            currentSettings.FOV = val
            applyAll()
        end
    end
})

spawn(function()
    while task.wait(0.05) do
        applyAll()
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.3)
    applyAll()
end)

task.wait(0.3)
applyAll()

MiscTab:AddSection("Bounce", "solar/transfer-vertical-bold")

BounceToggle = MiscTab:AddToggle("BounceToggle", {
    Title = "Modify Bounce",
    Default = false
})

BounceInput = MiscTab:AddInput("BounceInput", {
    Title = "Player Bounce",
    Default = "110",
    Placeholder = "Enter bounce speed",
    Numeric = true,
    Finished = false
})

local bounceConnection = nil
local player = game:GetService("Players").LocalPlayer

local function updateBounce()
    if not BounceToggle.Value then return end
    
    local gamePlayers = workspace.Game:FindFirstChild("Players")
    if not gamePlayers then return end
    
    local playerModel = gamePlayers:FindFirstChild(player.Name)
    if not playerModel then return end
    
    local humanoid = playerModel:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local speedValue = tonumber(BounceInput.Value) or 110
    humanoid.WalkSpeed = speedValue
end

BounceToggle:OnChanged(function(state)
    if state then
        
        if bounceConnection then
            bounceConnection:Disconnect()
        end
        
        bounceConnection = game:GetService("RunService").Heartbeat:Connect(updateBounce)
    else
        if bounceConnection then
            bounceConnection:Disconnect()
            bounceConnection = nil
        end
        
        
        local gamePlayers = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
        if gamePlayers then
            local playerModel = gamePlayers:FindFirstChild(player.Name)
            if playerModel then
                local humanoid = playerModel:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 0  
                end
            end
        end
    end
end)

BounceInput:OnChanged(function(Value)
    if BounceToggle.Value then
        local gamePlayers = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
        if gamePlayers then
            local playerModel = gamePlayers:FindFirstChild(player.Name)
            if playerModel then
                local humanoid = playerModel:FindFirstChild("Humanoid")
                if humanoid then
                    local speedValue = tonumber(Value) or 110
                    humanoid.WalkSpeed = speedValue
                end
            end
        end
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    if BounceToggle.Value then
        
        task.wait(1)
        updateBounce()
    end
end)

MiscTab:AddSection("Revive Players", "solar/heart-pulse-bold")

local InstantReviveToggle = MiscTab:AddToggle("InstantReviveToggle", {
    Title = "Instant Revive",
    Default = false
})

local ReviveDelaySlider = MiscTab:AddSlider("ReviveDelaySlider", {
    Title = "Revive Delay",
    Min = 0,
    Max = 1,
    Default = 0.15,
    Rounding = 2,
    Callback = function(value)
        getgenv().InstantReviveDelay = value
    end
})
getgenv().InstantReviveDelay = 0.15

local InstantReviveModule = (function()
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LocalPlayer = Players.LocalPlayer
    local Workspace = game:GetService("Workspace")

    local reviveRange = 10
    local loopDelay = getgenv().InstantReviveDelay or 0.15

    local enabled = false
    local handle = nil

    local InteractRemote = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("Interact")

    local function getPlayerTag(pl)
        if not pl then return nil end
        local char = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild(pl.Name)
        if char then
            return char:GetAttribute("Tag")
        end
        return nil
    end

    local function reviveLoop()
        while enabled do
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myHRP then
                task.wait(loopDelay)
                continue
            end

            local playersFolder = Workspace:FindFirstChild("Players")
            if not playersFolder then
                task.wait(loopDelay)
                continue
            end

            for _, otherChar in ipairs(playersFolder:GetChildren()) do
                if otherChar.Name ~= LocalPlayer.Name then
                    local otherTag = otherChar:GetAttribute("Tag")
                    if otherTag then
                        local otherHrp = otherChar:FindFirstChild("HumanoidRootPart")
                        if otherHrp then
                            local dist = (myHRP.Position - otherHrp.Position).Magnitude
                            if dist <= reviveRange then
                                if InteractRemote then
                                    InteractRemote:FireServer("Revive", otherTag)
                                    task.wait(0.05)
                                    InteractRemote:FireServer("Revive", otherTag, true)
                                end
                                task.wait(0.1)
                            end
                        end
                    end
                end
            end

            task.wait(loopDelay)
        end
    end

    local function start()
        if handle then return end
        enabled = true
        handle = task.spawn(reviveLoop)
    end

    local function stop()
        enabled = false
        if handle then task.cancel(handle) handle = nil end
    end

    return {
        Start = start,
        Stop = stop,
        SetDelay = function(d) loopDelay = d end,
    }
end)()

InstantReviveToggle:OnChanged(function(state)
    if state then
        InstantReviveModule.SetDelay(getgenv().InstantReviveDelay)
        InstantReviveModule.Start()
    else
        InstantReviveModule.Stop()
    end
end)

ReviveDelaySlider:OnChanged(function(value)
    getgenv().InstantReviveDelay = value
    InstantReviveModule.SetDelay(value)
end)

local instantReviveButtonScreenGui = nil
local instantReviveButton = nil
local instantReviveKeybindValue = "R"
local instantReviveButtonState = false

local function createInstantReviveButton()
    local CoreGui = game:GetService("CoreGui")
    
    if instantReviveButtonScreenGui then
        instantReviveButtonScreenGui:Destroy()
        instantReviveButtonScreenGui = nil
    end
    
    instantReviveButtonScreenGui = Instance.new("ScreenGui")
    instantReviveButtonScreenGui.Name = "InstantReviveButtonGUI"
    instantReviveButtonScreenGui.ResetOnSpawn = false
    instantReviveButtonScreenGui.Parent = CoreGui
    
    local buttonSize = 180
    if Options.InstantReviveButtonSizeInput and Options.InstantReviveButtonSizeInput.Value and tonumber(Options.InstantReviveButtonSizeInput.Value) then
        buttonSize = tonumber(Options.InstantReviveButtonSizeInput.Value)
    end
    local btnWidth = math.max(150, math.min(buttonSize, 400))
    local btnHeight = math.max(60, math.min(buttonSize * 0.4, 160))
    
    local btn, clicker, stroke = createGradientButton(
        instantReviveButtonScreenGui,
        UDim2.new(0.5, -btnWidth/2, 0.5, -btnHeight/2),
        UDim2.new(0, btnWidth, 0, btnHeight),
        instantReviveButtonState and "Instant Revive:On" or "Instant Revive:Off"
    )
    
    clicker.MouseButton1Click:Connect(function()
        instantReviveButtonState = not instantReviveButtonState
        
        if btn:FindFirstChild("TextLabel") then
            btn.TextLabel.Text = instantReviveButtonState and "Instant Revive:On" or "Instant Revive:Off"
        end
        
        if instantReviveButtonState then
            InstantReviveModule.SetDelay(getgenv().InstantReviveDelay)
            InstantReviveModule.Start()
        else
            InstantReviveModule.Stop()
        end
        
        if Options.InstantReviveToggle then
            Options.InstantReviveToggle:SetValue(instantReviveButtonState)
        end
    end)
    
    instantReviveButton = btn
    return instantReviveButtonScreenGui
end

InstantReviveButtonToggle = MiscTab:AddToggle("InstantReviveButtonToggle", {
    Title = "Instant Revive Button GUI",
    Default = false,
    Callback = function(Value)
        if Value then
            createInstantReviveButton()
        else
            if instantReviveButtonScreenGui then
                instantReviveButtonScreenGui:Destroy()
                instantReviveButtonScreenGui = nil
            end
        end
    end
})

InstantReviveKeybind = MiscTab:AddKeybind("InstantReviveKeybind", {
    Title = "Instant Revive Keybind",
    Mode = "Toggle",
    Default = "R",
    ChangedCallback = function(New)
        instantReviveKeybindValue = New
    end,
    Callback = function()
        instantReviveButtonState = not instantReviveButtonState
        
        if instantReviveButtonState then
            InstantReviveModule.SetDelay(getgenv().InstantReviveDelay)
            InstantReviveModule.Start()
        else
            InstantReviveModule.Stop()
        end
        
        if instantReviveButtonScreenGui and instantReviveButtonScreenGui:FindFirstChild("GradientBtn") then
            local button = instantReviveButtonScreenGui:FindFirstChild("GradientBtn")
            if button and button:FindFirstChild("TextLabel") then
                button.TextLabel.Text = instantReviveButtonState and "Instant Revive:On" or "Instant Revive:Off"
            end
        end
        
        if Options.InstantReviveToggle then
            Options.InstantReviveToggle:SetValue(instantReviveButtonState)
        end
    end
})

InstantReviveToggle:OnChanged(function(Value)
    instantReviveButtonState = Value
    
    if instantReviveButtonScreenGui and instantReviveButtonScreenGui:FindFirstChild("GradientBtn") then
        local button = instantReviveButtonScreenGui:FindFirstChild("GradientBtn")
        if button and button:FindFirstChild("TextLabel") then
            button.TextLabel.Text = instantReviveButtonState and "Instant Revive: On" or "Instant Revive: Off"
        end
    end
end)

InstantReviveButtonToggle:OnChanged(function(Value)
    if Value then
        createInstantReviveButton()
    else
        if instantReviveButtonScreenGui then
            instantReviveButtonScreenGui:Destroy()
            instantReviveButtonScreenGui = nil
        end
    end
end)

MiscTab:AddSection("Carry Players", "solar/users-group-rounded-bold")

AutoCarryToggle = MiscTab:AddToggle("AutoCarryToggle", {
    Title = "Auto Carry",
    Default = false
})

CarryGUIToggle = MiscTab:AddToggle("CarryGUIToggle", {
    Title = "Carry GUI Button",
    Default = false
})

CarryKeybind = MiscTab:AddKeybind("CarryKeybind", {
    Title = "Auto Carry Keybind",
    Mode = "Toggle",
    Default = "F3",
    ChangedCallback = function(New)
    end,
    Callback = function()
        featureStates.AutoCarry = not featureStates.AutoCarry
        if featureStates.AutoCarry then
            startAutoCarry()
        else
            stopAutoCarry()
        end
        if Options.AutoCarryToggle then
            Options.AutoCarryToggle:SetValue(featureStates.AutoCarry)
        end
    end
})

local AutoCarryConnection = nil
local player = LocalPlayer
local Workspace = game:GetService("Workspace")

local InteractRemote = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("Interact")

local isCarrying = false

local function isCarryingPlayer()
    local char = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild(player.Name)
    if char then
        local carryWeld = char:FindFirstChild("CarryWeld")
        if carryWeld then
            isCarrying = true
            return true
        end
        
        local carrying = char:GetAttribute("Carrying")
        if carrying and carrying ~= 0 then
            isCarrying = true
            return true
        end
    end
    
    isCarrying = false
    return false
end

local function startAutoCarry()
    if AutoCarryConnection then 
        AutoCarryConnection:Disconnect()
        AutoCarryConnection = nil
    end
    
    AutoCarryConnection = RunService.Heartbeat:Connect(function()
        if not featureStates.AutoCarry then 
            return 
        end
        
        if isCarryingPlayer() then
            return 
        end
        
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        if hrp then
            local playersFolder = Workspace:FindFirstChild("Players")
            if not playersFolder then return end
            
            for _, otherChar in ipairs(playersFolder:GetChildren()) do
                if otherChar.Name ~= player.Name then
                    local otherTag = otherChar:GetAttribute("Tag")
                    if otherTag then
                        local otherHrp = otherChar:FindFirstChild("HumanoidRootPart")
                        if otherHrp then
                            local dist = (hrp.Position - otherHrp.Position).Magnitude
                            if dist <= 20 then
                                if InteractRemote then
                                    InteractRemote:FireServer("Carry", otherTag)
                                end
                                task.wait(0.01)
                            end
                        end
                    end
                end
            end
        end
    end)
end

local function stopAutoCarry()
    if AutoCarryConnection then
        AutoCarryConnection:Disconnect()
        AutoCarryConnection = nil
    end
    isCarrying = false
end

local function toggleAutoCarryGUI()
    local CoreGui = game:GetService("CoreGui")
    local existingScreenGui = CoreGui:FindFirstChild("AutoCarryButtonGUI")
    
    if existingScreenGui then
        existingScreenGui:Destroy()
    else
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "AutoCarryButtonGUI"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = CoreGui
        
        local buttonSize = 180
        if Options.CarryButtonSizeInput and Options.CarryButtonSizeInput.Value and tonumber(Options.CarryButtonSizeInput.Value) then
            buttonSize = tonumber(Options.CarryButtonSizeInput.Value)
        end
        
        local btnWidth = math.max(150, math.min(buttonSize, 400))
        local btnHeight = math.max(60, math.min(buttonSize * 0.4, 160))
        
        local btn, clicker, stroke = createGradientButton(
            screenGui,
            UDim2.new(0.5, -btnWidth/2, 0.5, -btnHeight/2),
            UDim2.new(0, btnWidth, 0, btnHeight),
            "Auto Carry: Off"
        )
        
        local function updateButtonText()
            if btn and btn:FindFirstChild("TextLabel") then
                local text = isCarrying and "Auto Carry: Carrying" or (featureStates.AutoCarry and "Auto Carry: On" or "Auto Carry: Off")
                btn.TextLabel.Text = text
            end
        end
        
        updateButtonText()
        
        clicker.MouseButton1Click:Connect(function()
            featureStates.AutoCarry = not featureStates.AutoCarry
            updateButtonText()
            
            if featureStates.AutoCarry then
                startAutoCarry()
            else
                stopAutoCarry()
            end
            
            if Options.AutoCarryToggle then
                Options.AutoCarryToggle:SetValue(featureStates.AutoCarry)
            end
        end)
        
        AutoCarryToggle:OnChanged(function(state)
            featureStates.AutoCarry = state
            updateButtonText()
            
            if state then
                startAutoCarry()
            else
                stopAutoCarry()
            end
        end)
    end
end

AutoCarryToggle:OnChanged(function(state)
    featureStates.AutoCarry = state
    
    if state then
        startAutoCarry()
    else
        stopAutoCarry()
    end
end)

CarryGUIToggle:OnChanged(function(state)
    if state then
        toggleAutoCarryGUI()
    else
        local CoreGui = game:GetService("CoreGui")
        local existingScreenGui = CoreGui:FindFirstChild("AutoCarryButtonGUI")
        if existingScreenGui then
            existingScreenGui:Destroy()
        end
    end
end)

local carryWeldConnection
local function setupCarryWeldListener()
    if carryWeldConnection then
        carryWeldConnection:Disconnect()
        carryWeldConnection = nil
    end
    
    local char = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild(player.Name)
    if char then
        carryWeldConnection = char.ChildAdded:Connect(function(child)
            if child.Name == "CarryWeld" then
                isCarrying = true
                updateButtonText()
                print("[AutoCarry] CarryWeld РїРѕСЏРІРёР»СЃСЏ, РѕСЃС‚Р°РЅРѕРІРєР°")
            end
        end)
        
        carryWeldConnection = char.ChildRemoved:Connect(function(child)
            if child.Name == "CarryWeld" then
                isCarrying = false
                updateButtonText()
                print("[AutoCarry] CarryWeld РёСЃС‡РµР·, РїСЂРѕРґРѕР»Р¶РµРЅРёРµ")
            end
        end)
    end
end

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    setupCarryWeldListener()
end)

task.wait(1)
setupCarryWeldListener()

MiscTab:AddSection("Emote Speed", "solar/playback-speed-bold")

local originalEmoteSpeeds = {}
local itemsFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Items")
if itemsFolder then
    local emotesFolder = itemsFolder:FindFirstChild("Emotes")
    if emotesFolder then
        for _, emoteModule in ipairs(emotesFolder:GetChildren()) do
            if emoteModule:IsA("ModuleScript") then
                local success, emoteData = pcall(require, emoteModule)
                if success and emoteData and emoteData.EmoteInfo then
                    originalEmoteSpeeds[emoteModule.Name] = emoteData.EmoteInfo.SpeedMult
                end
            end
        end
    end
end

local function applyEmoteSpeed(speedValue)
    if not itemsFolder then return end
    local emotesFolder = itemsFolder:FindFirstChild("Emotes")
    if not emotesFolder then return end
    
    for _, emoteModule in ipairs(emotesFolder:GetChildren()) do
        if emoteModule:IsA("ModuleScript") then
            local success, emoteData = pcall(require, emoteModule)
            if success and emoteData and emoteData.EmoteInfo and emoteData.EmoteInfo.SpeedMult ~= 0 then
                emoteData.EmoteInfo.SpeedMult = speedValue
            end
        end
    end
end

local function restoreOriginalEmoteSpeeds()
    if not itemsFolder then return end
    local emotesFolder = itemsFolder:FindFirstChild("Emotes")
    if not emotesFolder then return end
    
    for _, emoteModule in ipairs(emotesFolder:GetChildren()) do
        if emoteModule:IsA("ModuleScript") then
            local originalSpeed = originalEmoteSpeeds[emoteModule.Name]
            if originalSpeed then
                local success, emoteData = pcall(require, emoteModule)
                if success and emoteData and emoteData.EmoteInfo then
                    emoteData.EmoteInfo.SpeedMult = originalSpeed
                end
            end
        end
    end
end

local requiredFields = {
    Friction = true,
    AirStrafeAcceleration = true,
    JumpHeight = true,
    RunDeaccel = true,
    JumpSpeedMultiplier = true,
    JumpCap = true,
    SprintCap = true,
    WalkSpeedMultiplier = true,
    BhopEnabled = true,
    Speed = true,
    AirAcceleration = true,
    RunAccel = true,
    SprintAcceleration = true
}

local function getMatchingTables()
    local matched = {}
    for _, obj in pairs(getgc(true)) do
        if typeof(obj) == "table" then
            local ok = true
            for field in pairs(requiredFields) do
                if rawget(obj, field) == nil then
                    ok = false
                    break
                end
            end
            if ok then
                table.insert(matched, obj)
            end
        end
    end
    return matched
end

local function applySpeedMultiplier(speedMultiplier)
    local targets = getMatchingTables()
    for _, tableObj in ipairs(targets) do
        if tableObj and typeof(tableObj) == "table" then
            pcall(function()
                tableObj.WalkSpeedMultiplier = speedMultiplier
            end)
        end
    end
end

local player = game:GetService("Players").LocalPlayer

local function getPlayerObj()
    local gamePlayers = workspace.Game and workspace.Game.Players
    if not gamePlayers then return nil end
    return gamePlayers:FindFirstChild(player.Name)
end

local playerObj = nil
local connection = nil
local emotingSpeed = 1.5

local function setupConnection(obj)
    if connection then 
        connection:Disconnect() 
        connection = nil
    end
    playerObj = obj
    if not obj then return end
    
    local function onStateChanged()
        local state = obj:GetAttribute("State")
        local targetSpeed = (state == "Emoting") and emotingSpeed or 1.5
        applySpeedMultiplier(targetSpeed)
    end
    
    onStateChanged()
    connection = obj:GetAttributeChangedSignal("State"):Connect(onStateChanged)
end

local function resetMultiplierSpeed()
    emotingSpeed = 1.5
    applySpeedMultiplier(1.5)
end

EmoteSpeedModeDropdown = MiscTab:AddDropdown("EmoteSpeedModeDropdown", {
    Title = "Emote speed mode",
    Values = {"Nah", "Legit", "Multiplier speed"},
    Multi = false,
    Default = "Nah",
    Callback = function(Value)
        if Value == "Nah" then
            resetMultiplierSpeed()
            restoreOriginalEmoteSpeeds()
            if connection then 
                connection:Disconnect() 
                connection = nil
            end
        elseif Value == "Multiplier speed" then
            restoreOriginalEmoteSpeeds()
            setupConnection(getPlayerObj())
            task.spawn(function()
                while Options.EmoteSpeedModeDropdown and Options.EmoteSpeedModeDropdown.Value == "Multiplier speed" do
                    task.wait(2)
                    local current = getPlayerObj()
                    if current ~= playerObj then
                        setupConnection(current)
                    elseif playerObj then
                        local state = playerObj:GetAttribute("State")
                        local targetSpeed = (state == "Emoting") and emotingSpeed or 1.5
                        applySpeedMultiplier(targetSpeed)
                    end
                end
            end)
        elseif Value == "Legit" then
            resetMultiplierSpeed()
            if connection then 
                connection:Disconnect() 
                connection = nil
            end
            local speedValue = featureStates.EmoteSpeedValue or 2
            applyEmoteSpeed(speedValue)
        end
    end
})

EmoteSpeedInput = MiscTab:AddInput("EmoteSpeedInput", {
    Title = "Emote Speed Value",
    Default = "1500",
    Placeholder = "Enter speed value",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num > 0 then
            featureStates.EmoteSpeedValue = num
            local appliedValue = num / 1000
            
            if Options.EmoteSpeedModeDropdown and Options.EmoteSpeedModeDropdown.Value == "Legit" then
                applyEmoteSpeed(appliedValue)
            elseif Options.EmoteSpeedModeDropdown and Options.EmoteSpeedModeDropdown.Value == "Multiplier speed" then
                emotingSpeed = appliedValue
            end
        end
    end
})

ApplyUnwalkableButton = MiscTab:AddButton({
    Title = "Apply Speed to Unwalkable Emotes",
    Callback = function()
        if not itemsFolder then return end
        
        local emotesFolder = itemsFolder:FindFirstChild("Emotes")
        if not emotesFolder then return end
        
        local speedValue = featureStates.EmoteSpeedValue or 2
        
        for _, emoteModule in ipairs(emotesFolder:GetChildren()) do
            if emoteModule:IsA("ModuleScript") then
                local success, emoteData = pcall(require, emoteModule)
                if success and emoteData and emoteData.EmoteInfo and emoteData.EmoteInfo.SpeedMult == 0 then
                    emoteData.EmoteInfo.SpeedMult = speedValue
                end
            end
        end
    end
})

ResetEmoteSpeedButton = MiscTab:AddButton({
    Title = "Reset Emote Speed",
    Callback = function()
        Fluent:Notify({
            Title = "Emote Speed",
            Content = "Resetting emote speeds...",
            Duration = 3
        })
        restoreOriginalEmoteSpeeds()
        resetMultiplierSpeed()
    end
})

MiscTab:AddSection("Gun Functions", "solar/bomb-emoji-bold")

GrappleHookToggle = MiscTab:AddButton({
    Title = "Grapplehook",
    Callback = function()
        local success, result = pcall(function()
            local GrappleHook = require(game:GetService("ReplicatedStorage").Tools["GrappleHook"])

            local grappleTask = GrappleHook.Tasks[2]

            
            local shootMethod = grappleTask.Functions[1].Activations[1].Methods[1]

            
            shootMethod.Info.Speed = 10000          
            shootMethod.Info.Lifetime = 10.0        
            shootMethod.Info.Gravity = Vector3.new(0, 0, 0)  
            shootMethod.Info.SpreadIncrease = 0     
            shootMethod.Info.Cooldown = 0.1         

            
            grappleTask.MethodReferences.Projectile.Info.SpreadInfo.MaxSpread = 0
            grappleTask.MethodReferences.Projectile.Info.SpreadInfo.MinSpread = 0
            grappleTask.MethodReferences.Projectile.Info.SpreadInfo.ReductionRate = 100

            
            local checkMethod = grappleTask.AutomaticFunctions[1].Methods[1]
            checkMethod.Info.Cooldown = 0.1
            checkMethod.CooldownInfo.TestCooldown = 0.1

            
            grappleTask.ResourceInfo.Cap = 999999

            
            GrappleHook.Adjustments.ToolViewbob = false
            GrappleHook.Actions.LookBack.Enabled = true
            GrappleHook.Actions.ADS.Enabled = true
            GrappleHook.Actions.ADS.Zoom = 0.5  

            
            shootMethod.GlobalPriority = 500    
            
            return true
        end)
        
        if success then
            Fluent:Notify({
                Title = "GrappleHook",
                Content = "GrappleHook Successfully upgraded! \nвњ“ infinite ammo \nвњ“ cooldown removed",
                Duration = 5
            })
        else
            Fluent:Notify({
                Title = "GrappleHook Error",
                Content = "Error: " .. tostring(result),
                Duration = 5
            })
        end
    end
})

BreacherToggle = MiscTab:AddButton({
    Title = "Breacher (Portal Gun)",
    Callback = function()
        local success, result = pcall(function()
            local Breacher = require(game:GetService("ReplicatedStorage").Tools.Breacher)

            
            local portalTask
            for i, task in ipairs(Breacher.Tasks) do
                if task.ResourceInfo and task.ResourceInfo.Type == "Clip" then
                    portalTask = task
                    break
                end
            end

            if not portalTask then
                portalTask = Breacher.Tasks[2]
            end

            
            portalTask.ResourceInfo.Cap = 999999

            
            local blueShoot = portalTask.Functions[1].Activations[1].Methods[1]  
            local yellowShoot = portalTask.Functions[2].Activations[1].Methods[1] 

            blueShoot.Info.Range = 999999
            yellowShoot.Info.Range = 999999

            
            blueShoot.Info.SpreadIncrease = 0
            yellowShoot.Info.SpreadIncrease = 0

            portalTask.MethodReferences.Portal.Info.SpreadInfo.MaxSpread = 0
            portalTask.MethodReferences.Portal.Info.SpreadInfo.MinSpread = 0
            portalTask.MethodReferences.Portal.Info.SpreadInfo.ReductionRate = 100

            
            blueShoot.Info.Cooldown = 0.1
            yellowShoot.Info.Cooldown = 0.1

            
            blueShoot.CooldownInfo = {}
            yellowShoot.CooldownInfo = {}
            blueShoot.Requirements = {}
            yellowShoot.Requirements = {}

            
            
            Breacher.Actions.ADS.Enabled = false  

            
            local unequipMethod = Breacher.Tasks[1].AutomaticFunctions[2].Methods[1]
            unequipMethod.CooldownInfo = {}  

            
            if blueShoot.CooldownInfo and blueShoot.CooldownInfo.DisabledActions then
                
                local newDisabled = {}
                for _, action in ipairs(blueShoot.CooldownInfo.DisabledActions) do
                    if action ~= "ADS" then
                        table.insert(newDisabled, action)
                    end
                end
                blueShoot.CooldownInfo.DisabledActions = newDisabled
            end

            if yellowShoot.CooldownInfo and yellowShoot.CooldownInfo.DisabledActions then
                
                local newDisabled = {}
                for _, action in ipairs(yellowShoot.CooldownInfo.DisabledActions) do
                    if action ~= "ADS" then
                        table.insert(newDisabled, action)
                    end
                end
                yellowShoot.CooldownInfo.DisabledActions = newDisabled
            end

            
            blueShoot.GlobalPriority = 500
            yellowShoot.GlobalPriority = 500
            blueShoot.Priority = 1
            yellowShoot.Priority = 1

            
            
            blueShoot.ResourceAboveZero = false
            yellowShoot.ResourceAboveZero = false

            
            portalTask.Functions[1].Activations[1].CanHoldDown = true
            portalTask.Functions[2].Activations[1].CanHoldDown = true

            
            if not blueShoot.Info.Speed then
                blueShoot.Info.Speed = 5000
                yellowShoot.Info.Speed = 5000
            end

            
            local baseTask = Breacher.Tasks[1]
            baseTask.AutomaticFunctions[1].Methods[1].Info.Cooldown = 0.1
            baseTask.AutomaticFunctions[2].Methods[1].Info.Cooldown = 0.1

            
            
            Breacher.Actions.LookBack.Enabled = true

            
            Breacher.Adjustments.ToolViewbob = true
            Breacher.Adjustments.AnimationRootStraight = true
            Breacher.Adjustments.TurnWaist = true

            
            Breacher.HUD.CrosshairType = "Accurate"  
            Breacher.HUD.Colored = true

            
            if Breacher.Actions.ADS.Zoom then
                Breacher.Actions.ADS.Zoom = nil  
            end
            
            return true
        end)
        
        if success then
            Fluent:Notify({
                Title = "Breacher (Portal Gun)",
                Content = "Portal Gun Successfully upgraded! \nвњ“ Infinite charges \nвњ“ Maximum range \nвњ“ Instant reload",
                Duration = 6
            })
        else
            Fluent:Notify({
                Title = "Breacher Error",
                Content = "Error: " .. tostring(result),
                Duration = 5
            })
        end
    end
})

SmokeGrenadeToggle = MiscTab:AddButton({
    Title = "Smoke Grenade",
    Callback = function()
        local success, result = pcall(function()
            local SmokeGrenade = require(game:GetService("ReplicatedStorage").Tools["SmokeGrenade"])

            
            SmokeGrenade.RequiresOwnedItem = false  

            
            local throwMethod = SmokeGrenade.Tasks[1].Functions[1].Activations[1].Methods[1]

            
            throwMethod.ItemUseIncrement = {"SmokeGrenade", 0}

            
            throwMethod.Info.Cooldown = 0.1  

            
            throwMethod.Info.ThrowVelocity = 200  

            
            SmokeGrenade.Tasks[1].Functions[1].Activations[1].CanHoldDown = true  

            
            
            throwMethod.Info.SmokeDuration = 999  
            throwMethod.Info.SmokeRadius = 100    
            throwMethod.Info.FadeTime = 60        

            
            local equipMethod = SmokeGrenade.Tasks[1].AutomaticFunctions[1].Methods[1]
            local unequipMethod = SmokeGrenade.Tasks[1].AutomaticFunctions[2].Methods[1]
            equipMethod.Info.Cooldown = 0.1  
            unequipMethod.Info.Cooldown = 0.1  

            
            throwMethod.GlobalPriority = 500  

            
            throwMethod.CooldownInfo = {}  

            
            SmokeGrenade.HUD.ShowAmount = false  

            
            
            throwMethod.Info.Density = 0.9        
            throwMethod.Info.Color = Color3.new(0.7, 0.7, 0.7)  
            throwMethod.Info.ExplosionRadius = 20  

            
            throwMethod.CooldownInfo.ActivatePhrase = nil  

            
            throwMethod.Info.Cooldown = 0.05  

            
            SmokeGrenade.KeybindInfo.UnequipKeybind = "Backspace"  

            
            local args = {
                [1] = 0,
                [2] = 20
            }
            
            game:GetService("ReplicatedStorage").Events.Character.ToolAction:FireServer(unpack(args))
            
            return true
        end)
        
        if success then
            Fluent:Notify({
                Title = "Smoke Grenade",
                Content = "Smoke Grenade Improved! \nвњ“ Infinite Grenades \nвњ“ Instant Reload",
                Duration = 6
            })
        else
            Fluent:Notify({
                Title = "Smoke Grenade Error",
                Content = "Error: " .. tostring(result),
                Duration = 5
            })
        end
    end
})

StunBatonToggle = MiscTab:AddButton({
    Title = "Stun Baton",
    Callback = function()
        local success, result = pcall(function()
            local StunBaton = require(game:GetService("ReplicatedStorage").Tools.StunBaton)

            
            local task = StunBaton.Tasks[1]

            
            local meleeStart = task.Functions[1].Activations[2].Methods[1]
            meleeStart.Info.Cooldown = 0.05           
            meleeStart.Info.LungeRange = 0             
            meleeStart.Info.ImmortalLength = 5         
            meleeStart.Info.SuccessStunLength = 5      
            meleeStart.CooldownInfo = {}               
            meleeStart.Requirements = {}                

            
            local meleeStartFail = task.Functions[1].Activations[1].Methods[1]
            meleeStartFail.Info.Cooldown = 0.05
            meleeStartFail.Info.LungeRange = 0
            meleeStartFail.Info.ImmortalLength = 5
            meleeStartFail.CooldownInfo = {}

            
            local meleeEnd = task.AutomaticFunctions[2].Methods[1]
            meleeEnd.Info.Cooldown = 0.1               
            meleeEnd.Info.Damage = 999                  
            meleeEnd.Info.Range = 0                     
            meleeEnd.CooldownInfo = {}

            
            local meleeEndFail = task.AutomaticFunctions[1].Methods[1]
            meleeEndFail.Info.Cooldown = 0.1            
            meleeEndFail.Info.SelfDamage = 0            
            meleeEndFail.Info.Range = 0
            meleeEndFail.CooldownInfo = {}

            
            local equip = task.AutomaticFunctions[3].Methods[1]
            local unequip = task.AutomaticFunctions[4].Methods[1]
            equip.Info.Cooldown = 0.1                   
            unequip.Info.Cooldown = 0.1                  
            unequip.CooldownInfo = {}                     

            
            StunBaton.Actions.ADS.Enabled = false        
            StunBaton.Actions.LookBack.Enabled = true    
            
            return true
        end)
        
        if success then
            Fluent:Notify({
                Title = "Stun Baton",
                Content = "Stun Baton Successfully upgraded!\nвњ“ Instant attacks \nвњ“ No self damage\nвњ“ Long stun",
                Duration = 6
            })
        else
            Fluent:Notify({
                Title = "Stun Baton Error",
                Content = "Error: " .. tostring(result),
                Duration = 5
            })
        end
    end
})

MiscTab:AddSection("Infinity Slide", "solar/running-bold")

local infiniteSlideEnabled = false
local slideFrictionValue = -8
local movementTables = {}
local infiniteSlideHeartbeat = nil
local infiniteSlideCharacterConn = nil
local slideLastAppliedFriction = nil
local slideRefreshScheduled = false
local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer

local requiredKeys = {
    "Friction","AirStrafeAcceleration","JumpHeight","RunDeaccel",
    "JumpSpeedMultiplier","JumpCap","SprintCap","WalkSpeedMultiplier",
    "BhopEnabled","Speed","AirAcceleration","RunAccel","SprintAcceleration"
}

local function hasRequiredFields(tbl)
    if typeof(tbl) ~= "table" then return false end
    for _, key in ipairs(requiredKeys) do
        if rawget(tbl, key) == nil then return false end
    end
    return true
end

local function findMovementTables()
    movementTables = {}
    for _, obj in ipairs(getgc(true)) do
        if hasRequiredFields(obj) then
            table.insert(movementTables, obj)
        end
    end
    return #movementTables > 0
end

local function setSlideFriction(value)
    if #movementTables > 0 and slideLastAppliedFriction == value then
        return
    end
    local appliedCount = 0
    for _, tbl in ipairs(movementTables) do
        pcall(function()
            tbl.Friction = value
            appliedCount = appliedCount + 1
        end)
    end
    if appliedCount == 0 then
        slideLastAppliedFriction = nil
        if slideRefreshScheduled then
            return
        end
        slideRefreshScheduled = true
        task.defer(function()
            slideRefreshScheduled = false
            findMovementTables()
            slideLastAppliedFriction = nil
            if infiniteSlideEnabled then
                setSlideFriction(value)
            end
        end)
        return
    end
    slideLastAppliedFriction = value
end

local function updatePlayerModel()
    local gameFolder = workspace:FindFirstChild("Game")
    if not gameFolder then return false end
    
    local playersFolder = gameFolder:FindFirstChild("Players")
    if not playersFolder then return false end
    
    local playerModel = playersFolder:FindFirstChild(player.Name)
    return playerModel
end

local function infiniteSlideHeartbeatFunc()
    if not infiniteSlideEnabled then return end
    
    local playerModel = updatePlayerModel()
    if not playerModel then return end
    
    local state = playerModel:GetAttribute("State")
    
    if state == "Slide" then
        pcall(function()
            playerModel:SetAttribute("State", "EmotingSlide")
        end)
    elseif state == "EmotingSlide" then
        setSlideFriction(slideFrictionValue)
    else
        setSlideFriction(5)
    end
end

local function onCharacterAddedSlide(character)
    if not infiniteSlideEnabled then return end
    
    for i = 1, 5 do
        task.wait(0.5)
        if updatePlayerModel() then
            break
        end
    end
    
    task.wait(0.5)
    movementTables = {}
    slideLastAppliedFriction = nil
    slideRefreshScheduled = false
    task.defer(function()
        if not infiniteSlideEnabled then return end
        findMovementTables()
        slideLastAppliedFriction = nil
    end)
end

local function setInfiniteSlide(enabled)
    infiniteSlideEnabled = enabled

    if enabled then
        movementTables = {}
        slideLastAppliedFriction = nil
        slideRefreshScheduled = false
        task.defer(function()
            if not infiniteSlideEnabled then return end
            findMovementTables()
            slideLastAppliedFriction = nil
        end)
        updatePlayerModel()
        
        if not infiniteSlideCharacterConn then
            infiniteSlideCharacterConn = player.CharacterAdded:Connect(onCharacterAddedSlide)
        end
        
        if player.Character then
            task.spawn(function()
                onCharacterAddedSlide(player.Character)
            end)
        end
        
        if infiniteSlideHeartbeat then infiniteSlideHeartbeat:Disconnect() end
        infiniteSlideHeartbeat = RunService.Heartbeat:Connect(infiniteSlideHeartbeatFunc)
        
    else
        if infiniteSlideHeartbeat then
            infiniteSlideHeartbeat:Disconnect()
            infiniteSlideHeartbeat = nil
        end
        
        if infiniteSlideCharacterConn then
            infiniteSlideCharacterConn:Disconnect()
            infiniteSlideCharacterConn = nil
        end
        
        local savedForFrictionRestore = movementTables
        movementTables = {}
        slideLastAppliedFriction = nil
        slideRefreshScheduled = false
        task.defer(function()
            for _, tbl in ipairs(savedForFrictionRestore) do
                pcall(function()
                    tbl.Friction = 5
                end)
            end
        end)
    end
end

InfiniteSlideToggle = MiscTab:AddToggle("InfiniteSlideToggle", {
    Title = "Sprint Slide",
    Default = false,
    Callback = function(Value)
        setInfiniteSlide(Value)
    end
})

SlideFrictionInput = MiscTab:AddInput("SlideFrictionInput", {
    Title = "Slide Speed (Negative only)",
    Default = "-8",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            slideFrictionValue = num
            if infiniteSlideEnabled then
                setSlideFriction(slideFrictionValue)
            end
        end
    end
})

local function createSlideGradientButton()
    local CoreGui = game:GetService("CoreGui")
    
    if slideButtonScreenGui then
        slideButtonScreenGui:Destroy()
        slideButtonScreenGui = nil
    end
    
    slideButtonScreenGui = Instance.new("ScreenGui")
    slideButtonScreenGui.Name = "SlideButtonGUI"
    slideButtonScreenGui.ResetOnSpawn = false
    slideButtonScreenGui.Parent = CoreGui
    
    local buttonSize = 180
    if Options.SlideButtonScaleInput and Options.SlideButtonScaleInput.Value and tonumber(Options.SlideButtonScaleInput.Value) then
        buttonSize = tonumber(Options.SlideButtonScaleInput.Value)
    end
    local btnWidth = math.max(150, math.min(buttonSize, 400))
    local btnHeight = math.max(60, math.min(buttonSize * 0.4, 160))
    
    
    local btn, clicker, stroke = createGradientButton(
        slideButtonScreenGui,
        UDim2.new(0.5, -btnWidth/2, 0.5, -btnHeight/2),
        UDim2.new(0, btnWidth, 0, btnHeight),
        infiniteSlideEnabled and "Sprint Slide: On" or "Sprint Slide: Off"
    )
    
    clicker.MouseButton1Click:Connect(function()
        infiniteSlideEnabled = not infiniteSlideEnabled
        setInfiniteSlide(infiniteSlideEnabled)
        
        if btn:FindFirstChild("TextLabel") then
            btn.TextLabel.Text = infiniteSlideEnabled and "Sprint Slide: On" or "Sprint Slide: Off"
        end
        
        if Options.InfiniteSlideToggle then
            Options.InfiniteSlideToggle:SetValue(infiniteSlideEnabled)
        end
    end)
    
    return slideButtonScreenGui
end

local function updateSlideButtonText()
    if slideButtonScreenGui and slideButtonScreenGui:FindFirstChild("GradientBtn") then
        local button = slideButtonScreenGui:FindFirstChild("GradientBtn")
        if button and button:FindFirstChild("TextLabel") then
            button.TextLabel.Text = infiniteSlideEnabled and "Sprint Slide: On" or "Sprint Slide: Off"
        end
    end
end

SlideButtonToggle = MiscTab:AddToggle("SlideButtonToggle", {
    Title = "Sprint Slide Button GUI",
    Default = false,
    Callback = function(Value)
        if Value then
            createSlideGradientButton()
        else
            if slideButtonScreenGui then
                slideButtonScreenGui:Destroy()
                slideButtonScreenGui = nil
            end
        end
    end
})

SlideKeybind = MiscTab:AddKeybind("SlideKeybind", {
    Title = "Sprint Slide Keybind",
    Mode = "Toggle",
    Default = "X", 
    ChangedCallback = function(New)
        
    end,
    Callback = function()
        infiniteSlideEnabled = not infiniteSlideEnabled
        setInfiniteSlide(infiniteSlideEnabled)
        
        if Options.InfiniteSlideToggle then
            Options.InfiniteSlideToggle:SetValue(infiniteSlideEnabled)
        end
        
        updateSlideButtonText()
    end
})

MiscTab:AddSection("Gravity", "solar/planet-bold")

local gravityEnabled = false
local originalGravity = workspace.Gravity
local gravityValue = 10
local gravityHeartbeat = nil
local gravityKeybindValue = "G"

local function toggleGravity()
    gravityEnabled = not gravityEnabled
    local CoreGui = game:GetService("CoreGui")
    local screenGui = CoreGui:FindFirstChild("GravityButtonGUI")
    local btn = screenGui and screenGui:FindFirstChild("GradientBtn")
    if btn and btn:FindFirstChild("TextLabel") then
        btn.TextLabel.Text = gravityEnabled and "Gravity: On" or "Gravity: Off"
    end
    if gravityEnabled then
        workspace.Gravity = gravityValue
    else
        workspace.Gravity = originalGravity
    end
    if Options.GravityToggle then
        Options.GravityToggle:SetValue(gravityEnabled)
    end
end

local function createGravityButton()
    local CoreGui = game:GetService("CoreGui")
    local existingScreenGui = CoreGui:FindFirstChild("GravityButtonGUI")

    if existingScreenGui then
        existingScreenGui:Destroy()
    else
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "GravityButtonGUI"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = CoreGui

        local buttonSize = 180
        if Options.GravityButtonSizeInput and Options.GravityButtonSizeInput.Value and tonumber(Options.GravityButtonSizeInput.Value) then
            buttonSize = tonumber(Options.GravityButtonSizeInput.Value)
        end
        local btnWidth = math.max(150, math.min(buttonSize, 400))
        local btnHeight = math.max(60, math.min(buttonSize * 0.4, 160))

        local btn, clicker, stroke = createGradientButton(
            screenGui,
            UDim2.new(0.5, -btnWidth/2, 0.5, -btnHeight/2),
            UDim2.new(0, btnWidth, 0, btnHeight),
            gravityEnabled and "Gravity: On" or "Gravity: Off"
        )

        clicker.MouseButton1Click:Connect(function()
            toggleGravity()
        end)
    end
end

GravityToggle = MiscTab:AddToggle("GravityToggle", {
    Title = "Gravity",
    Default = false,
    Callback = function(Value)
        gravityEnabled = Value
        
        if Value then
            workspace.Gravity = gravityValue
        else
            workspace.Gravity = originalGravity
        end
    end
})

GravityButtonToggle = MiscTab:AddToggle("GravityButtonToggle", {
    Title = "Gravity Button GUI",
    Default = false,
    Callback = function(Value)
        if Value then
            createGravityButton()
        else
            local CoreGui = game:GetService("CoreGui")
            local existingScreenGui = CoreGui:FindFirstChild("GravityButtonGUI")
            if existingScreenGui then
                existingScreenGui:Destroy()
            end
        end
    end
})

GravityKeybind = MiscTab:AddKeybind("GravityKeybind", {
    Title = "Gravity Keybind",
    Mode = "Toggle",
    Default = "G",
    ChangedCallback = function(New)
        gravityKeybindValue = New
    end,
    Callback = function()
        toggleGravity()
    end
})

GravityAdjustmentInput = MiscTab:AddInput("GravityAdjustmentInput", {
    Title = "Gravity Adjustment",
    Default = "10",
    Placeholder = "Enter gravity value",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num > 0 then
            gravityValue = num
            if gravityEnabled then
                workspace.Gravity = gravityValue
            end
        end
    end
})

originalGravity = workspace.Gravity

GravityToggle:OnChanged(function(state)
    if Options.GravityButtonToggle and Options.GravityButtonToggle.Value then
        local CoreGui = game:GetService("CoreGui")
        local screenGui = CoreGui:FindFirstChild("GravityButtonGUI")
        if screenGui then
            local button = screenGui:FindFirstChild("GradientBtn")
            if button and button:FindFirstChild("TextLabel") then
                button.TextLabel.Text = state and "Gravity: On" or "Gravity: Off"
            end
        end
    end
end)
MiscTab:AddSection("Auto Jump", "solar/arrow-up-bold")

local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

getgenv().autoJumpType = "Bounce"
getgenv().bhopMode = "Acceleration"
getgenv().bhopAccelValue = -0.5
getgenv().bhopHoldActive = false
getgenv().autoJumpEnabled = false
getgenv().jumpCooldown = 0.25
getgenv().rotationEnabled = false 

featureStates = featureStates or {}
featureStates.Bhop = false
featureStates.BhopHold = false

local bhopConnection = nil
local bhopLoaded = false
local characterConnection = nil
local frictionTables = {}
local Character = nil
local Humanoid = nil
local HumanoidRootPart = nil
local LastJump = 0
local GROUND_CHECK_OFFSET = 3.5
local GROUND_CHECK_RAY_LENGTH = 4
local MAX_SLOPE_ANGLE = 45
local bhopButtonScreenGui = nil
local rotationConnection = nil 
local rotationSpeed = 100000 
local jumpButtonDownConnection = nil
local jumpButtonUpConnection = nil

local function startRotation()
    if rotationConnection then
        rotationConnection:Disconnect()
        rotationConnection = nil
    end
    
    if not getgenv().rotationEnabled or not HumanoidRootPart then return end
    
    rotationConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if HumanoidRootPart and HumanoidRootPart.Parent then
            
            local currentRotation = HumanoidRootPart.Orientation
            
            local newRotation = Vector3.new(
                currentRotation.X,
                currentRotation.Y + (rotationSpeed * deltaTime),
                currentRotation.Z
            )
            
            HumanoidRootPart.Orientation = newRotation
        else
            
            if rotationConnection then
                rotationConnection:Disconnect()
                rotationConnection = nil
            end
        end
    end)
end

local function stopRotation()
    if rotationConnection then
        rotationConnection:Disconnect()
        rotationConnection = nil
    end
end

local function updateRotationState()
    if getgenv().rotationEnabled and getgenv().autoJumpEnabled then
        startRotation()
    else
        stopRotation()
    end
end

local function createBhopGradientButton()
    local CoreGui = game:GetService("CoreGui")
    
    if bhopButtonScreenGui then
        bhopButtonScreenGui:Destroy()
        bhopButtonScreenGui = nil
    end
    
    bhopButtonScreenGui = Instance.new("ScreenGui")
    bhopButtonScreenGui.Name = "BhopButtonGUI"
    bhopButtonScreenGui.ResetOnSpawn = false
    bhopButtonScreenGui.Parent = CoreGui
    
    local buttonSize = 180
    if Options.BhopButtonScaleInput and Options.BhopButtonScaleInput.Value and tonumber(Options.BhopButtonScaleInput.Value) then
        buttonSize = tonumber(Options.BhopButtonScaleInput.Value)
    end
    local btnWidth = math.max(150, math.min(buttonSize, 400))
    local btnHeight = math.max(60, math.min(buttonSize * 0.4, 160))
    
    local btn, clicker, stroke = createGradientButton(
        bhopButtonScreenGui,
        UDim2.new(0.5, -btnWidth/2, 0.5, -btnHeight/2),
        UDim2.new(0, btnWidth, 0, btnHeight),
        getgenv().autoJumpEnabled and "Auto Jump: On" or "Auto Jump: Off"
    )
    
    clicker.MouseButton1Click:Connect(function()
        getgenv().autoJumpEnabled = not getgenv().autoJumpEnabled
        featureStates.Bhop = getgenv().autoJumpEnabled
        
        if btn:FindFirstChild("TextLabel") then
            btn.TextLabel.Text = getgenv().autoJumpEnabled and "Auto Jump: On" or "Auto Jump: Off"
        end
        
        if Options.BhopToggle then
            Options.BhopToggle:SetValue(getgenv().autoJumpEnabled)
        end
        
        checkBhopState() 
    end)
    
    return bhopButtonScreenGui
end

local function updateBhopButtonText()
    if bhopButtonScreenGui and bhopButtonScreenGui:FindFirstChild("GradientBtn") then
        local button = bhopButtonScreenGui:FindFirstChild("GradientBtn")
        if button and button:FindFirstChild("TextLabel") then
            button.TextLabel.Text = getgenv().autoJumpEnabled and "Auto Jump: On" or "Auto Jump: Off"
        end
    end
end

local function IsOnGround()
    if not Character or not HumanoidRootPart or not Humanoid then 
        return false 
    end
    
    local state = Humanoid:GetState()
    if state == Enum.HumanoidStateType.Jumping or 
       state == Enum.HumanoidStateType.Freefall or
       state == Enum.HumanoidStateType.Swimming then
        return false
    end
    
    if Humanoid:GetState() == Enum.HumanoidStateType.Running then
        return true
    end
    
    
    local rayOrigin = HumanoidRootPart.Position
    local rayDirection = Vector3.new(0, -GROUND_CHECK_RAY_LENGTH, 0)
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {Character}
    raycastParams.IgnoreWater = true
    
    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    if raycastResult then
        local surfaceNormal = raycastResult.Normal
        local angle = math.deg(math.acos(surfaceNormal:Dot(Vector3.new(0, 1, 0))))
        
        
        if angle <= MAX_SLOPE_ANGLE then
            
            local heightDiff = math.abs(rayOrigin.Y - raycastResult.Position.Y)
            return heightDiff <= GROUND_CHECK_OFFSET
        end
    end
    
    
    if HumanoidRootPart.Velocity.Y > -1 and HumanoidRootPart.Velocity.Y < 1 then
        return true
    end
    
    return false
end

local function findFrictionTables()
    frictionTables = {}
    
    for _, obj in pairs(getgc(true)) do
        if type(obj) == "table" and rawget(obj, "Friction") then
            table.insert(frictionTables, {
                obj = obj,
                original = obj.Friction
            })
        end
    end
end

local function applyBhopFriction()
    local isActive = getgenv().autoJumpEnabled or getgenv().bhopHoldActive
    
    if isActive and getgenv().bhopMode == "Acceleration" then
        if #frictionTables == 0 then
            findFrictionTables()
        end
        
        for _, tableData in ipairs(frictionTables) do
            if tableData.obj and type(tableData.obj) == "table" then
                pcall(function()
                    tableData.obj.Friction = getgenv().bhopAccelValue or -0.5
                end)
            end
        end
    else
        
        for _, tableData in ipairs(frictionTables) do
            if tableData.obj and type(tableData.obj) == "table" and tableData.original then
                pcall(function()
                    tableData.obj.Friction = tableData.original
                end)
            end
        end
    end
end

local function updateBhop()
    if not bhopLoaded then return end

    local isActive = getgenv().autoJumpEnabled or getgenv().bhopHoldActive

    if isActive then
        
        if not Character or not Humanoid or not HumanoidRootPart then
            Character = player.Character
            if Character then
                Humanoid = Character:FindFirstChildOfClass("Humanoid")
                HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            end
            if not Humanoid or not HumanoidRootPart then return end
        end

        
        if Humanoid:GetState() == Enum.HumanoidStateType.Dead then
            return
        end
        
        
        local now = tick()
        
        if getgenv().autoJumpType == "Realistic" then
            
            pcall(function()
                player.PlayerScripts.Events.temporary_events.JumpReact:Fire()
                player.PlayerScripts.Events.temporary_events.EndJump:Fire()
            end)
            
        else  
            local cooldown = getgenv().jumpCooldown or 0.25
            if IsOnGround() and (now - LastJump) > cooldown then  
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                LastJump = now
            end
        end
    end
end

local function loadBhop()
    if bhopLoaded then return end
    
    
    bhopLoaded = true
    
    
    if #frictionTables == 0 then
        findFrictionTables()
    end
    
    
    applyBhopFriction()
    
    
    if bhopConnection then
        bhopConnection:Disconnect()
    end
    
    bhopConnection = RunService.Heartbeat:Connect(function(deltaTime)
        updateBhop()
    end)
    
end

local function unloadBhop()
    if not bhopLoaded then return end
    
    
    bhopLoaded = false
    
    if bhopConnection then
        bhopConnection:Disconnect()
        bhopConnection = nil
    end
    
    getgenv().bhopHoldActive = false
    applyBhopFriction() 
    
end

local function checkBhopState()
    local shouldLoad = getgenv().autoJumpEnabled or getgenv().bhopHoldActive
    
    if shouldLoad then
        loadBhop()
        updateRotationState() 
    else
        unloadBhop()
        stopRotation() 
    end
end

local function reapplyBhopOnRespawn()
    if getgenv().autoJumpEnabled or getgenv().bhopHoldActive then
        task.wait(1) 
        Character = player.Character
        if Character then
            Humanoid = Character:FindFirstChildOfClass("Humanoid")
            HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        end
        checkBhopState()
    end
end

local function setupJumpButton()
    local isMobile = UserInputService.TouchEnabled
    
    if isMobile then
        task.spawn(function()
            task.wait(2) 
            
            local success, err = pcall(function()
                local touchGui = player:WaitForChild("PlayerGui"):WaitForChild("TouchGui")
                if not touchGui then return end
                
                local touchControlFrame = touchGui:WaitForChild("TouchControlFrame")
                if not touchControlFrame then return end
                
                local jumpButton = touchControlFrame:WaitForChild("JumpButton")
                if not jumpButton then return end
                
                if jumpButtonDownConnection then
                    jumpButtonDownConnection:Disconnect()
                    jumpButtonDownConnection = nil
                end
                if jumpButtonUpConnection then
                    jumpButtonUpConnection:Disconnect()
                    jumpButtonUpConnection = nil
                end

                jumpButtonDownConnection = jumpButton.MouseButton1Down:Connect(function()
                    if featureStates.BhopHold then
                        getgenv().bhopHoldActive = true
                        checkBhopState()
                    end
                end)
                
                jumpButtonUpConnection = jumpButton.MouseButton1Up:Connect(function()
                    getgenv().bhopHoldActive = false
                    checkBhopState()
                end)
            end)
            
            if not success then
            end
        end)
    end
end

AutoJumpTypeDropdown = MiscTab:AddDropdown("AutoJumpTypeDropdown", {
    Title = "Auto Jump Type",
    Values = {"Bounce", "Realistic"},
    Multi = false,
    Default = "Bounce",
    Callback = function(Value)
        getgenv().autoJumpType = Value
    end
})

RotationToggle = MiscTab:AddToggle("RotationToggle", {
    Title = "Rotation 360",
    Description = "Do not use with emotions!",
    Default = false,
    Callback = function(Value)
        getgenv().rotationEnabled = Value
        updateRotationState() 
    end
})

BhopToggle = MiscTab:AddToggle("BhopToggle", {
    Title = "Bunny Hop",
    Default = false,
    Callback = function(Value)
        featureStates.Bhop = Value
        getgenv().autoJumpEnabled = Value
        
        updateBhopButtonText()
        updateRotationState() 
        checkBhopState() 
    end
})

BhopHoldToggle = MiscTab:AddToggle("BhopHoldToggle", {
    Title = "Bhop Hold (Hold Space/Jump)",
    Default = false,
    Callback = function(Value)
        featureStates.BhopHold = Value
        if not Value then
            getgenv().bhopHoldActive = false
            checkBhopState() 
        end
    end
})

BhopButtonToggle = MiscTab:AddToggle("BhopButtonToggle", {
    Title = "Bhop Button GUI",
    Default = false,
    Callback = function(Value)
        if Value then
            createBhopGradientButton()
        else
            if bhopButtonScreenGui then
                bhopButtonScreenGui:Destroy()
                bhopButtonScreenGui = nil
            end
        end
    end
})

BhopKeybind = MiscTab:AddKeybind("BhopKeybind", {
    Title = "Bhop Keybind",
    Mode = "Toggle",
    Default = "B",
    ChangedCallback = function(New)
    end,
    Callback = function()
        getgenv().autoJumpEnabled = not getgenv().autoJumpEnabled
        featureStates.Bhop = getgenv().autoJumpEnabled
        
        if Options.BhopToggle then
            Options.BhopToggle:SetValue(getgenv().autoJumpEnabled)
        end
        
        updateBhopButtonText()
        checkBhopState()
    end
})

BhopModeDropdown = MiscTab:AddDropdown("BhopModeDropdown", {
    Title = "Bhop Mode",
    Values = {"Acceleration", "No Acceleration"},
    Multi = false,
    Default = "Acceleration",
    Callback = function(Value)
        getgenv().bhopMode = Value
        checkBhopState()
    end
})

BhopAccelInput = MiscTab:AddInput("BhopAccelInput", {
    Title = "Bhop Acceleration",
    Default = "-0.5",
    Placeholder = "Enter negative value (e.g., -0.5)",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num and string.sub(Value, 1, 1) == "-" then
            getgenv().bhopAccelValue = num
            if getgenv().autoJumpEnabled or getgenv().bhopHoldActive then
                applyBhopFriction()
            end
        end
    end
})

JumpCooldownInput = MiscTab:AddInput("JumpCooldownInput", {
    Title = "Jump Cooldown (Seconds)",
    Default = "0.25",
    Placeholder = "Enter cooldown in seconds",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num > 0 then
            getgenv().jumpCooldown = num
        end
    end
})

RunService.Heartbeat:Connect(function()
    if not Character or not Character:IsDescendantOf(workspace) then
        Character = player.Character
        if Character then
            Humanoid = Character:FindFirstChildOfClass("Humanoid")
            HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            
            
            updateRotationState()
        else
            Humanoid = nil
            HumanoidRootPart = nil
            stopRotation() 
        end
    end
end)

if characterConnection then
    characterConnection:Disconnect()
end

characterConnection = player.CharacterAdded:Connect(function(character)
    Character = character
    frictionTables = {}
    task.wait(0.5)
    Humanoid = character:WaitForChild("Humanoid")
    HumanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    setupJumpButton()
    reapplyBhopOnRespawn()
    updateRotationState() 
    
end)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    
    if input.KeyCode == Enum.KeyCode.Space and featureStates.BhopHold then
        getgenv().bhopHoldActive = true
        checkBhopState()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then
        getgenv().bhopHoldActive = false
        checkBhopState()
    end
end)

task.spawn(function()
    task.wait(2)
    
    if player.Character then
        Character = player.Character
        Humanoid = Character:FindFirstChildOfClass("Humanoid")
        HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    end
    
    setupJumpButton()
    
    if featureStates.Bhop then
        checkBhopState()
    end
    
    
    task.wait(1)
    if Options.BhopButtonToggle and Options.BhopButtonToggle.Value then
        createBhopGradientButton()
    end
end)

Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        unloadBhop()
        stopRotation() 
        
        if characterConnection then
            characterConnection:Disconnect()
            characterConnection = nil
        end
    end
end)

MiscTab:AddSection("Lag Switch", "solar/wifi-router-bold")

local lagSwitchEnabled = false
local lagSwitchKeybindValue = "F12"
local lagDelayValue = 0.1
local lagIntensity = 1000000
local lagSwitchMode = "Normal" 
local isLagActive = false

local function performMathLag()
    local startTime = tick()
    local duration = lagDelayValue
    
    while tick() - startTime < duration do
        for i = 1, lagIntensity do
            local a = math.random(1, 1000000) * math.random(1, 1000000)
            a = a / math.random(1, 10000)
            local b = math.sqrt(math.random(1, 1000000))
            b = b * math.pi * math.exp(1)
            local c = math.sin(math.rad(math.random(1, 360))) * math.cos(math.rad(math.random(1, 360)))
        end
    end
end

local function performDemonLag()
    local startTime = tick()
    local duration = lagDelayValue
    
    
    local currentHeightInput = Options.DemonRiseHeightInput and Options.DemonRiseHeightInput.Value or "100"
    local currentSpeedInput = Options.DemonRiseSpeedInput and Options.DemonRiseSpeedInput.Value or "80"
    
    local RISE_HEIGHT = tonumber(currentHeightInput) or 10
    local BOOST_SPEED = tonumber(currentSpeedInput) or 80
    
    
    
    task.spawn(function()
        local startLagTime = tick()
        while tick() - startLagTime < duration do
            for i = 1, math.floor(lagIntensity / 2) do
                local a = math.random(1, 1000000) * math.random(1, 1000000)
                a = a / math.random(1, 10000)
                local b = math.sqrt(math.random(1, 1000000))
                b = b * math.pi * math.exp(1)
            end
        end
    end)
    
    
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")
        
        if humanoidRootPart and humanoid then
            
            local startHeight = humanoidRootPart.Position.Y
            
            
            local bodyThrust = Instance.new("BodyThrust")
            bodyThrust.Name = "DemonRiseThrust"
            bodyThrust.Force = Vector3.new(0, BOOST_SPEED * 500, 0)  
            bodyThrust.Location = Vector3.new(0, 0, 0)
            bodyThrust.Parent = humanoidRootPart
            
            
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Name = "DemonRiseVelocity"
            bodyVelocity.MaxForce = Vector3.new(0, 500000, 0)  
            bodyVelocity.Velocity = Vector3.new(0, BOOST_SPEED, 0)
            bodyVelocity.Parent = humanoidRootPart
            
            
            local waitTime = 0
            local maxWaitTime = 5  
            
            while waitTime < maxWaitTime do
                local currentHeight = humanoidRootPart.Position.Y
                local heightGained = currentHeight - startHeight
                
                if heightGained >= RISE_HEIGHT then
                    break
                end
                
                task.wait(0.1)
                waitTime = waitTime + 0.1
            end
            
            
            if bodyThrust then
                bodyThrust:Destroy()
            end
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
            
            
            local finalHeight = humanoidRootPart.Position.Y
            local heightGained = finalHeight - startHeight
            
            Fluent:Notify({
                Title = "Demon Mode",
                Content = string.format("Lifted %.1f meters", heightGained),
                Duration = 3
            })
        end
    end
    
    isLagActive = false
end

local function toggleLagSwitch()
    if not isLagActive then
        isLagActive = true
        
        if lagSwitchMode == "Normal" then
            task.spawn(function()
                performMathLag()
                isLagActive = false
            end)
        elseif lagSwitchMode == "Demon" then
            task.spawn(function()
                performDemonLag()
                isLagActive = false
            end)
        end
    end
end

getgenv().DemonRiseHeight = 10  
getgenv().DemonRiseSpeed = 80
getgenv().DemonSoftLanding = true

local function createLagSwitchButton()
    local CoreGui = game:GetService("CoreGui")
    local existingScreenGui = CoreGui:FindFirstChild("LagSwitchButtonGUI")
    
    if existingScreenGui then
        existingScreenGui:Destroy()
    else
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "LagSwitchButtonGUI"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = CoreGui
        
        local buttonSize = 180
        if Options.LagSwitchScaleInput and Options.LagSwitchScaleInput.Value and tonumber(Options.LagSwitchScaleInput.Value) then
            buttonSize = tonumber(Options.LagSwitchScaleInput.Value)
        end
        local btnWidth = math.max(150, math.min(buttonSize, 400))
        local btnHeight = math.max(60, math.min(buttonSize * 0.4, 160))
        
        local btn, clicker, stroke = createGradientButton(
            screenGui,
            UDim2.new(0.5, -btnWidth/2, 0.5, -btnHeight/2),
            UDim2.new(0, btnWidth, 0, btnHeight),
            "Lag Switch"
        )
        
        clicker.MouseButton1Click:Connect(function()
            if lagSwitchEnabled then
                toggleLagSwitch()
            end
        end)
    end
end

LagSwitchToggle = MiscTab:AddToggle("LagSwitchToggle", {
    Title = "Lag Switch",
    Default = false,
    Callback = function(Value)
        lagSwitchEnabled = Value
    end
})

LagSwitchModeDropdown = MiscTab:AddDropdown("LagSwitchModeDropdown", {
    Title = "Lag Switch Mode",
    Values = {"Normal", "Demon"},
    Multi = false,
    Default = "Normal",
    Callback = function(Value)
        lagSwitchMode = Value
    end
})

LagDelayInput = MiscTab:AddInput("LagDelayInput", {
    Title = "Lag Delay (Seconds)",
    Default = "0.1",
    Placeholder = "Enter delay in seconds (0.1-5)",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num > 0 and num <= 5 then
            lagDelayValue = num
        end
    end
})

LagIntensityInput = MiscTab:AddInput("LagIntensityInput", {
    Title = "Lag Intensity",
    Default = "1000000",
    Placeholder = "Enter intensity (1000-10000000)",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num >= 1000 and num <= 10000000 then
            lagIntensity = num
        end
    end
})

DemonRiseHeightInput = MiscTab:AddInput("DemonRiseHeightInput", {
    Title = "Demon Rise Height (meters)",
    Default = "10",
    Placeholder = "Enter rise height in meters (10-500)",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num >= 10 and num <= 500 then
            getgenv().DemonRiseHeight = num
            Fluent:Notify({
                Title = "Demon Mode",
                Content = string.format("Rise height set to %d meters", num),
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "Demon Mode",
                Content = "Height must be between 10 and 500 meters",
                Duration = 3
            })
        end
    end
})

DemonRiseSpeedInput = MiscTab:AddInput("DemonRiseSpeedInput", {
    Title = "Demon Rise Speed",
    Default = "80",
    Placeholder = "Enter rise speed (20-200)",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num >= 20 and num <= 200 then
            getgenv().DemonRiseSpeed = num
            Fluent:Notify({
                Title = "Demon Mode",
                Content = string.format("Rise speed set to %d", num),
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "Demon Mode",
                Content = "Speed must be between 20 and 200",
                Duration = 3
            })
        end
    end
})

LagSwitchButtonToggle = MiscTab:AddToggle("LagSwitchButtonToggle", {
    Title = "Lag Switch Button",
    Default = false,
    Callback = function(Value)
        if Value then
            createLagSwitchButton()
        else
            local CoreGui = game:GetService("CoreGui")
            local existingScreenGui = CoreGui:FindFirstChild("LagSwitchButtonGUI")
            if existingScreenGui then
                existingScreenGui:Destroy()
            end
        end
    end
})

LagSwitchKeybind = MiscTab:AddKeybind("LagSwitchKeybind", {
    Title = "Lag Switch Keybind",
    Mode = "Toggle",
    Default = "F12",
    ChangedCallback = function(New)
        lagSwitchKeybindValue = New
        
        local CoreGui = game:GetService("CoreGui")
        local screenGui = CoreGui:FindFirstChild("LagSwitchButtonGUI")
        if screenGui then
            local button = screenGui:FindFirstChild("GradientBtn")
            if button and button:FindFirstChild("TextLabel") then
                button.TextLabel.Text = "Lag Switch"
            end
        end
    end,
    Callback = function()
        if lagSwitchEnabled then
            toggleLagSwitch()
        end
    end
})

LagSwitchKeybind:OnChanged(function()
    if Options.LagSwitchButtonToggle and Options.LagSwitchButtonToggle.Value then
        local CoreGui = game:GetService("CoreGui")
        local screenGui = CoreGui:FindFirstChild("LagSwitchButtonGUI")
        if screenGui then
            local button = screenGui:FindFirstChild("GradientBtn")
            if button and button:FindFirstChild("TextLabel") then
                button.TextLabel.Text = "Lag Switch"
            end
        end
    end
end)

task.spawn(function()
    task.wait(1)
    if DemonRiseHeightInput then
        DemonRiseHeightInput:SetValue("100")
    end
    if DemonRiseSpeedInput then
        DemonRiseSpeedInput:SetValue("80")
    end
    if DemonSoftLandingToggle then
        DemonSoftLandingToggle:SetValue(true)
    end
end)

MiscTab:AddParagraph({
    Title = "Demon Mode Features",
    Content = "Demon mode combines lag switch with character elevation. Default height: 100 meters. You can adjust height and speed settings."
})

MiscTab:AddSection("Camera Adjustments", "solar/camera-bold")

local cameraStretchConnection = nil
local stretchHorizontal = 0.80
local stretchVertical = 0.80

local function setupCameraStretch()
    if cameraStretchConnection then 
        cameraStretchConnection:Disconnect() 
        cameraStretchConnection = nil
    end
    
    cameraStretchConnection = game:GetService("RunService").RenderStepped:Connect(function()
        local Camera = workspace.CurrentCamera
        if Camera then
            Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, stretchHorizontal, 0, 0, 0, stretchVertical, 0, 0, 0, 1)
        end
    end)
end

CameraStretchToggle = MiscTab:AddToggle("CameraStretchToggle", {
    Title = "Camera Stretch",
    Default = false,
    Callback = function(Value)
        if Value then
            setupCameraStretch()
        else
            if cameraStretchConnection then
                cameraStretchConnection:Disconnect()
                cameraStretchConnection = nil
            end
        end
    end
})

CameraStretchHorizontalInput = MiscTab:AddInput("CameraStretchHorizontalInput", {
    Title = "Camera Stretch Horizontal",
    Default = "0.80",
    Placeholder = "Enter horizontal stretch value",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            stretchHorizontal = num
            if Options.CameraStretchToggle and Options.CameraStretchToggle.Value then
                setupCameraStretch()
            end
        end
    end
})

CameraStretchVerticalInput = MiscTab:AddInput("CameraStretchVerticalInput", {
    Title = "Camera Stretch Vertical",
    Default = "0.80",
    Placeholder = "Enter vertical stretch value",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            stretchVertical = num
            if Options.CameraStretchToggle and Options.CameraStretchToggle.Value then
                setupCameraStretch()
            end
        end
    end
})
MiscTab:AddSection("Client Modification", "solar/monitor-bold")

FullBrightToggle = MiscTab:AddToggle("FullBrightToggle", {
    Title = "Full Bright",
    Default = false,
    Callback = function(state)
        featureStates.FullBright = state
        if state then
            local Lighting = game:GetService("Lighting")
            
            featureStates.originalBrightness = Lighting.Brightness
            featureStates.originalAmbient = Lighting.Ambient
            featureStates.originalOutdoorAmbient = Lighting.OutdoorAmbient
            featureStates.originalColorShiftBottom = Lighting.ColorShift_Bottom
            featureStates.originalColorShiftTop = Lighting.ColorShift_Top
            
            local function applyFullBright()
                if Lighting.Brightness ~= 1 then
                    Lighting.Brightness = 1
                end
                if Lighting.Ambient ~= Color3.new(1, 1, 1) then
                    Lighting.Ambient = Color3.new(1, 1, 1)
                end
                if Lighting.OutdoorAmbient ~= Color3.new(1, 1, 1) then
                    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
                end
                if Lighting.ColorShift_Bottom ~= Color3.new(1, 1, 1) then
                    Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
                end
                if Lighting.ColorShift_Top ~= Color3.new(1, 1, 1) then
                    Lighting.ColorShift_Top = Color3.new(1, 1, 1)
                end
            end
            
            applyFullBright()
            
            if featureStates.fullBrightConnection then
                featureStates.fullBrightConnection:Disconnect()
            end
            
            featureStates.fullBrightConnection = RunService.Heartbeat:Connect(function()
                if featureStates.FullBright then
                    applyFullBright()
                end
            end)
            
            featureStates.fullBrightCharConnection = game.Players.LocalPlayer.CharacterAdded:Connect(function()
                task.wait(1)
                if featureStates.FullBright then
                    applyFullBright()
                end
            end)
            
        else
            if featureStates.fullBrightConnection then
                featureStates.fullBrightConnection:Disconnect()
                featureStates.fullBrightConnection = nil
            end
            
            if featureStates.fullBrightCharConnection then
                featureStates.fullBrightCharConnection:Disconnect()
                featureStates.fullBrightCharConnection = nil
            end
            
            if featureStates.originalBrightness then
                local Lighting = game:GetService("Lighting")
                Lighting.Brightness = featureStates.originalBrightness
                Lighting.Ambient = featureStates.originalAmbient
                Lighting.OutdoorAmbient = featureStates.originalOutdoorAmbient
                Lighting.ColorShift_Bottom = featureStates.originalColorShiftBottom
                Lighting.ColorShift_Top = featureStates.originalColorShiftTop
            end
        end
    end
})

AntiLag1 = MiscTab:AddButton({
    Title = "Anti lag 1",
    Callback = function()
        local Lighting = game:GetService("Lighting")
        local Terrain = workspace:FindFirstChildOfClass("Terrain")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e10
        Lighting.Brightness = 1

        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 1
        end

        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.Plastic
                obj.Reflectance = 0
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj:Destroy()
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj:Destroy()
            elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                obj:Destroy()
            end
        end

        for _, player in ipairs(Players:GetPlayers()) do
            local char = player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("Accessory") or part:IsA("Clothing") then
                        part:Destroy()
                    end
                end
            end
        end
    end
})

AntiLag2 = MiscTab:AddButton({
    Title = "Anti lag 2",
    Callback = function()
        local ToDisable = {
            Textures = true,
            VisualEffects = true,
            Parts = true,
            Particles = true,
            Sky = true
        }

        local ToEnable = {
            FullBright = false
        }

        local Stuff = {}

        for _, v in next, game:GetDescendants() do
            if ToDisable.Parts then
                if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic
                    table.insert(Stuff, 1, v)
                end
            end
            
            if ToDisable.Particles then
                if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Explosion") or v:IsA("Sparkles") or v:IsA("Fire") then
                    v.Enabled = false
                    table.insert(Stuff, 1, v)
                end
            end
            
            if ToDisable.VisualEffects then
                if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then
                    v.Enabled = false
                    table.insert(Stuff, 1, v)
                end
            end
            
            if ToDisable.Textures then
                if v:IsA("Decal") or v:IsA("Texture") then
                    v.Texture = ""
                    table.insert(Stuff, 1, v)
                end
            end
            
            if ToDisable.Sky then
                if v:IsA("Sky") then
                    v.Parent = nil
                    table.insert(Stuff, 1, v)
                end
            end
        end

        if ToEnable.FullBright then
            local Lighting = game:GetService("Lighting")
            
            Lighting.FogColor = Color3.fromRGB(255, 255, 255)
            Lighting.FogEnd = math.huge
            Lighting.FogStart = math.huge
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 5
            Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
            Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.Outlines = true
        end
    end 
})

AntiLag3 = MiscTab:AddButton({
    Title = "Remove Texture",
    Callback = function()
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("Part") or part:IsA("MeshPart") or part:IsA("UnionOperation") or part:IsA("WedgePart") or part:IsA("CornerWedgePart") then
                if part:IsA("Part") then
                    part.Material = Enum.Material.SmoothPlastic
                end
                if part:FindFirstChildWhichIsA("Texture") then
                    local texture = part:FindFirstChildWhichIsA("Texture")
                    texture.Texture = "rbxassetid://0"
                end
                if part:FindFirstChildWhichIsA("Decal") then
                    local decal = part:FindFirstChildWhichIsA("Decal")
                    decal.Texture = "rbxassetid://0"
                end
            end
        end
    end
})

NoFogToggle = MiscTab:AddToggle("NoFogToggle", {
    Title = "Remove fog",
    Default = false,
    Callback = function(state)
        local Lighting = game:GetService("Lighting")
        if state then
            featureStates.originalFogEnd = Lighting.FogEnd
            featureStates.originalAtmospheres = {}
            
            for _, atmosphere in ipairs(Lighting:GetChildren()) do
                if atmosphere:IsA("Atmosphere") then
                    table.insert(featureStates.originalAtmospheres, atmosphere:Clone())
                end
            end
            
            Lighting.FogEnd = 1000000
            for _, v in pairs(Lighting:GetDescendants()) do
                if v:IsA("Atmosphere") then
                    v:Destroy()
                end
            end
        else
            if featureStates.originalFogEnd then
                Lighting.FogEnd = featureStates.originalFogEnd
            end
            
            if featureStates.originalAtmospheres then
                for _, atmosphere in ipairs(featureStates.originalAtmospheres) do
                    if not atmosphere.Parent then
                        local newAtmosphere = Instance.new("Atmosphere")
                        for _, prop in pairs({"Density", "Offset", "Color", "Decay", "Glare", "Haze"}) do
                            if atmosphere[prop] then
                                newAtmosphere[prop] = atmosphere[prop]
                            end
                        end
                        newAtmosphere.Parent = Lighting
                    end
                end
            end
        end
    end
})
    return {
        MiscTab = MiscTab,
    }
end

return Misc
