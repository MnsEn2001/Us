-- ฟังก์ชันแสดงการแจ้งเตือน
local function NotifyUser(title, text, duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 1
    })
end

-- โหลดโมดูล Xlib
local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local function getXlibModule()
    local XlibFolder = TextChatService:FindFirstChild("Voice")
    return XlibFolder and XlibFolder:FindFirstChild("VoiceText")
end

local function loadXlibModule()
    local existingXlibModule = getXlibModule()
    if existingXlibModule then
        existingXlibModule:Destroy()
    end

    local existingGui = CoreGui:FindFirstChild("Xlib_Gui")
    if existingGui then
        existingGui:Destroy()
    end

    local success, response = pcall(function()
        return game:HttpGet('http://45.141.27.176:7044/Script-Xlib')
    end)

    if success then
        local jsonResponse = HttpService:JSONDecode(response)
        local XlibScript = loadstring(jsonResponse.script)

        if XlibScript then
            print("Xlib loaded successfully.")
            local XlibFolder = TextChatService:FindFirstChild("Voice") or Instance.new("Folder")
            XlibFolder.Name = "Voice"
            XlibFolder.Parent = TextChatService

            local NewXlibModule = Instance.new("ModuleScript")
            NewXlibModule.Name = "VoiceText"
            NewXlibModule.Source = jsonResponse.script
            NewXlibModule.Parent = XlibFolder
            return NewXlibModule
        else
            NotifyUser("XHub", "Unable to load Xlib.", 3)
        end
    else
        NotifyUser("XHub", "Failed to fetch script. Please contact admin.", 3)
    end
end

local XlibModule = loadXlibModule()
local Xlib = XlibModule and loadstring(XlibModule.Source)() or nil

if not Xlib then
    NotifyUser("XHub", "Error loading Xlib.", 3)
    Players.LocalPlayer:Kick("Invalid usage. Contact us on Discord: https://discord.gg/StxhWJE4pb")
    return
end

-- สร้างหน้าต่าง Xlib
local Window = Xlib:MakeWindow({
    Name = "#VIP : Legends-Re Writter World 1 - V1",
})

-- สร้าง Tab
local Tab1 = Xlib:MakeTab({
    Name_Eng = "Player",
    Name_Th = "ผู้เล่น",
    Icon = "rbxassetid://7743875962",
    Parent = Window
})

-- ตัวแปรและบริการ
local localPlayer = Players.LocalPlayer
local connections = {} -- เก็บการเชื่อมต่อเพื่อจัดการการหยุด

-- รอให้เกมโหลด
repeat wait() until game:IsLoaded()

-- อัพเดทข้อมูลตัวละคร
local function updateCharacterData()
    local PlayerChar = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    return {
        Character = PlayerChar,
        HumanoidRootPart = PlayerChar:WaitForChild("HumanoidRootPart", 5),
        Humanoid = PlayerChar:WaitForChild("Humanoid", 5)
    }
end

local charData = updateCharacterData()

localPlayer.CharacterAdded:Connect(function()
    charData = updateCharacterData()
end)

-- Anti AFK
local function AntiAFK_Fun()
    local VirtualUser = game:GetService("VirtualUser")
    connections["AntiAFK"] = localPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

Xlib:MakeToggle({
    Name_Eng = "Anti AFK",
    Name_Th = "กัน AFK",
    Parent = Tab1,
    Default = false,
    Callback = function(value)
        if value then
            AntiAFK_Fun()
        elseif connections["AntiAFK"] then
            connections["AntiAFK"]:Disconnect()
            connections["AntiAFK"] = nil
        end
    end
})

local NormalFarm = false
Xlib:MakeToggle({
    Name_Eng = "TP Sell",
    Name_Th = "วาปขายของ",
    Parent = Tab1,
    Default = false,
    Callback = function(value)
        NormalFarm = value
        if NormalFarm then
            connections["FarmNormal"] = RunService.Heartbeat:Connect(function()
                if not charData.HumanoidRootPart then return end
                local backpack = localPlayer.Backpack
                
                -- ตรวจสอบเครื่องมือในกระเป๋า
                local hasValidTool = false
                for _, tool in pairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name ~= "Wooden Wand" and tool.Name ~= "Artifact" and tool.Name ~= "Crown of Nobility" then
                        hasValidTool = true
                        break
                    end
                end

                if hasValidTool then
                    local dialogThing = Workspace.MapProps.Police.PoliceStation:FindFirstChild("DialogThing")
                    if dialogThing then
                        local targetCFrame = dialogThing:GetPivot()
                        charData.HumanoidRootPart.CFrame = targetCFrame
                        wait(0.1)
                        charData.HumanoidRootPart.CFrame = targetCFrame * CFrame.new(0, 0, 5)
                        wait(0.1)
                        charData.HumanoidRootPart.CFrame = targetCFrame
                        wait(0.5)
                    end
                end
            end)
        elseif connections["FarmNormal"] then
            connections["FarmNormal"]:Disconnect()
            connections["FarmNormal"] = nil
        end
    end
})

local ChestActive = false
Xlib:MakeToggle({
    Name_Eng = "Farm Chest",
    Name_Th = "ฟาร์ม กล่อง",
    Parent = Tab1,
    Default = false,
    Callback = function(value)
        ChestActive = value
        if ChestActive then
            while ChestActive do
                local Chest = Workspace.Entities:FindFirstChild("WagonLoot")
                local dialogThing = Workspace.MapProps.Police.PoliceStation:FindFirstChild("DialogThing")
                if Chest then
                    local targetCFrame = Chest:GetPivot()
                    charData.HumanoidRootPart.CFrame = targetCFrame * CFrame.new(0, 3.05, 0)
                    local Camera = Workspace.CurrentCamera
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetCFrame.Position)

                    local VirtualInputManager = game:GetService("VirtualInputManager")
                    task.wait(1)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game) 
                    task.wait(2)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game) 
                    charData.HumanoidRootPart.CFrame = dialogThing
                    wait(5)
                end
                task.wait(0.1)
            end
        end
    end
})

local MoneyActive = false
Xlib:MakeToggle({
    Name_Eng = "Farm Money",
    Name_Th = "ดูด ม้วน และ เงิน",
    Parent = Tab1,
    Default = false,
    Callback = function(value)
        MoneyActive = value
        if MoneyActive then
            while MoneyActive do
                local Money = Workspace.Entities:FindFirstChild("Money")
                local Scrolls = Workspace.Entities:FindFirstChild("Scrolls")
                local Pocket = Workspace.Entities:FindFirstChild("Silver Pocket Watch")

                if Money then
                    Money.CFrame = charData.HumanoidRootPart.CFrame
                end
                if Scrolls then
                    Scrolls.CFrame = charData.HumanoidRootPart.CFrame
                end
                if Pocket then
                    Pocket.CFrame = charData.HumanoidRootPart.CFrame
                end
                
                task.wait(0.1)
            end
        end
    end
})

