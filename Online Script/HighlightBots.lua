-- ==================== HIGHLIGHT BOTS MODULE ====================
-- External module for Draconic Hub X Evade
-- File: HighlightBots.lua

local module = {}

-- Services
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local PlayersService = game:GetService("Players")
local LocalPlayer = PlayersService.LocalPlayer

-- Internal variables
local botHighlights = {}
local highlightConnection = nil
local isEnabled = false
local Fluent = nil
local Options = nil

-- Store original transparency values
local originalTransparencies = {}

-- Список ключевых слов для определения Hitbox
local HITBOX_KEYWORDS = {
    "hitbox", "hit", "collision", "collide", "damage", 
    "hurt", "attack", "body", "root", "torso", 
    "head", "limb", "arm", "leg"
}

-- Функция проверки, является ли часть Hitbox
local function isHitboxPart(part)
    if not part or not part:IsA("BasePart") then return false end
    
    local nameLower = part.Name:lower()
    for _, keyword in ipairs(HITBOX_KEYWORDS) do
        if nameLower:find(keyword) then
            return true
        end
    end
    return false
end

-- Function to check if a player is a bot (Team = Nextbot в workspace.Players)
local function isBotPlayer(playerName)
    local playersFolder = Workspace:FindFirstChild("Players")
    if not playersFolder then return false end
    
    local playerModel = playersFolder:FindFirstChild(playerName)
    if not playerModel then return false end
    
    -- Проверяем атрибут Team
    local team = playerModel:GetAttribute("Team")
    if team == "Nextbot" then
        return true
    end
    
    return false
end

-- Function to get all Rigs folders in workspace
local function getAllRigsFolders()
    local rigsFolders = {}
    
    for _, child in ipairs(Workspace:GetChildren()) do
        if child.Name == "Rigs" and child:IsA("Folder") then
            table.insert(rigsFolders, child)
        end
    end
    
    return rigsFolders
end

-- Function to check if a model has hitbox parts
local function hasHitboxParts(model)
    if not model then return false end
    
    for _, part in ipairs(model:GetDescendants()) do
        if isHitboxPart(part) then
            return true
        end
    end
    
    return false
end

-- Function to get hitbox parts from a model
local function getHitboxParts(model)
    local hitboxes = {}
    
    for _, part in ipairs(model:GetDescendants()) do
        if isHitboxPart(part) then
            table.insert(hitboxes, part)
        end
    end
    
    return hitboxes
end

-- Function to make hitboxes visible (transparency = 0)
local function makeHitboxesVisible(model)
    if not model then return end
    
    local hitboxes = getHitboxParts(model)
    
    for _, part in ipairs(hitboxes) do
        -- Store original transparency if not already stored
        if not originalTransparencies[part] then
            originalTransparencies[part] = part.Transparency
        end
        -- Set to 0 (fully visible)
        part.Transparency = 0
        part.CanQuery = true
    end
end

-- Function to restore original transparency
local function restoreHitboxesTransparency(model)
    if not model then return end
    
    local hitboxes = getHitboxParts(model)
    
    for _, part in ipairs(hitboxes) do
        if originalTransparencies[part] then
            part.Transparency = originalTransparencies[part]
            originalTransparencies[part] = nil
        end
    end
end

-- Initialize module with Fluent library
function module:Init(fluentLib, options)
    Fluent = fluentLib
    Options = options
    print("Highlight Bots module initialized")
end

-- Function to update/create highlight for a bot
local function updateBotHighlight(bot)
    if not bot or not isEnabled then return end
    
    -- Проверяем, является ли ботом (Team = Nextbot в workspace.Players)
    if not isBotPlayer(bot.Name) then return end
    
    -- Проверяем наличие Hitbox
    if hasHitboxParts(bot) then
        -- Делаем Hitbox видимыми (Transparency = 0)
        makeHitboxesVisible(bot)
        
        -- Удаляем старый highlight если есть
        if botHighlights[bot] then
            local oldHighlight = botHighlights[bot]
            if oldHighlight and oldHighlight.Parent then
                oldHighlight:Destroy()
            end
            botHighlights[bot] = nil
        end
        
        -- Подсвечиваем каждый Hitbox отдельно
        local hitboxes = getHitboxParts(bot)
        local hitboxHighlights = {}
        
        for _, part in ipairs(hitboxes) do
            local highlight = Instance.new("Highlight")
            highlight.Name = "DraconicBotHighlight_" .. bot.Name .. "_" .. part.Name
            highlight.Parent = part
            
            -- Visibility settings (through walls)
            highlight.FillTransparency = 0.3
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            
            -- Color: Red for bots
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(200, 0, 0)
            
            table.insert(hitboxHighlights, highlight)
        end
        
        botHighlights[bot] = hitboxHighlights
    else
        -- Если нет Hitbox, подсвечиваем всю модель
        -- Восстанавливаем прозрачность (на случай если были Hitbox)
        restoreHitboxesTransparency(bot)
        
        -- Удаляем старый highlight если есть
        if botHighlights[bot] then
            local oldHighlights = botHighlights[bot]
            if type(oldHighlights) == "table" then
                for _, highlight in ipairs(oldHighlights) do
                    if highlight and highlight.Parent then
                        highlight:Destroy()
                    end
                end
            elseif oldHighlights and oldHighlights.Parent then
                oldHighlights:Destroy()
            end
            botHighlights[bot] = nil
        end
        
        -- Создаем highlight на всей модели
        local highlight = Instance.new("Highlight")
        highlight.Name = "DraconicBotHighlight_" .. bot.Name
        highlight.Parent = bot
        
        -- Visibility settings (through walls)
        highlight.FillTransparency = 0.3
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        
        -- Color: Red for bots
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(200, 0, 0)
        
        botHighlights[bot] = highlight
    end
end

-- Function to remove highlight from a bot
local function removeBotHighlight(bot)
    -- Восстанавливаем прозрачность Hitbox
    restoreHitboxesTransparency(bot)
    
    if botHighlights[bot] then
        local highlights = botHighlights[bot]
        if type(highlights) == "table" then
            for _, highlight in ipairs(highlights) do
                if highlight and highlight.Parent then
                    highlight:Destroy()
                end
            end
        elseif highlights and highlights.Parent then
            highlights:Destroy()
        end
        botHighlights[bot] = nil
    end
end

-- Function to clear all bot highlights
local function clearAllHighlights()
    -- Восстанавливаем прозрачность для всех ботов
    for bot in pairs(botHighlights) do
        restoreHitboxesTransparency(bot)
    end
    
    for bot, highlights in pairs(botHighlights) do
        if type(highlights) == "table" then
            for _, highlight in ipairs(highlights) do
                if highlight and highlight.Parent then
                    highlight:Destroy()
                end
            end
        elseif highlights and highlights.Parent then
            highlights:Destroy()
        end
    end
    botHighlights = {}
end

-- Function to find all bots in Rigs folders
local function findAllBots()
    local bots = {}
    
    local rigsFolders = getAllRigsFolders()
    
    for _, rigsFolder in ipairs(rigsFolders) do
        for _, model in ipairs(rigsFolder:GetChildren()) do
            if model:IsA("Model") then
                -- Проверяем, является ли ботом (Team = Nextbot в workspace.Players)
                if isBotPlayer(model.Name) then
                    table.insert(bots, model)
                end
            end
        end
    end
    
    return bots
end

-- Main update function for all bots
local function updateAllHighlights()
    if not isEnabled then return end
    
    local currentBots = {}
    local bots = findAllBots()
    
    -- Update/create highlights for current bots
    for _, bot in ipairs(bots) do
        currentBots[bot] = true
        updateBotHighlight(bot)
    end
    
    -- Remove highlights for bots that no longer exist
    for bot in pairs(botHighlights) do
        if not currentBots[bot] or not bot.Parent then
            removeBotHighlight(bot)
        end
    end
end

-- Start the module
function module:Start()
    if isEnabled then return end
    isEnabled = true
    
    -- Clear any stored transparency data from previous runs
    originalTransparencies = {}
    
    -- Create highlights for existing bots
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
    
    -- Подписываемся на изменения в папках Rigs
    local rigsFolders = getAllRigsFolders()
    
    for _, rigsFolder in ipairs(rigsFolders) do
        rigsFolder.ChildAdded:Connect(function(child)
            if isEnabled and child:IsA("Model") then
                if isBotPlayer(child.Name) then
                    task.wait(0.1)
                    updateBotHighlight(child)
                end
            end
        end)
        
        rigsFolder.ChildRemoved:Connect(function(child)
            if isEnabled and child:IsA("Model") then
                removeBotHighlight(child)
            end
        end)
    end
    
    -- Подписываемся на появление новых папок Rigs
    Workspace.ChildAdded:Connect(function(child)
        if isEnabled and child.Name == "Rigs" and child:IsA("Folder") then
            child.ChildAdded:Connect(function(grandChild)
                if isEnabled and grandChild:IsA("Model") then
                    if isBotPlayer(grandChild.Name) then
                        task.wait(0.1)
                        updateBotHighlight(grandChild)
                    end
                end
            end)
            child.ChildRemoved:Connect(function(grandChild)
                if isEnabled and grandChild:IsA("Model") then
                    removeBotHighlight(grandChild)
                end
            end)
        end
    end)
    
    if Fluent then
        Fluent:Notify({
            Title = "Highlight Bots",
            Content = "Enabled",
            Duration = 3
        })
    end
    
    print("Highlight Bots module started")
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
            Title = "Highlight Bots",
            Content = "Disabled",
            Duration = 3
        })
    end
    
    print("Highlight Bots module stopped")
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