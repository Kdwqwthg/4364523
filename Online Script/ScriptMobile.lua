game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Draconic Hub 2",
    Text = "Welcome Draconic Hub Remake",
    Icon = "rbxassetid://102225156206159",
    Duration = 7
})
local Fluent = loadstring(game:HttpGet("https://github.com/Kdwqwthg/4364523/releases/download/Fluent/Fluent.lua"))()
local SaveManager = Fluent.SaveManager
local InterfaceManager = Fluent.InterfaceManager
local Window = Fluent:CreateWindow({
    Title = "Draconic-X-Remake",
    SubTitle = "Made by Unknownproooolucky",
    TabWidth = 160,
    Tags = {
        { Text = " Evade Overhaul ", Color = Color3.fromRGB(211, 15, 40) },
    },
    Version = "Version 3.3 Beta",
    Size = UDim2.fromOffset(580, 460),
    Theme = "Blood Red",
    Search = true,
    SearchInHeader = true,
    TitleIcon = "rbxassetid://102225156206159",
    UserInfoTop = true,
    UserInfoTitle = "Hello?",
    MinimizeKey = Enum.KeyCode.LeftControl,
})

local FLOATING_BTN_URL = "https://raw.githubusercontent.com/Kdwqwthg/4364523/refs/heads/main/Online%20Script/FlyBytton.lua"
local GRADIENT_BUTTON_URL = "https://raw.githubusercontent.com/Kdwqwthg/4364523/refs/heads/main/Online%20Script/CreateGradientButton.lua"
local SIMPLE_TIMER_URL = "https://raw.githubusercontent.com/Kdwqwthg/4364523/refs/heads/main/Online%20Script/CreateSimpleTimer.lua"
local floatingBtnSource
pcall(function()
    if typeof(readfile) == "function" then
        floatingBtnSource = readfile("Online Script/FlyBytton.lua")
    end
end)
if type(floatingBtnSource) ~= "string" or #floatingBtnSource < 80 then
    floatingBtnSource = game:HttpGet(FLOATING_BTN_URL, true)
end
local FloatingButton = loadstring(floatingBtnSource)()
FloatingButton.init(Window)

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "solar/home-bold", Favoriteable = true })
}

local Options = Fluent.Options

Fluent:Notify({
    Title = "Draconic X Evade",
    Content = "System Loaded...",
    Duration = 3
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local gradientButtonSource
pcall(function()
    if typeof(readfile) == "function" then
        gradientButtonSource = readfile("Online Script/CreateGradientButton.lua")
    end
end)
if type(gradientButtonSource) ~= "string" or #gradientButtonSource < 80 then
    gradientButtonSource = game:HttpGet(GRADIENT_BUTTON_URL, true)
end
local createGradientButton = loadstring(gradientButtonSource)().createGradientButton

local simpleTimerSource
pcall(function()
    if typeof(readfile) == "function" then
        simpleTimerSource = readfile("Online Script/CreateSimpleTimer.lua")
    end
end)
if type(simpleTimerSource) ~= "string" or #simpleTimerSource < 80 then
    simpleTimerSource = game:HttpGet(SIMPLE_TIMER_URL, true)
end
local createSimpleTimer = loadstring(simpleTimerSource)().createSimpleTimer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local NextbotBillboards = {}
local nextbotLoop = nil

local TicketBillboards = {}

local ExternalESP = nil
local ExternalESPLoaded = false
local ExternalNextbotESP = nil
local ExternalNextbotESPLoaded = false

local function forceCleanAllESP()
    
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
            if obj.Name:find("ESP") or obj.Name:find("Nextbot") or obj.Name:find("Billboard") then
                obj:Destroy()
            end
        end
    end
    
    
    local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        for _, gui in ipairs(playerGui:GetDescendants()) do
            if gui:IsA("BillboardGui") or gui:IsA("SurfaceGui") or gui:IsA("TextLabel") then
                if gui.Name:find("ESP") or gui.Name:find("Nextbot") then
                    gui:Destroy()
                end
            end
        end
    end
    
    
    local coreGui = game:GetService("CoreGui")
    for _, gui in ipairs(coreGui:GetDescendants()) do
        if gui:IsA("BillboardGui") or gui:IsA("SurfaceGui") then
            if gui.Name:find("ESP") or gui.Name:find("Nextbot") then
                gui:Destroy()
            end
        end
    end
    
    
    pcall(function()
        local drawings = {}
        
        
        for _, v in pairs(getgenv() or {}) do
            if type(v) == "table" then
                
                if v.Visible ~= nil and v.Color ~= nil and v.Thickness ~= nil then
                    table.insert(drawings, v)
                end
            end
        end
        
        
        for _, drawing in ipairs(drawings) do
            if drawing.Remove then
                pcall(function() drawing:Remove() end)
            end
        end
    end)
    
end

local playerTracerElements = {}
local botTracerElements = {}
local playerTracerConnection = nil
local botTracerConnection = nil

local lastSavedPosition = nil
local respawnConnection = nil
local AutoSelfReviveConnection = nil
local hasRevived = false
local SelfReviveMethod = "Spawnpoint"

local AntiAFKConnection = nil
local autoWhistleHandle = nil
local stableCameraInstance = nil

function cleanUpOnlyPlayerESPObjects()
    local cleaned = 0
    
    
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player.Character then
                
                for _, obj in pairs(player.Character:GetDescendants()) do
                    if obj:IsA("BillboardGui") then
                        local objName = obj.Name:lower()
                        
                        if objName:find("esp") and 
                           not objName:find("nextbot") and 
                           not objName:find("npc") and
                           not objName:find("bot") and
                           not objName:find("enemy") then
                            obj:Destroy()
                            cleaned = cleaned + 1
                        end
                    end
                end
            end
        end
    end
    
    
    local guiContainers = {
        game:GetService("CoreGui"),
        LocalPlayer.PlayerGui
    }
    
    for _, container in pairs(guiContainers) do
        for _, gui in pairs(container:GetDescendants()) do
            if gui:IsA("BillboardGui") or gui:IsA("ScreenGui") then
                local guiName = gui.Name:lower()
                
                if (guiName:find("player") or guiName:find("esp")) and 
                   not guiName:find("nextbot") and 
                   not guiName:find("bot") then
                    gui:Destroy()
                    cleaned = cleaned + 1
                end
            end
        end
    end
    
    return cleaned
end

local nextBotNames = {}
if ReplicatedStorage:FindFirstChild("NPCs") then
    for _, npc in ipairs(ReplicatedStorage.NPCs:GetChildren()) do
        table.insert(nextBotNames, npc.Name)
    end
end

function isNextbotModel(model)
    if not model or not model.Name then return false end
    for _, name in ipairs(nextBotNames) do
        if model.Name == name then return true end
    end
    return model.Name:lower():find("nextbot") or 
           model.Name:lower():find("scp") or 
           model.Name:lower():find("monster") or
           model.Name:lower():find("creep") or
           model.Name:lower():find("enemy") or
           model.Name:lower():find("zombie") or
           model.Name:lower():find("ghost") or
           model.Name:lower():find("demon")
end

function getDistanceFromPlayer(targetPosition)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
        return 0 
    end
    local distance = (targetPosition - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    return math.floor(distance)
end

local function scanForTickets()
    
    if ExternalTicketESPLoaded and _G.UpdateTicketESP then
        pcall(_G.UpdateTicketESP)
    else
        
        local ticketsFound = {}
        
        local gameFolder = workspace:FindFirstChild("Game")
        if gameFolder then
            local effects = gameFolder:FindFirstChild("Effects")
            if effects then
                local tickets = effects:FindFirstChild("Tickets")
                if tickets then
                    for _, ticket in pairs(tickets:GetChildren()) do
                        if ticket:IsA("BasePart") or ticket:IsA("Model") then
                            local part = ticket:IsA("Model") and 
                                       (ticket:FindFirstChild("HumanoidRootPart") or 
                                        ticket:FindFirstChild("Head") or 
                                        ticket.PrimaryPart or 
                                        ticket:FindFirstChildWhichIsA("BasePart")) or 
                                       ticket:IsA("BasePart") and ticket
                            if part then
                                ticketsFound[ticket] = part
                            end
                        end
                    end
                end
            end
        end
        
        
        for ticket, data in pairs(TicketBillboards) do
            if not ticketsFound[ticket] or not ticket.Parent then
                if data.esp then
                    data.esp:Destroy()
                end
                TicketBillboards[ticket] = nil
            end
        end
    end
end

function createTracerObject()
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Thickness = 1
    tracer.ZIndex = 1
    return tracer
end

function updatePlayerTracers()
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    local screenBottomCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
    local currentTargets = {}

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                currentTargets[player] = true
                
                if not playerTracerElements[player] then
                    playerTracerElements[player] = createTracerObject()
                end

                local tracer = playerTracerElements[player]
                local vector, onScreen = camera:WorldToViewportPoint(hrp.Position)

                if onScreen then
                    tracer.Visible = true
                    tracer.From = screenBottomCenter
                    tracer.To = Vector2.new(vector.X, vector.Y)
                    tracer.Color = Color3.fromRGB(255, 255, 255)
                else
                    tracer.Visible = false
                end
            end
        end
    end

    for player, tracer in pairs(playerTracerElements) do
        if not currentTargets[player] then
            if tracer and tracer.Remove then
                tracer:Remove()
            end
            playerTracerElements[player] = nil
        end
    end
end

function updateBotTracers()
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    local screenBottomCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
    local currentTargets = {}

    local playersFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
    if playersFolder then
        for _, model in pairs(playersFolder:GetChildren()) do
            if model:IsA("Model") and isNextbotModel(model) then
                local hrp = model:FindFirstChild("HumanoidRootPart")
                if hrp then
                    currentTargets[model] = true
                    
                    if not botTracerElements[model] then
                        botTracerElements[model] = createTracerObject()
                    end

                    local tracer = botTracerElements[model]
                    local vector, onScreen = camera:WorldToViewportPoint(hrp.Position)

                    if onScreen then
                        tracer.Visible = true
                        tracer.From = screenBottomCenter
                        tracer.To = Vector2.new(vector.X, vector.Y)
                        tracer.Color = Color3.fromRGB(255, 0, 0)
                    else
                        tracer.Visible = false
                    end
                end
            end
        end
    end

    local npcsFolder = workspace:FindFirstChild("NPCs")
    if npcsFolder then
        for _, model in pairs(npcsFolder:GetChildren()) do
            if model:IsA("Model") and isNextbotModel(model) then
                local hrp = model:FindFirstChild("HumanoidRootPart")
                if hrp then
                    currentTargets[model] = true
                    
                    if not botTracerElements[model] then
                        botTracerElements[model] = createTracerObject()
                    end

                    local tracer = botTracerElements[model]
                    local vector, onScreen = camera:WorldToViewportPoint(hrp.Position)

                    if onScreen then
                        tracer.Visible = true
                        tracer.From = screenBottomCenter
                        tracer.To = Vector2.new(vector.X, vector.Y)
                        tracer.Color = Color3.fromRGB(255, 0, 0)
                    else
                        tracer.Visible = false
                    end
                end
            end
        end
    end

    for model, tracer in pairs(botTracerElements) do
        if not currentTargets[model] then
            if tracer and tracer.Remove then
                tracer:Remove()
            end
            botTracerElements[model] = nil
        end
    end
end

function startPlayerTracers()
    if playerTracerConnection then return end
    playerTracerConnection = RunService.RenderStepped:Connect(updatePlayerTracers)
end

function stopPlayerTracers()
    if playerTracerConnection then
        playerTracerConnection:Disconnect()
        playerTracerConnection = nil
    end
    for player, tracer in pairs(playerTracerElements) do
        if tracer and tracer.Remove then
            tracer:Remove()
        end
    end
    playerTracerElements = {}
end

function startBotTracers()
    if botTracerConnection then return end
    botTracerConnection = RunService.RenderStepped:Connect(updateBotTracers)
end

function stopBotTracers()
    if botTracerConnection then
        botTracerConnection:Disconnect()
        botTracerConnection = nil
    end
    for model, tracer in pairs(botTracerElements) do
        if tracer and tracer.Remove then
            tracer:Remove()
        end
    end
    botTracerElements = {}
end

local function startAutoRespawn()
    if AutoSelfReviveConnection then
        AutoSelfReviveConnection:Disconnect()
    end
    if respawnConnection then
        respawnConnection:Disconnect()
    end
    
    local character = LocalPlayer.Character
    if character then
        AutoSelfReviveConnection = character:GetAttributeChangedSignal("Downed"):Connect(function()
            local isDowned = character:GetAttribute("Downed")
            if isDowned then
                if SelfReviveMethod == "Spawnpoint" then
                    if not hasRevived then
                        hasRevived = true
                        
                        pcall(function()
                            ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
                        end)
                        task.delay(0.5, function()
                            hasRevived = false
                        end)
                    end
                elseif SelfReviveMethod == "Fake Revive" then
                    if not hasRevived then
                        hasRevived = true
                        
                        local lastPos = nil
                        if character and character:FindFirstChild("HumanoidRootPart") then
                            lastPos = character.HumanoidRootPart.Position
                        end
                        
                        pcall(function()
                            ReplicatedStorage:WaitForChild("Events"):WaitForChild("Player"):WaitForChild("ChangePlayerMode"):FireServer(true)
                        end)
                        
                        task.spawn(function()
                            for i = 1, 10 do
                                local newChar = LocalPlayer.Character
                                if newChar and newChar ~= character then
                                    local newHRP = newChar:FindFirstChild("HumanoidRootPart")
                                    if newHRP and lastPos then
                                        newHRP.CFrame = CFrame.new(lastPos)
                                        break
                                    end
                                end
                                task.wait(0.05)
                            end
                        end)
                        task.delay(0.5, function()
                            hasRevived = false
                        end)
                    end
                end
            end
        end)
    end
    
    respawnConnection = LocalPlayer.CharacterAdded:Connect(function(newChar)
        task.wait(0.5)
        local newHumanoid = newChar:WaitForChild("Humanoid")
        local newHRP = newChar:WaitForChild("HumanoidRootPart")
        
        AutoSelfReviveConnection = newChar:GetAttributeChangedSignal("Downed"):Connect(function()
            local isDowned = newChar:GetAttribute("Downed")
            if isDowned then
                if SelfReviveMethod == "Spawnpoint" then
                    if not hasRevived then
                        hasRevived = true
                        pcall(function()
                            ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
                        end)
                        task.delay(0.5, function()
                            hasRevived = false
                        end)
                    end
                elseif SelfReviveMethod == "Fake Revive" then
                    if not hasRevived then
                        hasRevived = true
                        local lastPos = nil
                        if newHRP then
                            lastPos = newHRP.Position
                        end
                        pcall(function()
                            ReplicatedStorage:WaitForChild("Events"):WaitForChild("Player"):WaitForChild("ChangePlayerMode"):FireServer(true)
                        end)
                        task.spawn(function()
                            for i = 1, 10 do
                                local freshChar = LocalPlayer.Character
                                if freshChar and freshChar ~= newChar then
                                    local freshHRP = freshChar:FindFirstChild("HumanoidRootPart")
                                    if freshHRP and lastPos then
                                        freshHRP.CFrame = CFrame.new(lastPos)
                                        break
                                    end
                                end
                                task.wait(0.05)
                            end
                        end)
                        task.delay(0.5, function()
                            hasRevived = false
                        end)
                    end
                end
            end
        end)
    end)
end

local function stopAutoRespawn()
    if AutoSelfReviveConnection then
        AutoSelfReviveConnection:Disconnect()
        AutoSelfReviveConnection = nil
    end
    if respawnConnection then
        respawnConnection:Disconnect()
        respawnConnection = nil
    end
    hasRevived = false
    lastSavedPosition = nil
end

local function startAntiAFK()
    if AntiAFKConnection then return end
    AntiAFKConnection = LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

local function stopAntiAFK()
    if AntiAFKConnection then
        AntiAFKConnection:Disconnect()
        AntiAFKConnection = nil
    end
end

local function startAutoWhistle()
    if autoWhistleHandle then 
        stopAutoWhistle() 
    end
    
    autoWhistleHandle = task.spawn(function()
        while true do
            if not AutoWhistleToggle.Value then break end
            
            pcall(function() 
                local success, result = pcall(function()
                    return ReplicatedStorage.Events.Character.Whistle:FireServer()
                end)
                if not success then
                    warn("Auto Whistle Error:", result)
                end
            end)
            
            task.wait(1)
        end
        autoWhistleHandle = nil
    end)
end

local function stopAutoWhistle()
    if autoWhistleHandle then
        local handle = autoWhistleHandle
        autoWhistleHandle = nil
        
        
        pcall(function()
            
            if type(handle) == "table" and handle.cancel then
                handle:cancel()
            end
        end)
    end
end

local StableCamera = {}
StableCamera.__index = StableCamera

function StableCamera.new(maxDistance)
    local self = setmetatable({}, StableCamera)
    self.Player = Players.LocalPlayer
    self.MaxDistance = maxDistance or 50
    self._conn = RunService.RenderStepped:Connect(function(dt) self:Update(dt) end)
    return self
end

local function tryResetShake(player)
    if not player then return end
    local ok, playerScripts = pcall(function() return player:FindFirstChild("PlayerScripts") end)
    if not ok or not playerScripts then return end
    local cameraSet = playerScripts:FindFirstChild("Camera") and playerScripts.Camera:FindFirstChild("Set")
    if cameraSet and type(cameraSet.Invoke) == "function" then
        pcall(function()
            cameraSet:Invoke("CFrameOffset", "Shake", CFrame.new())
        end)
    end
end

function StableCamera:Update(dt)
    if Players and Players.LocalPlayer then
        tryResetShake(Players.LocalPlayer)
    end
end

function StableCamera:Destroy()
    if self._conn then
        self._conn:Disconnect()
        self._conn = nil
    end
end

local function startNoCameraShake()
    if stableCameraInstance then return end
    stableCameraInstance = StableCamera.new()
end

local function stopNoCameraShake()
    if stableCameraInstance then
        stableCameraInstance:Destroy()
        stableCameraInstance = nil
    end
end

 billboardSection = Tabs.Main:AddSection("Billboard ESP", "solar/eye-bold")

 NextbotToggle = Tabs.Main:AddToggle("NextbotToggle", {
    Title = "ESP Nextbots",
    Default = false
})

 PlayerToggle = Tabs.Main:AddToggle("PlayerToggle", {
    Title = "ESP Players",
    Default = false
})

 TicketToggle = Tabs.Main:AddToggle("TicketToggle", {
    Title = "ESP Tickets",
    Default = false
})

local highlightSection = Tabs.Main:AddSection("Highlight", "solar/magic-stick-bold")

local HighlightDownedPlayers = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kdwqwthg/4364523/refs/heads/main/Online%20Script/HighlightPlayers.lua"))()
HighlightDownedPlayers:Init(Fluent, Options)

HighlightDownedToggle = Tabs.Main:AddToggle("HighlightDownedToggle", {
    Title = "Highlight Players",
    Default = false,
    Callback = function(value)
        if value then
            HighlightDownedPlayers:Start()
        else
            HighlightDownedPlayers:Stop()
        end
    end
})

local HighlightBots = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kdwqwthg/4364523/refs/heads/main/Online%20Script/HighlightBots.lua"))()
HighlightBots:Init(Fluent, Options)

HighlightBotsToggle = Tabs.Main:AddToggle("HighlightBotsToggle", {
    Title = "Highlight Bots",
    Default = false,
    Callback = function(value)
        if value then
            HighlightBots:Start()
        else
            HighlightBots:Stop()
        end
    end
})

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(2)
    if HighlightBotsToggle and HighlightBotsToggle.Value then
        HighlightBots:Refresh()
    end
end)

workspace.ChildAdded:Connect(function(child)
    task.wait(1)
    if child.Name == "Game" and HighlightBotsToggle and HighlightBotsToggle.Value then
        HighlightBots:Refresh()
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if HighlightDownedToggle and HighlightDownedToggle.Value then
        HighlightDownedPlayers:Refresh()
    end
end)

 tracerSection = Tabs.Main:AddSection("Tracer ESP", "solar/routing-bold")

 TracerPlayerToggle = Tabs.Main:AddToggle("TracerPlayerToggle", {
    Title = "Tracer Players",
    Default = false
})

 TracerBotToggle = Tabs.Main:AddToggle("TracerBotToggle", {
    Title = "Tracer Bots",
    Default = false
})

 modificationSection = Tabs.Main:AddSection("Respawn", "solar/restart-bold")

 AutoRespawnTypeDropdown = Tabs.Main:AddDropdown("AutoRespawnTypeDropdown", {
    Title = "Auto Respawn Type",
    Values = {"Spawnpoint", "Fake Revive"},
    Multi = false,
    Default = "Spawnpoint",
})

RespawnButton = Tabs.Main:AddButton({
    Title = "Respawn Button",
    Callback = function()
        local CoreGui = game:GetService("CoreGui")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        
        local existingScreenGui = CoreGui:FindFirstChild("DraconicRespawnButtonGUI")
        
        if existingScreenGui then
            existingScreenGui:Destroy()
        else
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "DraconicRespawnButtonGUI"
            screenGui.ResetOnSpawn = false
            screenGui.Parent = CoreGui

            local buttonSize = 180
            if Options.RespawnButtonSizeInput and Options.RespawnButtonSizeInput.Value and tonumber(Options.RespawnButtonSizeInput.Value) then
                buttonSize = tonumber(Options.RespawnButtonSizeInput.Value)
            end
            
            local btnWidth = math.max(150, math.min(buttonSize, 400))
            local btnHeight = math.max(60, math.min(buttonSize * 0.4, 160))
            
            local btn, clicker, stroke = createGradientButton(
                screenGui,
                UDim2.new(0.5, -btnWidth/2, 0.5, -btnHeight/2),
                UDim2.new(0, btnWidth, 0, btnHeight),
                "RESPAWN"
            )
            clicker.MouseButton1Click:Connect(function()
                  manualRevive()
            end)
        end
    end
})

modificationSection = Tabs.Main:AddSection("Things", "solar/settings-bold")

 AntiAFKToggle = Tabs.Main:AddToggle("AntiAFKToggle", {
    Title = "Anti AFK",
    Default = false
})

 AutoWhistleToggle = Tabs.Main:AddToggle("AutoWhistleToggle", {
    Title = "Auto Whistle",
    Default = false
})

 NoCameraShakeToggle = Tabs.Main:AddToggle("NoCameraShakeToggle", {
    Title = "No Camera Shake",
    Default = false
})

NextbotToggle:OnChanged(function(value)
    if value then
        
        if not ExternalNextbotESPLoaded then
            local success, errorMsg = pcall(function()
                ExternalNextbotESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kdwqwthg/4364523/refs/heads/main/Online%20Script/NextbotESP.lua"))()
                ExternalNextbotESPLoaded = true
                
                _G.NextbotESPRunning = true
                
                if ExternalNextbotESP and ExternalNextbotESP.Start then
                    ExternalNextbotESP.Start()
                end
                
                Fluent:Notify({
                    Title = "ESP Nextbots",
                    Content = "External Nextbot ESP loaded and running!",
                    Duration = 3
                })
            end)
            
            if not success then
                Fluent:Notify({
                    Title = "ESP Nextbots Error",
                    Content = "Failed to load external Nextbot ESP: " .. tostring(errorMsg),
                    Duration = 5
                })
                Options.NextbotToggle:Set(false)
                return
            end
        else
            if ExternalNextbotESP and ExternalNextbotESP.Start then
                ExternalNextbotESP.Start()
            end
            _G.NextbotESPRunning = true
        end
        
        
        if not nextbotLoop then
            nextbotLoop = RunService.Heartbeat:Connect(function()
                if Options.NextbotToggle.Value then
                    if _G.NextbotESPRunning == false then
                        _G.NextbotESPRunning = true
                        if ExternalNextbotESP and ExternalNextbotESP.Start then
                            pcall(ExternalNextbotESP.Start)
                        end
                    end
                end
            end)
        end
        
    else
        
        if nextbotLoop then
            nextbotLoop:Disconnect()
            nextbotLoop = nil
        end
        
        
        if ExternalNextbotESP and ExternalNextbotESPLoaded then
            if ExternalNextbotESP.Stop then
                pcall(function()
                    ExternalNextbotESP.Stop()
                end)
            end
        end
        
        
        task.spawn(function()
            task.wait(0.2)
            
            
            for model, data in pairs(NextbotBillboards) do
                if data.esp and data.esp:IsDescendantOf(game) then
                    local espName = data.esp.Name:lower()
                    if espName:find("nextbot") or espName:find("bot") or espName:find("npc") then
                        data.esp:Destroy()
                    end
                end
            end
            NextbotBillboards = {}
            
            
            for model, tracer in pairs(botTracerElements) do
                if tracer and tracer.Remove then
                    pcall(function()
                        tracer:Remove()
                    end)
                end
            end
            botTracerElements = {}
            
            
            pcall(function()
                for _, drawing in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetDescendants()) do
                    if drawing:IsA("BillboardGui") and drawing.Name:find("Nextbot") then
                        drawing:Destroy()
                    end
                end
                
                
                for _, obj in pairs(getgc(true)) do
                    if type(obj) == "table" then
                        if obj.__type and obj.__type == "Drawing" and obj.Color then
                            
                            if obj.Color.r == 1 and obj.Color.g == 0 and obj.Color.b == 0 then
                                if obj.Remove then
                                    pcall(obj.Remove, obj)
                                end
                            end
                        end
                    end
                end
            end)
        end)
        
        
        ExternalNextbotESPLoaded = false
        _G.NextbotESPRunning = false
        
        Fluent:Notify({
            Title = "ESP Nextbots",
            Content = "Nextbot ESP disabled!",
            Duration = 3
        })
    end
end)

PlayerToggle:OnChanged(function(value)
    if value then
        
        cleanUpOnlyPlayerESPObjects()
        
        
        local nextbotESPActive = Options.NextbotToggle and Options.NextbotToggle.Value
        
        
        if not ExternalESPLoaded then
            local success, errorMsg = pcall(function()
                
                local espScript = game:HttpGet("https://raw.githubusercontent.com/Kdwqwthg/4364523/refs/heads/main/Online%20Script/Esp.lua", true)
                
                
                espScript = [[
                    if _G.PlayerESP_Loaded == true then
                        return
                    end
                    _G.PlayerESP_Loaded = true

                    local function cleanOldPlayerESP()
                        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                            if player ~= game:GetService("Players").LocalPlayer then
                                if player.Character then
                                    local esp = player.Character:FindFirstChild("PlayerESP")
                                    if esp then
                                        esp:Destroy()
                                    end
                                end
                            end
                        end
                    end
                    cleanOldPlayerESP()
                    
                ]] .. espScript
                
                ExternalESP = loadstring(espScript)()
                ExternalESPLoaded = true
                
                
                _G.ExternalESPRunning = true
                _G.PlayerESP_Loaded = true
                
                Fluent:Notify({
                    Title = "ESP Players",
                    Content = "Player ESP loaded!",
                    Duration = 3
                })
            end)
            
            if not success then
                Fluent:Notify({
                    Title = "ESP Players Error",
                    Content = "Failed to load ESP: " .. tostring(errorMsg),
                    Duration = 5
                })
                Options.PlayerToggle:Set(false)
                return
            end
        else
            
            _G.ExternalESPRunning = true
            _G.PlayerESP_Loaded = true
        end
        
        
        if nextbotESPActive then
            task.wait(0.5)
            if ExternalNextbotESP and ExternalNextbotESPLoaded and ExternalNextbotESP.Start then
                pcall(ExternalNextbotESP.Start)
            end
        end
        
        
        if not playerLoop then
            playerLoop = RunService.Heartbeat:Connect(function()
                if Options.PlayerToggle.Value then
                    
                    local playerEspCount = 0
                    
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            
                            for _, obj in pairs(player.Character:GetDescendants()) do
                                if obj:IsA("BillboardGui") then
                                    local textLabels = obj:GetDescendants()
                                    local labelCount = 0
                                    for _, label in pairs(textLabels) do
                                        if label:IsA("TextLabel") then
                                            labelCount = labelCount + 1
                                        end
                                    end
                                    
                                    
                                    if labelCount > 3 then
                                        obj:Destroy()
                                        playerEspCount = playerEspCount + 1
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
        
    else
        
        if playerLoop then
            playerLoop:Disconnect()
            playerLoop = nil
        end
        
        
        cleanUpOnlyPlayerESPObjects()
        
        
        if ExternalESP and ExternalESPLoaded then
            if type(ExternalESP) == "table" and ExternalESP.Stop then
                pcall(ExternalESP.Stop)
            end
        end
        
        
        _G.ExternalESPRunning = false
        _G.PlayerESP_Loaded = false
        ExternalESPLoaded = false
        
        Fluent:Notify({
            Title = "ESP Players",
            Content = "Player ESP disabled!",
            Duration = 3
        })
    end
end)

TicketToggle:OnChanged(function(value)
    if value then
        
        if not ExternalTicketESPLoaded then
            local success, errorMsg = pcall(function()
                
                ExternalTicketESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kdwqwthg/4364523/refs/heads/main/Online%20Script/TicketESP.lua"))()
                ExternalTicketESPLoaded = true
                
                
                _G.TicketESPRunning = true
                
                Fluent:Notify({
                    Title = "ESP Tickets",
                    Content = "External Ticket ESP loaded!",
                    Duration = 3
                })
            end)
            
            if not success then
                Fluent:Notify({
                    Title = "ESP Tickets Error",
                    Content = "Failed to load external Ticket ESP: " .. tostring(errorMsg),
                    Duration = 5
                })
            end
        else
            
            _G.TicketESPRunning = true
        end
        
        
        if not ticketLoop then
            ticketLoop = RunService.RenderStepped:Connect(function()
                if Options.TicketToggle.Value then
                    scanForTickets()
                end
            end)
        end
    else
        
        if ExternalTicketESPLoaded then
            if _G.StopTicketESP then
                pcall(_G.StopTicketESP)
            end
        end
        
        
        if ticketLoop then
            ticketLoop:Disconnect()
            ticketLoop = nil
        end
        
        
        for ticket, data in pairs(TicketBillboards) do
            if data.esp then
                data.esp:Destroy()
            end
        end
        TicketBillboards = {}
        
        ExternalTicketESPLoaded = false
        _G.TicketESPRunning = false
        
        Fluent:Notify({
            Title = "ESP Tickets",
            Content = "Ticket ESP disabled!",
            Duration = 3
        })
    end
end)

TracerPlayerToggle:OnChanged(function(value)
    if value then
        startPlayerTracers()
    else
        stopPlayerTracers()
    end
end)

TracerBotToggle:OnChanged(function(value)
    if value then
        startBotTracers()
    else
        stopBotTracers()
    end
end)

AutoRespawnTypeDropdown:OnChanged(function(value)
    SelfReviveMethod = value
end)

AntiAFKToggle:OnChanged(function(value)
    if value then
        startAntiAFK()
    else
        stopAntiAFK()
    end
end)

AutoWhistleToggle:OnChanged(function(value)
    if value then
        startAutoWhistle()
    else
        stopAutoWhistle()
    end
end)

NoCameraShakeToggle:OnChanged(function(value)
    if value then
        startNoCameraShake()
    else
        stopNoCameraShake()
    end
end)

local TimerDisplayToggle = Tabs.Main:AddToggle("TimerDisplayToggle", {
    Title = "Show Timer",
    Default = false
})

local timerDisplayLoop = nil

TimerDisplayToggle:OnChanged(function(state)
    if state then
        if timerDisplayLoop then return end
        
        timerDisplayLoop = RunService.RenderStepped:Connect(function()
            local player = game:GetService("Players").LocalPlayer
            local pg = player.PlayerGui
            
            
            local gameGui = pg:FindFirstChild("Game")
            local hud = gameGui and gameGui:FindFirstChild("HUD")
            local overlay = hud and hud:FindFirstChild("Overlay")
            local roundOverlay = overlay and overlay:FindFirstChild("RoundOverlay")
            local roundTimer = roundOverlay and roundOverlay:FindFirstChild("RoundTimer")
            
            if timer then
                timer.Visible = true
            end
            
            local main = pg:FindFirstChild("MainInterface")
            if main then
                local container = main:FindFirstChild("TimerContainer")
                if container then
                    container.Visible = true
                end
            end
        end)
    else
        if timerDisplayLoop then
            timerDisplayLoop:Disconnect()
            timerDisplayLoop = nil
        end
        
        local player = game:GetService("Players").LocalPlayer
        local pg = player.PlayerGui
        
        local gameGui = pg:FindFirstChild("Game")
        local hud = gameGui and gameGui:FindFirstChild("HUD")
        local overlay = hud and hud:FindFirstChild("Overlay")
        local roundOverlay = overlay and overlay:FindFirstChild("RoundOverlay")
        local roundTimer = roundOverlay and roundOverlay:FindFirstChild("RoundTimer")
        
        if timer then
            timer.Visible = false
        end
        
        local main = pg:FindFirstChild("MainInterface")
        if main then
            local container = main:FindFirstChild("TimerContainer")
            if container then
                container.Visible = false
            end
        end
    end
end)
local billboardSection = Tabs.Main:AddSection("Player Modification", "solar/user-bold")

 FlyToggle = Tabs.Main:AddToggle("FlyToggle", {
    Title = "Fly",
    Default = false
})

 FlySpeedInput = Tabs.Main:AddInput("FlySpeedInput", {
    Title = "Fly Speed",
    Default = "50",
    Placeholder = "Enter speed value",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        if Value and tonumber(Value) then
            featureStates.FlySpeed = tonumber(Value)
        end
    end
})

local flying = false
local bodyVelocity = nil
local bodyGyro = nil
local character = LocalPlayer.Character
local humanoid = character and character:FindFirstChild("Humanoid")
local rootPart = character and character:FindFirstChild("HumanoidRootPart")
local UserInputService = game:GetService("UserInputService")

featureStates = featureStates or {}
featureStates.FlySpeed = 50

local function startFlying()
    if not character or not humanoid or not rootPart then 
        
        character = LocalPlayer.Character
        if not character then return end
        humanoid = character:WaitForChild("Humanoid")
        rootPart = character:WaitForChild("HumanoidRootPart")
        if not humanoid or not rootPart then return end
    end
    
    flying = true
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart
    
    humanoid.PlatformStand = true
end

local function stopFlying()
    flying = false
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    if humanoid then
        humanoid.PlatformStand = false
    end
end

local function updateFly()
    if not flying or not bodyVelocity or not bodyGyro then return end
    local camera = workspace.CurrentCamera
    local cameraCFrame = camera.CFrame
    local direction = Vector3.new(0, 0, 0)
    local moveDirection = humanoid.MoveDirection
    
    if moveDirection.Magnitude > 0 then
        local forwardVector = cameraCFrame.LookVector
        local rightVector = cameraCFrame.RightVector
        local forwardComponent = moveDirection:Dot(forwardVector) * forwardVector
        local rightComponent = moveDirection:Dot(rightVector) * rightVector
        direction = direction + (forwardComponent + rightComponent).Unit * moveDirection.Magnitude
    end
    
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) or humanoid.Jump then
        direction = direction + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        direction = direction - Vector3.new(0, 1, 0)
    end
    
    local speed = featureStates.FlySpeed or 50
    bodyVelocity.Velocity = direction.Magnitude > 0 and direction.Unit * (speed * 2) or Vector3.new(0, 0, 0)
    bodyGyro.CFrame = cameraCFrame
end

local flyLoop = nil

local characterAddedConnection = nil

FlyToggle:OnChanged(function(state)
    if state then
        
        if characterAddedConnection then
            characterAddedConnection:Disconnect()
        end
        
        characterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(newChar)
            character = newChar
            task.wait(0.5)
            humanoid = character:WaitForChild("Humanoid")
            rootPart = character:WaitForChild("HumanoidRootPart")
            
            
            if Options.FlyToggle.Value and flying == false then
                startFlying()
            end
        end)
        
        
        character = LocalPlayer.Character
        if character then
            humanoid = character:FindFirstChild("Humanoid")
            rootPart = character:FindFirstChild("HumanoidRootPart")
        end
        
        startFlying()
        
        
        if not flyLoop then
            flyLoop = RunService.RenderStepped:Connect(function()
                if Options.FlyToggle.Value then
                    updateFly()
                end
            end)
        end
    else
        stopFlying()
        
        if flyLoop then
            flyLoop:Disconnect()
            flyLoop = nil
        end
        
        if characterAddedConnection then
            characterAddedConnection:Disconnect()
            characterAddedConnection = nil
        end
    end
end)

game:GetService("Players").LocalPlayer.CharacterRemoving:Connect(function()
    if Options.FlyToggle.Value then
        stopFlying()
        if flyLoop then
            flyLoop:Disconnect()
            flyLoop = nil
        end
    end
end)

modificationSection = Tabs.Main:AddSection("Manual", "solar/hand-shake-bold")

 function manualRevive()
    local player = game:GetService("Players").LocalPlayer
    
    
    local gamePlayers = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
    if not gamePlayers then return end
    
    local character = gamePlayers:FindFirstChild(player.Name)
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local isDowned = character:GetAttribute("Downed")
    
    if not isDowned then 
        return 
    end
    
    local SelfReviveMethod = Options.AutoRespawnTypeDropdown and Options.AutoRespawnTypeDropdown.Value or "Spawnpoint"
    
    if SelfReviveMethod == "Spawnpoint" then
        pcall(function()
            ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
        end)
        
    elseif SelfReviveMethod == "Fake Revive" then
        
        local lastSavedPosition = nil
        if hrp then
            lastSavedPosition = hrp.Position
        end
        
        
        pcall(function()
            ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
        end)
        
        
        task.spawn(function()
            for i = 1, 30 do
                task.wait(0.05)
                local newGamePlayers = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
                if newGamePlayers then
                    local newCharacter = newGamePlayers:FindFirstChild(player.Name)
                    if newCharacter and newCharacter ~= character then
                        local newHRP = newCharacter:FindFirstChild("HumanoidRootPart")
                        if newHRP and lastSavedPosition then
                            newHRP.CFrame = CFrame.new(lastSavedPosition)
                            newHRP.Velocity = Vector3.new(0, 0, 0)
                            break
                        end
                    end
                end
            end
        end)
    end
end

NoclipToggle = Tabs.Main:AddToggle("NoclipToggle", {
    Title = "Noclip",
    Default = false
})

local noclipEnabled = false
local noclipConnection = nil

local function toggleNoclip(state)
    noclipEnabled = state
    
    if noclipEnabled then
        
        if noclipConnection then
            noclipConnection:Disconnect()
        end
        
        noclipConnection = RunService.Stepped:Connect(function()
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
        
        Fluent:Notify({
            Title = "Noclip",
            Content = "Noclip enabled",
            Duration = 2
        })
    else
        
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        
        
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        
        Fluent:Notify({
            Title = "Noclip",
            Content = "Noclip disabled",
            Duration = 2
        })
    end
end

NoclipToggle:OnChanged(function(value)
    toggleNoclip(value)
end)

LocalPlayer.CharacterAdded:Connect(function(character)
    if noclipEnabled then
        task.wait(0.5) 
        toggleNoclip(false) 
        task.wait(0.1)
        toggleNoclip(true) 
    end
end)

game:GetService("Players").LocalPlayer.CharacterRemoving:Connect(function()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
end)

toggleNoclip(false)

SitToggle = Tabs.Main:AddToggle("SitToggle", {
    Title = "Bug Emote",
    Default = false
})

local sitLoopConnection = nil
local player = game:GetService("Players").LocalPlayer

local function updateSit()
    if not SitToggle.Value then return end
    
    local character = player.Character
    if not character then return end
    
    
    
    local humanoid = character:FindFirstChild("Humanoid")
    
    
    if not humanoid then
        local gamePlayers = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
        if gamePlayers then
            local playerModel = gamePlayers:FindFirstChild(player.Name)
            if playerModel then
                humanoid = playerModel:FindFirstChild("Humanoid")
            end
        end
    end
    
    if humanoid then
        humanoid.Sit = true
    end
end

SitToggle:OnChanged(function(state)
    if state then
        
        if sitLoopConnection then
            sitLoopConnection:Disconnect()
        end
        
        
        sitLoopConnection = game:GetService("RunService").Heartbeat:Connect(updateSit)
        
        
        updateSit()
        
        Fluent:Notify({
            Title = "Force Sit",
            Content = "Character will now sit continuously",
            Duration = 2
        })
    else
        
        if sitLoopConnection then
            sitLoopConnection:Disconnect()
            sitLoopConnection = nil
        end
        
        
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if not humanoid then
                local gamePlayers = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
                if gamePlayers then
                    local playerModel = gamePlayers:FindFirstChild(player.Name)
                    if playerModel then
                        humanoid = playerModel:FindFirstChild("Humanoid")
                    end
                end
            end
            if humanoid then
                humanoid.Sit = false
            end
        end
        
        Fluent:Notify({
            Title = "Force Sit",
            Content = "Sit mode disabled",
            Duration = 2
        })
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(1) 
    if SitToggle and SitToggle.Value then
        updateSit()
    end
end)

player.CharacterRemoving:Connect(function()
    if sitLoopConnection then
        sitLoopConnection:Disconnect()
        sitLoopConnection = nil
    end
end)

NoCollisionToggle = Tabs.Main:AddToggle("NoCollisionToggle", {
    Title = "Remove Barriers",
    Default = false
})

local function toggleInvisPartsCollision(state)
    local invisParts = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("InvisParts")
    
    if not invisParts then
        Fluent:Notify({
            Title = "Remove Barriers",
            Content = "InvisParts folder not found!",
            Duration = 3
        })
        return
    end
    
    local objectsChanged = 0
    
    for _, obj in ipairs(invisParts:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.CanCollide = not state 
            obj.CanQuery = not state   
            objectsChanged = objectsChanged + 1
        end
    end
    
    Fluent:Notify({
        Title = "Remove Barriers",
        Content = string.format("%s collision and query for %d objects", 
            state and "Disabled" or "Enabled", 
            objectsChanged),
        Duration = 3
    })
end

NoCollisionToggle:OnChanged(function(state)
    toggleInvisPartsCollision(state)
end)

LocalPlayer.CharacterAdded:Connect(function()
    if Options.NoCollisionToggle and Options.NoCollisionToggle.Value then
        task.wait(1)
        toggleInvisPartsCollision(true)
    end
end)

InvisPartsTransparencyToggle = Tabs.Main:AddToggle("InvisPartsTransparencyToggle", {
    Title = "Barriers Visible",
    Default = false
})

local function setInvisPartsTransparency(transparent)
    local invisParts = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("InvisParts")
    
    if not invisParts then
        Fluent:Notify({
            Title = "Barriers Visible",
            Content = "InvisParts folder not found!",
            Duration = 3
        })
        return
    end
    
    local changed = 0
    
    if transparent then
        for _, obj in ipairs(invisParts:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Decal") then
                obj.Transparency = 0
                changed = changed + 1
            end
        end
        
        Fluent:Notify({
            Title = "Barriers Visible",
            Content = string.format("Set Transparency = 0 for %d objects", changed),
            Duration = 3
        })
    else
        for _, obj in ipairs(invisParts:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Decal") then
                obj.Transparency = 1
                changed = changed + 1
            end
        end
        
        Fluent:Notify({
            Title = "Barriers Disable",
            Content = string.format("Set Transparency = 1 for %d objects", changed),
            Duration = 3
        })
    end
end

InvisPartsTransparencyToggle:OnChanged(function(state)
    setInvisPartsTransparency(state)
    
    if state then
        local invisParts = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("InvisParts")
        
        if invisParts then
            invisParts.DescendantAdded:Connect(function(obj)
                if state then
                    if obj:IsA("BasePart") or obj:IsA("Decal") then
                        task.wait(0.05)
                        obj.Transparency = 0
                    end
                end
            end)
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    if Options.InvisPartsTransparencyToggle and Options.InvisPartsTransparencyToggle.Value then
        task.wait(1)
        setInvisPartsTransparency(true)
    end
end)

game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == LocalPlayer and Options.InvisPartsTransparencyToggle and Options.InvisPartsTransparencyToggle.Value then
        setInvisPartsTransparency(false)
    end
end)

LeaderboardToggle = Tabs.Main:AddButton({
    Title = "Unlock Leaderboard",
    Callback = function()
        local player = game.Players.LocalPlayer
        local guiService = game:GetService("GuiService")
        local starterGui = game:GetService("StarterGui")
        local TweenService = game:GetService("TweenService")
        local UserInputService = game:GetService("UserInputService")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")

        local playerGui = player:WaitForChild("PlayerGui")
        if playerGui:FindFirstChild("CustomTopGui") then
            playerGui.CustomTopGui:Destroy()
        end

        starterGui:SetCore("TopbarEnabled", false)

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "CustomTopGui"
        screenGui.IgnoreGuiInset = false
        screenGui.ScreenInsets = Enum.ScreenInsets.TopbarSafeInsets
        screenGui.DisplayOrder = 100
        screenGui.ResetOnSpawn = false
        screenGui.Parent = playerGui

        local frame = Instance.new("Frame")
        frame.Parent = screenGui
        frame.BackgroundTransparency = 1
        frame.BorderSizePixel = 0
        frame.Position = UDim2.new(0, 0, 0, 0)
        frame.Size = UDim2.new(1, 0, 1, -2)

        local scrollingFrame = Instance.new("ScrollingFrame")
        scrollingFrame.Name = "Right"
        scrollingFrame.Parent = frame
        scrollingFrame.BackgroundTransparency = 1
        scrollingFrame.BorderSizePixel = 0
        scrollingFrame.Position = UDim2.new(0, 12, 0, 0)
        scrollingFrame.Size = UDim2.new(1, -24, 1, 0)
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
        scrollingFrame.ScrollBarThickness = 0
        scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
        scrollingFrame.ScrollingEnabled = false

        local uiListLayout = Instance.new("UIListLayout")
        uiListLayout.Parent = scrollingFrame
        uiListLayout.Padding = UDim.new(0, 12)
        uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        uiListLayout.FillDirection = Enum.FillDirection.Horizontal
        uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

        -- РќР°С…РѕРґРёРј SendKeybindEvent
        local SendKeybindEvent = nil
        for _, obj in ipairs(game:GetDescendants()) do
            if obj:IsA("BindableEvent") and obj.Name == "SendKeybindEvent" then
                SendKeybindEvent = obj
                break
            end
        end

        -- РўРѕР»СЊРєРѕ РєРЅРѕРїРєР° Leaderboard
        local config = {
            name = "LeaderboardButton",
            layoutOrder = 998,
            icon = "rbxassetid://5107166345",
            label = "Leaderboard",
            width = 143,
            labelWidth = 88,
            key = "Leaderboard"
        }

        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        local Button = Instance.new("Frame")
        Button.Name = config.name
        Button.Parent = scrollingFrame
        Button.BackgroundTransparency = 1
        Button.ClipsDescendants = true
        Button.LayoutOrder = config.layoutOrder
        Button.Size = UDim2.new(0, 44, 0, 44)
        Button.ZIndex = 20

        local IconButton = Instance.new("Frame")
        IconButton.Name = "IconButton"
        IconButton.Parent = Button
        IconButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        IconButton.BackgroundTransparency = 0.3
        IconButton.BorderSizePixel = 0
        IconButton.ClipsDescendants = true
        IconButton.Size = UDim2.new(1, 0, 1, 0)
        IconButton.ZIndex = 2

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(1, 0)
        UICorner.Parent = IconButton

        local Menu = Instance.new("ScrollingFrame")
        Menu.Name = "Menu"
        Menu.Parent = IconButton
        Menu.BackgroundTransparency = 1
        Menu.BorderSizePixel = 0
        Menu.Position = UDim2.new(0, 4, 0, 0)
        Menu.Selectable = false
        Menu.Size = UDim2.new(1, 0, 1, 0)
        Menu.ZIndex = 20
        Menu.BottomImage = ""
        Menu.CanvasSize = UDim2.new(0, 0, 1, -1)
        Menu.HorizontalScrollBarInset = Enum.ScrollBarInset.Always
        Menu.ScrollBarThickness = 3
        Menu.TopImage = ""

        local MenuUIListLayout = Instance.new("UIListLayout")
        MenuUIListLayout.Name = "MenuUIListLayout"
        MenuUIListLayout.Parent = Menu
        MenuUIListLayout.FillDirection = Enum.FillDirection.Horizontal
        MenuUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        MenuUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

        local MenuGap = Instance.new("Frame")
        MenuGap.Name = "MenuGap"
        MenuGap.Parent = Menu
        MenuGap.AnchorPoint = Vector2.new(0, 0.5)
        MenuGap.BackgroundTransparency = 1
        MenuGap.Size = UDim2.new(0, 4, 0, 0)
        MenuGap.Visible = false
        MenuGap.ZIndex = 5

        local IconSpot = Instance.new("Frame")
        IconSpot.Name = "IconSpot"
        IconSpot.Parent = Menu
        IconSpot.AnchorPoint = Vector2.new(0, 0.5)
        IconSpot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        IconSpot.BackgroundTransparency = 1
        IconSpot.Position = UDim2.new(0, 4, 0.5, 0)
        IconSpot.Size = UDim2.new(0, 36, 1, -8)
        IconSpot.ZIndex = 5

        local UICorner_2 = Instance.new("UICorner")
        UICorner_2.CornerRadius = UDim.new(1, 0)
        UICorner_2.Parent = IconSpot

        local IconOverlay = Instance.new("Frame")
        IconOverlay.Name = "IconOverlay"
        IconOverlay.Parent = IconSpot
        IconOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        IconOverlay.BackgroundTransparency = 0.925
        IconOverlay.Size = UDim2.new(1, 0, 1, 0)
        IconOverlay.Visible = false
        IconOverlay.ZIndex = 6

        local UICorner_3 = Instance.new("UICorner")
        UICorner_3.CornerRadius = UDim.new(1, 0)
        UICorner_3.Parent = IconOverlay

        local ClickRegion = Instance.new("TextButton")
        ClickRegion.Name = "ClickRegion"
        ClickRegion.Parent = IconSpot
        ClickRegion.BackgroundTransparency = 1
        ClickRegion.Size = UDim2.new(1, 0, 1, 0)
        ClickRegion.ZIndex = 20
        ClickRegion.Text = ""

        local UICorner_4 = Instance.new("UICorner")
        UICorner_4.CornerRadius = UDim.new(1, 0)
        UICorner_4.Parent = ClickRegion

        local Contents = Instance.new("Frame")
        Contents.Name = "Contents"
        Contents.Parent = IconSpot
        Contents.BackgroundTransparency = 1
        Contents.Size = UDim2.new(1, 0, 1, 0)

        local ContentsList = Instance.new("UIListLayout")
        ContentsList.Name = "ContentsList"
        ContentsList.Parent = Contents
        ContentsList.FillDirection = Enum.FillDirection.Horizontal
        ContentsList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        ContentsList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentsList.VerticalAlignment = Enum.VerticalAlignment.Center
        ContentsList.Padding = UDim.new(0, 3)

        local PaddingLeft = Instance.new("Frame")
        PaddingLeft.Name = "PaddingLeft"
        PaddingLeft.Parent = Contents
        PaddingLeft.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        PaddingLeft.BackgroundTransparency = 1
        PaddingLeft.BorderColor3 = Color3.fromRGB(0, 0, 0)
        PaddingLeft.BorderSizePixel = 0
        PaddingLeft.LayoutOrder = 1
        PaddingLeft.Size = UDim2.new(0, 9, 1, 0)
        PaddingLeft.ZIndex = 5

        local PaddingCenter = Instance.new("Frame")
        PaddingCenter.Name = "PaddingCenter"
        PaddingCenter.Parent = Contents
        PaddingCenter.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        PaddingCenter.BackgroundTransparency = 1
        PaddingCenter.BorderColor3 = Color3.fromRGB(0, 0, 0)
        PaddingCenter.BorderSizePixel = 0
        PaddingCenter.LayoutOrder = 3
        PaddingCenter.Size = UDim2.new(0, 0, 1, 0)
        PaddingCenter.ZIndex = 5

        local PaddingRight = Instance.new("Frame")
        PaddingRight.Name = "PaddingRight"
        PaddingRight.Parent = Contents
        PaddingRight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        PaddingRight.BackgroundTransparency = 1
        PaddingRight.BorderColor3 = Color3.fromRGB(0, 0, 0)
        PaddingRight.BorderSizePixel = 0
        PaddingRight.LayoutOrder = 5
        PaddingRight.Size = UDim2.new(0, 11, 1, 0)
        PaddingRight.ZIndex = 5

        local IconLabelContainer = Instance.new("Frame")
        IconLabelContainer.Name = "IconLabelContainer"
        IconLabelContainer.Parent = Contents
        IconLabelContainer.AnchorPoint = Vector2.new(0, 0.5)
        IconLabelContainer.BackgroundTransparency = 1
        IconLabelContainer.LayoutOrder = 4
        IconLabelContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
        IconLabelContainer.Size = UDim2.new(0, 0, 1, 0)
        IconLabelContainer.Visible = false
        IconLabelContainer.ZIndex = 3

        local IconLabel = Instance.new("TextLabel")
        IconLabel.Name = "IconLabel"
        IconLabel.Parent = IconLabelContainer
        IconLabel.BackgroundTransparency = 1
        IconLabel.LayoutOrder = 4
        IconLabel.Size = UDim2.new(0, 1306, 1, 0)
        IconLabel.ZIndex = 15
        IconLabel.Font = Enum.Font.GothamMedium
        IconLabel.Text = config.label
        IconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        IconLabel.TextSize = 16
        IconLabel.TextWrapped = true
        IconLabel.TextXAlignment = Enum.TextXAlignment.Left
        IconLabel.Visible = false

        local IconImage = Instance.new("ImageLabel")
        IconImage.Name = "IconImage"
        IconImage.Parent = Contents
        IconImage.AnchorPoint = Vector2.new(0, 0.5)
        IconImage.BackgroundTransparency = 1
        IconImage.LayoutOrder = 2
        IconImage.Position = UDim2.new(0, 11, 0.5, 0)
        IconImage.Size = UDim2.new(0.7, 0, 0.7, 0)
        IconImage.ZIndex = 15
        IconImage.Image = config.icon

        local IconImageCorner = Instance.new("UICorner")
        IconImageCorner.CornerRadius = UDim.new(0, 0)
        IconImageCorner.Name = "IconImageCorner"
        IconImageCorner.Parent = IconImage

        local IconImageRatio = Instance.new("UIAspectRatioConstraint")
        IconImageRatio.Name = "IconImageRatio"
        IconImageRatio.Parent = IconImage
        IconImageRatio.DominantAxis = Enum.DominantAxis.Height

        local IconSpotGradient = Instance.new("UIGradient")
        IconSpotGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(96, 98, 100)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(77, 78, 80))
        }
        IconSpotGradient.Rotation = 45
        IconSpotGradient.Name = "IconSpotGradient"
        IconSpotGradient.Parent = IconSpot

        local IconGradient = Instance.new("UIGradient")
        IconGradient.Name = "IconGradient"
        IconGradient.Parent = IconButton

        local isHovering = false
        local currentTween = nil
        local hideDelay = 0.3
        local isMouseDown = false
        
        local smallButtonSize = UDim2.new(0, 44, 0, 44)
        local largeButtonSize = UDim2.new(0, config.width, 0, 44)
        local smallIconSpotSize = UDim2.new(0, 36, 1, -8)
        local largeIconSpotSize = UDim2.new(0, config.width - 8, 1, -8)
        local smallLabelSize = UDim2.new(0, 0, 1, 0)
        local largeLabelSize = UDim2.new(0, config.labelWidth, 1, 0)

        local function hideTextWithDelay()
            task.wait(hideDelay)
            if not isHovering then
                IconLabel.Visible = false
                IconLabelContainer.Visible = false
                IconOverlay.Visible = false
            end
        end

        local function expand()
            isHovering = true
            
            if currentTween then
                currentTween:Cancel()
            end
            
            IconLabel.Visible = true
            IconLabelContainer.Visible = true
            IconOverlay.Visible = true
            
            currentTween = TweenService:Create(Button, tweenInfo, {Size = largeButtonSize})
            currentTween:Play()
            
            TweenService:Create(IconSpot, tweenInfo, {Size = largeIconSpotSize}):Play()
            TweenService:Create(IconLabelContainer, tweenInfo, {Size = largeLabelSize}):Play()
        end

        local function contract()
            isHovering = false
            
            if currentTween then
                currentTween:Cancel()
            end
            
            currentTween = TweenService:Create(Button, tweenInfo, {Size = smallButtonSize})
            currentTween:Play()
            
            TweenService:Create(IconSpot, tweenInfo, {Size = smallIconSpotSize}):Play()
            TweenService:Create(IconLabelContainer, tweenInfo, {Size = smallLabelSize}):Play()
            
            hideTextWithDelay()
        end

        ClickRegion.MouseEnter:Connect(function()
            expand()
        end)

        ClickRegion.MouseLeave:Connect(function()
            contract()
            if isMouseDown then
                isMouseDown = false
                if SendKeybindEvent then
                    SendKeybindEvent:Fire({
                        Key = config.key,
                        Down = false,
                        GameProcessed = false
                    })
                end
            end
        end)

        ClickRegion.MouseButton1Down:Connect(function()
            isMouseDown = true
            if SendKeybindEvent then
                SendKeybindEvent:Fire({
                    Key = config.key,
                    Down = true,
                    GameProcessed = false
                })
            end
        end)

        ClickRegion.MouseButton1Up:Connect(function()
            isMouseDown = false
            if SendKeybindEvent then
                SendKeybindEvent:Fire({
                    Key = config.key,
                    Down = false,
                    GameProcessed = false
                })
            end
        end)

        player.CharacterAdded:Connect(function()
            task.wait(0.1)
            isHovering = false
            isMouseDown = false
            if currentTween then
                currentTween:Cancel()
                currentTween = nil
            end
            
            Button.Size = smallButtonSize
            IconSpot.Size = smallIconSpotSize
            IconLabelContainer.Size = smallLabelSize
            IconLabel.Visible = false
            IconLabelContainer.Visible = false
            IconOverlay.Visible = false
        end)
        
        Fluent:Notify({
            Title = "Leaderboard",
            Content = "Leaderboard UI created!",
            Duration = 3
        })
    end
})

if not workspace:FindFirstChild("SecurityPart") then
    local SecurityPart = Instance.new("Part")
    SecurityPart.Name = "SecurityPart"
    SecurityPart.Size = Vector3.new(10, 1, 10)
    SecurityPart.Position = Vector3.new(5000, 5000, 5000)
    SecurityPart.Anchored = true
    SecurityPart.CanCollide = true
    SecurityPart.Parent = workspace
end

local AutoTab = Window:AddTab({ Title = "Auto Farm", Icon = "solar/clock-circle-bold", Favoriteable = true })

AutoTab:AddSection("Farmings", "solar/leaf-bold")

AutoMoneyFarmToggle = AutoTab:AddToggle("AutoMoneyFarmToggle", {
    Title = "Auto Farm Money",
    Default = false
})

AutoTicketFarmToggle = AutoTab:AddToggle("AutoTicketFarmToggle", {
    Title = "Auto Farm Tickets",
    Default = false
})

AFKFarmToggle = AutoTab:AddToggle("AFKFarmToggle", {
    Title = "AFK Farm",
    Default = false
})

AutoTab:AddSection("Teleports", "solar/map-arrow-right-bold")

AutoTab:AddButton({
    Title = "Custom Server",
    Description = "Create Custom Server",
    Callback = function()
        
        Fluent:Notify({
            Title = "Create",
            Content = "Create Custom Server",
            Duration = 3
        })
        
        
        task.wait(1)
        
        
        local success, errorMsg = pcall(function()
            game:GetService("TeleportService"):Teleport(99214917572799)
        end)
        
        
        if not success then
            Fluent:Notify({
                Title = "Failed Custom Server",
                Content = "Failed Custom Server: " .. tostring(errorMsg),
                Duration = 5
            })
        end
    end
})

TeleportObjectiveButton = AutoTab:AddButton({
    Title = "Teleport to Objective",
    Callback = function()
        local objectives = {}
        
        local gameFolder = workspace:FindFirstChild("Game")
        if not gameFolder then return end
        
        local mapFolder = gameFolder:FindFirstChild("Map")
        if not mapFolder then return end
        
        
        local objectivesFolder = nil
        
        
        local partsFolder = mapFolder:FindFirstChild("Parts")
        if partsFolder then
            objectivesFolder = partsFolder:FindFirstChild("Objectives")
        end
        
        
        if not objectivesFolder then
            objectivesFolder = mapFolder:FindFirstChild("Objectives")
        end
        
        
        if not objectivesFolder then
            for _, obj in ipairs(mapFolder:GetDescendants()) do
                if obj.Name == "Objectives" and (obj:IsA("Folder") or obj:IsA("Model")) then
                    objectivesFolder = obj
                    break
                end
            end
        end
        
        if not objectivesFolder then return end
        
        
        for _, obj in pairs(objectivesFolder:GetChildren()) do
            if obj:IsA("Model") or obj:IsA("Part") or obj:IsA("MeshPart") then
                local teleportPart = nil
                
                if obj:IsA("BasePart") then
                    teleportPart = obj
                elseif obj:IsA("Model") then
                    teleportPart = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or 
                                  obj:FindFirstChild("Head") or obj:FindFirstChild("Torso") or 
                                  obj:FindFirstChildWhichIsA("BasePart")
                end
                
                if teleportPart then
                    table.insert(objectives, {
                        Name = obj.Name,
                        Part = teleportPart,
                        Position = teleportPart.Position
                    })
                end
            end
        end
        
        if #objectives == 0 then return end
        
        
        local selectedObjective = objectives[math.random(1, #objectives)]
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        
        local teleportPosition = selectedObjective.Position + Vector3.new(0, 5, 0)
        humanoidRootPart.CFrame = CFrame.new(teleportPosition)
    end
})

TeleportSpawnButton = AutoTab:AddButton({
    Title = "Teleport to Spawn",
    Callback = function()
        local gameFolder = workspace:FindFirstChild("Game")
        if not gameFolder then return end
        
        local mapFolder = gameFolder:FindFirstChild("Map")
        if not mapFolder then return end
        
        local partsFolder = mapFolder:FindFirstChild("Parts")
        if not partsFolder then return end
        
        local spawnsFolder = partsFolder:FindFirstChild("Spawns")
        if not spawnsFolder then return end
        
        
        local spawns = {}
        for _, obj in pairs(spawnsFolder:GetChildren()) do
            if obj:IsA("Part") or obj:IsA("MeshPart") then
                table.insert(spawns, obj)
            elseif obj:IsA("Model") then
                local part = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or 
                            obj:FindFirstChild("Head") or obj:FindFirstChild("Torso") or 
                            obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    table.insert(spawns, part)
                end
            end
        end
        
        if #spawns == 0 then return end
        
        
        local selectedSpawn = spawns[math.random(1, #spawns)]
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        
        local teleportPosition = selectedSpawn.Position + Vector3.new(0, 3, 0)
        humanoidRootPart.CFrame = CFrame.new(teleportPosition)
    end
})

AutoMoneyFarmConnection = nil
AutoWinConnection = nil
AutoTicketFarmConnection = nil
AutoReviveModule = nil

character = LocalPlayer.Character
humanoid = character and character:FindFirstChild("Humanoid")
rootPart = character and character:FindFirstChild("HumanoidRootPart")

function startAutoWin()
    if AutoWinConnection then return end
    
    AutoWinConnection = RunService.Heartbeat:Connect(function()
        local securityPart = workspace:FindFirstChild("SecurityPart")
        if not securityPart then return end
        
        local currentCharacter = LocalPlayer.Character
        if not currentCharacter then return end
        
        local currentRootPart = currentCharacter:FindFirstChild("HumanoidRootPart")
        if not currentRootPart then return end
        
        if not currentCharacter:GetAttribute("Downed") then
            currentRootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
        end
    end)
end

function stopAutoWin()
    if AutoWinConnection then
        AutoWinConnection:Disconnect()
        AutoWinConnection = nil
    end
end

function initAutoReviveModule()
    local reviveRange = 15
    local loopDelay = 0.25
    local autoReviveEnabled = false
    local reviveLoopHandle = nil
    local interactEvent = ReplicatedStorage:FindFirstChild("Events") and 
                         ReplicatedStorage.Events:FindFirstChild("Character") and 
                         ReplicatedStorage.Events.Character:FindFirstChild("Interact")
    
    if not interactEvent then
        warn("Auto Revive Module: Interact event not found!")
        return nil
    end

    local function isPlayerDowned(pl)
        if not pl or not pl.Character then return false end
        local char = pl.Character
        
        if char:GetAttribute("Downed") == true then
            return true
        end
        
        local ragdollsFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Ragdolls")
        if ragdollsFolder and ragdollsFolder:FindFirstChild(pl.Name) then
            return true
        end
        
        return false
    end

    local function getDownedRootPart(pl)
        if pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            return pl.Character.HumanoidRootPart
        end
        
        local ragdollsFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Ragdolls")
        if ragdollsFolder then
            local ragdoll = ragdollsFolder:FindFirstChild(pl.Name)
            if ragdoll then
                return ragdoll:FindFirstChild("HumanoidRootPart") or 
                       ragdoll:FindFirstChild("Torso") or 
                       ragdoll:FindFirstChild("Head") or 
                       ragdoll:FindFirstChildWhichIsA("BasePart")
            end
        end
        return nil
    end

    function startAutoRevive()
        if reviveLoopHandle then return end
        reviveLoopHandle = task.spawn(function()
            while autoReviveEnabled do
                local currentPlayer = Players.LocalPlayer
                if currentPlayer then
                    local character = currentPlayer.Character
                    local securityPart = workspace:FindFirstChild("SecurityPart")
                    
                    
                    if character and character:GetAttribute("Downed") then
                        pcall(function()
                            ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
                        end)
                        
                        if securityPart then
                            task.wait(1)
                            local newChar = currentPlayer.Character
                            if newChar and newChar:FindFirstChild("HumanoidRootPart") then
                                newChar.HumanoidRootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
                            end
                        end
                        task.wait(1)
                    
                    
                    elseif character and character:FindFirstChild("HumanoidRootPart") then
                        local myHRP = character.HumanoidRootPart
                        local downedFound = false
                        
                        for _, pl in ipairs(Players:GetPlayers()) do
                            if pl ~= currentPlayer and isPlayerDowned(pl) then
                                local targetRoot = getDownedRootPart(pl)
                                if targetRoot then
                                    downedFound = true
                                    local dist = (myHRP.Position - targetRoot.Position).Magnitude
                                    
                                    
                                    if dist > reviveRange then
                                        local targetPos = targetRoot.Position
                                        myHRP.CFrame = CFrame.new(targetPos.X, targetPos.Y - 5, targetPos.Z)
                                        task.wait(0.1)
                                    end
                                    
                                    
                                    pcall(function()
                                        interactEvent:FireServer("Revive", true, pl.Name)
                                    end)
                                    task.wait(0.2)
                                end
                            end
                        end
                        
                        
                        if not downedFound and not character:GetAttribute("Downed") and securityPart then
                            myHRP.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
                        end
                    end
                end
                task.wait(loopDelay)
            end
            reviveLoopHandle = nil
        end)
    end

    function stopAutoRevive()
        autoReviveEnabled = false
        if reviveLoopHandle then
            task.cancel(reviveLoopHandle)
            reviveLoopHandle = nil
        end
    end

    function ToggleAutoRevive(state)
        autoReviveEnabled = state
        if autoReviveEnabled then
            startAutoRevive()
        else
            stopAutoRevive()
        end
    end

    return {
        Toggle = ToggleAutoRevive,
        Start = function() ToggleAutoRevive(true) end,
        Stop = function() ToggleAutoRevive(false) end,
        IsEnabled = function() return autoReviveEnabled end,
    }
end

function startAutoMoneyFarm()
    if AutoMoneyFarmConnection then 
        stopAutoMoneyFarm()
    end
    
    if not AutoReviveModule then
        AutoReviveModule = initAutoReviveModule()
        if not AutoReviveModule then
            Fluent:Notify({
                Title = "Auto Farm Money",
                Content = "Failed to initialize revive module!",
                Duration = 5
            })
            return
        end
    end
    
    AutoReviveModule.Start()
    
    AutoMoneyFarmConnection = RunService.Heartbeat:Connect(function()
        if not AutoReviveModule or not AutoReviveModule.IsEnabled() then
            if Options.AutoMoneyFarmToggle and Options.AutoMoneyFarmToggle.Value then
                AutoReviveModule.Start()
            end
        end
    end)
end

function stopAutoMoneyFarm()
    if AutoMoneyFarmConnection then
        AutoMoneyFarmConnection:Disconnect()
        AutoMoneyFarmConnection = nil
    end
    
    if AutoReviveModule then
        AutoReviveModule.Stop()
    end
end

AutoMoneyFarmToggle:OnChanged(function(state)
    if state then
        startAutoMoneyFarm()
    else
        stopAutoMoneyFarm()
    end
end)

AFKFarmToggle:OnChanged(function(state)
    if state then
        startAutoWin()
    else
        stopAutoWin()
    end
end)

AutoTicketFarmToggle:OnChanged(function(state)
    local yOffset = 15
    local currentTicket = nil
    local ticketProcessedTime = 0

    if state then
        local securityPart = workspace:FindFirstChild("SecurityPart")
        if not securityPart then
            return
        end

        if AutoTicketFarmConnection then
            AutoTicketFarmConnection:Disconnect()
        end
        
        AutoTicketFarmConnection = RunService.Heartbeat:Connect(function()
            local character = LocalPlayer.Character
            if not character then return end
            
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then return end
            
            local tickets = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Effects") and workspace.Game.Effects:FindFirstChild("Tickets")

            if character:GetAttribute("Downed") then
                pcall(function()
                    ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
                end)
                humanoidRootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
                return
            end

            if tickets then
                local activeTickets = tickets:GetChildren()
                if #activeTickets > 0 then
                    if not currentTicket or not currentTicket.Parent then
                        currentTicket = activeTickets[1]
                        ticketProcessedTime = tick()
                    end

                    if currentTicket and currentTicket.Parent then
                        local ticketPart = currentTicket:FindFirstChild("HumanoidRootPart") or currentTicket:IsA("BasePart") and currentTicket
                        if ticketPart then
                            local targetPosition = ticketPart.Position + Vector3.new(0, yOffset, 0)
                            humanoidRootPart.CFrame = CFrame.new(targetPosition)
                            
                            if tick() - ticketProcessedTime > 0.1 then
                                humanoidRootPart.CFrame = ticketPart.CFrame
                            end
                        else
                            currentTicket = nil
                        end
                    else
                        humanoidRootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
                        currentTicket = nil
                    end
                else
                    humanoidRootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
                    currentTicket = nil
                end
            else
                humanoidRootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
                currentTicket = nil
            end
        end)
    else
        if AutoTicketFarmConnection then
            AutoTicketFarmConnection:Disconnect()
            AutoTicketFarmConnection = nil
        end
        currentTicket = nil
        local character = LocalPlayer.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            local securityPart = workspace:FindFirstChild("SecurityPart")
            if humanoidRootPart and securityPart then
                humanoidRootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end
end)

VIPTab = Window:AddTab({ Title = "VIP Server", Icon = "solar/crown-bold", Favoriteable = true })

VIPTab:AddSection("Special Round", "solar/cup-star-bold")

VIPRoundInput = VIPTab:AddInput("VIPRoundInput", {
    Title = "Special Round Name",
    Default = "",
    Placeholder = "Enter round name",
    Finished = false,
    Callback = function(Value)
        getgenv().VIPRoundName = Value
    end
})

VIPRoundToggle = VIPTab:AddToggle("VIPRoundToggle", {
    Title = "Auto Special Round",
    Default = false,
    Callback = function(Value)
        getgenv().VIPRoundEnabled = Value
    end
})

VIPTab:AddSection("Vote System", "solar/checklist-bold")

local VoteValues = {"1", "2", "3", "4"}

VoteInput1 = VIPTab:AddDropdown("VoteInput1", {
    Title = "Vote Option 1",
    Values = VoteValues,
    Multi = false,
    Default = "1",
    Callback = function(Value)
        getgenv().VoteValue1 = tonumber(Value)
    end
})

VoteInput2 = VIPTab:AddDropdown("VoteInput2", {
    Title = "Vote Option 2",
    Values = VoteValues,
    Multi = false,
    Default = "1",
    Callback = function(Value)
        getgenv().VoteValue2 = tonumber(Value)
    end
})

VoteToggle = VIPTab:AddToggle("VoteToggle", {
    Title = "Auto Vote",
    Default = false,
    Callback = function(Value)
        getgenv().VoteEnabled = Value
    end
})

VIPTab:AddSection("Skip Time", "solar/clock-circle-bold")

TimerCommandToggle = VIPTab:AddToggle("TimerCommandToggle", {
    Title = "Auto Skip Time",
    Default = false,
    Callback = function(Value)
        getgenv().TimerCommandEnabled = Value
    end
})

getgenv().VIPRoundName = getgenv().VIPRoundName or ""
getgenv().VIPRoundEnabled = false
getgenv().VIPRoundActivated = false

getgenv().VoteValue1 = 1
getgenv().VoteValue2 = 1
getgenv().VoteEnabled = false
getgenv().VoteActivated = false

getgenv().TimerCommandEnabled = false
getgenv().TimerCommandActivated = false

local timerConnection = nil

timerConnection = game:GetService("RunService").Heartbeat:Connect(function()
    local stats = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Stats")
    if stats then
        local timerValue = stats:GetAttribute("Timer")
        local roundStarted = stats:GetAttribute("RoundStarted")
        
        if timerValue == 30 then
            
            if getgenv().VIPRoundEnabled and not getgenv().VIPRoundActivated then
                local roundName = getgenv().VIPRoundName or ""
                if roundName ~= "" then
                    local args = {
                        [1] = "!specialround " .. roundName
                    }
                    
                    pcall(function()
                        game:GetService("ReplicatedStorage").Events.Admin.VIPCommand:InvokeServer(unpack(args))
                        getgenv().VIPRoundActivated = true
                        task.delay(10, function()
                            getgenv().VIPRoundActivated = false
                        end)
                    end)
                end
            end
            
            
            if getgenv().VoteEnabled and not getgenv().VoteActivated then
                local value1 = getgenv().VoteValue1 or 1
                local value2 = getgenv().VoteValue2 or 1
                
                local args1 = {
                    [1] = value1
                }
                
                local args2 = {
                    [1] = value2,
                    [2] = true
                }
                
                pcall(function()
                    game:GetService("ReplicatedStorage").Events.Player.Vote:FireServer(unpack(args1))
                    game:GetService("ReplicatedStorage").Events.Player.Vote:FireServer(unpack(args2))
                    getgenv().VoteActivated = true
                    task.delay(10, function()
                        getgenv().VoteActivated = false
                    end)
                end)
            end
            
            
            if getgenv().TimerCommandEnabled and not getgenv().TimerCommandActivated then
                if roundStarted == false then
                    local args = {
                        [1] = "!timer 1"
                    }
                    
                    pcall(function()
                        game:GetService("ReplicatedStorage").Events.Admin.VIPCommand:InvokeServer(unpack(args))
                        getgenv().TimerCommandActivated = true
                        task.delay(10, function()
                            getgenv().TimerCommandActivated = false
                        end)
                    end)
                end
            end
        else
            if timerValue ~= 30 then
                getgenv().VIPRoundActivated = false
                getgenv().VoteActivated = false
                getgenv().TimerCommandActivated = false
            end
        end
    end
end)


local MISC_MODULE_URL = "https://raw.githubusercontent.com/Kdwqwthg/4364523/refs/heads/main/Online%20Script/MiscModule.lua"
local miscModuleSource
pcall(function()
    if typeof(readfile) == "function" then
        miscModuleSource = readfile("Online Script/MiscModule.lua")
    end
end)
if type(miscModuleSource) ~= "string" or #miscModuleSource < 80 then
    miscModuleSource = game:HttpGet(MISC_MODULE_URL, true)
end
local MiscModule = loadstring(miscModuleSource)()
MiscModule.init({
    Window = Window,
    Fluent = Fluent,
    Options = Options,
    createGradientButton = createGradientButton,
    RunService = RunService,
    Players = Players,
    LocalPlayer = LocalPlayer,
    ReplicatedStorage = ReplicatedStorage,
    featureStates = featureStates,
})


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

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(2) 
    
    
    if Options.PlayerToggle and Options.PlayerToggle.Value then
        if not ExternalESPLoaded or not _G.ExternalESPRunning then
            Fluent:Notify({
                Title = "ESP Players",
                Content = "Restoring Player ESP after respawn...",
                Duration = 3
            })
            
            
            cleanupPlayerESPObjects()
            
            
            ExternalESPLoaded = false
            ExternalESP = nil
            _G.ExternalESPRunning = false
            
            
            local success = pcall(function()
                ExternalESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kdwqwthg/4364523/refs/heads/main/Online%20Script/Esp.lua"))()
                ExternalESPLoaded = true
                _G.ExternalESPRunning = true
            end)
            
            if success then
                Fluent:Notify({
                    Title = "ESP Players",
                    Content = "Player ESP restored successfully!",
                    Duration = 3
                })
            else
                Fluent:Notify({
                    Title = "ESP Players Error",
                    Content = "Failed to restore Player ESP",
                    Duration = 3
                })
                Options.PlayerToggle:Set(false)
            end
        end
    end
end)

LocalPlayer.CharacterRemoving:Connect(function()
    if Options.NextbotToggle and Options.NextbotToggle.Value then
        
        if ExternalNextbotESPLoaded and ExternalNextbotESP then
            if ExternalNextbotESP.Stop then
                pcall(ExternalNextbotESP.Stop)
            end
        end
        
        
        for model, data in pairs(NextbotBillboards) do
            if data.esp then
                data.esp:Destroy()
            end
        end
        NextbotBillboards = {}
        
        
        for model, tracer in pairs(botTracerElements) do
            if tracer and tracer.Remove then
                tracer:Remove()
            end
        end
        botTracerElements = {}
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(2)
    
    if Options.NextbotToggle and Options.NextbotToggle.Value then
        if ExternalNextbotESPLoaded and ExternalNextbotESP then
            if ExternalNextbotESP.Start then
                pcall(function()
                    ExternalNextbotESP.Start()
                    _G.NextbotESPRunning = true
                    Fluent:Notify({
                        Title = "ESP Nextbots",
                        Content = "Nextbot ESP restored after respawn!",
                        Duration = 3
                    })
                end)
            end
        end
    end

end)
