local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local robloxID = player.UserId
local key = _G.Key2

function SendMessage(key, robloxID)
    local url = "https://discord.com/api/webhooks/1265676014667825244/iuzgoQQ3AfrNDBdV7ifAjhvBaygChmTTNB-hwz_YAKndCBdcfALPJDkhXbaQkgtXfDFG"
    local headers = {
        ["Content-Type"] = "application/json"
    }
    local data = {
        ["content"] = "Key : " .. key .. "\nIDRB : " .. robloxID
    }
    local body = HttpService:JSONEncode(data)
    local response = request({
        Url = url,
        Method = "POST",
        Headers = headers,
        Body = body
    })
end

function GetRobloxIDAndSendMessage(key)
    local player = Players.LocalPlayer
    local robloxID = player.UserId
    SendMessage(key, robloxID)
end

local function LoadScript(scriptUrl)
    local script = loadstring(game:HttpGet(scriptUrl))()
end

local function NotifyUser(title, text)
    game.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 5
    })
end

local function CopyToClipboard(text)
    setclipboard(text)
end

local function CheckIDRB(key, robloxID)
    local whitelistURLs = {
        ["1"] = "https://raw.githubusercontent.com/MnsEn2001/Us/main/database/User_LRW_V1.json",
        ["2"] = "https://raw.githubusercontent.com/MnsEn2001/Us/main/database/User_LRW_V2.json",
        ["3"] = "https://raw.githubusercontent.com/MnsEn2001/Us/main/database/User_TQ_V1.json",
        ["4"] = "https://raw.githubusercontent.com/MnsEn2001/Us/main/database/User_TQ_V2.json"
    }
    
    local Loading_Scripts = {
        ["1"] = "https://raw.githubusercontent.com/MnsEn2001/Us/main/Game/LRWV1",
        ["2"] = "https://raw.githubusercontent.com/MnsEn2001/Us/main/Game/LRWV2",
        ["3"] = "https://raw.githubusercontent.com/MnsEn2001/Us/main/Game/TQV1",
        ["4"] = "https://raw.githubusercontent.com/MnsEn2001/Us/main/Game/TQV2"
    }

    local idFound = false

    for id, url in pairs(whitelistURLs) do
        local response = game:HttpGet(url)
        local whitelist = HttpService:JSONDecode(response)

        for _, user in pairs(whitelist.users) do
            if key == user.Key then
                if user.IDRB == "" then
                    GetRobloxIDAndSendMessage(key)
                    NotifyUser("Welcome", "ยินดีต้อนรับ สู่ สคริปต์")
                    LoadScript(Loading_Scripts[id])
                    idFound = true
                    break
                elseif robloxID == tonumber(user.IDRB) then
                    NotifyUser("Welcome", "ยินดีต้อนรับ สู่ สคริปต์")
                    LoadScript(Loading_Scripts[id])
                    idFound = true
                    break
                end
            end
        end

        if idFound then
            break
        end
    end

    if not idFound then
        NotifyUser("Error", "Key ไม่ถูกต้อง ได้คัดลอกลิงค์ดิสคอร์ดไว้ที่คลิปบอร์ดคุณแล้ว")
        CopyToClipboard("https://discord.com/invite/StxhWJE4pb")
    end
end

CheckIDRB(key, robloxID)
