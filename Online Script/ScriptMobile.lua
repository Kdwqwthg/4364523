game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Draconic Hub 2",
    Text = "Welcome Draconic Hub Remake",
    Icon = "rbxassetid://102225156206159",
    Duration = 7
})

local MODULE_BASE = "https://raw.githubusercontent.com/Kdwqwthg/4364523/refs/heads/main/Online%20Script/"

local function loadModule(fileName)
    local src
    pcall(function()
        if typeof(readfile) == "function" then
            src = readfile("Online Script/" .. fileName)
        end
    end)
    if type(src) ~= "string" or #src < 80 then
        src = game:HttpGet(MODULE_BASE .. fileName, true)
    end
    return loadstring(src)()
end

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

local FloatingButton = loadModule("FlyBytton.lua")
FloatingButton.init(Window)

local GradientButtonModule = loadModule("CreateGradientButton.lua")
local SimpleTimerModule = loadModule("CreateSimpleTimer.lua")

local deps = {
    Window = Window,
    Fluent = Fluent,
    Options = Fluent.Options,
    SaveManager = SaveManager,
    InterfaceManager = InterfaceManager,
    FloatingButton = FloatingButton,
    createGradientButton = GradientButtonModule.createGradientButton,
    createSimpleTimer = SimpleTimerModule.createSimpleTimer,
    RunService = game:GetService("RunService"),
    Players = game:GetService("Players"),
    LocalPlayer = game:GetService("Players").LocalPlayer,
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    VirtualUser = game:GetService("VirtualUser"),
    featureStates = { FlySpeed = 50 },
}

local loadErrors = {}

local function tryLoad(name, initFn)
    local ok, err = pcall(initFn)
    if not ok then
        table.insert(loadErrors, name .. ": " .. tostring(err))
        warn("[Draconic Hub]", name, err)
    end
end

tryLoad("CoreModule", function()
    loadModule("CoreModule.lua").init(deps)
end)

tryLoad("MiscModule", function()
    loadModule("MiscModule.lua").init(deps)
end)

tryLoad("SettingsModule", function()
    loadModule("SettingsModule.lua").init(deps)
end)

if #loadErrors > 0 then
    Fluent:Notify({
        Title = "Draconic Hub - Load Error",
        Content = table.concat(loadErrors, "\n"),
        Duration = 12
    })
end
