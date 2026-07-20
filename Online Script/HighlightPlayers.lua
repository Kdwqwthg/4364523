-- ==================== HIGHLIGHT PLAYERS MODULE ====================
-- External module for Draconic Hub X Evade
-- File: HighlightPlayers.lua

local module = {}

-- Services
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local PlayersService = game:GetService("Players")
local LocalPlayer = PlayersService.LocalPlayer

-- Internal variables
local playerHighlights = {}
local highlightConnection = nil
local isEnabled = false
local Fluent = nil
local Options = nil

-- Initialize module with Fluent library
function module:Init(fluentLib, options)
    Fluent = fluentLib
    Options = options
    print("Highlight Players module initialized")
end

-- Function to check if player has revives (health <= 0)
local function hasRevives(playerModel)
    if not playerModel then return false end
    
    local humanoid = playerModel:FindFirstChildOfClass("Humanoid")
    
    if humanoid and humanoid.Health <= 0 then
        return true
    end
    
    return false
end

-- Function to update/create highlight for a player
local function updatePlayerHighlight(playerModel)
    if not playerModel or not playerModel:IsA("Model") then return end
    if not isEnabled then return end
    
    -- Проверяем, не является ли это локальным игроком
    if playerModel.Name == LocalPlayer.Name then return end
    
    local hasRevivesStatus = hasRevives(playerModel)
    
    -- Если highlight уже существует, обновляем его цвет
    if playerHighlights[playerModel] then
        local highlight = playerHighlights[playerModel]
        if highlight and highlight.Parent then
            highlight.FillColor = hasRevivesStatus and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 255, 255)
            highlight.OutlineColor = hasRevivesStatus and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(200, 200, 200)
            return
        else
            playerHighlights[playerModel] = nil
        end
    end
    
    -- Create new highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "DraconicHighlight_" .. playerModel.Name
    highlight.Parent = playerModel
    
    -- Visibility settings (through walls)
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    -- Colors: White (alive) or Yellow (revives/health <= 0)
    highlight.FillColor = hasRevivesStatus and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 255, 255)
    highlight.OutlineColor = hasRevivesStatus and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(200, 200, 200)
    
    playerHighlights[playerModel] = highlight
end

-- Function to remove highlight from a player
local function removePlayerHighlight(playerModel)
    if playerHighlights[playerModel] then
        local highlight = playerHighlights[playerModel]
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
        playerHighlights[playerModel] = nil
    end
end

-- Function to clear all highlights
local function clearAllHighlights()
    for playerModel, highlight in pairs(playerHighlights) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
    end
    playerHighlights = {}
end

-- Проверка, является ли модель игроком
local function isPlayerModel(model)
    if not model or not model:IsA("Model") then return false end
    
    -- Проверяем наличие Humanoid (у всех игроков есть Humanoid)
    if not model:FindFirstChildOfClass("Humanoid") then
        return false
    end
    
    return true
end

-- Функция для получения всех папок Rigs в workspace
local function getAllRigsFolders()
    local rigsFolders = {}
    
    for _, child in ipairs(Workspace:GetChildren()) do
        if child.Name == "Rigs" and child:IsA("Folder") then
            table.insert(rigsFolders, child)
        end
    end
    
    return rigsFolders
end

-- Main update function for all players
local function updateAllHighlights()
    if not isEnabled then return end
    
    local rigsFolders = getAllRigsFolders()
    if #rigsFolders == 0 then return end
    
    local currentPlayers = {}
    
    -- Проходим по всем папкам Rigs
    for _, rigsFolder in ipairs(rigsFolders) do
        for _, playerModel in ipairs(rigsFolder:GetChildren()) do
            if isPlayerModel(playerModel) and playerModel.Name ~= LocalPlayer.Name then
                currentPlayers[playerModel] = true
                updatePlayerHighlight(playerModel)
            end
        end
    end
    
    -- Удаляем подсветку для игроков, которых больше нет
    for playerModel in pairs(playerHighlights) do
        if not currentPlayers[playerModel] then
            removePlayerHighlight(playerModel)
        end
    end
end

-- Start the module
function module:Start()
    if isEnabled then return end
    isEnabled = true
    
    -- Create highlights for existing players
    updateAllHighlights()
    
    -- Start update loop
    if highlightConnection then
        highlightConnection:Disconnect()
    end
    
    highlightConnection = RunService.Heartbeat:Connect(function()
        if isEnabled then
            updateAllHighlights()
        end
    end)
    
    -- Подписываемся на изменения в workspace (добавление новых папок Rigs или игроков)
    Workspace.ChildAdded:Connect(function(child)
        if isEnabled then
            if child.Name == "Rigs" and child:IsA("Folder") then
                -- Новая папка Rigs появилась
                child.ChildAdded:Connect(function(grandChild)
                    if isEnabled and isPlayerModel(grandChild) and grandChild.Name ~= LocalPlayer.Name then
                        task.wait(0.5)
                        updatePlayerHighlight(grandChild)
                    end
                end)
                child.ChildRemoved:Connect(function(grandChild)
                    if isEnabled and isPlayerModel(grandChild) then
                        removePlayerHighlight(grandChild)
                    end
                end)
            elseif isPlayerModel(child) and child.Name ~= LocalPlayer.Name then
                -- Если игрок добавлен напрямую в workspace (не в Rigs)
                task.wait(0.5)
                updatePlayerHighlight(child)
            end
        end
    end)
    
    Workspace.ChildRemoved:Connect(function(child)
        if isEnabled and isPlayerModel(child) then
            removePlayerHighlight(child)
        end
    end)
    
    -- Подписываемся на изменения в существующих папках Rigs
    local rigsFolders = getAllRigsFolders()
    for _, rigsFolder in ipairs(rigsFolders) do
        rigsFolder.ChildAdded:Connect(function(child)
            if isEnabled and isPlayerModel(child) and child.Name ~= LocalPlayer.Name then
                task.wait(0.5)
                updatePlayerHighlight(child)
            end
        end)
        
        rigsFolder.ChildRemoved:Connect(function(child)
            if isEnabled and isPlayerModel(child) then
                removePlayerHighlight(child)
            end
        end)
    end
    
    if Fluent then
        Fluent:Notify({
            Title = "Highlight Players",
            Content = "Enabled",
            Duration = 3
        })
    end
    
    print("Highlight Players module started")
end

-- Stop the module
function module:Stop()
    if not isEnabled then return end
    isEnabled = false
    
    if highlightConnection then
        highlightConnection:Disconnect()
        highlightConnection = nil
    end
    
    clearAllHighlights()
    
    if Fluent then
        Fluent:Notify({
            Title = "Highlight Players",
            Content = "Disabled",
            Duration = 3
        })
    end
    
    print("Highlight Players module stopped")
end

-- Toggle function (for keybinds)
function module:Toggle()
    if isEnabled then
        self:Stop()
    else
        self:Start()
    end
    return isEnabled
end

-- Check if module is running
function module:IsEnabled()
    return isEnabled
end

-- Force update all highlights
function module:Refresh()
    if isEnabled then
        updateAllHighlights()
    end
end

return module