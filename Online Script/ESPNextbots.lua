local ESPNextbots = {}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local BASE = "https://raw.githubusercontent.com/Kdwqwthg/4364523/refs/heads/main/Online%20Script/"

local deps = {}
local ExternalNextbotESP = nil
local ExternalNextbotESPLoaded = false
local nextbotLoop = nil
local NextbotBillboards = {}

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
    return loadstring(source)()
end

function ESPNextbots.init(initDeps)
    deps = initDeps or {}
end

function ESPNextbots.isLoaded()
    return ExternalNextbotESPLoaded and ExternalNextbotESP ~= nil
end

function ESPNextbots.start()
    if not ExternalNextbotESPLoaded then
        ExternalNextbotESP = loadInner("NextbotESP.lua")
        ExternalNextbotESPLoaded = true
        _G.NextbotESPRunning = true
        if ExternalNextbotESP and ExternalNextbotESP.Start then
            ExternalNextbotESP.Start()
        end
    else
        if ExternalNextbotESP and ExternalNextbotESP.Start then
            ExternalNextbotESP.Start()
        end
        _G.NextbotESPRunning = true
    end

    if not nextbotLoop then
        nextbotLoop = RunService.Heartbeat:Connect(function()
            local enabled = true
            if deps.isEnabled then
                enabled = deps.isEnabled()
            end
            if enabled and _G.NextbotESPRunning == false then
                _G.NextbotESPRunning = true
                if ExternalNextbotESP and ExternalNextbotESP.Start then
                    pcall(ExternalNextbotESP.Start)
                end
            end
        end)
    end
end

function ESPNextbots.restart()
    if ExternalNextbotESP and ExternalNextbotESPLoaded and ExternalNextbotESP.Start then
        pcall(ExternalNextbotESP.Start)
    end
end

function ESPNextbots.stop()
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

        for _, data in pairs(NextbotBillboards) do
            if data.esp and data.esp:IsDescendantOf(game) then
                local espName = data.esp.Name:lower()
                if espName:find("nextbot") or espName:find("bot") or espName:find("npc") then
                    data.esp:Destroy()
                end
            end
        end
        NextbotBillboards = {}

        pcall(function()
            for _, drawing in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
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
end

function ESPNextbots.onCharacterRemoving()
    if ExternalNextbotESPLoaded and ExternalNextbotESP then
        if ExternalNextbotESP.Stop then
            pcall(ExternalNextbotESP.Stop)
        end
    end

    for _, data in pairs(NextbotBillboards) do
        if data.esp then
            data.esp:Destroy()
        end
    end
    NextbotBillboards = {}
end

function ESPNextbots.onCharacterAdded()
    if ExternalNextbotESPLoaded and ExternalNextbotESP then
        if ExternalNextbotESP.Start then
            pcall(function()
                ExternalNextbotESP.Start()
                _G.NextbotESPRunning = true
            end)
            return true
        end
    end
    return false
end

return ESPNextbots
