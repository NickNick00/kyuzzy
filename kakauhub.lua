-- kakauHub - Funções em coluna + Kill Player + Todas as funções organizadas

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local settingsData = { hubTheme = "escuro", confirmOnClose = false }
local function saveSettings()
    local folder = PlayerGui:FindFirstChild("kakauHubSettings") or Instance.new("Folder", PlayerGui)
    folder.Name = "kakauHubSettings"
    for k, v in pairs(settingsData) do
        local vObj = folder:FindFirstChild(k) or Instance.new("StringValue", folder)
        vObj.Name = k
        vObj.Value = tostring(v)
    end
end
local function loadSettings()
    local folder = PlayerGui:FindFirstChild("kakauHubSettings")
    if not folder then return end
    for _, vObj in ipairs(folder:GetChildren()) do
        if vObj.Name == "confirmOnClose" then
            settingsData.confirmOnClose = (vObj.Value == "true")
        elseif vObj.Name == "hubTheme" then
            settingsData.hubTheme = "escuro"
        end
    end
end
loadSettings()

local normalSize = UDim2.new(0.6, 0, 0.62, 0)
local normalPos  = UDim2.new(0.5, 0, 0.48, 0)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "kakauHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = PlayerGui

local function addCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
end

local TabFrames = {}

local function makeHeader(tab, text)
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, -20, 0, 28)
    header.Position = UDim2.new(0, 10, 0, 0)
    header.BackgroundTransparency = 1
    header.Text = text
    header.Font = Enum.Font.GothamBold
    header.TextColor3 = Color3.fromRGB(255,60,60)
    header.TextSize = 19
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = TabFrames[tab]
end

local function makeRow(tab, labelText, control)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -40, 0, 38)
    row.BackgroundTransparency = 1
    row.BorderSizePixel = 0
    row.Parent = TabFrames[tab]

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 12)
    layout.Parent = row

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 130, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.Font = Enum.Font.Gotham
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    if control then
        control.Parent = row
    end
    return row
end

-- Main Frame/UI
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = normalSize
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = normalPos
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
addCorner(MainFrame, 16)

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 44)
TopBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TopBar.BackgroundTransparency = 0.35
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
addCorner(TopBar, 15)

local Accent = Instance.new("Frame")
Accent.Size = UDim2.new(1, 0, 0, 3)
Accent.Position = UDim2.new(0,0,1,-3)
Accent.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
Accent.BorderSizePixel = 0
Accent.Parent = TopBar
addCorner(Accent, 1)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "kakauHub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 23
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Drag
do
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            dragInput = input
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    TopBar.InputChanged:Connect(function(input)
        if dragging and input == dragInput then update(input) end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then update(input) end
    end)
end

local HubBtn = Instance.new("TextButton")
HubBtn.Name = "HubBtn"
HubBtn.Text = "≡"
HubBtn.Font = Enum.Font.GothamBold
HubBtn.TextSize = 26
HubBtn.TextColor3 = Color3.fromRGB(255,255,255)
HubBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
HubBtn.BackgroundTransparency = 0.28
HubBtn.Size = UDim2.new(0, 44, 0, 44)
HubBtn.Position = UDim2.new(0.93, 0, 0.91, 0)
HubBtn.Visible = true
HubBtn.ZIndex = 10
HubBtn.Parent = ScreenGui
addCorner(HubBtn, 14)

do
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        HubBtn.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    HubBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = HubBtn.Position
            dragInput = input
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    HubBtn.InputChanged:Connect(function(input)
        if dragging and input == dragInput then update(input) end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then update(input) end
    end)
end

local TABLIST = {
    {Name="Main",Label="Main"},
    {Name="Visual",Label="Visual"},
    {Name="Poderes",Label="Poderes"},
    {Name="Admin",Label="Admin"},
}

-- SCROLLING ABAS (INTEGRADO)
local TabBarArea = Instance.new("ScrollingFrame")
TabBarArea.Name = "TabBarArea"
TabBarArea.Size = UDim2.new(1, -10, 0, 52)
TabBarArea.Position = UDim2.new(0, 5, 0, 44)
TabBarArea.BackgroundColor3 = Color3.fromRGB(0,0,0)
TabBarArea.BackgroundTransparency = 0.31
TabBarArea.BorderSizePixel = 0
TabBarArea.Parent = MainFrame
TabBarArea.ScrollingDirection = Enum.ScrollingDirection.X
TabBarArea.CanvasSize = UDim2.new(0, 0, 1, 0)
TabBarArea.AutomaticCanvasSize = Enum.AutomaticSize.X
TabBarArea.ScrollBarThickness = 4
TabBarArea.ScrollBarImageColor3 = Color3.fromRGB(255, 60, 60)
addCorner(TabBarArea, 10)

local tabListLayout = Instance.new("UIListLayout")
tabListLayout.FillDirection = Enum.FillDirection.Horizontal
tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabListLayout.Padding = UDim.new(0, 8)
tabListLayout.Parent = TabBarArea

local Tabs = {}
for i,tab in ipairs(TABLIST) do
    Tabs[tab.Name] = Instance.new("TextButton")
    local btn = Tabs[tab.Name]
    btn.Name = tab.Name
    btn.Text = tab.Label
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 17
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = 0.45
    btn.Size = UDim2.new(0, 130, 0, 42)
    btn.BorderSizePixel = 0
    btn.Parent = TabBarArea
    addCorner(btn, 10)
end

local ContentArea = Instance.new("ScrollingFrame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, 0, 1, -(TabBarArea.Position.Y.Offset + TabBarArea.Size.Y.Offset))
ContentArea.AnchorPoint = Vector2.new(0, 0)
ContentArea.Position = UDim2.new(0, 0, 0, TabBarArea.Position.Y.Offset + TabBarArea.Size.Y.Offset)
ContentArea.BackgroundColor3 = Color3.fromRGB(0,0,0)
ContentArea.BackgroundTransparency = 0.49
ContentArea.BorderSizePixel = 0
ContentArea.ScrollingDirection = Enum.ScrollingDirection.Y
ContentArea.CanvasSize = UDim2.new(0,0,0,0)
ContentArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentArea.ScrollBarThickness = 5
ContentArea.ScrollBarImageColor3 = Color3.fromRGB(255, 60, 60)
ContentArea.ScrollBarImageTransparency = 0.3
ContentArea.Parent = MainFrame
addCorner(ContentArea, 12)
if ContentArea:FindFirstChild("SmoothScrollingEnabled") ~= nil then
    ContentArea.SmoothScrollingEnabled = true
end

for _,tab in ipairs(TABLIST) do
    local frame = Instance.new("Frame")
    frame.Name = tab.Name.."TabFrame"
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.LayoutOrder = 0
    frame.Parent = ContentArea
    TabFrames[tab.Name] = frame

    -- Cada aba agora recebe um UIListLayout VERTICAL para deixar os elementos em coluna!
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = frame
end
TabFrames["Main"].Visible = true

--------------------------------------------------
-- ========== MAIN ==========
makeHeader("Main","Bem-vindo ao kakauHub!")
makeRow("Main","Use as abas acima para acessar os poderes e visuais.",nil)

--------------------------------------------------
-- ========== VISUAL ==========
makeHeader("Visual","Visuais")

local nightActive, fogActive, xrayEnemiesActive = false, false, false
local xrayEnemiesTransparency, xrayEnemiesParts = 0.1, {}
local function setNightVision(val)
    Lighting.Brightness = val and 4 or 1
    Lighting.Ambient = val and Color3.new(1,1,1) or Color3.new(0.5,0.5,0.5)
end
local function setNoFog(val)
    Lighting.FogEnd = val and 1000000 or 1000
end
local function setXrayEnemies(val)
    local function isEnemy(plr)
        if plr == player then return false end
        if plr.Team ~= nil and player.Team ~= nil then
            return plr.Team ~= player.Team
        end
        return true
    end
    if val then
        xrayEnemiesParts = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj:IsDescendantOf(Players) then
                if obj.Transparency < 1 then
                    table.insert(xrayEnemiesParts, {part=obj, original=obj.Transparency})
                    obj.Transparency = 0.9
                end
            end
        end
        for _, plr in pairs(Players:GetPlayers()) do
            if isEnemy(plr) and plr.Character then
                for _, obj in pairs(plr.Character:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        obj.Transparency = xrayEnemiesTransparency
                    end
                end
            end
        end
    else
        for _, data in pairs(xrayEnemiesParts) do
            if data.part and data.part.Parent then
                data.part.Transparency = data.original
            end
        end
        xrayEnemiesParts = {}
    end
end

local function criarBotao(text, cor, txtOn, txtOff, getState, setState)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 32)
    btn.BackgroundColor3 = cor
    btn.BackgroundTransparency = 0.2
    btn.Text = getState() and txtOn or txtOff
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 15
    addCorner(btn, 8)
    btn.MouseButton1Click:Connect(function()
        setState(not getState())
        btn.Text = getState() and txtOn or txtOff
    end)
    return btn
end

local visuais = {
    {
        nome = "Night Vision:",
        cor = Color3.fromRGB(70,70,70),
        txtOff = "Night Vision",
        txtOn = "Normal Vision",
        getState = function() return nightActive end,
        setState = function(v) nightActive = v; setNightVision(v) end
    },
    {
        nome = "Sem Névoa:",
        cor = Color3.fromRGB(70,120,180),
        txtOff = "Remover Névoa",
        txtOn = "Restaurar Névoa",
        getState = function() return fogActive end,
        setState = function(v) fogActive = v; setNoFog(v) end
    },
    {
        nome = "Xray Inimigos:",
        cor = Color3.fromRGB(40,40,40),
        txtOff = "Ativar Xray Inimigos",
        txtOn = "Desativar Xray Inimigos",
        getState = function() return xrayEnemiesActive end,
        setState = function(v) xrayEnemiesActive = v; setXrayEnemies(v) end
    },
}
for _,v in ipairs(visuais) do
    makeRow("Visual", v.nome, criarBotao(v.nome, v.cor, v.txtOn, v.txtOff, v.getState, v.setState))
end

-- ESP MM2 Highlight
local espHighlightActive = false
local espThread = nil
local function getRoleColor(plr)
    local char = plr.Character
    local bp = plr:FindFirstChild("Backpack")
    if (bp and bp:FindFirstChild("Knife")) or (char and char:FindFirstChild("Knife")) then
        return Color3.new(1,0,0) -- Vermelho (Murder)
    elseif (bp and bp:FindFirstChild("Gun")) or (char and char:FindFirstChild("Gun")) then
        return Color3.new(0,0,1) -- Azul (Sheriff)
    else
        return Color3.new(0,1,0) -- Verde (Inocente)
    end
end
local function setESPHighlight(enable)
    if espThread then
        espThread:Disconnect()
        espThread = nil
    end
    if not enable then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("Highlight") then
                plr.Character.Highlight:Destroy()
            end
        end
        return
    end
    espThread = RunService.RenderStepped:Connect(function()
        for _, v in ipairs(Players:GetPlayers()) do
            if v ~= player and v.Character then
                local highlight = v.Character:FindFirstChild("Highlight")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Parent = v.Character
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0.5
                end
                highlight.FillColor = getRoleColor(v)
            end
        end
    end)
end
makeRow("Visual","ESP MM2:", (function()
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(0,180,80)
    btn.BackgroundTransparency = 0.2
    btn.Text = "Ativar ESP MM2"
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 15
    addCorner(btn, 8)
    btn.MouseButton1Click:Connect(function()
        espHighlightActive = not espHighlightActive
        setESPHighlight(espHighlightActive)
        btn.Text = espHighlightActive and "Desativar ESP MM2" or "Ativar ESP MM2"
    end)
    return btn
end)())

--------------------------------------------------
-- ========== PODERES ==========
makeHeader("Poderes","Poderes")

-- Kill Aura MM2
local killAuraActive = false

local function getKnifeTool()
    local bp = player:FindFirstChildOfClass("Backpack")
    local char = player.Character
    return (char and char:FindFirstChild("Knife")) or (bp and bp:FindFirstChild("Knife"))
end

local function isMurder()
    local bp = player:FindFirstChildOfClass("Backpack")
    local char = player.Character
    return ((bp and bp:FindFirstChild("Knife")) or (char and char:FindFirstChild("Knife")))
end

local function stab(target)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    local knifeTool = getKnifeTool()
    if not knifeTool then return end
    if knifeTool.Parent ~= player.Character then
        knifeTool.Parent = player.Character
        task.wait(0.12)
    end
    local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local oldCFrame = myRoot.CFrame
    local targetPos = target.Character.HumanoidRootPart.CFrame
    local backstab = targetPos * CFrame.new(0, 0, 2)
    myRoot.CFrame = backstab + Vector3.new(0, 1.5, 0)
    myRoot.CFrame = CFrame.new(myRoot.Position, target.Character.HumanoidRootPart.Position)
    
    local success = false
    for _, obj in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if obj.Name:lower():find("knife") and obj:IsA("RemoteEvent") then
            pcall(function()
                obj:FireServer("Slash")
                obj:FireServer("Hit", target.Character:FindFirstChild("Humanoid"))
                success = true
            end)
        end
    end
    if not success then
        pcall(function()
            knifeTool:Activate()
        end)
    end
    task.wait(0.18)
    if oldCFrame and myRoot then
        myRoot.CFrame = oldCFrame
    end
end

local function killAuraLoop()
    while killAuraActive and player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") do
        local myPos = player.Character.HumanoidRootPart.Position
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (myPos - plr.Character.HumanoidRootPart.Position).Magnitude
                if dist < 15 then  -- alcance do kill aura; ajuste conforme necessário
                    local humanoid = plr.Character:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        pcall(function() 
                            stab(plr)
                        end)
                        task.wait(0.2)  -- delay entre ataques para evitar spam
                    end
                end
            end
        end
        task.wait(0.1)
    end
end

makeRow("Main", "Kill Aura MM2:", (function()
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Text = "Ativar Kill Aura"
    addCorner(btn, 8)
    btn.MouseButton1Click:Connect(function()
        killAuraActive = not killAuraActive
        if killAuraActive then
            btn.Text = "Desativar Kill Aura"
            if not isMurder() then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Kill Aura",
                    Text = "Você não é o Murder ou não possui a faca equipada.",
                    Duration = 3,
                })
                killAuraActive = false
                btn.Text = "Ativar Kill Aura"
                return
            end
            spawn(function() killAuraLoop() end)
        else
            btn.Text = "Ativar Kill Aura"
        end
    end)
    return btn
end)())


-- ========== FLING & WALKFLING PODERES (ANTI-ARREMESSO COM ANCORAGEM) ==========

local function getPlayerByNamePartial(name)
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and (plr.Name:lower():sub(1,#name)==name:lower() or plr.DisplayName:lower():sub(1,#name)==name:lower()) then
            return plr
        end
    end
    return nil
end

-- FLING: Arremessa apenas o alvo, não você
local function flingTarget(target)
    if not target or target == player or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    local targetRoot = target.Character.HumanoidRootPart
    -- Lança para o void (Y negativo)
    targetRoot.Velocity = Vector3.new(0, -500, 0) + (targetRoot.CFrame.LookVector * 200)
    targetRoot.RotVelocity = Vector3.new(9000,9000,9000)
end

local function flingAll()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            flingTarget(plr)
            task.wait(0.23)
        end
    end
end

-- Constantes para o launch
local LAUNCH_VELOCITY = Vector3.new(0, -120, 0) -- Joga para o void. Ajuste a força se quiser
local WALKFLING_ROT = Vector3.new(8888, 8888, 8888)

local function onTouchFling(otherPart)
    local myChar = player.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    if otherPart:IsDescendantOf(myChar) then return end

    local otherChar = otherPart and otherPart.Parent
    local otherPlr = otherChar and Players:GetPlayerFromCharacter(otherChar)
    if otherPlr and otherPlr ~= player then
        if walkflingModeAll or (walkflingTargetPlayer and otherPlr == walkflingTargetPlayer) then
            local humanoid = otherChar:FindFirstChildOfClass("Humanoid")
            local hroot = otherChar:FindFirstChild("HumanoidRootPart")
            if humanoid and hroot then
                -- Coloca o player em modo Physics e lança
                humanoid.PlatformStand = true
                humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                hroot.Velocity = LAUNCH_VELOCITY
                hroot.RotVelocity = WALKFLING_ROT
            end
        end
    end
end

makeRow("Poderes", "Fling All:", (function()
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(255,140,0)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Text = "Fling All"
    addCorner(btn, 8)
    btn.MouseButton1Click:Connect(flingAll)
    return btn
end)())

makeRow("Poderes", "Fling Player:", (function()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 34)
    frame.BackgroundTransparency = 1
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 100, 0, 30)
    box.BackgroundColor3 = Color3.fromRGB(255,140,0)
    box.TextColor3 = Color3.fromRGB(255,255,255)
    box.Font = Enum.Font.GothamBold
    box.TextSize = 13
    box.Text = "Nome"
    box.ClearTextOnFocus = false
    addCorner(box, 8)
    box.Parent = frame
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 68, 0, 30)
    btn.Position = UDim2.new(0, 110, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255,90,0)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Text = "Fling"
    addCorner(btn, 8)
    btn.Parent = frame
    btn.MouseButton1Click:Connect(function()
        local plr = getPlayerByNamePartial(box.Text)
        if plr then
            flingTarget(plr)
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Fling Player",
                Text = "Jogador não encontrado.",
                Duration = 2,
            })
        end
    end)
    return frame
end)())

local userSpeed = 16
local userJump = 50
local godActive, noclipActive, flyActive = false, false, false
local godConnection, noclipConn, flyConn = nil, nil, nil
local flySpeed = 55

local function setGod(enabled)
    local char = player.Character
    if not char or not char:FindFirstChild("Humanoid") then return end
    local humanoid = char.Humanoid
    if enabled then
        humanoid.Name = "GodH"
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        if godConnection then godConnection:Disconnect() end
        godConnection = humanoid.HealthChanged:Connect(function()
            if humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
    else
        humanoid.Name = "Humanoid"
        pcall(function()
            humanoid.MaxHealth = 100
            humanoid.Health = 100
            humanoid.WalkSpeed = userSpeed
            humanoid.JumpPower = userJump
        end)
        if godConnection then godConnection:Disconnect() godConnection = nil end
    end
end
local function setSpeed(val)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = val
    end
end
local function setJump(val)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = val
    end
end
local function setNoclip(enabled)
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    local char = player.Character
    if enabled and char then
        noclipConn = RunService.Stepped:Connect(function()
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    elseif char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end
local function startFly()
    if flyConn then flyConn:Disconnect() flyConn = nil end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end
    local hrp = char.HumanoidRootPart
    local humanoid = char.Humanoid
    humanoid.PlatformStand = true
    flyConn = RunService.RenderStepped:Connect(function()
        if not flyActive then return end
        local camCF = workspace.CurrentCamera.CFrame
        local move = humanoid.MoveDirection
        if move.Magnitude > 0 then
            local camRight = camCF.RightVector
            local camLook = camCF.LookVector
            local input = Vector3.new(move.X, 0, move.Z)
            local camForward = Vector3.new(camLook.X, 0, camLook.Z).Unit
            local moveDir = (camRight * input.X + camForward * input.Z)
            local vertical = camLook.Y * input.Z
            local final = Vector3.new(moveDir.X, vertical, moveDir.Z)
            if final.Magnitude > 0 then
                hrp.Velocity = final.Unit * flySpeed
                hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + camCF.LookVector)
            else
                hrp.Velocity = Vector3.zero
            end
        else
            hrp.Velocity = Vector3.zero
        end
    end)
end
local function stopFly()
    flyActive = false
    if flyConn then flyConn:Disconnect() flyConn = nil end
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.PlatformStand = false
    end
end

-- Cada função em uma linha (funções em coluna)
makeRow("Poderes", "God (Imortal):",
    criarBotao("God", Color3.fromRGB(60,200,60), "Desativar God", "Ativar God", function() return godActive end, function(v) godActive = v; setGod(v) end)
)
makeRow("Poderes", "Noclip:",
    criarBotao("Noclip", Color3.fromRGB(180,120,255), "Desativar Noclip", "Ativar Noclip", function() return noclipActive end, function(v) noclipActive = v; setNoclip(v) end)
)
makeRow("Poderes", "Fly (InfiniteYield):",
    criarBotao("Fly", Color3.fromRGB(60,60,160), "Desativar Fly", "Ativar Fly", function() return flyActive end, function(v) flyActive = v; if v then startFly() else stopFly() end end)
)

makeRow("Poderes", "Velocidade:", (function()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 34)
    frame.BackgroundTransparency = 1
    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0, 90, 0, 30)
    speedBox.BackgroundColor3 = Color3.fromRGB(40,40,80)
    speedBox.TextColor3 = Color3.fromRGB(255,255,255)
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 13
    speedBox.Text = tostring(userSpeed)
    speedBox.ClearTextOnFocus = false
    addCorner(speedBox, 8)
    speedBox.Parent = frame
    speedBox.FocusLost:Connect(function(enter)
        local n = tonumber(speedBox.Text)
        if n and n > 0 and n < 1000 then
            userSpeed = n
            setSpeed(userSpeed)
        else
            speedBox.Text = tostring(userSpeed)
        end
    end)
    local speedResetBtn = Instance.new("TextButton")
    speedResetBtn.Size = UDim2.new(0, 68, 0, 30)
    speedResetBtn.Position = UDim2.new(0, 100, 0, 0)
    speedResetBtn.BackgroundColor3 = Color3.fromRGB(120,120,255)
    speedResetBtn.TextColor3 = Color3.fromRGB(255,255,255)
    speedResetBtn.Font = Enum.Font.GothamBold
    speedResetBtn.TextSize = 13
    speedResetBtn.Text = "Reset"
    addCorner(speedResetBtn, 8)
    speedResetBtn.Parent = frame
    speedResetBtn.MouseButton1Click:Connect(function()
        userSpeed = 16
        speedBox.Text = tostring(userSpeed)
        setSpeed(userSpeed)
    end)
    return frame
end)())

makeRow("Poderes", "Pulo:", (function()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 34)
    frame.BackgroundTransparency = 1
    local jumpBox = Instance.new("TextBox")
    jumpBox.Size = UDim2.new(0, 90, 0, 30)
    jumpBox.BackgroundColor3 = Color3.fromRGB(40,80,40)
    jumpBox.TextColor3 = Color3.fromRGB(255,255,255)
    jumpBox.Font = Enum.Font.GothamBold
    jumpBox.TextSize = 13
    jumpBox.Text = tostring(userJump)
    jumpBox.ClearTextOnFocus = false
    addCorner(jumpBox, 8)
    jumpBox.Parent = frame
    jumpBox.FocusLost:Connect(function(enter)
        local n = tonumber(jumpBox.Text)
        if n and n > 0 and n < 1000 then
            userJump = n
            setJump(userJump)
        else
            jumpBox.Text = tostring(userJump)
        end
    end)
    local jumpResetBtn = Instance.new("TextButton")
    jumpResetBtn.Size = UDim2.new(0, 68, 0, 30)
    jumpResetBtn.Position = UDim2.new(0, 100, 0, 0)
    jumpResetBtn.BackgroundColor3 = Color3.fromRGB(120,255,120)
    jumpResetBtn.TextColor3 = Color3.fromRGB(255,255,255)
    jumpResetBtn.Font = Enum.Font.GothamBold
    jumpResetBtn.TextSize = 13
    jumpResetBtn.Text = "Reset"
    addCorner(jumpResetBtn, 8)
    jumpResetBtn.Parent = frame
    jumpResetBtn.MouseButton1Click:Connect(function()
        userJump = 50
        jumpBox.Text = tostring(userJump)
        setJump(userJump)
    end)
    return frame
end)())

makeRow("Poderes", "Kill All:", (function()
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 160, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Text = "Kill All MM2"
    addCorner(btn, 8)
    btn.MouseButton1Click:Connect(function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local function isMurder()
            local bp = player:FindFirstChildOfClass("Backpack")
            local char = player.Character
            if (bp and bp:FindFirstChild("Knife")) or (char and char:FindFirstChild("Knife")) then
                return true
            end
            return false
        end
        local function getKnifeTool()
            local bp = player:FindFirstChildOfClass("Backpack")
            local char = player.Character
            return (char and char:FindFirstChild("Knife")) or (bp and bp:FindFirstChild("Knife"))
        end
        local function stab(target)
            if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
            local knifeTool = getKnifeTool()
            if not knifeTool then return end
            if knifeTool.Parent ~= player.Character then
                knifeTool.Parent = player.Character
                task.wait(0.12)
            end
            local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local oldCFrame = myRoot and myRoot.CFrame
            local targetPos = target.Character.HumanoidRootPart.CFrame
            local backstab = targetPos * CFrame.new(0, 0, 2)
            myRoot.CFrame = backstab + Vector3.new(0,1.5,0)
            myRoot.CFrame = CFrame.new(myRoot.Position, target.Character.HumanoidRootPart.Position)
            local success = false
            for _,obj in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                if obj.Name:lower():find("knife") and obj:IsA("RemoteEvent") then
                    pcall(function()
                        obj:FireServer("Slash")
                        obj:FireServer("Hit", target.Character:FindFirstChild("Humanoid"))
                        success = true
                    end)
                end
            end
            if not success then
                pcall(function()
                    knifeTool:Activate()
                end)
            end
            task.wait(0.18)
            if oldCFrame and myRoot then
                myRoot.CFrame = oldCFrame
            end
        end
        local function killAll(config)
            config = config or {}
            local skipSheriff = config.skipSheriff or false
            local delayMin, delayMax = config.delayMin or 0.25, config.delayMax or 0.5
            local targets, sheriffTarget = {}, nil
            for _,plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local bp = plr:FindFirstChildOfClass("Backpack")
                    if skipSheriff and ((bp and bp:FindFirstChild("Gun")) or (plr.Character and plr.Character:FindFirstChild("Gun"))) then
                        sheriffTarget = plr
                    else
                        table.insert(targets, plr)
                    end
                end
            end
            if sheriffTarget then table.insert(targets, sheriffTarget) end
            for _,target in ipairs(targets) do
                if target and target.Character and target.Character:FindFirstChild("Humanoid").Health > 0 then
                    stab(target)
                    task.wait(math.random() * (delayMax - delayMin) + delayMin)
                end
            end
        end
        if isMurder() and getKnifeTool() then
            killAll({skipSheriff=true, delayMin=0.23, delayMax=0.4})
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Kill All",
                Text = "Kill all executado!",
                Duration = 3,
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Kill All",
                Text = "Você não é o Murder ou não está com a faca.",
                Duration = 3,
            })
        end
    end)
    return btn
end)())

-- TP Player
local function tpToPlayer(targetName)
    local target = nil
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and (plr.Name:lower():sub(1,#targetName) == targetName:lower() or plr.DisplayName:lower():sub(1,#targetName) == targetName:lower()) then
            target = plr
            break
        end
    end
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,2)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "TP",
            Text = "Teleportado para "..target.Name,
            Duration = 3,
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "TP",
            Text = "Jogador não encontrado ou sem personagem.",
            Duration = 3,
        })
    end
end

makeRow("Poderes", "TP Player:", (function()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 34)
    frame.BackgroundTransparency = 1
    local tpPlayerBox = Instance.new("TextBox")
    tpPlayerBox.Size = UDim2.new(0, 100, 0, 30)
    tpPlayerBox.BackgroundColor3 = Color3.fromRGB(80,80,180)
    tpPlayerBox.TextColor3 = Color3.fromRGB(255,255,255)
    tpPlayerBox.Font = Enum.Font.GothamBold
    tpPlayerBox.TextSize = 13
    tpPlayerBox.Text = "Nome"
    tpPlayerBox.ClearTextOnFocus = false
    addCorner(tpPlayerBox, 8)
    tpPlayerBox.Parent = frame
    local tpPlayerBtn = Instance.new("TextButton")
    tpPlayerBtn.Size = UDim2.new(0, 68, 0, 30)
    tpPlayerBtn.Position = UDim2.new(0, 110, 0, 0)
    tpPlayerBtn.BackgroundColor3 = Color3.fromRGB(100,100,255)
    tpPlayerBtn.TextColor3 = Color3.fromRGB(255,255,255)
    tpPlayerBtn.Font = Enum.Font.GothamBold
    tpPlayerBtn.TextSize = 13
    tpPlayerBtn.Text = "TP"
    addCorner(tpPlayerBtn, 8)
    tpPlayerBtn.Parent = frame
    tpPlayerBtn.MouseButton1Click:Connect(function()
        tpToPlayer(tpPlayerBox.Text)
    end)
    return frame
end)())

-- Kill Player (nova função)
makeRow("Poderes", "Kill Player:", (function()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 220, 0, 34)
    frame.BackgroundTransparency = 1
    local killBox = Instance.new("TextBox")
    killBox.Size = UDim2.new(0, 100, 0, 30)
    killBox.BackgroundColor3 = Color3.fromRGB(220,60,60)
    killBox.TextColor3 = Color3.fromRGB(255,255,255)
    killBox.Font = Enum.Font.GothamBold
    killBox.TextSize = 13
    killBox.Text = "Nome"
    killBox.ClearTextOnFocus = false
    addCorner(killBox, 8)
    killBox.Parent = frame
    local killBtn = Instance.new("TextButton")
    killBtn.Size = UDim2.new(0, 90, 0, 30)
    killBtn.Position = UDim2.new(0, 110, 0, 0)
    killBtn.BackgroundColor3 = Color3.fromRGB(220,50,50)
    killBtn.TextColor3 = Color3.fromRGB(255,255,255)
    killBtn.Font = Enum.Font.GothamBold
    killBtn.TextSize = 13
    killBtn.Text = "Kill"
    addCorner(killBtn, 8)
    killBtn.Parent = frame
    killBtn.MouseButton1Click:Connect(function()
        local targetName = killBox.Text
        local target = nil
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and (plr.Name:lower():sub(1,#targetName) == targetName:lower() or plr.DisplayName:lower():sub(1,#targetName) == targetName:lower()) then
                target = plr
                break
            end
        end
        local function isMurder()
            local bp = player:FindFirstChildOfClass("Backpack")
            local char = player.Character
            if (bp and bp:FindFirstChild("Knife")) or (char and char:FindFirstChild("Knife")) then
                return true
            end
            return false
        end
        local function getKnifeTool()
            local bp = player:FindFirstChildOfClass("Backpack")
            local char = player.Character
            return (char and char:FindFirstChild("Knife")) or (bp and bp:FindFirstChild("Knife"))
        end
        local function stab(target)
            if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
            local knifeTool = getKnifeTool()
            if not knifeTool then return end
            if knifeTool.Parent ~= player.Character then
                knifeTool.Parent = player.Character
                task.wait(0.12)
            end
            local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local oldCFrame = myRoot and myRoot.CFrame
            local targetPos = target.Character.HumanoidRootPart.CFrame
            local backstab = targetPos * CFrame.new(0, 0, 2)
            myRoot.CFrame = backstab + Vector3.new(0,1.5,0)
            myRoot.CFrame = CFrame.new(myRoot.Position, target.Character.HumanoidRootPart.Position)
            local success = false
            for _,obj in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                if obj.Name:lower():find("knife") and obj:IsA("RemoteEvent") then
                    pcall(function()
                        obj:FireServer("Slash")
                        obj:FireServer("Hit", target.Character:FindFirstChild("Humanoid"))
                        success = true
                    end)
                end
            end
            if not success then
                pcall(function()
                    knifeTool:Activate()
                end)
            end
            task.wait(0.18)
            if oldCFrame and myRoot then
                myRoot.CFrame = oldCFrame
            end
        end
        if not target then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Kill Player",
                Text = "Jogador não encontrado.",
                Duration = 3,
            })
            return
        end
        if isMurder() and getKnifeTool() then
            stab(target)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Kill Player",
                Text = "Tentativa de kill executada!",
                Duration = 3,
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Kill Player",
                Text = "Você não é o Murder ou não está com a faca.",
                Duration = 3,
            })
        end
    end)
    return frame
end)())

-- TP Lobby
local function tpToLobby()
    local lobby = workspace:FindFirstChild("Lobby")
    local pos = nil
    if lobby then
        for _,v in ipairs(lobby:GetDescendants()) do
            if v:IsA("BasePart") and (v.Name:lower():find("spawn") or v.Name:lower():find("center")) then
                pos = v.CFrame
                break
            end
        end
        if not pos and lobby.PrimaryPart then
            pos = lobby.PrimaryPart.CFrame
        elseif not pos then
            local parts = {}
            for _,v in ipairs(lobby:GetDescendants()) do
                if v:IsA("BasePart") then table.insert(parts, v.Position) end
            end
            if #parts > 0 then
                local sum = Vector3.new(0,0,0)
                for _,v in ipairs(parts) do sum = sum + v end
                pos = CFrame.new(sum/#parts)
            end
        end
    end
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and pos then
        player.Character.HumanoidRootPart.CFrame = pos + Vector3.new(0,2,0)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "TP",
            Text = "Teleportado para o Lobby!",
            Duration = 3,
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "TP",
            Text = "Lobby não encontrado.",
            Duration = 3,
        })
    end
end

makeRow("Poderes", "TP Lobby:", (function()
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 180, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(150,150,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Text = "TP para Lobby"
    addCorner(btn, 8)
    btn.MouseButton1Click:Connect(tpToLobby)
    return btn
end)())

-- TP Mapa
local function tpToMap()
    local map = nil
    for _,obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name ~= "Lobby" and not Players:FindFirstChild(obj.Name) and obj.Name ~= "Camera" and obj.Name ~= "Lobby2" then
            if obj:FindFirstChildWhichIsA("BasePart") then
                map = obj
                break
            end
        end
    end
    local pos = nil
    if map then
        for _,v in ipairs(map:GetDescendants()) do
            if v:IsA("BasePart") and v.Name:lower():find("spawn") then
                pos = v.CFrame
                break
            end
        end
        if not pos and map.PrimaryPart then
            pos = map.PrimaryPart.CFrame
        elseif not pos then
            local parts = {}
            for _,v in ipairs(map:GetDescendants()) do
                if v:IsA("BasePart") then table.insert(parts, v.Position) end
            end
            if #parts > 0 then
                local sum = Vector3.new(0,0,0)
                for _,v in ipairs(parts) do sum = sum + v end
                pos = CFrame.new(sum/#parts)
            end
        end
    end
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and pos then
        player.Character.HumanoidRootPart.CFrame = pos + Vector3.new(0,2,0)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "TP",
            Text = "Teleportado para o Mapa!",
            Duration = 3,
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "TP",
            Text = "Mapa não encontrado.",
            Duration = 3,
        })
    end
end

makeRow("Poderes", "TP Mapa:", (function()
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 180, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(80,220,100)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Text = "TP para Mapa"
    addCorner(btn, 8)
    btn.MouseButton1Click:Connect(tpToMap)
    return btn
end)())

--------------------------------------------------
-- ========== SWITCH ABAS ==========
local function showTab(tab)
    for name, frame in pairs(TabFrames) do
        frame.Visible = false
    end
    TabFrames[tab].Visible = true
end
for name,btn in pairs(Tabs) do
    btn.MouseButton1Click:Connect(function() showTab(name) end)
end

local hubOpened = false
local function animateOpen()
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = normalSize,
        Position = normalPos
    })
    tween:Play()
    hubOpened = true
end
local function animateClose()
    if settingsData.confirmOnClose then
        saveSettings()
    end
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    tween:Play()
    tween.Completed:Wait()
    MainFrame.Visible = false
    hubOpened = false
end
HubBtn.MouseButton1Click:Connect(function()
    if hubOpened then
        animateClose()
    else
        animateOpen()
    end
end)

pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "KakauHub",
        Text = "KakauHub iniciado!",
        Duration = 4
    })
end)

task.wait(0.1)
animateOpen()
