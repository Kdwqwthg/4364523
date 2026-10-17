local ESPPlayers = {}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local BASE = "https://raw.githubusercontent.com/Kdwqwthg/4364523/refs/heads/main/Online%20Script/"

local deps = {}
local ExternalESP = nil
local ExternalESPLoaded = false
local playerLoop = nil

local function loadInner(fileName)
    local source
    pcall(function()
        if typeof(readfile) == "function" then
            source = readfile("Online Script/" .. fileName)
        end
    end)
    if type(source) ~= "string" or #source < 80 then
        source = game:HttpGet(BASE .. fileName, true)
    end
    return source
end

function ESPPlayers.init(initDeps)
    deps = initDeps or {}
end

function ESPPlayers.clean()
    local cleaned = 0

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player.Character then
                for _, obj in pairs(player.Character:GetDescendants()) do
                    if obj:IsA("BillboardGui") then
                        local objName = obj.Name:lower()
                        if objName:find("esp")
                            and not objName:find("nextbot")
                            and not objName:find("npc")
                            and not objName:find("bot")
                            and not objName:find("enemy") then
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
                if (guiName:find("player") or guiName:find("esp"))
                    and not guiName:find("nextbot")
                    and not guiName:find("bot") then
                    gui:Destroy()
                    cleaned = cleaned + 1
                end
            end
        end
    end

    return cleaned
end

function ESPPlayers.isRunning()
    return ExternalESPLoaded and _G.ExternalESPRunning
end

function ESPPlayers.start()
    ESPPlayers.clean()

    if not ExternalESPLoaded then
        local espScript = loadInner("Esp.lua")
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
    else
        _G.ExternalESPRunning = true
        _G.PlayerESP_Loaded = true
    end

    if not playerLoop then
        playerLoop = RunService.Heartbeat:Connect(function()
            local enabled = true
            if deps.isEnabled then
                enabled = deps.isEnabled()
            end
            if not enabled then
                return
            end

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
                            end
                        end
                    end
                end
            end
        end)
    end
end

function ESPPlayers.stop()
    if playerLoop then
        playerLoop:Disconnect()
        playerLoop = nil
    end

    ESPPlayers.clean()

    if ExternalESP and ExternalESPLoaded then
        if type(ExternalESP) == "table" and ExternalESP.Stop then
            pcall(ExternalESP.Stop)
        end
    end

    _G.ExternalESPRunning = false
    _G.PlayerESP_Loaded = false
    ExternalESPLoaded = false
end

function ESPPlayers.restoreAfterRespawn()
    if ExternalESPLoaded and _G.ExternalESPRunning then
        return false
    end

    ESPPlayers.clean()
    ExternalESPLoaded = false
    ExternalESP = nil
    _G.ExternalESPRunning = false

    ExternalESP = loadstring(loadInner("Esp.lua"))()
    ExternalESPLoaded = true
    _G.ExternalESPRunning = true
    return true
end

return ESPPlayers
