local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local robloxID = player.UserId
local key = _G.Key

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

function Loading_Script()
    local Game = loadstring(game:HttpGet('https://raw.githubusercontent.com/EnJirad/GUI/main/Main_New.lua'))()
end

local function CheckIDRB(key, robloxID)
    local whitelistURLs = {
        "https://raw.githubusercontent.com/MnsEn2001/Us/main/database/User_LRW_V1.json",
        "https://raw.githubusercontent.com/MnsEn2001/Us/main/database/User_LRW_V2.json",
        "https://raw.githubusercontent.com/MnsEn2001/Us/main/database/User_TQ_V1.json",
        "https://raw.githubusercontent.com/MnsEn2001/Us/main/database/User_TQ_V2.json"
    }
    
    local idFound = false

    for _, url in ipairs(whitelistURLs) do
        local response = game:HttpGet(url)
        local whitelist = HttpService:JSONDecode(response)
        
        for _, user in pairs(whitelist.users) do
            if user.IDRB == "" then
                if key == user.Key then
                    GetRobloxIDAndSendMessage(key)
                    print("ส่งข้อมูลการ Redeem ไปที่ Discord แล้ว")
                    print("ยินดีต้อนรับ สู่ สคริปต์")
                    Loading_Script()
                    idFound = true
                    break
                else
                    print("Key ไม่ถูกต้อง ซื้อ Key ได้ที่ปุ่มซื้อ Key 1")
                    idFound = true
                    break
                end
            else
                if key == user.Key then
                    if robloxID == tonumber(user.IDRB) then
                        Loading_Script()
                        print("ยินดีต้อนรับ สู่ สคริปต์")
                        idFound = true
                        break
                    else
                        print("ID Roblox ไม่ตรงกัน")
                        idFound = true
                        break
                    end
                else
                    print("Key ไม่ถูกต้อง ซื้อ Key ได้ที่ปุ่มซื้อ Key 2")
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
        print("ยัง ไม่ได้ทำการ Redeem")
    end
end

CheckIDRB(key, robloxID)
