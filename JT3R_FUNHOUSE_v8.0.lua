--[[
    JT3R FUNHOUSE v8.0
    Obsidian Atelier — Signature Redesign
    Standalone UI shell for Roblox experiences.

    The ESP page includes client-side R6/R15 character visualisation for
    the owner's own Roblox experience: boxes, names, highlights, health,
    team filtering, distance filtering, RGB accents and body-part diagnostics and a server-authorised, whitelist-controlled hitbox expander. It does not include
    aim assistance, automation, anti-cheat bypasses or recording concealment.

    Upload this file to GitHub as JT3R_FUNHOUSE_v8.0.lua.
]]

--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// Cleanup previous copy
-- Stop the previous controller first so its input/render connections do not stack on re-execution.
local previousController = _G.JT3R_FUNHOUSE
if type(previousController) == "table" and type(previousController.Destroy) == "function" then
    pcall(function() previousController.Destroy() end)
end

local GUI_NAME = "JT3R_FUNHOUSE_V27"
pcall(function()
    local old = (gethui and gethui()) or CoreGui
    for _, oldName in ipairs({GUI_NAME, "JT3R_FUNHOUSE_V23", "JT3R_FUNHOUSE_V22", "JT3R_FUNHOUSE_V21", "JT3R_FUNZONE_KeyGate"}) do
        local existing = old:FindFirstChild(oldName)
        if existing then existing:Destroy() end
    end
end)

--// JT3R FUNZONE access gate
-- Client-side access gate: directs users to Linkvertise; it does not securely verify completion.
do
    local accepted = false
    -- Replace this placeholder with your real Linkvertise destination when ready.
    local LINKVERTISE_URL = "https://link-hub.net/8033743/AXAnz3AlJFY4"
    -- Local access phrase gate. Linkvertise completion is not server-verified in this client-only build.
    local function validateAccessKey(candidate)
        return string.lower((candidate or ""):gsub("%s+", "")) == "funzone"
    end
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "JT3R_FUNZONE_KeyGate"
    keyGui.IgnoreGuiInset = true
    keyGui.ResetOnSpawn = false
    keyGui.DisplayOrder = 10000
    keyGui.Parent = PlayerGui

    local backdrop = Instance.new("Frame")
    backdrop.Size = UDim2.fromScale(1, 1)
    backdrop.BackgroundColor3 = Color3.fromRGB(3, 4, 6)
    backdrop.BackgroundTransparency = 1
    backdrop.BorderSizePixel = 0
    backdrop.Parent = keyGui
    local backdropGradient = Instance.new("UIGradient")
    backdropGradient.Rotation = 35
    backdropGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 23, 16)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(7, 8, 11)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 15, 12)),
    })
    backdropGradient.Parent = backdrop

    local card = Instance.new("Frame")
    card.Name = "AccessCard"
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.fromScale(0.5, 0.5)
    card.Size = UDim2.new(0.88, 0, 0, 340)
    card.BackgroundColor3 = Color3.fromRGB(14, 15, 18)
    card.BackgroundTransparency = 1
    card.BorderSizePixel = 0
    card.Parent = backdrop
    card.ClipsDescendants = true
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 22)
    local sizeLimit = Instance.new("UISizeConstraint")
    sizeLimit.MinSize = Vector2.new(290, 340)
    sizeLimit.MaxSize = Vector2.new(430, 340)
    sizeLimit.Parent = card
    local cardEdge = Instance.new("UIStroke")
    cardEdge.Color = Color3.fromRGB(225, 187, 119)
    cardEdge.Thickness = 1.4
    cardEdge.Transparency = 0.16
    cardEdge.Parent = card
    local cardGradient = Instance.new("UIGradient")
    cardGradient.Rotation = 125
    cardGradient.Color = ColorSequence.new(Color3.fromRGB(37, 30, 21), Color3.fromRGB(10, 11, 14))
    cardGradient.Parent = card

    local glow = Instance.new("Frame")
    glow.AnchorPoint = Vector2.new(0.5, 0)
    glow.Position = UDim2.new(0.5, 0, 0, -38)
    glow.Size = UDim2.new(0.72, 0, 0, 68)
    glow.BackgroundColor3 = Color3.fromRGB(209, 164, 94)
    glow.BackgroundTransparency = 0.86
    glow.BorderSizePixel = 0
    glow.Parent = card
    Instance.new("UICorner", glow).CornerRadius = UDim.new(1, 0)

    local brand = Instance.new("TextLabel")
    brand.BackgroundTransparency = 1
    brand.Position = UDim2.new(0, 25, 0, 14)
    brand.Size = UDim2.new(1, -50, 0, 38)
    brand.Font = Enum.Font.Merriweather
    brand.Text = "JT3R"
    brand.TextColor3 = Color3.fromRGB(255, 224, 173)
    brand.TextSize = 29
    brand.TextXAlignment = Enum.TextXAlignment.Center
    brand.Parent = card

    local eyebrow = Instance.new("TextLabel")
    eyebrow.BackgroundTransparency = 1
    eyebrow.Position = UDim2.new(0, 20, 0, 49)
    eyebrow.Size = UDim2.new(1, -40, 0, 18)
    eyebrow.Font = Enum.Font.RobotoMono
    eyebrow.Text = "FUNHOUSE  /  PRIVATE ACCESS"
    eyebrow.TextColor3 = Color3.fromRGB(208, 168, 105)
    eyebrow.TextSize = 9
    eyebrow.Parent = card

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 24, 0, 80)
    title.Size = UDim2.new(1, -48, 0, 26)
    title.Font = Enum.Font.SourceSansSemibold
    title.Text = "Enter your access key"
    title.TextColor3 = Color3.fromRGB(246, 240, 229)
    title.TextSize = 17
    title.Parent = card

    local hint = Instance.new("TextLabel")
    hint.BackgroundTransparency = 1
    hint.Position = UDim2.new(0, 24, 0, 108)
    hint.Size = UDim2.new(1, -48, 0, 20)
    hint.Font = Enum.Font.SourceSans
    hint.Text = "Your private access key is required to continue."
    hint.TextColor3 = Color3.fromRGB(143, 139, 130)
    hint.TextSize = 10
    hint.Parent = card

    local getKey = Instance.new("TextButton")
    getKey.Name = "LinkvertiseButton"
    getKey.Position = UDim2.new(0, 24, 0, 143)
    getKey.Size = UDim2.new(1, -48, 0, 38)
    getKey.BackgroundColor3 = Color3.fromRGB(29, 27, 23)
    getKey.BorderSizePixel = 0
    getKey.AutoButtonColor = false
    getKey.Text = "GET ACCESS KEY   /   LINKVERTISE"
    getKey.TextColor3 = Color3.fromRGB(232, 207, 163)
    getKey.TextSize = 9
    getKey.Font = Enum.Font.RobotoMono
    getKey.Parent = card
    Instance.new("UICorner", getKey).CornerRadius = UDim.new(0, 9)
    local getKeyEdge = Instance.new("UIStroke")
    getKeyEdge.Color = Color3.fromRGB(133, 105, 67)
    getKeyEdge.Transparency = 0.48
    getKeyEdge.Parent = getKey

    local keyBox = Instance.new("TextBox")
    keyBox.Name = "AccessKeyInput"
    keyBox.Position = UDim2.new(0, 24, 0, 191)
    keyBox.Size = UDim2.new(1, -48, 0, 44)
    keyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 27)
    keyBox.BorderSizePixel = 0
    keyBox.ClearTextOnFocus = false
    keyBox.PlaceholderText = "Enter key..."
    keyBox.PlaceholderColor3 = Color3.fromRGB(112, 108, 100)
    keyBox.Text = ""
    keyBox.TextColor3 = Color3.fromRGB(248, 239, 222)
    keyBox.Font = Enum.Font.SourceSansSemibold
    keyBox.TextSize = 13
    keyBox.TextXAlignment = Enum.TextXAlignment.Center
    keyBox.Parent = card
    Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 10)
    local inputEdge = Instance.new("UIStroke")
    inputEdge.Color = Color3.fromRGB(133, 105, 67)
    inputEdge.Transparency = 0.42
    inputEdge.Parent = keyBox

    local status = Instance.new("TextLabel")
    status.BackgroundTransparency = 1
    status.Position = UDim2.new(0, 24, 0, 241)
    status.Size = UDim2.new(1, -48, 0, 16)
    status.Font = Enum.Font.SourceSansSemibold
    status.Text = "LINKVERTISE ACCESS  /  ENTER KEY: FUNZONE"
    status.TextColor3 = Color3.fromRGB(153, 135, 107)
    status.TextSize = 8
    status.Parent = card

    local unlock = Instance.new("TextButton")
    unlock.Name = "UnlockButton"
    unlock.Position = UDim2.new(0, 24, 1, -45)
    unlock.Size = UDim2.new(1, -48, 0, 36)
    unlock.BackgroundColor3 = Color3.fromRGB(164, 123, 67)
    unlock.BorderSizePixel = 0
    unlock.AutoButtonColor = false
    unlock.Text = "UNLOCK  →"
    unlock.TextColor3 = Color3.fromRGB(16, 14, 11)
    unlock.TextSize = 10
    unlock.Font = Enum.Font.Merriweather
    unlock.Parent = card
    Instance.new("UICorner", unlock).CornerRadius = UDim.new(0, 10)

    -- Refined access-card entrance: soft reveal, gold edge bloom and a breathing emblem glow.
    local keySweep = Instance.new("Frame")
    keySweep.Name = "EdgeSweep"
    keySweep.BackgroundColor3 = Color3.fromRGB(235, 199, 139)
    keySweep.BackgroundTransparency = 0.82
    keySweep.BorderSizePixel = 0
    keySweep.Position = UDim2.new(-0.35, 0, 0, 0)
    keySweep.Size = UDim2.new(0.22, 0, 1, 0)
    keySweep.ZIndex = card.ZIndex + 1
    keySweep.Parent = card
    local keySweepGradient = Instance.new("UIGradient")
    keySweepGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.25),
        NumberSequenceKeypoint.new(1, 1),
    })
    keySweepGradient.Parent = keySweep

    local keyScale = Instance.new("UIScale")
    keyScale.Scale = 0.94
    keyScale.Parent = card
    local keyOriginal = {}
    for _, object in ipairs(card:GetDescendants()) do
        if object:IsA("GuiObject") then
            keyOriginal[object] = {BackgroundTransparency = object.BackgroundTransparency}
            if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
                keyOriginal[object].TextTransparency = object.TextTransparency
                object.TextTransparency = 1
            end
            object.BackgroundTransparency = 1
        elseif object:IsA("UIStroke") then
            keyOriginal[object] = {Transparency = object.Transparency}
            object.Transparency = 1
        end
    end
    card.Position = UDim2.new(0.5, 0, 0.5, 16)
    local keyIn = TweenInfo.new(0.62, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenService:Create(backdrop, keyIn, {BackgroundTransparency = 0}):Play()
    TweenService:Create(card, keyIn, {BackgroundTransparency = 0}):Play()
    TweenService:Create(keyScale, keyIn, {Scale = 1}):Play()
    TweenService:Create(card, keyIn, {Position = UDim2.fromScale(0.5, 0.5)}):Play()
    for object, values in pairs(keyOriginal) do
        if object.Parent then
            local properties = {}
            for property, value in pairs(values) do properties[property] = value end
            TweenService:Create(object, TweenInfo.new(0.48, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), properties):Play()
        end
    end
    task.spawn(function()
        while keyGui.Parent and not accepted do
            keySweep.Position = UDim2.new(-0.35, 0, 0, 0)
            local sweepTween = TweenService:Create(keySweep, TweenInfo.new(1.05, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.new(1.15, 0, 0, 0)})
            sweepTween:Play()
            TweenService:Create(glow, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.78, Size = UDim2.new(0.84, 0, 0, 88)}):Play()
            task.wait(1.8)
            if not keyGui.Parent or accepted then break end
            TweenService:Create(glow, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.9, Size = UDim2.new(0.72, 0, 0, 70)}):Play()
            task.wait(1.8)
        end
    end)
    getKey.MouseEnter:Connect(function()
        TweenService:Create(getKey, TweenInfo.new(0.16), {BackgroundColor3 = Color3.fromRGB(45, 38, 28)}):Play()
        TweenService:Create(getKeyEdge, TweenInfo.new(0.16), {Transparency = 0.12}):Play()
    end)
    getKey.MouseLeave:Connect(function()
        TweenService:Create(getKey, TweenInfo.new(0.16), {BackgroundColor3 = Color3.fromRGB(29, 27, 23)}):Play()
        TweenService:Create(getKeyEdge, TweenInfo.new(0.16), {Transparency = 0.48}):Play()
    end)
    getKey.Activated:Connect(function()
        status.Text = "OPENING LINKVERTISE  /  COMPLETE THE STEPS"
        status.TextColor3 = Color3.fromRGB(220, 181, 116)

        local opened = pcall(function()
            GuiService:OpenBrowserWindow(LINKVERTISE_URL)
        end)

        if opened then
            status.Text = "LINKVERTISE OPENED  /  RETURN WITH KEY: FUNZONE"
            status.TextColor3 = Color3.fromRGB(137, 199, 147)
        else
            local copied = pcall(function()
                if type(setclipboard) ~= "function" then error("Clipboard unavailable") end
                setclipboard(LINKVERTISE_URL)
            end)
            if copied then
                status.Text = "LINK COPIED  /  OPEN IT IN YOUR BROWSER"
                status.TextColor3 = Color3.fromRGB(137, 199, 147)
            else
                status.Text = "OPEN LINK: LINK-HUB.NET/8033743/AXANZ3ALJFY4"
                status.TextColor3 = Color3.fromRGB(220, 181, 116)
            end
        end
    end)

    keyBox.Focused:Connect(function()
        TweenService:Create(inputEdge, TweenInfo.new(0.18), {Color = Color3.fromRGB(235, 199, 139), Transparency = 0.08, Thickness = 1.5}):Play()
    end)
    keyBox.FocusLost:Connect(function()
        TweenService:Create(inputEdge, TweenInfo.new(0.18), {Color = Color3.fromRGB(133, 105, 67), Transparency = 0.42, Thickness = 1}):Play()
    end)
    unlock.MouseEnter:Connect(function()
        TweenService:Create(unlock, TweenInfo.new(0.16), {BackgroundColor3 = Color3.fromRGB(211, 171, 105)}):Play()
    end)
    unlock.MouseLeave:Connect(function()
        if not accepted then TweenService:Create(unlock, TweenInfo.new(0.16), {BackgroundColor3 = Color3.fromRGB(164, 123, 67)}):Play() end
    end)

    local function checkKey()
        if accepted then return end
        if validateAccessKey(keyBox.Text) then
            accepted = true
            status.Text = "ACCESS GRANTED  •  WELCOME"
            status.TextColor3 = Color3.fromRGB(137, 199, 147)
            unlock.Text = "ACCESS GRANTED"
            unlock.BackgroundColor3 = Color3.fromRGB(105, 145, 99)
            task.wait(0.42)
            -- Fade the access layer away so the signature intro feels like one continuous sequence.
            local outInfo = TweenInfo.new(0.38, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            TweenService:Create(backdrop, outInfo, {BackgroundTransparency = 1}):Play()
            TweenService:Create(keyScale, outInfo, {Scale = 0.97}):Play()
            TweenService:Create(card, outInfo, {Position = UDim2.new(0.5, 0, 0.48, 0)}):Play()
            for object, values in pairs(keyOriginal) do
                if object.Parent then
                    local props = {}
                    for property in pairs(values) do
                        props[property] = property == "Transparency" and 1 or 1
                    end
                    TweenService:Create(object, outInfo, props):Play()
                end
            end
            task.wait(0.4)
            keyGui:Destroy()
        else
            status.Text = "INCORRECT KEY  •  TRY AGAIN"
            status.TextColor3 = Color3.fromRGB(220, 121, 105)
            keyBox.Text = ""
            cardEdge.Color = Color3.fromRGB(190, 92, 79)
            task.wait(0.25)
            cardEdge.Color = Color3.fromRGB(225, 187, 119)
        end
    end
    unlock.Activated:Connect(checkKey)
    keyBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then checkKey() end
    end)

    while not accepted do
        task.wait(0.1)
        if not keyGui.Parent then return end
    end
end

--// JT3R FUNZONE signature startup screen
-- Premium full-screen intro with a large custom monogram and animated progress.
do
    local splashGui = Instance.new("ScreenGui")
    splashGui.Name = "JT3R_FUNZONE_Startup"
    splashGui.IgnoreGuiInset = true
    splashGui.ResetOnSpawn = false
    splashGui.DisplayOrder = 9999
    splashGui.Parent = PlayerGui

    local shade = Instance.new("Frame")
    shade.Name = "Backdrop"
    shade.Size = UDim2.fromScale(1, 1)
    shade.BackgroundColor3 = Color3.fromRGB(5, 6, 8)
    shade.BackgroundTransparency = 1
    shade.BorderSizePixel = 0
    shade.Parent = splashGui

    local card = Instance.new("Frame")
    card.Name = "StartupCard"
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.fromScale(0.5, 0.5)
    card.Size = UDim2.new(0.88, 0, 0, 202)
    card.BackgroundColor3 = Color3.fromRGB(13, 14, 17)
    card.BackgroundTransparency = 1
    card.BorderSizePixel = 0
    card.Parent = shade
    card.ClipsDescendants = true
    local cardConstraint = Instance.new("UISizeConstraint")
    cardConstraint.MinSize = Vector2.new(290, 202)
    cardConstraint.MaxSize = Vector2.new(480, 202)
    cardConstraint.Parent = card
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 26)
    local splashScale = Instance.new("UIScale")
    splashScale.Scale = 0.92
    splashScale.Parent = card
    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Color3.fromRGB(230, 190, 122)
    cardStroke.Transparency = 1
    cardStroke.Thickness = 1.5
    cardStroke.Parent = card
    local cardGradient = Instance.new("UIGradient")
    cardGradient.Rotation = 125
    cardGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(49, 39, 25)),
        ColorSequenceKeypoint.new(0.42, Color3.fromRGB(19, 19, 21)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 10, 13)),
    })
    cardGradient.Parent = card

    local topLine = Instance.new("Frame")
    topLine.BackgroundColor3 = Color3.fromRGB(235, 199, 139)
    topLine.BorderSizePixel = 0
    topLine.Size = UDim2.new(1, 0, 0, 3)
    topLine.Parent = card
    local topLineGradient = Instance.new("UIGradient")
    topLineGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(111, 79, 42)),
        ColorSequenceKeypoint.new(0.48, Color3.fromRGB(255, 230, 187)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(111, 79, 42)),
    })
    topLineGradient.Parent = topLine

    local emblem = Instance.new("Frame")
    emblem.Name = "SignatureEmblem"
    emblem.Position = UDim2.new(0, 20, 0, 22)
    emblem.Size = UDim2.fromOffset(66, 66)
    emblem.BackgroundColor3 = Color3.fromRGB(29, 25, 20)
    emblem.BorderSizePixel = 0
    emblem.Parent = card
    Instance.new("UICorner", emblem).CornerRadius = UDim.new(0, 22)
    local emblemStroke = Instance.new("UIStroke")
    emblemStroke.Color = Color3.fromRGB(236, 199, 137)
    emblemStroke.Thickness = 1.5
    emblemStroke.Transparency = 0.05
    emblemStroke.Parent = emblem
    local emblemGradient = Instance.new("UIGradient")
    emblemGradient.Rotation = 135
    emblemGradient.Color = ColorSequence.new(Color3.fromRGB(94, 70, 39), Color3.fromRGB(18, 18, 18))
    emblemGradient.Parent = emblem
    local diamond = Instance.new("Frame")
    diamond.AnchorPoint = Vector2.new(0.5, 0.5)
    diamond.Position = UDim2.fromScale(0.5, 0.5)
    diamond.Size = UDim2.fromOffset(44, 44)
    diamond.Rotation = 45
    diamond.BackgroundTransparency = 1
    diamond.Parent = emblem
    Instance.new("UICorner", diamond).CornerRadius = UDim.new(0, 10)
    local diamondStroke = Instance.new("UIStroke")
    diamondStroke.Color = Color3.fromRGB(222, 184, 119)
    diamondStroke.Transparency = 0.35
    diamondStroke.Thickness = 1
    diamondStroke.Parent = diamond

    local logo = Instance.new("TextLabel")
    logo.BackgroundTransparency = 1
    logo.AnchorPoint = Vector2.new(0.5, 0.5)
    logo.Position = UDim2.fromScale(0.5, 0.49)
    logo.Size = UDim2.new(1, -8, 0, 40)
    logo.Font = Enum.Font.Merriweather
    logo.Text = "JT3R"
    logo.TextColor3 = Color3.fromRGB(255, 224, 173)
    logo.TextSize = 23
    logo.Parent = emblem

    local wordmark = Instance.new("TextLabel")
    wordmark.BackgroundTransparency = 1
    wordmark.Position = UDim2.new(0, 102, 0, 27)
    wordmark.Size = UDim2.new(1, -122, 0, 36)
    wordmark.Font = Enum.Font.Merriweather
    wordmark.Text = "JT3R FUNHOUSE"
    wordmark.TextColor3 = Color3.fromRGB(248, 241, 228)
    wordmark.TextSize = 20
    wordmark.TextXAlignment = Enum.TextXAlignment.Left
    wordmark.Parent = card

    local edition = Instance.new("TextLabel")
    edition.BackgroundTransparency = 1
    edition.Position = UDim2.new(0, 104, 0, 63)
    edition.Size = UDim2.new(1, -124, 0, 18)
    edition.Font = Enum.Font.RobotoMono
    edition.Text = "O B S I D I A N   /   P R I V A T E   E D I T I O N"
    edition.TextColor3 = Color3.fromRGB(218, 181, 117)
    edition.TextSize = 9
    edition.TextXAlignment = Enum.TextXAlignment.Left
    edition.Parent = card

    local status = Instance.new("TextLabel")
    status.BackgroundTransparency = 1
    status.Position = UDim2.new(0, 22, 0, 112)
    status.Size = UDim2.new(1, -50, 0, 16)
    status.Font = Enum.Font.SourceSansSemibold
    status.Text = "PREPARING YOUR SESSION"
    status.TextColor3 = Color3.fromRGB(224, 215, 198)
    status.TextSize = 10
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Parent = card

    local statusRight = Instance.new("TextLabel")
    statusRight.BackgroundTransparency = 1
    statusRight.AnchorPoint = Vector2.new(1, 0)
    statusRight.Position = UDim2.new(1, -22, 0, 112)
    statusRight.Size = UDim2.fromOffset(42, 18)
    statusRight.Font = Enum.Font.RobotoMono
    statusRight.Text = "0%"
    statusRight.TextColor3 = Color3.fromRGB(235, 199, 139)
    statusRight.TextSize = 10
    statusRight.TextXAlignment = Enum.TextXAlignment.Right
    statusRight.Parent = card

    local track = Instance.new("Frame")
    track.Position = UDim2.new(0, 22, 0, 139)
    track.Size = UDim2.new(1, -44, 0, 6)
    track.BackgroundColor3 = Color3.fromRGB(47, 43, 36)
    track.BorderSizePixel = 0
    track.Parent = card
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(235, 199, 139)
    fill.BorderSizePixel = 0
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local fillGradient = Instance.new("UIGradient")
    fillGradient.Color = ColorSequence.new(Color3.fromRGB(255, 229, 183), Color3.fromRGB(177, 126, 65))
    fillGradient.Parent = fill

    local footer = Instance.new("TextLabel")
    footer.BackgroundTransparency = 1
    footer.Position = UDim2.new(0, 22, 0, 162)
    footer.Size = UDim2.new(1, -44, 0, 16)
    footer.Font = Enum.Font.SourceSans
    footer.Text = "DESIGNED TO STAND APART     •     v8.0"
    footer.TextColor3 = Color3.fromRGB(135, 130, 121)
    footer.TextSize = 8
    footer.TextXAlignment = Enum.TextXAlignment.Left
    footer.Parent = card

    -- Cinematic intro reveal: the card settles into place while the monogram and gold trim wake up.
    local splashIn = TweenInfo.new(0.72, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenService:Create(shade, splashIn, {BackgroundTransparency = 0.24}):Play()
    TweenService:Create(card, splashIn, {BackgroundTransparency = 0.02}):Play()
    TweenService:Create(splashScale, splashIn, {Scale = 1}):Play()
    TweenService:Create(cardStroke, TweenInfo.new(0.65, Enum.EasingStyle.Quart), {Transparency = 0.12}):Play()
    TweenService:Create(diamond, TweenInfo.new(0.95, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = 0}):Play()
    task.spawn(function()
        while splashGui.Parent do
            topLineGradient.Offset = Vector2.new(-1, 0)
            local sweep = TweenService:Create(topLineGradient, TweenInfo.new(1.15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Offset = Vector2.new(1, 0)})
            sweep:Play()
            sweep.Completed:Wait()
            task.wait(0.55)
        end
    end)
    for _, object in ipairs(card:GetDescendants()) do
        if object:IsA("TextLabel") then
            local targetTransparency = object.TextTransparency
            object.TextTransparency = 1
            TweenService:Create(object, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = targetTransparency}):Play()
        end
    end
    task.spawn(function()
        while splashGui.Parent do
            TweenService:Create(emblemStroke, TweenInfo.new(1.45, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.32, Thickness = 2}):Play()
            TweenService:Create(diamond, TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Rotation = 90}):Play()
            task.wait(1.45)
            if not splashGui.Parent then break end
            TweenService:Create(emblemStroke, TweenInfo.new(1.45, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.05, Thickness = 1.5}):Play()
            TweenService:Create(diamond, TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Rotation = 180}):Play()
            task.wait(1.45)
        end
    end)
    local started, duration = os.clock(), 2.65
    local phases = {"LOADING CORE", "SETTING THE SCENE", "PREPARING VISUALS", "READY"}
    while os.clock() - started < duration do
        local alpha = math.clamp((os.clock() - started) / duration, 0, 1)
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        status.Text = phases[math.clamp(math.floor(alpha * #phases) + 1, 1, #phases)]
        statusRight.Text = tostring(math.floor(alpha * 100)) .. "%"
        task.wait(0.035)
    end
    fill.Size = UDim2.new(1, 0, 1, 0)
    statusRight.Text = "100%"
    task.wait(0.22)
    TweenService:Create(card, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    TweenService:Create(shade, TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    TweenService:Create(splashScale, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Scale = 1.025}):Play()
    task.wait(0.34)
    splashGui:Destroy()
end

--// Theme
local Themes = {
    Obsidian = {
        Background = Color3.fromRGB(8, 9, 11),
        Surface = Color3.fromRGB(14, 15, 17),
        Surface2 = Color3.fromRGB(21, 22, 24),
        Surface3 = Color3.fromRGB(29, 30, 32),
        Border = Color3.fromRGB(43, 41, 36),
        Accent = Color3.fromRGB(184, 149, 94),
        AccentBright = Color3.fromRGB(232, 207, 163),
        AccentSoft = Color3.fromRGB(54, 45, 33),
        Text = Color3.fromRGB(244, 240, 231),
        Muted = Color3.fromRGB(153, 150, 143),
        Quiet = Color3.fromRGB(98, 97, 93),
        Success = Color3.fromRGB(125, 173, 135),
        Danger = Color3.fromRGB(190, 112, 105),
    },
    Platinum = {
        Background = Color3.fromRGB(13, 15, 18), Surface = Color3.fromRGB(20, 22, 26),
        Surface2 = Color3.fromRGB(27, 30, 35), Surface3 = Color3.fromRGB(36, 39, 44),
        Border = Color3.fromRGB(53, 58, 65), Accent = Color3.fromRGB(177, 190, 202),
        AccentBright = Color3.fromRGB(225, 232, 238), AccentSoft = Color3.fromRGB(53, 61, 69),
        Text = Color3.fromRGB(239, 242, 245), Muted = Color3.fromRGB(158, 166, 174),
        Quiet = Color3.fromRGB(105, 113, 122), Success = Color3.fromRGB(125, 173, 135),
        Danger = Color3.fromRGB(190, 112, 105),
    },
    Crimson = {
        Background = Color3.fromRGB(15, 12, 13), Surface = Color3.fromRGB(23, 18, 20),
        Surface2 = Color3.fromRGB(31, 23, 26), Surface3 = Color3.fromRGB(40, 29, 32),
        Border = Color3.fromRGB(58, 42, 43), Accent = Color3.fromRGB(174, 91, 91),
        AccentBright = Color3.fromRGB(221, 139, 132), AccentSoft = Color3.fromRGB(68, 39, 42),
        Text = Color3.fromRGB(244, 235, 232), Muted = Color3.fromRGB(165, 150, 148),
        Quiet = Color3.fromRGB(111, 99, 99), Success = Color3.fromRGB(125, 173, 135),
        Danger = Color3.fromRGB(190, 112, 105),
    },
    Midnight = {
        Background = Color3.fromRGB(10, 13, 19), Surface = Color3.fromRGB(17, 22, 31),
        Surface2 = Color3.fromRGB(23, 30, 42), Surface3 = Color3.fromRGB(31, 40, 54),
        Border = Color3.fromRGB(43, 54, 70), Accent = Color3.fromRGB(115, 145, 185),
        AccentBright = Color3.fromRGB(166, 192, 224), AccentSoft = Color3.fromRGB(38, 54, 77),
        Text = Color3.fromRGB(235, 241, 249), Muted = Color3.fromRGB(147, 160, 177),
        Quiet = Color3.fromRGB(98, 112, 132), Success = Color3.fromRGB(125, 173, 135),
        Danger = Color3.fromRGB(190, 112, 105),
    },
}

local currentThemeName = "Obsidian"
local glassEnabled = true
local ambientEnabled = true
local animationsEnabled = true
local T = Themes[currentThemeName]
local currentPage = "Home"
local userScale = 1
local isOpen = true
local isMinimized = false
local notificationCount = 0
local sessionStartedAt = os.clock()
local uninject
local pageButtons = {}
local pageFrames = {}
local connections = {}

local preferenceFolder = "JT3R/FUNHOUSE"
local preferencePath = preferenceFolder .. "/preferences.txt"
local function ensurePreferenceFolder()
    if type(writefile) ~= "function" or type(readfile) ~= "function" then return false end
    local ok = pcall(function()
        if type(isfolder) == "function" and not isfolder("JT3R") then makefolder("JT3R") end
        if type(isfolder) == "function" and not isfolder(preferenceFolder) then makefolder(preferenceFolder) end
    end)
    return ok
end
local function readPreferences()
    if not ensurePreferenceFolder() or type(isfile) ~= "function" or not isfile(preferencePath) then return {} end
    local ok, data = pcall(readfile, preferencePath)
    if not ok then return {} end
    local page = tostring(data):match("PAGE=([%w_]+)") or "Home"
    local welcomed = tostring(data):find("WELCOME=1", 1, true) ~= nil
    return {page = page, welcomed = welcomed}
end
local sessionPreferences = readPreferences()
local function savePreferences(page, welcomed)
    if not ensurePreferenceFolder() then return false end
    local body = "PAGE=" .. tostring(page or "Home") .. "\nWELCOME=" .. (welcomed and "1" or "0")
    return pcall(writefile, preferencePath, body)
end
local toastContainer

--// Helpers
local function addConnection(connection)
    table.insert(connections, connection)
    return connection
end

local function tween(object, duration, properties, style)
    if not animationsEnabled then
        for property, value in pairs(properties) do
            pcall(function() object[property] = value end)
        end
        return nil
    end
    local info = TweenInfo.new(duration, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local tw = TweenService:Create(object, info, properties)
    tw:Play()
    return tw
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 12)
    c.Parent = parent
    return c
end

local function stroke(parent, color, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or T.Border
    s.Transparency = transparency or 0
    s.Thickness = thickness or 1
    s.Parent = parent
    return s
end

local function padding(parent, left, right, top, bottom)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, left or 0)
    p.PaddingRight = UDim.new(0, right or 0)
    p.PaddingTop = UDim.new(0, top or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)
    p.Parent = parent
    return p
end

local function label(parent, text, size, color, font, xalign)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text or ""
    l.TextSize = size or 14
    l.TextColor3 = color or T.Text
    l.Font = font or Enum.Font.SourceSans
    l.TextXAlignment = xalign or Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.TextWrapped = false
    l.Parent = parent
    return l
end

local function button(parent, text, size, bg, fg)
    local b = Instance.new("TextButton")
    b.AutoButtonColor = false
    b.Text = text or ""
    b.TextSize = 13
    b.Font = Enum.Font.SourceSansSemibold
    b.TextColor3 = fg or T.Text
    b.BackgroundColor3 = bg or T.Surface2
    b.Size = size or UDim2.new(0, 100, 0, 36)
    b.Parent = parent
    corner(b, 9)
    stroke(b, T.Border, 0.45, 1)
    return b
end

local function listLayout(parent, direction, gap, horizontalAlignment)
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = direction or Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, gap or 8)
    layout.HorizontalAlignment = horizontalAlignment or Enum.HorizontalAlignment.Left
    layout.Parent = parent
    return layout
end

--// Root GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = GUI_NAME
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() screenGui.Parent = (gethui and gethui()) or CoreGui end)
if not screenGui.Parent then screenGui.Parent = PlayerGui end

local dim = Instance.new("Frame")
dim.Name = "Backdrop"
dim.BackgroundColor3 = Color3.new(0, 0, 0)
dim.BackgroundTransparency = 1
dim.Size = UDim2.fromScale(1, 1)
dim.Visible = false
dim.Parent = screenGui

local ambientHalo = Instance.new("Frame")
ambientHalo.Name = "AmbientLighting"
ambientHalo.AnchorPoint = Vector2.new(0.5, 0.5)
ambientHalo.Position = UDim2.fromScale(0.5, 0.5)
ambientHalo.Size = UDim2.new(0, 874, 0, 594)
ambientHalo.BackgroundColor3 = T.Accent
ambientHalo.BackgroundTransparency = 1
ambientHalo.BorderSizePixel = 0
ambientHalo.ZIndex = 0
ambientHalo.Parent = screenGui
corner(ambientHalo, 24)
local ambientStroke = Instance.new("UIStroke")
ambientStroke.Color = T.AccentBright
ambientStroke.Thickness = 8
ambientStroke.Transparency = 0.91
ambientStroke.Parent = ambientHalo
local ambientInnerStroke = Instance.new("UIStroke")
ambientInnerStroke.Color = T.Accent
ambientInnerStroke.Thickness = 2
ambientInnerStroke.Transparency = 0.78
ambientInnerStroke.Parent = ambientHalo
local haloGradient = Instance.new("UIGradient")
haloGradient.Rotation = 35
haloGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.88),
    NumberSequenceKeypoint.new(0.5, 1),
    NumberSequenceKeypoint.new(1, 0.88),
})
haloGradient.Parent = ambientHalo

local shell = Instance.new("Frame")
shell.Name = "MainWindow"
shell.AnchorPoint = Vector2.new(0.5, 0.5)
shell.Position = UDim2.fromScale(0.5, 0.5)
shell.Size = UDim2.new(0, 900, 0, 600)
shell.BackgroundColor3 = T.Background
shell.BackgroundTransparency = 0.035
shell.BorderSizePixel = 0
shell.ZIndex = 1
shell.ClipsDescendants = true
shell.Parent = screenGui
corner(shell, 21)
stroke(shell, T.AccentBright, 0.68, 1.2)
local shellOuterGlow = Instance.new("UIStroke")
shellOuterGlow.Color = T.Accent
shellOuterGlow.Transparency = 0.88
shellOuterGlow.Thickness = 7
shellOuterGlow.Parent = shell
local shellSheen = Instance.new("UIGradient")
shellSheen.Rotation = 115
shellSheen.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(43, 40, 34)),
    ColorSequenceKeypoint.new(0.28, T.Background),
    ColorSequenceKeypoint.new(0.72, T.Background),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(32, 29, 25)),
})
shellSheen.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.28),
    NumberSequenceKeypoint.new(0.5, 0.02),
    NumberSequenceKeypoint.new(1, 0.30),
})
shellSheen.Parent = shell

local shellScale = Instance.new("UIScale")
shellScale.Parent = shell

local topAccent = Instance.new("Frame")
topAccent.Name = "TopAccent"
topAccent.BackgroundColor3 = T.Accent
topAccent.BorderSizePixel = 0
topAccent.Size = UDim2.new(1, 0, 0, 2)
topAccent.Parent = shell
local topAccentGradient = Instance.new("UIGradient")
topAccentGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(92, 66, 35)),
    ColorSequenceKeypoint.new(0.22, Color3.fromRGB(255, 226, 178)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(173, 127, 70)),
    ColorSequenceKeypoint.new(0.78, Color3.fromRGB(255, 231, 190)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(92, 66, 35))
})
topAccentGradient.Parent = topAccent
local shellInner = Instance.new("Frame")
shellInner.Name = "InnerBevel"
shellInner.BackgroundTransparency = 1
shellInner.BorderSizePixel = 0
shellInner.Position = UDim2.new(0, 5, 0, 5)
shellInner.Size = UDim2.new(1, -10, 1, -10)
shellInner.ZIndex = 2
shellInner.Active = false
shellInner.Parent = shell
corner(shellInner, 20)
local innerBevelStroke = stroke(shellInner, Color3.fromRGB(255, 232, 194), 0.94, 1)
innerBevelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

--// Header
local header = Instance.new("Frame")
header.Name = "Header"
header.BackgroundColor3 = T.Surface
header.BorderSizePixel = 0
header.Size = UDim2.new(1, 0, 0, 76)
header.BackgroundTransparency = 0.16
header.Parent = shell
local headerSheen = Instance.new("UIGradient")
headerSheen.Rotation = 0
headerSheen.Color = ColorSequence.new(Color3.fromRGB(39, 36, 31), T.Surface)
headerSheen.Transparency = NumberSequence.new(0.22, 0.04)
headerSheen.Parent = header

local brandMark = Instance.new("Frame")
brandMark.Name = "JT3RLogo"
brandMark.Position = UDim2.new(0, 18, 0, 13)
brandMark.Size = UDim2.fromOffset(54, 52)
brandMark.BackgroundColor3 = Color3.fromRGB(24, 22, 19)
brandMark.BorderSizePixel = 0
brandMark.Parent = header
corner(brandMark, 14)
stroke(brandMark, T.AccentBright, 0.02, 1.6)
local logoOuterGlow = Instance.new("UIStroke")
logoOuterGlow.Color = T.Accent
logoOuterGlow.Transparency = 0.34
logoOuterGlow.Thickness = 8
logoOuterGlow.Parent = brandMark
local logoInnerGlow = Instance.new("UIStroke")
logoInnerGlow.Color = T.AccentBright
logoInnerGlow.Transparency = 0.12
logoInnerGlow.Thickness = 2
logoInnerGlow.Parent = brandMark
brandMark.ClipsDescendants = false
local markGradient = Instance.new("UIGradient")
markGradient.Rotation = 135
markGradient.Color = ColorSequence.new(Color3.fromRGB(72, 59, 39), Color3.fromRGB(20, 19, 17))
markGradient.Parent = brandMark
local markInner = Instance.new("Frame")
markInner.BackgroundTransparency = 1
markInner.Position = UDim2.fromOffset(4, 4)
markInner.Size = UDim2.new(1, -8, 1, -8)
markInner.Parent = brandMark
corner(markInner, 10)
stroke(markInner, T.Accent, 0.55, 1)
local brandDiamond = Instance.new("Frame")
brandDiamond.Name = "MonogramDiamond"
brandDiamond.AnchorPoint = Vector2.new(0.5, 0.5)
brandDiamond.Position = UDim2.new(0.5, 0, 0.45, 0)
brandDiamond.Size = UDim2.fromOffset(25, 25)
brandDiamond.BackgroundTransparency = 1
brandDiamond.Rotation = 45
brandDiamond.Parent = markInner
stroke(brandDiamond, T.AccentBright, 0.58, 1)
local logoRing = Instance.new("Frame")
logoRing.Name = "LogoSeal"
logoRing.BackgroundTransparency = 1
logoRing.AnchorPoint = Vector2.new(0.5, 0.5)
logoRing.Position = UDim2.fromScale(0.5, 0.5)
logoRing.Size = UDim2.fromOffset(35, 35)
logoRing.Parent = markInner
corner(logoRing, 12)
stroke(logoRing, T.AccentBright, 0.52, 1)
local brandGlyph = label(markInner, "JT3R", 13, T.AccentBright, Enum.Font.Merriweather, Enum.TextXAlignment.Center)
brandGlyph.Position = UDim2.new(0, 0, 0, 2)
brandGlyph.TextStrokeColor3 = T.AccentBright
brandGlyph.TextStrokeTransparency = 0.16
brandGlyph.Size = UDim2.new(1, 0, 0, 28)
local markWord = label(markInner, "SIGNATURE", 4, T.Text, Enum.Font.Merriweather, Enum.TextXAlignment.Center)
markWord.Position = UDim2.new(0, 0, 1, -12)
markWord.Size = UDim2.new(1, 0, 0, 8)
local markBar = Instance.new("Frame")
markBar.BackgroundColor3 = T.AccentBright
markBar.BorderSizePixel = 0
markBar.AnchorPoint = Vector2.new(0.5, 0)
markBar.Position = UDim2.new(0.5, 0, 0, 31)
markBar.Size = UDim2.fromOffset(18, 1)
markBar.Parent = markInner
local logoSlash1 = Instance.new("Frame")
logoSlash1.Name = "LogoDistressA"
logoSlash1.BackgroundColor3 = T.AccentBright
logoSlash1.BackgroundTransparency = 0.28
logoSlash1.BorderSizePixel = 0
logoSlash1.Rotation = 32
logoSlash1.Position = UDim2.new(1, -8, 0, 8)
logoSlash1.Size = UDim2.fromOffset(2, 12)
logoSlash1.Parent = brandMark
local logoSlash2 = Instance.new("Frame")
logoSlash2.Name = "LogoDistressB"
logoSlash2.BackgroundColor3 = T.Accent
logoSlash2.BackgroundTransparency = 0.38
logoSlash2.BorderSizePixel = 0
logoSlash2.Rotation = 32
logoSlash2.Position = UDim2.new(1, -13, 0, 11)
logoSlash2.Size = UDim2.fromOffset(1, 8)
logoSlash2.Parent = brandMark

local brandName = label(header, "JT3R", 20, T.Text, Enum.Font.Merriweather)
brandName.Position = UDim2.new(0, 84, 0, 12)
brandName.Size = UDim2.new(0, 190, 0, 28)
brandName.TextStrokeColor3 = T.Accent
brandName.TextStrokeTransparency = 0.78

local brandSub = label(header, "OBSIDIAN ATELIER   /   PRIVATE SUITE", 8, T.Accent, Enum.Font.RobotoMono)
brandSub.Position = UDim2.new(0, 85, 0, 42)
brandSub.Size = UDim2.new(0, 240, 0, 16)
local brandRule = Instance.new("Frame")
brandRule.Name = "BrandSignatureRule"
brandRule.BackgroundColor3 = T.Accent
brandRule.BackgroundTransparency = 0.25
brandRule.BorderSizePixel = 0
brandRule.Position = UDim2.new(0, 85, 0, 60)
brandRule.Size = UDim2.new(0, 46, 0, 1)
brandRule.Parent = header
local brandRuleGradient = Instance.new("UIGradient")
brandRuleGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.1),
    NumberSequenceKeypoint.new(1, 1)
})
brandRuleGradient.Parent = brandRule

-- Invisible hit target makes the complete brand lockup a reliable minimise control.
local logoMinimizeHitbox = Instance.new("TextButton")
logoMinimizeHitbox.Name = "LogoMinimizeButton"
logoMinimizeHitbox.BackgroundTransparency = 1
logoMinimizeHitbox.BorderSizePixel = 0
logoMinimizeHitbox.Text = ""
logoMinimizeHitbox.AutoButtonColor = false
logoMinimizeHitbox.Position = UDim2.new(0, 8, 0, 7)
logoMinimizeHitbox.Size = UDim2.fromOffset(180, 48)
logoMinimizeHitbox.ZIndex = 50
logoMinimizeHitbox.Active = true
logoMinimizeHitbox.Selectable = true
logoMinimizeHitbox.Parent = header

-- Membership indicator (display-only until a real key/licensing service is connected).
local headerPlan = Instance.new("TextLabel")
headerPlan.Name = "PlanBadge"
headerPlan.BackgroundColor3 = T.AccentSoft
headerPlan.BackgroundTransparency = 0.12
headerPlan.BorderSizePixel = 0
headerPlan.Text = "ATELIER"
headerPlan.TextColor3 = T.AccentBright
headerPlan.TextSize = 8
headerPlan.Font = Enum.Font.RobotoMono
headerPlan.Size = UDim2.fromOffset(82, 24)
headerPlan.AnchorPoint = Vector2.new(1, 0)
headerPlan.Position = UDim2.new(1, -250, 0, 27)
headerPlan.Parent = header
corner(headerPlan, 8)
stroke(headerPlan, T.Accent, 0.42, 1)

local headerClock = label(header, "00:00:00", 12, T.AccentBright, Enum.Font.RobotoMono, Enum.TextXAlignment.Right)
headerClock.AnchorPoint = Vector2.new(1, 0)
headerClock.Position = UDim2.new(1, -194, 0, 13)
headerClock.Size = UDim2.new(0, 120, 0, 18)
local headerDate = label(header, "LOCAL DEVICE TIME", 8, T.Quiet, Enum.Font.SourceSansSemibold, Enum.TextXAlignment.Right)
headerDate.AnchorPoint = Vector2.new(1, 0)
headerDate.Position = UDim2.new(1, -194, 0, 34)
headerDate.Size = UDim2.new(0, 120, 0, 14)

local headerLine = Instance.new("Frame")
headerLine.BackgroundColor3 = T.Border
headerLine.BackgroundTransparency = 0.25
headerLine.BorderSizePixel = 0
headerLine.Position = UDim2.new(0, 0, 1, -1)
headerLine.Size = UDim2.new(1, 0, 0, 1)
headerLine.Parent = header

local headerRight = Instance.new("Frame")
headerRight.BackgroundTransparency = 1
headerRight.AnchorPoint = Vector2.new(1, 0)
headerRight.Position = UDim2.new(1, -14, 0, 36)
headerRight.Size = UDim2.new(0, 132, 0, 30)
headerRight.Parent = header

local statusDot = Instance.new("Frame")
statusDot.BackgroundColor3 = T.Success
statusDot.Position = UDim2.new(0, 2, 0, 12)
statusDot.Size = UDim2.fromOffset(6, 6)
statusDot.Parent = headerRight
corner(statusDot, 8)

local statusText = label(headerRight, "LIVE", 8, T.Muted, Enum.Font.RobotoMono)
statusText.Position = UDim2.new(0, 13, 0, 7)
statusText.Size = UDim2.new(0, 38, 0, 16)

local minimizeButton = button(headerRight, "–", UDim2.fromOffset(26, 26), Color3.fromRGB(31, 28, 23), T.AccentBright)
minimizeButton.Name = "MinimiseControl"
minimizeButton.Font = Enum.Font.RobotoMono
minimizeButton.TextSize = 16
stroke(minimizeButton, T.AccentBright, 0.48, 1)
minimizeButton.Position = UDim2.new(1, -60, 0, 2)
corner(minimizeButton, 8)

local closeButton = button(headerRight, "×", UDim2.fromOffset(26, 26), Color3.fromRGB(35, 25, 23), Color3.fromRGB(226, 157, 139))
closeButton.Name = "CloseControl"
closeButton.Font = Enum.Font.RobotoMono
closeButton.TextSize = 17
stroke(closeButton, Color3.fromRGB(176, 103, 86), 0.58, 1)
closeButton.Position = UDim2.new(1, -28, 0, 2)
corner(closeButton, 8)

-- Restrained micro-interactions: compact controls brighten and lift on hover/press.
for _, control in ipairs({minimizeButton, closeButton}) do
    local controlScale = Instance.new("UIScale")
    controlScale.Scale = 1
    controlScale.Parent = control
    control.MouseEnter:Connect(function()
        tween(controlScale, 0.14, {Scale = 1.07}, Enum.EasingStyle.Quad)
        tween(control, 0.14, {BackgroundTransparency = 0.04}, Enum.EasingStyle.Quad)
    end)
    control.MouseLeave:Connect(function()
        tween(controlScale, 0.16, {Scale = 1}, Enum.EasingStyle.Quad)
        tween(control, 0.16, {BackgroundTransparency = 0}, Enum.EasingStyle.Quad)
    end)
    control.Activated:Connect(function()
        tween(controlScale, 0.08, {Scale = 0.92}, Enum.EasingStyle.Quad)
        task.delay(0.09, function()
            if controlScale.Parent then tween(controlScale, 0.16, {Scale = 1}, Enum.EasingStyle.Back) end
        end)
    end)
end

--// Main body and navigation
local body = Instance.new("Frame")
body.BackgroundTransparency = 1
body.Position = UDim2.new(0, 0, 0, 77)
body.Size = UDim2.new(1, 0, 1, -109)
body.Parent = shell

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.BackgroundColor3 = T.Surface
sidebar.BorderSizePixel = 0
sidebar.Size = UDim2.new(0, 180, 1, 0)
sidebar.Parent = body

local sideInset = Instance.new("Frame")
sideInset.BackgroundColor3 = T.Border
sideInset.BackgroundTransparency = 0.35
sideInset.BorderSizePixel = 0
sideInset.Position = UDim2.new(1, -1, 0, 16)
sideInset.Size = UDim2.new(0, 1, 1, -32)
sideInset.Parent = sidebar

local navCaption = label(sidebar, "JT3R  /  COLLECTION", 8, T.Quiet, Enum.Font.RobotoMono)
navCaption.Position = UDim2.new(0, 17, 0, 20)
navCaption.Size = UDim2.new(1, -30, 0, 18)
local navCaptionRule = Instance.new("Frame")
navCaptionRule.Name = "CollectionHairline"
navCaptionRule.BackgroundColor3 = T.Accent
navCaptionRule.BackgroundTransparency = 0.76
navCaptionRule.BorderSizePixel = 0
navCaptionRule.Position = UDim2.new(0, 17, 0, 43)
navCaptionRule.Size = UDim2.new(1, -34, 0, 1)
navCaptionRule.Parent = sidebar

local navHolder = Instance.new("ScrollingFrame")
navHolder.Name = "NavigationScroll"
navHolder.BackgroundTransparency = 1
navHolder.BorderSizePixel = 0
navHolder.Position = UDim2.new(0, 9, 0, 54)
navHolder.Size = UDim2.new(1, -18, 1, -66)
navHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
navHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
navHolder.ScrollingDirection = Enum.ScrollingDirection.Y
navHolder.ScrollBarThickness = 2
navHolder.ScrollBarImageColor3 = T.Accent
navHolder.ScrollBarImageTransparency = 0.12
navHolder.Active = true
navHolder.ScrollingEnabled = true
navHolder.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
navHolder.Parent = sidebar
listLayout(navHolder, Enum.FillDirection.Vertical, 5)

local navItems = {
    {"Home", "H"}, {"Aim", "A"}, {"ESP", "E"}, {"Visuals", "V"},
    {"Fly", "F"}, {"Misc", "M"}, {"Settings", "S"}, {"Console", "C"}
}

local content = Instance.new("Frame")
content.Name = "Content"
content.BackgroundTransparency = 1
content.Position = UDim2.new(0, 180, 0, 0)
content.Size = UDim2.new(1, -180, 1, 0)
content.ClipsDescendants = true
content.Parent = body

local pageTop = Instance.new("Frame")
pageTop.BackgroundTransparency = 1
pageTop.Position = UDim2.new(0, 24, 0, 18)
pageTop.Size = UDim2.new(1, -48, 0, 52)
pageTop.Parent = content

local pageEyebrow = label(pageTop, "OVERVIEW", 9, T.Accent, Enum.Font.RobotoMono)
pageEyebrow.Position = UDim2.new(0, 0, 0, 0)
pageEyebrow.Size = UDim2.new(1, 0, 0, 14)
local pageTitleRule = Instance.new("Frame")
pageTitleRule.Name = "PageTitleSignature"
pageTitleRule.BackgroundColor3 = T.AccentBright
pageTitleRule.BackgroundTransparency = 0.28
pageTitleRule.BorderSizePixel = 0
pageTitleRule.Position = UDim2.new(0, 0, 1, -1)
pageTitleRule.Size = UDim2.new(0, 34, 0, 1)
pageTitleRule.Parent = pageTop
local pageTitleRuleGlow = Instance.new("UIStroke")
pageTitleRuleGlow.Color = T.Accent
pageTitleRuleGlow.Transparency = 0.55
pageTitleRuleGlow.Thickness = 2
pageTitleRuleGlow.Parent = pageTitleRule

local pageTitle = label(pageTop, "Home", 23, T.Text, Enum.Font.SourceSansSemibold)
pageTitle.Position = UDim2.new(0, 0, 0, 15)
pageTitle.Size = UDim2.new(1, 0, 0, 34)
pageTitle.Font = Enum.Font.Merriweather
pageTitle.TextSize = 25
pageEyebrow.Size = UDim2.new(1, -58, 0, 14)
pageTitle.Size = UDim2.new(1, -58, 0, 34)

local rgbModeEnabled = false
local rgbOriginals = {}
local rgbModeButton = button(pageTop, "RGB", UDim2.fromOffset(48, 27), T.Surface2, T.Muted)
rgbModeButton.Name = "GlobalRGBMode"
rgbModeButton.AnchorPoint = Vector2.new(1, 0)
rgbModeButton.Position = UDim2.new(1, 0, 0, 8)
rgbModeButton.TextSize = 9
rgbModeButton.Font = Enum.Font.RobotoMono
stroke(rgbModeButton, T.Accent, 0.38, 1)
local function collectRGBTargets()
    local targets = {}
    local trimNames = {
        TopAccent = true, JT3RLogo = true, GoldHairline = true,
        TopMetallicRule = true, MetallicGlint = true, GoldSparkle = true,
        ActiveGoldMarker = true, LogoDistressA = true, LogoDistressB = true
    }
    for _, object in ipairs(screenGui:GetDescendants()) do
        if object:IsA("UIStroke") and (object.Color == T.Accent or object.Color == T.AccentBright) then
            table.insert(targets, {object = object, property = "Color", original = object.Color})
        elseif object:IsA("GuiObject") and trimNames[object.Name] then
            table.insert(targets, {object = object, property = "BackgroundColor3", original = object.BackgroundColor3})
        elseif object:IsA("TextLabel") and (object.TextColor3 == T.Accent or object.TextColor3 == T.AccentBright) then
            table.insert(targets, {object = object, property = "TextColor3", original = object.TextColor3})
        end
    end
    return targets
end
local function setRGBMode(enabled)
    rgbModeEnabled = enabled
    rgbModeButton.Text = enabled and "RGB ON" or "RGB"
    rgbModeButton.BackgroundColor3 = enabled and T.AccentSoft or T.Surface2
    rgbModeButton.TextColor3 = enabled and T.AccentBright or T.Muted
    rgbModeButton.TextStrokeTransparency = enabled and 0.72 or 1
    if enabled then
        rgbOriginals = collectRGBTargets()
    else
        for _, item in ipairs(rgbOriginals) do
            if item.object and item.object.Parent then
                pcall(function() item.object[item.property] = item.original end)
            end
        end
        rgbOriginals = {}
    end
    notify("RGB lighting", enabled and "Full interface spectrum enabled." or "RGB lighting disabled.")
end
rgbModeButton.Activated:Connect(function() setRGBMode(not rgbModeEnabled) end)
task.spawn(function()
    while screenGui.Parent do
        if rgbModeEnabled and not isMinimized then
            local hue = (os.clock() * 0.075) % 1
            local color = Color3.fromHSV(hue, 0.66, 1)
            for _, item in ipairs(rgbOriginals) do
                if item.object and item.object.Parent then
                    pcall(function() item.object[item.property] = color end)
                end
            end
        end
        task.wait(0.06)
    end
end)

local pageScroll = Instance.new("ScrollingFrame")
pageScroll.Name = "PageScroll"
pageScroll.BackgroundTransparency = 1
pageScroll.BorderSizePixel = 0
pageScroll.Position = UDim2.new(0, 28, 0, 83)
pageScroll.Size = UDim2.new(1, -56, 1, -101)
pageScroll.ScrollBarThickness = 2
pageScroll.ScrollBarImageColor3 = T.Accent
pageScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
pageScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
pageScroll.Parent = content
local pagePadding = padding(pageScroll, 0, 5, 0, 14)
local pageList = listLayout(pageScroll, Enum.FillDirection.Vertical, 12)

--// Footer
local footer = Instance.new("Frame")
footer.Name = "Footer"
footer.BackgroundColor3 = T.Surface
footer.BorderSizePixel = 0
footer.Position = UDim2.new(0, 0, 1, -32)
footer.Size = UDim2.new(1, 0, 0, 32)
footer.Parent = shell

local footerLine = Instance.new("Frame")
footerLine.BackgroundColor3 = T.Border
footerLine.BackgroundTransparency = 0.25
footerLine.BorderSizePixel = 0
footerLine.Size = UDim2.new(1, 0, 0, 1)
footerLine.Parent = footer

local footerText = label(footer, "JT3R     /     OBSIDIAN ATELIER", 9, T.Quiet, Enum.Font.RobotoMono)
footerText.Position = UDim2.new(0, 20, 0, 7)
footerText.Size = UDim2.new(0.7, 0, 0, 18)

local footerVersion = label(footer, "V7.0", 9, T.Accent, Enum.Font.RobotoMono, Enum.TextXAlignment.Right)
footerVersion.AnchorPoint = Vector2.new(1, 0)
footerVersion.Position = UDim2.new(1, -20, 0, 7)
footerVersion.Size = UDim2.new(0, 60, 0, 18)

--// Floating restore button
local restore = button(screenGui, "JT3R", UDim2.fromOffset(68, 68), Color3.fromRGB(18, 16, 13), T.AccentBright)
restore.TextSize = 13
restore.Font = Enum.Font.Merriweather
restore.TextStrokeColor3 = T.Accent
restore.TextStrokeTransparency = 0.55
restore.Name = "JT3RRestore"
restore.Visible = false
restore.Position = UDim2.new(0, 20, 0.55, 0)
restore.TextSize = 16
restore.Font = Enum.Font.Merriweather
restore.AutoButtonColor = false
corner(restore, 16)
stroke(restore, T.AccentBright, 0.04, 1.5)
local restoreGlow = Instance.new("UIStroke")
restoreGlow.Color = T.Accent
restoreGlow.Thickness = 7
restoreGlow.Transparency = 0.48
restoreGlow.Parent = restore
local restoreGradient = Instance.new("UIGradient")
restoreGradient.Rotation = 35
restoreGradient.Color = ColorSequence.new(Color3.fromRGB(255, 225, 177), Color3.fromRGB(111, 78, 39))
restoreGradient.Parent = restore

--// Toasts
toastContainer = Instance.new("Frame")
toastContainer.Name = "Notifications"
toastContainer.BackgroundTransparency = 1
toastContainer.AnchorPoint = Vector2.new(1, 0)
toastContainer.Position = UDim2.new(1, -18, 0, 18)
toastContainer.Size = UDim2.new(0, 280, 0, 220)
toastContainer.Parent = screenGui
listLayout(toastContainer, Enum.FillDirection.Vertical, 8, Enum.HorizontalAlignment.Right)

local function notify(title, message)
    notificationCount += 1
    local toast = Instance.new("Frame")
    toast.BackgroundColor3 = T.Surface
    toast.BorderSizePixel = 0
    toast.Size = UDim2.new(1, 0, 0, 66)
    toast.BackgroundTransparency = 1
    toast.Parent = toastContainer
    corner(toast, 12)
    local outline = stroke(toast, T.Border, 1, 1)
    local accentBar = Instance.new("Frame")
    accentBar.BackgroundColor3 = T.Accent
    accentBar.BorderSizePixel = 0
    accentBar.Size = UDim2.new(0, 3, 1, -20)
    accentBar.Position = UDim2.new(0, 0, 0, 10)
    accentBar.Parent = toast
    corner(accentBar, 3)
    local t1 = label(toast, title, 12, T.Text, Enum.Font.SourceSansSemibold)
    t1.Position = UDim2.new(0, 15, 0, 10)
    t1.Size = UDim2.new(1, -25, 0, 19)
    local t2 = label(toast, message, 10, T.Muted, Enum.Font.SourceSans)
    t2.Position = UDim2.new(0, 15, 0, 33)
    t2.Size = UDim2.new(1, -25, 0, 18)
    toast.Position = UDim2.new(0, 24, 0, 0)
    tween(toast, 0.28, {BackgroundTransparency = 0, Position = UDim2.new(0, 0, 0, 0)})
    tween(outline, 0.28, {Transparency = 0.15})
    task.delay(3.2, function()
        if toast and toast.Parent then
            tween(toast, 0.22, {BackgroundTransparency = 1, Position = UDim2.new(0, 18, 0, 0)})
            task.wait(0.24)
            if toast then toast:Destroy() end
        end
    end)
end

--// Luxury surface finish: fine metallic grain, sparkle points and hairline trim.
local luxurySparkles = {}
local function luxurySurface(frame, compact)
    frame.ClipsDescendants = true
    local topRule = Instance.new("Frame")
    topRule.Name = "TopMetallicRule"
    topRule.BackgroundColor3 = T.AccentBright
    topRule.BackgroundTransparency = 0.72
    topRule.BorderSizePixel = 0
    topRule.Position = UDim2.new(0, 16, 0, 0)
    topRule.Size = UDim2.new(0, compact and 32 or 54, 0, 1)
    topRule.Parent = frame
    local glint = Instance.new("Frame")
    glint.Name = "MetallicGlint"
    glint.BackgroundColor3 = T.Accent
    glint.BackgroundTransparency = 0.9
    glint.BorderSizePixel = 0
    glint.AnchorPoint = Vector2.new(1, 0)
    glint.Position = UDim2.new(1, -15, 0, 9)
    glint.Size = UDim2.new(0, compact and 22 or 34, 0, 1)
    glint.Parent = frame
    local gradient = Instance.new("UIGradient")
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.12),
        NumberSequenceKeypoint.new(1, 1)
    })
    gradient.Parent = glint
end

--// UI construction helpers
local function sectionHeader(text)
    local holder = Instance.new("Frame")
    holder.BackgroundTransparency = 1
    holder.Size = UDim2.new(1, 0, 0, 22)
    holder.Parent = pageScroll
    local txt = label(holder, text:upper(), 9, T.Accent, Enum.Font.RobotoMono)
    txt.Size = UDim2.new(1, 0, 1, 0)
    return holder
end

local function panel(height)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = T.Surface
    frame.BackgroundTransparency = glassEnabled and 0.13 or 0
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(1, 0, 0, height)
    frame.Parent = pageScroll
    corner(frame, 14)
    luxurySurface(frame, false)
    frame:SetAttribute("JT3RPanel", true)
    local panelEdge = stroke(frame, T.Border, glassEnabled and 0.28 or 0.08, 1)
    panelEdge.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local sheen = Instance.new("UIGradient")
    sheen.Rotation = 110
    sheen.Color = ColorSequence.new(Color3.fromRGB(45, 41, 34), T.Surface)
    sheen.Transparency = NumberSequence.new(0.76, 0.18)
    sheen.Parent = frame
    local topHairline = Instance.new("Frame")
    topHairline.Name = "GoldHairline"
    topHairline.BackgroundColor3 = T.AccentBright
    topHairline.BackgroundTransparency = 0.68
    topHairline.BorderSizePixel = 0
    topHairline.Position = UDim2.new(0, 18, 0, 0)
    topHairline.Size = UDim2.new(0.34, 0, 0, 1)
    topHairline.Parent = frame
    return frame
end

local function infoPanel(kicker, title, description, height)
    local frame = panel(height or 128)
    local k = label(frame, kicker:upper(), 9, T.Accent, Enum.Font.RobotoMono)
    k.Position = UDim2.new(0, 18, 0, 15)
    k.Size = UDim2.new(1, -36, 0, 16)
    local h = label(frame, title, 17, T.Text, Enum.Font.SourceSansSemibold)
    h.Position = UDim2.new(0, 18, 0, 38)
    h.Size = UDim2.new(1, -36, 0, 25)
    local d = label(frame, description, 11, T.Muted, Enum.Font.SourceSans)
    d.Position = UDim2.new(0, 18, 0, 70)
    d.Size = UDim2.new(1, -36, 0, 38)
    d.TextWrapped = true
    d.TextYAlignment = Enum.TextYAlignment.Top
    return frame
end

local function actionRow(parent, title, subtitle, actionText, callback)
    local row = Instance.new("Frame")
    row.BackgroundColor3 = T.Surface2
    row.BorderSizePixel = 0
    row.Size = UDim2.new(1, 0, 0, 62)
    row.Parent = parent
    corner(row, 10)
    luxurySurface(row, true)
    local a = label(row, title, 12, T.Text, Enum.Font.SourceSansSemibold)
    a.Position = UDim2.new(0, 14, 0, 9)
    a.Size = UDim2.new(1, -130, 0, 19)
    local b = label(row, subtitle, 9, T.Muted, Enum.Font.SourceSans)
    b.Position = UDim2.new(0, 14, 0, 32)
    b.Size = UDim2.new(1, -130, 0, 16)
    local act = button(row, actionText, UDim2.fromOffset(92, 34), T.AccentSoft, T.AccentBright)
    act.AnchorPoint = Vector2.new(1, 0.5)
    act.Position = UDim2.new(1, -12, 0.5, 0)
    act.MouseButton1Click:Connect(callback)
    return row
end

local mobileDock = false

local function setPage(name)
    if pages[name] then savePreferences(name, sessionPreferences.welcomed) end
    currentPage = name
    pageTitle.Text = name
    local pageNumber = 1
    for index, item in ipairs(navItems) do if item[1] == name then pageNumber = index break end end
    pageEyebrow.Text = string.format("JT3R COLLECTION  /  %02d", pageNumber)
    if pageTitleRule then
        local ruleWidth = math.min(74, 30 + (#name * 5))
        tween(pageTitleRule, 0.3, {Size = UDim2.new(0, ruleWidth, 0, 1)}, Enum.EasingStyle.Quart)
    end
    if animationsEnabled then
        pageTitle.TextTransparency = 1
        pageEyebrow.TextTransparency = 1
        pageTitle.Position = UDim2.new(0, 0, 0, 19)
        tween(pageTitle, 0.28, {TextTransparency = 0, Position = UDim2.new(0, 0, 0, 15)}, Enum.EasingStyle.Quart)
        tween(pageEyebrow, 0.32, {TextTransparency = 0}, Enum.EasingStyle.Quart)
    else
        pageTitle.TextTransparency = 0
        pageEyebrow.TextTransparency = 0
    end
    for pageName, buttonObject in pairs(pageButtons) do
        local selected = pageName == name
        tween(buttonObject, 0.24, {
            BackgroundColor3 = selected and Color3.fromRGB(53,42,27) or T.Surface
        }, Enum.EasingStyle.Quart)
        buttonObject.TextColor3 = selected and T.AccentBright or T.Muted
        local navGradient=buttonObject:FindFirstChildOfClass("UIGradient")
        if navGradient then tween(navGradient,0.3,{Rotation=selected and 35 or 0},Enum.EasingStyle.Quart) end
        local activeDot = buttonObject:FindFirstChild("ActiveNavDot")
        if activeDot then
            activeDot.Visible = selected
            if selected then
                activeDot.Size = UDim2.fromOffset(2, 2)
                tween(activeDot, 0.2, {Size = UDim2.fromOffset(5, 5)}, Enum.EasingStyle.Back)
            end
        end
        local marker = buttonObject:FindFirstChild("ActiveGoldMarker")
        if marker then
            marker.Visible = selected
            marker.BackgroundColor3 = T.AccentBright
            if mobileDock then
                marker.Position = UDim2.new(0.18, 0, 1, -3)
                marker.Size = UDim2.new(0.64, 0, 0, 2)
            elseif selected then
                marker.Position = UDim2.new(0, 0, 0.18, 0)
                marker.Size = UDim2.new(0, 2, 0.35, 0)
                tween(marker, 0.22, {Size = UDim2.new(0, 3, 0.68, 0)}, Enum.EasingStyle.Back)
            end
        end
        local outline = buttonObject:FindFirstChild("NavOutline")
        if outline then
            outline.Color = T.Accent
            tween(outline, 0.2, {Transparency = selected and 0.48 or 1}, Enum.EasingStyle.Quart)
        end
        local iconLabel = buttonObject:FindFirstChild("NavIcon")
        if iconLabel then iconLabel.TextColor3 = selected and T.AccentBright or T.Quiet end
        local textLabel = buttonObject:FindFirstChild(name)
        if textLabel and textLabel:IsA("TextLabel") then
            textLabel.Font = selected and Enum.Font.RobotoMono or Enum.Font.SourceSansSemibold
        end
    end
    for pageName, frame in pairs(pageFrames) do
        local selected = pageName == name
        if selected then
            frame.Visible = true
            if animationsEnabled then
                local destination = frame.Position
                frame.Position = UDim2.new(destination.X.Scale, destination.X.Offset + 9, destination.Y.Scale, destination.Y.Offset + 2)
                tween(frame, 0.26, {Position = destination}, Enum.EasingStyle.Quart)
            end
        else
            frame.Visible = false
        end
    end
    -- Each page uses a dedicated scroll frame so switching pages starts cleanly.
    if pageFrames[name] then
        pageFrames[name].CanvasPosition = Vector2.new(0, 0)
    end
end

--// Dedicated page content containers
local function createPage(name)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = name .. "Page"
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.Position = UDim2.new(0, 24, 0, 82)
    scroll.Size = UDim2.new(1, -48, 1, -100)
    scroll.ScrollBarThickness = 2
    scroll.ScrollBarImageColor3 = T.Accent
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.Visible = false
    scroll.Parent = content
    padding(scroll, 0, 5, 0, 14)
    listLayout(scroll, Enum.FillDirection.Vertical, 12)
    pageFrames[name] = scroll
    return scroll
end

-- remove shared initial pageScroll (dedicated page frames replace it)
pageScroll:Destroy()
local pages = {}
for _, item in ipairs(navItems) do
    pages[item[1]] = createPage(item[1])
end

local function section(parent, text)
    local f = Instance.new("Frame")
    f.BackgroundTransparency = 1
    f.Size = UDim2.new(1, 0, 0, 20)
    f.Parent = parent
    local l = label(f, text:upper(), 8, T.AccentBright, Enum.Font.RobotoMono)
    l.Size = UDim2.fromScale(1, 1)
end

local function panelFor(parent, height)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = T.Surface
    f.BackgroundTransparency = glassEnabled and 0.13 or 0
    f.BorderSizePixel = 0
    f.Size = UDim2.new(1, 0, 0, height)
    f.Parent = parent
    corner(f, 14)
    luxurySurface(f, false)
    f:SetAttribute("JT3RPanel", true)
    stroke(f, T.Border, glassEnabled and 0.28 or 0.08, 1)
    local sheen = Instance.new("UIGradient")
    sheen.Rotation = 110
    sheen.Color = ColorSequence.new(Color3.fromRGB(45, 41, 34), T.Surface)
    sheen.Transparency = NumberSequence.new(0.78, 0.2)
    sheen.Parent = f
    return f
end

local function textBlock(parent, top, title, desc)
    local f = panelFor(parent, 112)
    local eyebrow = label(f, top:upper(), 9, T.Accent, Enum.Font.RobotoMono)
    eyebrow.Position = UDim2.new(0, 17, 0, 14)
    eyebrow.Size = UDim2.new(1, -34, 0, 15)
    local h = label(f, title, 16, T.Text, Enum.Font.SourceSansSemibold)
    h.Position = UDim2.new(0, 17, 0, 36)
    h.Size = UDim2.new(1, -34, 0, 24)
    local d = label(f, desc, 10, T.Muted, Enum.Font.SourceSans)
    d.Position = UDim2.new(0, 17, 0, 67)
    d.Size = UDim2.new(1, -34, 0, 30)
    d.TextWrapped = true
    d.TextYAlignment = Enum.TextYAlignment.Top
    return f
end

-- Interface-only controls. These switches change presentation state only.
local function interfaceSwitch(parent, titleText, detailText, defaultOn, callback)
    local row = Instance.new("Frame")
    row.BackgroundColor3 = T.Surface2
    row.BackgroundTransparency = 0.08
    row.BorderSizePixel = 0
    row.Size = UDim2.new(1, 0, 0, 66)
    row.Parent = parent
    corner(row, 10)
    stroke(row, T.Border, 0.35, 1)
    local title = label(row, titleText, 11, T.Text, Enum.Font.SourceSansSemibold)
    title.Position = UDim2.new(0, 14, 0, 10)
    title.Size = UDim2.new(1, -112, 0, 18)
    local detail = label(row, detailText, 9, T.Muted, Enum.Font.SourceSans)
    detail.Position = UDim2.new(0, 14, 0, 33)
    detail.Size = UDim2.new(1, -112, 0, 16)
    local enabled = defaultOn == true
    local toggle = button(row, enabled and "ON" or "OFF", UDim2.fromOffset(64, 30), enabled and T.AccentSoft or T.Surface3, enabled and T.AccentBright or T.Muted)
    toggle.AnchorPoint = Vector2.new(1, 0.5)
    toggle.Position = UDim2.new(1, -12, 0.5, 0)
    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggle.Text = enabled and "ON" or "OFF"
        toggle.BackgroundColor3 = enabled and T.AccentSoft or T.Surface3
        toggle.TextColor3 = enabled and T.AccentBright or T.Muted
        if callback then callback(enabled) end
    end)
    return row
end

local function miniAction(parent, titleText, detailText, actionText, callback)
    return actionRow(parent, titleText, detailText, actionText, callback)
end

-- Home / JT3R signature dashboard
do
    local p = pages.Home

    -- Brand-led masthead: the visual identity is the first thing the user sees.
    local hero = panelFor(p, 178)
    hero.Name = "SignatureHero"
    hero.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    hero.ClipsDescendants = true
    stroke(hero, T.AccentBright, 0.22, 1.25)

    local heroGradient = Instance.new("UIGradient")
    heroGradient.Rotation = 12
    heroGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 43, 26)),
        ColorSequenceKeypoint.new(0.34, Color3.fromRGB(29, 26, 21)),
        ColorSequenceKeypoint.new(0.72, Color3.fromRGB(17, 18, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 11, 13))
    })
    heroGradient.Parent = hero

    local heroTopline = Instance.new("Frame")
    heroTopline.Name = "HeroTopline"
    heroTopline.BackgroundColor3 = T.AccentBright
    heroTopline.BorderSizePixel = 0
    heroTopline.Position = UDim2.new(0, 18, 0, 0)
    heroTopline.Size = UDim2.new(0.32, 0, 0, 2)
    heroTopline.Parent = hero

    local heroGlow = Instance.new("Frame")
    heroGlow.Name = "HeroGlow"
    heroGlow.BackgroundColor3 = T.Accent
    heroGlow.BackgroundTransparency = 0.9
    heroGlow.BorderSizePixel = 0
    heroGlow.AnchorPoint = Vector2.new(1, 0.5)
    heroGlow.Position = UDim2.new(1, -10, 0.52, 0)
    heroGlow.Size = UDim2.fromOffset(148, 148)
    heroGlow.Parent = hero
    corner(heroGlow, 80)

    local heroRing = Instance.new("Frame")
    heroRing.Name = "HeroRing"
    heroRing.BackgroundTransparency = 1
    heroRing.AnchorPoint = Vector2.new(1, 0.5)
    heroRing.Position = UDim2.new(1, -17, 0.52, 0)
    heroRing.Size = UDim2.fromOffset(122, 122)
    heroRing.Parent = hero
    corner(heroRing, 70)
    local ringStroke = stroke(heroRing, T.AccentBright, 0.5, 1.2)

    local ringInner = Instance.new("Frame")
    ringInner.Name = "HeroRingInner"
    ringInner.BackgroundTransparency = 1
    ringInner.AnchorPoint = Vector2.new(0.5, 0.5)
    ringInner.Position = UDim2.fromScale(0.5, 0.5)
    ringInner.Size = UDim2.new(1, -13, 1, -13)
    ringInner.Parent = heroRing
    corner(ringInner, 60)
    stroke(ringInner, T.Accent, 0.78, 1)

    local heroSeal = label(hero, "JT3R", 25, T.AccentBright, Enum.Font.Merriweather, Enum.TextXAlignment.Center)
    heroSeal.Name = "HeroSeal"
    heroSeal.AnchorPoint = Vector2.new(1, 0.5)
    heroSeal.Position = UDim2.new(1, -27, 0.52, 0)
    heroSeal.Size = UDim2.fromOffset(104, 42)
    heroSeal.TextStrokeColor3 = T.Accent
    heroSeal.TextStrokeTransparency = 0.82

    local sealRule = Instance.new("Frame")
    sealRule.Name = "SealRule"
    sealRule.BackgroundColor3 = T.AccentBright
    sealRule.BackgroundTransparency = 0.24
    sealRule.BorderSizePixel = 0
    sealRule.AnchorPoint = Vector2.new(0.5, 0)
    sealRule.Position = UDim2.new(1, -79, 0.69, 0)
    sealRule.Size = UDim2.fromOffset(43, 1)
    sealRule.Parent = hero

    local heroIndex = label(hero, "PRIVATE INTERFACE  /  EST. JT3R", 8, T.AccentBright, Enum.Font.RobotoMono)
    heroIndex.Name = "HeroIndex"
    heroIndex.Position = UDim2.new(0, 20, 0, 19)
    heroIndex.Size = UDim2.new(1, -145, 0, 14)

    local heroTitle = label(hero, "CONTROL,\nREFINED.", 26, T.Text, Enum.Font.Merriweather)
    heroTitle.Name = "HeroTitle"
    heroTitle.Position = UDim2.new(0, 19, 0, 43)
    heroTitle.Size = UDim2.new(1, -148, 0, 68)
    heroTitle.TextYAlignment = Enum.TextYAlignment.Top
    heroTitle.TextWrapped = true

    local heroDesc = label(hero, "YOUR SPACE. YOUR SETTINGS. YOUR STANDARD.", 7, T.Muted, Enum.Font.RobotoMono)
    heroDesc.Name = "HeroDesc"
    heroDesc.Position = UDim2.new(0, 21, 1, -29)
    heroDesc.Size = UDim2.new(1, -42, 0, 12)

    task.spawn(function()
        while screenGui.Parent and hero.Parent do
            if animationsEnabled and not isMinimized then
                tween(ringStroke, 1.8, {Transparency = 0.18, Thickness = 1.8}, Enum.EasingStyle.Sine)
                task.wait(1.8)
                if ringStroke and ringStroke.Parent then
                    tween(ringStroke, 1.8, {Transparency = 0.62, Thickness = 1.05}, Enum.EasingStyle.Sine)
                end
                task.wait(1.8)
            else
                task.wait(0.3)
            end
        end
    end)

    -- A real-time status strip replaces decorative / fictional plan metrics.
    section(p, "At a glance")
    local statusPanel = panelFor(p, 76)
    statusPanel.Name = "LiveStatusStrip"
    statusPanel.BackgroundColor3 = Color3.fromRGB(15, 16, 18)
    local statusItems = {
        {"SESSION", "ONLINE", "HomeSessionValue"},
        {"PLAYERS", tostring(#Players:GetPlayers()), "HomePlayersValue"},
        {"EDITION", string.upper(currentThemeName), "HomeEditionValue"}
    }
    for index, item in ipairs(statusItems) do
        local cell = Instance.new("Frame")
        cell.Name = "StatusCell" .. index
        cell.BackgroundTransparency = 1
        cell.Position = UDim2.new((index - 1) / 3, 0, 0, 0)
        cell.Size = UDim2.new(1 / 3, 0, 1, 0)
        cell.Parent = statusPanel

        local value = label(cell, item[2], 12, T.Text, Enum.Font.Merriweather, Enum.TextXAlignment.Center)
        value.Name = item[3]
        value.Position = UDim2.new(0, 3, 0, 17)
        value.Size = UDim2.new(1, -6, 0, 21)
        value.TextTruncate = Enum.TextTruncate.AtEnd

        local caption = label(cell, item[1], 7, T.Accent, Enum.Font.RobotoMono, Enum.TextXAlignment.Center)
        caption.Position = UDim2.new(0, 3, 0, 43)
        caption.Size = UDim2.new(1, -6, 0, 12)

        if index < 3 then
            local divider = Instance.new("Frame")
            divider.BackgroundColor3 = T.Border
            divider.BackgroundTransparency = 0.25
            divider.BorderSizePixel = 0
            divider.Position = UDim2.new(1, -1, 0, 16)
            divider.Size = UDim2.new(0, 1, 0, 44)
            divider.Parent = cell
        end
    end

    -- Primary navigation becomes a designed launch grid, not generic text buttons.
    section(p, "Quick access")
    local quick = panelFor(p, 0)
    quick.Name = "WorkspaceShortcuts"
    quick.BackgroundColor3 = Color3.fromRGB(15, 16, 18)
    local quickLayout = Instance.new("UIGridLayout")
    quickLayout.Name = "ShortcutGrid"
    quickLayout.CellSize = UDim2.new(0.48, 0, 0, 60)
    quickLayout.CellPadding = UDim2.new(0.025, 0, 0, 8)
    quickLayout.FillDirectionMaxCells = 2
    quickLayout.SortOrder = Enum.SortOrder.LayoutOrder
    quickLayout.Parent = quick
    padding(quick, 12, 12, 12, 12)

    local shortcutData = {
        {"Aim", "A", "TARGETING"},
        {"ESP", "E", "INFORMATION"},
        {"Visuals", "V", "APPEARANCE"},
        {"Fly", "F", "MOVEMENT"},
        {"Misc", "M", "UTILITIES"},
        {"Settings", "S", "PREFERENCES"},
        {"Console", "C", "ACTIVITY LOG"},
        {"Home", "J", "OVERVIEW"},
    }

    for index, item in ipairs(shortcutData) do
        local target, glyph, detail = item[1], item[2], item[3]
        local tile = Instance.new("TextButton")
        tile.Name = target .. "Shortcut"
        tile.AutoButtonColor = false
        tile.Text = ""
        tile.BackgroundColor3 = T.Surface2
        tile.BorderSizePixel = 0
        tile.LayoutOrder = index
        tile.ZIndex = 3
        tile.Parent = quick
        corner(tile, 11)
        local tileStroke = stroke(tile, T.Border, 0.22, 1)

        local tileRail = Instance.new("Frame")
        tileRail.Name = "ShortcutGoldRail"
        tileRail.BackgroundColor3 = T.AccentBright
        tileRail.BackgroundTransparency = 0.22
        tileRail.BorderSizePixel = 0
        tileRail.Position = UDim2.new(0, 0, 0.18, 0)
        tileRail.Size = UDim2.new(0, 2, 0.64, 0)
        tileRail.ZIndex = 4
        tileRail.Parent = tile

        local tileIcon = Instance.new("Frame")
        tileIcon.Name = "ShortcutIcon"
        tileIcon.BackgroundColor3 = T.AccentSoft
        tileIcon.BorderSizePixel = 0
        tileIcon.Position = UDim2.new(0, 9, 0, 12)
        tileIcon.Size = UDim2.fromOffset(34, 34)
        tileIcon.ZIndex = 4
        tileIcon.Parent = tile
        corner(tileIcon, 9)

        local tileGlyph = label(tileIcon, glyph, 13, T.AccentBright, Enum.Font.RobotoMono, Enum.TextXAlignment.Center)
        tileGlyph.Name = "ShortcutGlyph"
        tileGlyph.Size = UDim2.fromScale(1, 1)
        tileGlyph.ZIndex = 5

        local tileTitle = label(tile, target:upper(), 9, T.Text, Enum.Font.RobotoMono)
        tileTitle.Name = "ShortcutTitle"
        tileTitle.Position = UDim2.new(0, 51, 0, 12)
        tileTitle.Size = UDim2.new(1, -61, 0, 16)
        tileTitle.ZIndex = 5

        local tileDetail = label(tile, detail, 6, T.Muted, Enum.Font.RobotoMono)
        tileDetail.Name = "ShortcutDetail"
        tileDetail.Position = UDim2.new(0, 51, 0, 30)
        tileDetail.Size = UDim2.new(1, -61, 0, 13)
        tileDetail.TextTruncate = Enum.TextTruncate.AtEnd
        tileDetail.ZIndex = 5

        tile.Activated:Connect(function()
            tween(tileIcon, 0.13, {Rotation = -6}, Enum.EasingStyle.Back)
            task.delay(0.14, function()
                if tileIcon.Parent then tween(tileIcon, 0.18, {Rotation = 0}, Enum.EasingStyle.Back) end
            end)
            setPage(target)
        end)
        tile.MouseEnter:Connect(function()
            tween(tile, 0.16, {BackgroundColor3 = T.AccentSoft})
            tween(tileIcon, 0.16, {BackgroundColor3 = T.Accent})
            tween(tileRail, 0.16, {BackgroundTransparency = 0})
            tween(tileStroke, 0.16, {Transparency = 0.42})
        end)
        tile.MouseLeave:Connect(function()
            tween(tile, 0.16, {BackgroundColor3 = T.Surface2})
            tween(tileIcon, 0.16, {BackgroundColor3 = T.AccentSoft})
            tween(tileRail, 0.16, {BackgroundTransparency = 0.22})
            tween(tileStroke, 0.16, {Transparency = 0.22})
        end)
    end
    quickLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        quick.Size = UDim2.new(1, 0, 0, quickLayout.AbsoluteContentSize.Y + 24)
    end)
    quick.Size = UDim2.new(1, 0, 0, quickLayout.AbsoluteContentSize.Y + 24)

    -- A personal identity card gives the dashboard a human focal point.
    section(p, "Your profile")
    local profile = panelFor(p, 82)
    profile.Name = "PlayerProfileCard"

    local avatarFrame = Instance.new("Frame")
    avatarFrame.Name = "AvatarFrame"
    avatarFrame.BackgroundColor3 = T.Surface3
    avatarFrame.Position = UDim2.new(0, 13, 0, 12)
    avatarFrame.Size = UDim2.fromOffset(58, 58)
    avatarFrame.Parent = profile
    corner(avatarFrame, 13)
    stroke(avatarFrame, T.Accent, 0.35, 1)

    local avatar = Instance.new("ImageLabel")
    avatar.Name = "ProfileAvatar"
    avatar.BackgroundTransparency = 1
    avatar.Position = UDim2.new(0, 2, 0, 2)
    avatar.Size = UDim2.new(1, -4, 1, -4)
    avatar.Image = ""
    avatar.Parent = avatarFrame
    corner(avatar, 11)

    local profileName = label(profile, LocalPlayer.DisplayName or LocalPlayer.Name, 12, T.Text, Enum.Font.SourceSansSemibold)
    profileName.Name = "ProfileName"
    profileName.Position = UDim2.new(0, 84, 0, 14)
    profileName.Size = UDim2.new(1, -100, 0, 19)
    profileName.TextTruncate = Enum.TextTruncate.AtEnd

    local profileHandle = label(profile, "@" .. LocalPlayer.Name, 9, T.Muted, Enum.Font.SourceSans)
    profileHandle.Position = UDim2.new(0, 84, 0, 36)
    profileHandle.Size = UDim2.new(1, -100, 0, 15)
    profileHandle.TextTruncate = Enum.TextTruncate.AtEnd

    local profileFoot = label(profile, "JT3R MEMBER  /  LOCAL SESSION", 7, T.Accent, Enum.Font.RobotoMono)
    profileFoot.Position = UDim2.new(0, 84, 0, 56)
    profileFoot.Size = UDim2.new(1, -100, 0, 12)

    task.spawn(function()
        local ok, imageUrl = pcall(function()
            return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)
        if ok and avatar and avatar.Parent then avatar.Image = imageUrl end
    end)

    -- Minimal signature footer, no fake subscription tier or filler information.
    local footer = panelFor(p, 46)
    footer.Name = "SignatureFooter"
    footer.BackgroundColor3 = Color3.fromRGB(14, 15, 17)
    local footerBrand = label(footer, "JT3R  /  OBSIDIAN ATELIER", 8, T.AccentBright, Enum.Font.RobotoMono)
    footerBrand.Position = UDim2.new(0, 14, 0, 8)
    footerBrand.Size = UDim2.new(1, -28, 0, 13)
    local footerText = label(footer, "A PRIVATE INTERFACE  /  JT3R", 7, T.Quiet, Enum.Font.RobotoMono)
    footerText.Position = UDim2.new(0, 14, 0, 25)
    footerText.Size = UDim2.new(1, -28, 0, 11)

    -- Keep live values factual and current.
    task.spawn(function()
        while screenGui.Parent and statusPanel.Parent do
            local playerValue = statusPanel:FindFirstChild("HomePlayersValue", true)
            local editionValue = statusPanel:FindFirstChild("HomeEditionValue", true)
            if playerValue then playerValue.Text = tostring(#Players:GetPlayers()) end
            if editionValue then editionValue.Text = string.upper(currentThemeName) end
            task.wait(2)
        end
    end)
end

-- Expanded workspaces. Controls below are presentation-only previews, not gameplay features.
local workspaceCopy = {
    Fly = {"MOVEMENT WORKSPACE", "Flight controls", "A dedicated flight workspace with PC keys and mobile joystick controls. Flight requires a compatible server controller in your own experience."},
    Aim = {"TARGETING WORKSPACE", "Aim workspace", "A dedicated visual workspace for organising future interface preferences."},
    ESP = {"LIVE PLAYER VISUALS", "Player visualisation", "Local character boxes, names, health and highlight controls for your own experience."},
    Visuals = {"PRESENTATION WORKSPACE", "Visual presentation", "Tune the look and feel of the JT3R interface itself."},
    Misc = {"UTILITY WORKSPACE", "Session utilities", "Small local tools for notifications, navigation and interface housekeeping."},
}
for _, name in ipairs({"Aim", "ESP", "Visuals", "Fly", "Misc"}) do
    local p = pages[name]
    local copy = workspaceCopy[name]
    section(p, copy[1])
    local intro = panelFor(p, 132)
    local iconTile = Instance.new("Frame")
    iconTile.BackgroundColor3 = T.AccentSoft
    iconTile.BorderSizePixel = 0
    iconTile.Position = UDim2.new(0, 16, 0, 17)
    iconTile.Size = UDim2.fromOffset(46, 46)
    iconTile.Parent = intro
    corner(iconTile, 13)
    stroke(iconTile, T.Accent, 0.42, 1)
    local iconText = label(iconTile, ({Aim="", ESP="", Visuals="", Fly="", Misc="⌘"})[name], 21, T.AccentBright, Enum.Font.RobotoMono, Enum.TextXAlignment.Center)
    iconText.Size = UDim2.fromScale(1, 1)
    local title = label(intro, copy[2], 17, T.Text, Enum.Font.SourceSansSemibold)
    title.Position = UDim2.new(0, 76, 0, 17)
    title.Size = UDim2.new(1, -92, 0, 25)
    local status = label(intro, "INTERFACE PREVIEW  /  READY", 8, T.Accent, Enum.Font.RobotoMono)
    status.Position = UDim2.new(0, 76, 0, 45)
    status.Size = UDim2.new(1, -92, 0, 15)
    local desc = label(intro, copy[3], 10, T.Muted, Enum.Font.SourceSans)
    desc.Position = UDim2.new(0, 16, 0, 79)
    desc.Size = UDim2.new(1, -32, 0, 38)
    desc.TextWrapped = true
    desc.TextYAlignment = Enum.TextYAlignment.Top

    local featureStrip = Instance.new("Frame")
    featureStrip.BackgroundTransparency = 1
    featureStrip.Size = UDim2.new(1, 0, 0, 66)
    featureStrip.Parent = p
    local featureLayout = Instance.new("UIListLayout")
    featureLayout.FillDirection = Enum.FillDirection.Horizontal
    featureLayout.SortOrder = Enum.SortOrder.LayoutOrder
    featureLayout.Padding = UDim.new(0, 8)
    featureLayout.Parent = featureStrip
    local featureNames = name == "Aim" and {{"04", "LAYOUT PRESETS"}, {"02", "CARD STYLES"}}
        or name == "ESP" and {{"03", "INFO MODES"}, {"02", "BADGE STYLES"}}
        or name == "Visuals" and {{"04", "VISUAL PROFILES"}, {"03", "LIGHT EFFECTS"}}
        or {{"03", "QUICK TOOLS"}, {"01", "ACTIVE SESSION"}}
    for index, item in ipairs(featureNames) do
        local stat = Instance.new("Frame")
        stat.BackgroundColor3 = Color3.fromRGB(22, 21, 19)
        stat.BorderSizePixel = 0
        stat.Size = UDim2.new(0.5, -4, 1, 0)
        stat.LayoutOrder = index
        stat.Parent = featureStrip
        corner(stat, 10)
        stroke(stat, T.Border, 0.28, 1)
        local statValue = label(stat, item[1], 18, T.AccentBright, Enum.Font.Merriweather)
        statValue.Position = UDim2.new(0, 13, 0, 8)
        statValue.Size = UDim2.new(1, -24, 0, 23)
        local statName = label(stat, item[2], 7, T.Muted, Enum.Font.RobotoMono)
        statName.Position = UDim2.new(0, 13, 0, 37)
        statName.Size = UDim2.new(1, -24, 0, 13)
    end

    if name == "Aim" then
        -- Keep this page intentionally clean: no fake practice controls or
        -- non-functional aim switches are presented as working features.
        section(p, "Visual workspace")
        local aimInfo = panelFor(p, 78)
        local aimInfoTitle = label(aimInfo, "AIM INTERFACE", 9, T.Accent, Enum.Font.RobotoMono)
        aimInfoTitle.Position = UDim2.new(0, 15, 0, 12)
        aimInfoTitle.Size = UDim2.new(1, -30, 0, 16)
        local aimInfoText = label(aimInfo, "This page is reserved for legitimate visual settings in your own experience. No automated targeting is active.", 10, T.Muted, Enum.Font.SourceSans)
        aimInfoText.Position = UDim2.new(0, 15, 0, 33)
        aimInfoText.Size = UDim2.new(1, -30, 0, 34)
        aimInfoText.TextWrapped = true
        aimInfoText.TextYAlignment = Enum.TextYAlignment.Top
    elseif name == "ESP" then
        -- Client-side player visualisation for the owner's own Roblox experience.
        -- Place/run this UI as a LocalScript in the experience; visuals are local to this client.
        local espState = {Enabled = true, Boxes = true, Names = true, Highlights = true, Health = true,
            Lines = false, TeamCheck = false, Distance = true, MaxDistance = 70000, RGB = false, HeldItem = true}
        local hitboxState = {Enabled = false, Multiplier = 1.5}
        local hitboxRemote = ReplicatedStorage:FindFirstChild("JT3R_HitboxControl")
        local function sendHitboxState()
            hitboxRemote = hitboxRemote or ReplicatedStorage:FindFirstChild("JT3R_HitboxControl")
            if not hitboxRemote or not hitboxRemote:IsA("RemoteEvent") then
                notify("Hitbox expander", "Server module not found. Add JT3R_HitboxServer.server.lua to ServerScriptService first.")
                return false
            end
            hitboxRemote:FireServer({Enabled = hitboxState.Enabled, Multiplier = hitboxState.Multiplier})
            return true
        end
        local function getCharacterRoot(character)
            if not character then return nil end
            return character:FindFirstChild("HumanoidRootPart")
                or character:FindFirstChild("Torso")
                or character:FindFirstChild("UpperTorso")
        end
        local espObjects = {}
        local rainbowClock = 0

        local function removeESP(player)
            local item = espObjects[player]
            if item then
                if item.Billboard then item.Billboard:Destroy() end
                if item.Highlight then item.Highlight:Destroy() end
                if item.Tracer then item.Tracer:Destroy() end
                if item.Box3D then item.Box3D:Destroy() end
                espObjects[player] = nil
            end
        end

        local function isEligible(player, character)
            if player == LocalPlayer or not character then return false end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local root = getCharacterRoot(character)
            local myCharacter = LocalPlayer.Character
            local myRoot = getCharacterRoot(myCharacter)
            if not humanoid or humanoid.Health <= 0 or not root or not myRoot then return false end
            if espState.TeamCheck and LocalPlayer.Team ~= nil and player.Team == LocalPlayer.Team then return false end
            if espState.Distance and (root.Position - myRoot.Position).Magnitude > espState.MaxDistance then return false end
            return true, root, humanoid
        end

        local function buildESP(player, character)
            removeESP(player)
            if not character then return end
            local highlight = Instance.new("Highlight")
            highlight.Name = "JT3R_PlayerHighlight"
            highlight.Adornee = character
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.FillColor = T.AccentBright
            highlight.OutlineColor = T.Accent
            highlight.FillTransparency = 0.38
            highlight.OutlineTransparency = 0.02
            highlight.Enabled = false
            highlight.Parent = character

            local billboard = Instance.new("BillboardGui")
            billboard.Name = "JT3R_PlayerInfo"
            billboard.Adornee = getCharacterRoot(character)
            billboard.Size = UDim2.fromOffset(190, 56)
            billboard.StudsOffset = Vector3.new(0, 3.35, 0)
            billboard.AlwaysOnTop = true
            billboard.Enabled = false
            billboard.Parent = PlayerGui

            -- A world-space bounding frame follows the real R6/R15 body dimensions.
            local box3D = Instance.new("BoxHandleAdornment")
            box3D.Name = "JT3R_CharacterBounds"
            box3D.Adornee = getCharacterRoot(character)
            box3D.Size = character:GetExtentsSize() + Vector3.new(0.12, 0.12, 0.12)
            box3D.AlwaysOnTop = true
            box3D.ZIndex = 8
            box3D.Transparency = 0.16
            box3D.Color3 = T.AccentBright
            box3D.Visible = false
            box3D.Parent = getCharacterRoot(character)

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Name = "PlayerName"
            nameLabel.BackgroundColor3 = Color3.fromRGB(12, 13, 15)
            nameLabel.BackgroundTransparency = 1
            nameLabel.BorderSizePixel = 0
            nameLabel.Size = UDim2.new(1, 0, 0, 22)
            nameLabel.Position = UDim2.new(0, 0, 0, 0)
            nameLabel.Font = Enum.Font.RobotoMono
            nameLabel.TextSize = 12
            nameLabel.TextWrapped = false
            nameLabel.TextYAlignment = Enum.TextYAlignment.Center
            nameLabel.TextColor3 = T.Text
            nameLabel.TextStrokeTransparency = 0.18
            nameLabel.Text = player.DisplayName
            nameLabel.Parent = billboard
            local nameCorner = Instance.new("UICorner")
            nameCorner.CornerRadius = UDim.new(0, 5)
            nameCorner.Parent = nameLabel

            local itemLabel = Instance.new("TextLabel")
            itemLabel.Name = "HeldItem"
            itemLabel.BackgroundTransparency = 1
            itemLabel.Position = UDim2.new(0, 0, 0, 22)
            itemLabel.Size = UDim2.new(1, 0, 0, 17)
            itemLabel.Font = Enum.Font.SourceSansSemibold
            itemLabel.TextSize = 10
            itemLabel.TextColor3 = T.AccentBright
            itemLabel.TextStrokeColor3 = Color3.fromRGB(5, 5, 6)
            itemLabel.TextStrokeTransparency = 0.12
            itemLabel.Text = "ITEM  ·  checking"
            itemLabel.Parent = billboard

            local healthBack = Instance.new("Frame")
            healthBack.Name = "HealthBack"
            healthBack.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            healthBack.BorderSizePixel = 0
            healthBack.Size = UDim2.new(0.72, 0, 0, 3)
            healthBack.Position = UDim2.new(0.14, 0, 1, -5)
            healthBack.Parent = billboard
            local healthFill = Instance.new("Frame")
            healthFill.Name = "HealthFill"
            healthFill.BackgroundColor3 = Color3.fromRGB(115, 190, 125)
            healthFill.BorderSizePixel = 0
            healthFill.Size = UDim2.fromScale(1, 1)
            healthFill.Parent = healthBack
            local tracer = Instance.new("Frame")
            tracer.Name = "JT3R_Tracer"
            tracer.AnchorPoint = Vector2.new(0.5, 0.5)
            tracer.BorderSizePixel = 0
            tracer.BackgroundColor3 = T.AccentBright
            tracer.Size = UDim2.fromOffset(1.5, 1)
            tracer.Visible = false
            tracer.ZIndex = 8
            tracer.Parent = screenGui
            espObjects[player] = {Character = character, Root = getCharacterRoot(character),
                Billboard = billboard, Highlight = highlight, Box3D = box3D,
                Name = nameLabel, Item = itemLabel, HealthBack = healthBack, HealthFill = healthFill,
                Tracer = tracer}
        end

        local function ensureESP(player)
            if player ~= LocalPlayer and player.Character and not espObjects[player] then
                buildESP(player, player.Character)
            end
        end

        for _, player in ipairs(Players:GetPlayers()) do ensureESP(player) end
        addConnection(Players.PlayerAdded:Connect(function(player)
            addConnection(player.CharacterAdded:Connect(function()
                task.wait(0.25)
                buildESP(player, player.Character)
            end))
            if player.Character then buildESP(player, player.Character) end
        end))
        addConnection(Players.PlayerRemoving:Connect(removeESP))
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                addConnection(player.CharacterAdded:Connect(function()
                    task.wait(0.25)
                    buildESP(player, player.Character)
                end))
            end
        end

        addConnection(RunService.RenderStepped:Connect(function(dt)
            rainbowClock = rainbowClock + dt * 0.22
            local rgbColor = Color3.fromHSV(rainbowClock % 1, 0.78, 1)
            for player, item in pairs(espObjects) do
                local character = player.Character
                local currentRoot = getCharacterRoot(character)
                -- StreamingEnabled can remove and later recreate body parts without CharacterAdded.
                -- Rebuild the local adornments when the streamed root returns or changes.
                if currentRoot and (item.Character ~= character or item.Root ~= currentRoot) then
                    buildESP(player, character)
                    item = espObjects[player]
                end
                local eligible, root, humanoid = isEligible(player, character)
                if not eligible or not espState.Enabled then
                    item.Billboard.Enabled = false
                    item.Highlight.Enabled = false
                    item.Tracer.Visible = false
                    if item.Box3D then item.Box3D.Visible = false end
                else
                    local color = espState.RGB and rgbColor or T.AccentBright
                    item.Billboard.Adornee = root
                    item.Billboard.Enabled = espState.Names or espState.Health or espState.HeldItem
                    if item.Box3D then
                        item.Box3D.Adornee = root
                        item.Box3D.Size = character:GetExtentsSize() + Vector3.new(0.12, 0.12, 0.12)
                        item.Box3D.Color3 = color
                        item.Box3D.Visible = espState.Boxes
                    end
                    local studs = math.floor((root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                    item.Name.Visible = espState.Names
                    item.Name.Text = player.DisplayName .. "   ·   " .. tostring(studs) .. " studs"
                    local equippedTool = character:FindFirstChildOfClass("Tool")
                    item.Item.Visible = espState.HeldItem
                    item.Item.Text = equippedTool and ("HOLDING  ·  " .. equippedTool.Name) or "HOLDING  ·  nothing visible"
                    item.Name.TextColor3 = Color3.fromRGB(250, 246, 237)
                    item.Name.TextStrokeColor3 = Color3.fromRGB(5, 5, 6)
                    item.Name.TextStrokeTransparency = 0.18
                    item.HealthBack.Visible = espState.Health
                    item.HealthFill.Visible = espState.Health
                    item.HealthFill.Size = UDim2.new(math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1), 0, 1, 0)
                    item.HealthFill.BackgroundColor3 = humanoid.Health / math.max(humanoid.MaxHealth, 1) > 0.55 and Color3.fromRGB(115, 190, 125)
                        or humanoid.Health / math.max(humanoid.MaxHealth, 1) > 0.25 and Color3.fromRGB(220, 170, 85)
                        or Color3.fromRGB(205, 92, 86)
                    item.Highlight.Enabled = espState.Highlights
                    item.Highlight.FillColor = color
                    item.Highlight.OutlineColor = color
                    local camera = workspace.CurrentCamera
                    local viewport, onScreen = camera:WorldToViewportPoint(root.Position)
                    if espState.Lines and onScreen then
                        local from = Vector2.new(camera.ViewportSize.X * 0.5, camera.ViewportSize.Y - 8)
                        local to = Vector2.new(viewport.X, viewport.Y)
                        local delta = to - from
                        item.Tracer.Visible = true
                        item.Tracer.Position = UDim2.fromOffset((from.X + to.X) * 0.5, (from.Y + to.Y) * 0.5)
                        item.Tracer.Size = UDim2.fromOffset(1.4, delta.Magnitude)
                        item.Tracer.Rotation = math.deg(math.atan2(delta.Y, delta.X)) - 90
                        item.Tracer.BackgroundColor3 = color
                    else
                        item.Tracer.Visible = false
                    end
                end
            end
        end))

        section(p, "ESP controls")
        interfaceSwitch(p, "ESP enabled", "Master switch for all player visual elements.", espState.Enabled, function(on)
            espState.Enabled = on
        end)
        interfaceSwitch(p, "Corner box display", "Show a clean frame around each eligible character.", espState.Boxes, function(on)
            espState.Boxes = on
        end)
        interfaceSwitch(p, "Player name display", "Show display names and live distance above characters.", espState.Names, function(on)
            espState.Names = on
        end)
        interfaceSwitch(p, "Character chams", "Highlight the actual character model, not just the frame.", espState.Highlights, function(on)
            espState.Highlights = on
        end)
        interfaceSwitch(p, "Player tracer lines", "Draw a fine line from the bottom of the screen to each player.", espState.Lines, function(on)
            espState.Lines = on
        end)
        interfaceSwitch(p, "Health bars", "Show a live health bar with low-health colour changes.", espState.Health, function(on)
            espState.Health = on
        end)
        interfaceSwitch(p, "Held item labels", "Show the equipped Tool when its character model is replicated locally.", espState.HeldItem, function(on)
            espState.HeldItem = on
        end)
        section(p, "Filters & colour")
        interfaceSwitch(p, "Team check", "Hide teammates when both players have the same team.", espState.TeamCheck, function(on)
            espState.TeamCheck = on
        end)
        interfaceSwitch(p, "Distance limit", "Only show characters inside the selected range.", espState.Distance, function(on)
            espState.Distance = on
        end)
        miniAction(p, "Maximum distance", "Current range: " .. espState.MaxDistance .. " studs", "CYCLE", function()
            local ranges = {100, 250, 500, 1000, 2000, 5000, 10000, 25000, 50000, 70000}
            local index = table.find(ranges, espState.MaxDistance) or 3
            espState.MaxDistance = ranges[index % #ranges + 1]
            notify("ESP distance", "Filter set to " .. espState.MaxDistance .. " studs. Roblox streaming can still limit which distant characters are loaded on your client.")
        end)
        interfaceSwitch(p, "RGB highlight mode", "Cycle a restrained spectrum across boxes and highlights.", espState.RGB, function(on)
            espState.RGB = on
        end)
        section(p, "Character diagnostics")
        section(p, "Server hitbox expander")
        interfaceSwitch(p, "Functional hitbox expansion", "Server-authorised size adjustment for R6/R15 characters; whitelist required.", hitboxState.Enabled, function(on)
            hitboxState.Enabled = on
            if not sendHitboxState() then hitboxState.Enabled = false end
        end)
        miniAction(p, "Hitbox multiplier", "Current size: " .. tostring(hitboxState.Multiplier) .. "x", "CYCLE", function()
            local values = {1.25, 1.5, 1.75, 2}
            local idx = table.find(values, hitboxState.Multiplier) or 1
            hitboxState.Multiplier = values[idx % #values + 1]
            if hitboxState.Enabled then sendHitboxState() end
            notify("Hitbox size", "Multiplier set to " .. tostring(hitboxState.Multiplier) .. "x.")
        end)
    elseif name == "Visuals" then
        section(p, "Interface effects")
        interfaceSwitch(p, "Ambient edge lighting", "Toggle the soft champagne halo around JT3R.", ambientEnabled, function(on)
            ambientEnabled = on
            ambientHalo.Visible = on and not isMinimized
            notify("Ambient lighting", on and "Halo enabled." or "Halo disabled.")
        end)
        interfaceSwitch(p, "Card sheen", "Toggle the subtle gradient finish on this workspace.", true, function(on)
            for _, child in ipairs(p:GetChildren()) do
                if child:IsA("Frame") then
                    local gradient = child:FindFirstChildOfClass("UIGradient")
                    if gradient then gradient.Enabled = on end
                end
            end
        end)
        interfaceSwitch(p, "Soft highlight", "Use a warmer accent on the workspace heading.", true, function(on)
            pageEyebrow.TextColor3 = on and T.Accent or T.Muted
        end)
        interfaceSwitch(p, "Warm panel contrast", "Preview a deeper surface tone for this page.", false, function(on)
            intro.BackgroundColor3 = on and Color3.fromRGB(31, 27, 21) or T.Surface
        end)

    elseif name == "Fly" then
        section(p, "Dedicated movement suite")
        local flyPanel = panelFor(p, 390)
        stroke(flyPanel, T.AccentBright, 0.36, 1.4)
        local flyBanner = label(flyPanel, "   JT3R FLIGHT", 17, T.AccentBright, Enum.Font.Merriweather)
        flyBanner.Position = UDim2.new(0, 16, 0, 13)
        flyBanner.Size = UDim2.new(1, -32, 0, 24)
        local flySub = label(flyPanel, "CONTROLLED MOVEMENT  /  PC + MOBILE", 8, T.Accent, Enum.Font.RobotoMono)
        flySub.Position = UDim2.new(0, 17, 0, 41)
        flySub.Size = UDim2.new(1, -34, 0, 15)
        local flyInfo = label(flyPanel, "PC  WASD to move  •  E rise  •  Q descend\nMOBILE  Analogue joystick + altitude buttons", 10, T.Muted, Enum.Font.SourceSans)
        flyInfo.Position = UDim2.new(0, 16, 0, 65)
        flyInfo.Size = UDim2.new(1, -32, 0, 38)
        flyInfo.TextWrapped = true
        flyInfo.TextYAlignment = Enum.TextYAlignment.Top
        local flyStatusTop = label(flyPanel, "SERVER-AUTHORISED FLIGHT", 8, T.Success, Enum.Font.RobotoMono)
        flyStatusTop.Position = UDim2.new(0, 16, 0, 112)
        flyStatusTop.Size = UDim2.new(1, -32, 0, 16)
        local flyButton = button(flyPanel, "ACTIVATE FLIGHT", UDim2.new(1, -28, 0, 38), T.AccentSoft, T.AccentBright)
        flyButton.Position = UDim2.new(0, 14, 0, 139)
        flyButton.TextSize = 10
        local flyStatus = label(flyPanel, "STANDBY  •  REQUIRES GAME SUPPORT", 8, T.Quiet, Enum.Font.RobotoMono)
        flyStatus.Position = UDim2.new(0, 16, 0, 182)
        flyStatus.Size = UDim2.new(1, -32, 0, 15)
        local flyEnabled = false
        flyButton.MouseButton1Click:Connect(function()
            local remote = ReplicatedStorage:FindFirstChild("JT3R_FlyControl")
            if not remote or not remote:IsA("RemoteEvent") then
                notify("Flight", "No JT3R_FlyControl server controller was found in this experience.")
                flyStatus.Text = "UNAVAILABLE  •  CONTROLLER NOT FOUND"
                flyStatus.TextColor3 = T.Danger
                return
            end
            flyEnabled = not flyEnabled
            remote:FireServer({Action = "SetFlight", Enabled = flyEnabled})
            flyButton.Text = flyEnabled and "DEACTIVATE FLIGHT" or "ACTIVATE FLIGHT"
            flyStatus.Text = flyEnabled and "FLIGHT REQUEST ACTIVE" or "STANDBY  •  GAME SUPPORT REQUIRED"
            flyStatus.TextColor3 = flyEnabled and T.Success or T.Quiet
            notify("Flight", flyEnabled and "Flight request sent." or "Flight disable request sent.")
        end)
        local mobileControl = Instance.new("Frame")
        mobileControl.Name = "FlightTouchControl"
        mobileControl.BackgroundColor3 = T.Surface2
        mobileControl.BackgroundTransparency = 0.08
        mobileControl.BorderSizePixel = 0
        mobileControl.Position = UDim2.new(0, 14, 0, 212)
        mobileControl.Size = UDim2.new(1, -28, 0, 106)
        mobileControl.Parent = flyPanel
        corner(mobileControl, 16)
        stroke(mobileControl, T.Accent, 0.42, 1)
        local stickBase = Instance.new("Frame")
        stickBase.Name = "FlightJoystick"
        stickBase.AnchorPoint = Vector2.new(0, 0.5)
        stickBase.Position = UDim2.new(0, 14, 0.5, 0)
        stickBase.Size = UDim2.fromOffset(88, 88)
        stickBase.BackgroundColor3 = Color3.fromRGB(29, 28, 26)
        stickBase.BorderSizePixel = 0
        stickBase.Parent = mobileControl
        corner(stickBase, 44)
        stroke(stickBase, T.AccentBright, 0.32, 1.2)
        local stickCenter = Instance.new("Frame")
        stickCenter.AnchorPoint = Vector2.new(0.5, 0.5)
        stickCenter.Position = UDim2.fromScale(0.5, 0.5)
        stickCenter.Size = UDim2.fromOffset(18, 18)
        stickCenter.BackgroundColor3 = T.AccentBright
        stickCenter.BorderSizePixel = 0
        stickCenter.Parent = stickBase
        corner(stickCenter, 9)
        local stickKnob = Instance.new("Frame")
        stickKnob.Name = "JoystickKnob"
        stickKnob.AnchorPoint = Vector2.new(0.5, 0.5)
        stickKnob.Position = UDim2.fromScale(0.5, 0.5)
        stickKnob.Size = UDim2.fromOffset(38, 38)
        stickKnob.BackgroundColor3 = Color3.fromRGB(211, 174, 111)
        stickKnob.BorderSizePixel = 0
        stickKnob.ZIndex = 4
        stickKnob.Parent = stickBase
        corner(stickKnob, 19)
        stroke(stickKnob, Color3.fromRGB(255, 230, 185), 0.12, 1.2)
        local liftTitle = label(mobileControl, "ALTITUDE", 8, T.Muted, Enum.Font.RobotoMono)
        liftTitle.Position = UDim2.new(0, 120, 0, 17)
        liftTitle.Size = UDim2.new(1, -130, 0, 14)
        local liftUp = button(mobileControl, "+", UDim2.fromOffset(38, 34), T.Surface3, T.AccentBright)
        liftUp.Position = UDim2.new(0, 120, 0, 39)
        liftUp.TextSize = 17
        local liftDown = button(mobileControl, "−", UDim2.fromOffset(38, 34), T.Surface3, T.AccentBright)
        liftDown.Position = UDim2.new(0, 164, 0, 39)
        liftDown.TextSize = 17
        local function sendFlyMove(direction, active)
            if not flyEnabled then return end
            local remote = ReplicatedStorage:FindFirstChild("JT3R_FlyControl")
            if remote and remote:IsA("RemoteEvent") then
                remote:FireServer({Action = "Move", Direction = direction, Active = active})
            end
        end
        local activeStickInput, currentStickDirection = nil, nil
        local function updateStick(screenPosition)
            local center = stickBase.AbsolutePosition + stickBase.AbsoluteSize * 0.5
            local delta = Vector2.new(screenPosition.X - center.X, screenPosition.Y - center.Y)
            local radius = 25
            if delta.Magnitude > radius then delta = delta.Unit * radius end
            stickKnob.Position = UDim2.new(0.5, delta.X, 0.5, delta.Y)
            local direction
            if delta.Magnitude > 8 then
                if math.abs(delta.X) > math.abs(delta.Y) then
                    direction = delta.X > 0 and "Right" or "Left"
                else
                    direction = delta.Y > 0 and "Backward" or "Forward"
                end
            end
            if direction ~= currentStickDirection then
                if currentStickDirection then sendFlyMove(currentStickDirection, false) end
                currentStickDirection = direction
                if currentStickDirection then sendFlyMove(currentStickDirection, true) end
            end
        end
        local function releaseStick()
            if currentStickDirection then sendFlyMove(currentStickDirection, false) end
            currentStickDirection, activeStickInput = nil, nil
            stickKnob:TweenPosition(UDim2.fromScale(0.5, 0.5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12, true)
        end
        stickBase.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                activeStickInput = input
                updateStick(input.Position)
            end
        end)
        addConnection(UserInputService.InputChanged:Connect(function(input)
            if activeStickInput and (input == activeStickInput or input.UserInputType == Enum.UserInputType.MouseMovement) then
                updateStick(input.Position)
            end
        end))
        addConnection(UserInputService.InputEnded:Connect(function(input)
            if activeStickInput and (input == activeStickInput or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                releaseStick()
            end
        end))
        local function bindLift(btn, direction)
            btn.MouseButton1Down:Connect(function() sendFlyMove(direction, true) end)
            btn.MouseButton1Up:Connect(function() sendFlyMove(direction, false) end)
            btn.MouseLeave:Connect(function() sendFlyMove(direction, false) end)
        end
        bindLift(liftUp, "Rise")
        bindLift(liftDown, "Descend")
        local keyDirections = {
            [Enum.KeyCode.W] = "Forward", [Enum.KeyCode.S] = "Backward",
            [Enum.KeyCode.A] = "Left", [Enum.KeyCode.D] = "Right",
            [Enum.KeyCode.E] = "Rise", [Enum.KeyCode.Q] = "Descend",
        }
        addConnection(UserInputService.InputBegan:Connect(function(input, processed)
            if processed or not flyEnabled then return end
            local direction = keyDirections[input.KeyCode]
            if direction then sendFlyMove(direction, true) end
        end))
        addConnection(UserInputService.InputEnded:Connect(function(input)
            local direction = keyDirections[input.KeyCode]
            if direction then sendFlyMove(direction, false) end
        end))
        section(p, "Flight notes")
        local note = panelFor(p, 66)
        local noteText = label(note, "This is not universal executor flight. Your own experience must provide a permission-checked JT3R_FlyControl RemoteEvent and server movement handler.", 9, T.Muted, Enum.Font.SourceSans)
        noteText.Position = UDim2.new(0, 15, 0, 10)
        noteText.Size = UDim2.new(1, -30, 0, 46)
        noteText.TextWrapped = true
        noteText.TextYAlignment = Enum.TextYAlignment.Top

        section(p, "Noclip control")
        local noclipPanel = panelFor(p, 142)
        noclipPanel.Name = "NoclipControlPanel"
        local noclipTitle = label(noclipPanel, "JT3R NOCLIP", 15, T.AccentBright, Enum.Font.Merriweather)
        noclipTitle.Position = UDim2.new(0, 15, 0, 11)
        noclipTitle.Size = UDim2.new(1, -30, 0, 22)
        local noclipInfo = label(noclipPanel, "MOBILE  Tap the button  •  PC  Press V\nRequires a permission-checked JT3R_NoClipControl RemoteEvent in the experience.", 9, T.Muted, Enum.Font.SourceSans)
        noclipInfo.Position = UDim2.new(0, 15, 0, 38)
        noclipInfo.Size = UDim2.new(1, -30, 0, 31)
        noclipInfo.TextWrapped = true
        noclipInfo.TextYAlignment = Enum.TextYAlignment.Top
        local noclipEnabled = false
        local noclipStatus = label(noclipPanel, "STANDBY  •  SERVER SUPPORT REQUIRED", 8, T.Quiet, Enum.Font.RobotoMono)
        noclipStatus.Position = UDim2.new(0, 15, 0, 76)
        noclipStatus.Size = UDim2.new(1, -150, 0, 30)
        noclipStatus.TextWrapped = true
        local noclipButton = button(noclipPanel, "NOCLIP OFF", UDim2.fromOffset(116, 38), T.Surface3, T.AccentBright)
        noclipButton.AnchorPoint = Vector2.new(1, 0)
        noclipButton.Position = UDim2.new(1, -14, 0, 78)
        noclipButton.TextSize = 9
        local function setNoClip(nextEnabled)
            local remote = ReplicatedStorage:FindFirstChild("JT3R_NoClipControl")
            if not remote or not remote:IsA("RemoteEvent") then
                noclipStatus.Text = "UNAVAILABLE  •  SERVER CONTROLLER NOT FOUND"
                noclipStatus.TextColor3 = T.Danger
                notify("Noclip unavailable", "This experience has not installed the JT3R server-side noclip controller.")
                return false
            end
            noclipEnabled = nextEnabled == true
            local sent = pcall(function()
                remote:FireServer({Action = "SetNoClip", Enabled = noclipEnabled})
            end)
            if not sent then
                noclipEnabled = false
                noclipStatus.Text = "REQUEST FAILED  •  TRY AGAIN"
                noclipStatus.TextColor3 = T.Danger
                return false
            end
            noclipButton.Text = noclipEnabled and "NOCLIP ON" or "NOCLIP OFF"
            noclipButton.BackgroundColor3 = noclipEnabled and T.AccentSoft or T.Surface3
            noclipButton.TextColor3 = noclipEnabled and T.AccentBright or T.Muted
            noclipStatus.Text = noclipEnabled and "ON  •  REQUEST SENT TO SERVER" or "OFF  •  REQUEST SENT TO SERVER"
            noclipStatus.TextColor3 = noclipEnabled and T.Success or T.Quiet
            notify("Noclip", noclipEnabled and "Enable request sent." or "Disable request sent.")
            return true
        end
        noclipButton.Activated:Connect(function()
            setNoClip(not noclipEnabled)
        end)
        addConnection(UserInputService.InputBegan:Connect(function(input, processed)
            if processed or input.KeyCode ~= Enum.KeyCode.V then return end
            setNoClip(not noclipEnabled)
        end))
        addConnection(LocalPlayer.CharacterAdded:Connect(function()
            if noclipEnabled then
                noclipEnabled = false
                noclipButton.Text = "NOCLIP OFF"
                noclipButton.BackgroundColor3 = T.Surface3
                noclipButton.TextColor3 = T.Muted
                noclipStatus.Text = "RESET  •  CHARACTER RESPAWNED"
                noclipStatus.TextColor3 = T.Quiet
            end
        end))

    elseif name == "Misc" then
        section(p, "Player intelligence")
        local selectedPlayer = nil
        local inventoryPanel = panelFor(p, 300)
        local invTitle = label(inventoryPanel, "INVENTORY VIEWER", 9, T.Accent, Enum.Font.RobotoMono)
        invTitle.Position = UDim2.new(0, 16, 0, 13)
        invTitle.Size = UDim2.new(1, -32, 0, 16)
        local invName = label(inventoryPanel, "Selected player: none", 13, T.Text, Enum.Font.SourceSansSemibold)
        invName.Position = UDim2.new(0, 16, 0, 35)
        invName.Size = UDim2.new(1, -32, 0, 20)
        local invStatus = label(inventoryPanel, "Choose a username, then refresh their locally visible Tools.", 9, T.Muted, Enum.Font.SourceSans)
        invStatus.Position = UDim2.new(0, 16, 0, 59)
        invStatus.Size = UDim2.new(1, -32, 0, 28)
        invStatus.TextWrapped = true
        invStatus.TextYAlignment = Enum.TextYAlignment.Top

        local selectBtn = button(inventoryPanel, "SELECT PLAYER  ▾", UDim2.new(0.62, -8, 0, 36), T.Surface3, T.AccentBright)
        selectBtn.Name = "PlayerDropdownButton"
        selectBtn.Position = UDim2.new(0, 14, 0, 96)
        selectBtn.TextSize = 10
        local refreshBtn = button(inventoryPanel, "REFRESH", UDim2.new(0.38, -8, 0, 36), T.AccentSoft, T.AccentBright)
        refreshBtn.Position = UDim2.new(0.62, 0, 0, 96)
        refreshBtn.TextSize = 10

        local dropdown = Instance.new("Frame")
        dropdown.Name = "PlayerDropdown"
        dropdown.Visible = false
        dropdown.BackgroundColor3 = T.Surface2
        dropdown.BorderSizePixel = 0
        dropdown.Position = UDim2.new(0, 14, 0, 136)
        dropdown.Size = UDim2.new(0.62, -8, 0, 112)
        dropdown.ZIndex = 30
        dropdown.Parent = inventoryPanel
        corner(dropdown, 12)
        stroke(dropdown, T.AccentBright, 0.18, 1.2)
        local playerScroll = Instance.new("ScrollingFrame")
        playerScroll.Name = "PlayerOptions"
        playerScroll.BackgroundTransparency = 1
        playerScroll.BorderSizePixel = 0
        playerScroll.Position = UDim2.fromOffset(5, 5)
        playerScroll.Size = UDim2.new(1, -10, 1, -10)
        playerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        playerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        playerScroll.ScrollBarThickness = 3
        playerScroll.ScrollBarImageColor3 = T.Accent
        playerScroll.ZIndex = 31
        playerScroll.Parent = dropdown
        local inventorySearch = Instance.new("TextBox")
        inventorySearch.Name = "PlayerSearch"
        inventorySearch.PlaceholderText = "Search display name or @username..."
        inventorySearch.Text = ""
        inventorySearch.ClearTextOnFocus = false
        inventorySearch.Font = Enum.Font.SourceSans
        inventorySearch.TextSize = 10
        inventorySearch.TextColor3 = T.Text
        inventorySearch.PlaceholderColor3 = T.Quiet
        inventorySearch.BackgroundColor3 = T.Surface3
        inventorySearch.BorderSizePixel = 0
        inventorySearch.Position = UDim2.fromOffset(5, 5)
        inventorySearch.Size = UDim2.new(1, -10, 0, 26)
        inventorySearch.ZIndex = 32
        inventorySearch.Parent = dropdown
        corner(inventorySearch, 8)
        playerScroll.Position = UDim2.fromOffset(5, 36)
        playerScroll.Size = UDim2.new(1, -10, 1, -41)
        local playerLayout = Instance.new("UIListLayout")
        playerLayout.Padding = UDim.new(0, 4)
        playerLayout.SortOrder = Enum.SortOrder.Name
        playerLayout.Parent = playerScroll
        local inventoryText = label(inventoryPanel, "No inventory loaded.", 10, T.Text, Enum.Font.SourceSansSemibold)
        inventoryText.Position = UDim2.new(0, 16, 0, 180)
        inventoryText.Size = UDim2.new(1, -32, 0, 76)
        inventoryText.TextWrapped = true
        inventoryText.TextYAlignment = Enum.TextYAlignment.Top

        local function getPlayerList()
            local list = {}
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then table.insert(list, plr) end
            end
            table.sort(list, function(a, b) return a.Name:lower() < b.Name:lower() end)
            return list
        end
        local function refreshInventory()
            if not selectedPlayer or not selectedPlayer.Parent then
                selectedPlayer = nil
                invName.Text = "Selected player: none"
                selectBtn.Text = "SELECT PLAYER  ▾"
                inventoryText.Text = "No player selected."
                invStatus.Text = "Choose a username from the dropdown."
                return
            end
            invName.Text = "Selected player: " .. selectedPlayer.DisplayName .. "  (@" .. selectedPlayer.Name .. ")"
            local found, seen = {}, {}
            local character = selectedPlayer.Character
            if character then
                for _, obj in ipairs(character:GetChildren()) do
                    if obj:IsA("Tool") and not seen[obj.Name] then
                        seen[obj.Name] = true
                        table.insert(found, obj.Name .. "  (equipped)")
                    end
                end
            end
            -- A remote player's Backpack is normally not replicated to other clients.
            local backpack = selectedPlayer:FindFirstChildOfClass("Backpack")
            if backpack then
                for _, obj in ipairs(backpack:GetChildren()) do
                    if obj:IsA("Tool") and not seen[obj.Name] then
                        seen[obj.Name] = true
                        table.insert(found, obj.Name .. "  (backpack visible)")
                    end
                end
            end
            if #found > 0 then
                inventoryText.Text = table.concat(found, "\n")
                invStatus.Text = "Showing Tools replicated to your client only."
            else
                inventoryText.Text = "No visible Tools found."
                invStatus.Text = "Private Backpack contents are not available through a GUI-only client script."
            end
        end
        local function rebuildPlayerDropdown()
            for _, child in ipairs(playerScroll:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end
            local query = string.lower(inventorySearch.Text or "")
            local list = {}
            for _, candidate in ipairs(getPlayerList()) do
                if query == "" or string.find(string.lower(candidate.DisplayName), query, 1, true)
                    or string.find(string.lower(candidate.Name), query, 1, true) then
                    table.insert(list, candidate)
                end
            end
            if #list == 0 then
                local empty = label(playerScroll, "No other players in this server.", 9, T.Muted, Enum.Font.SourceSans)
                empty.Size = UDim2.new(1, -6, 0, 28)
                empty.ZIndex = 32
                return
            end
            for index, plr in ipairs(list) do
                local option = button(playerScroll, plr.DisplayName .. "  @" .. plr.Name, UDim2.new(1, -4, 0, 29), T.Surface3, T.Text)
                option.Name = "Player_" .. plr.UserId
                option.TextXAlignment = Enum.TextXAlignment.Left
                option.TextSize = 10
                option.ZIndex = 32
                option.LayoutOrder = index
                option.MouseButton1Click:Connect(function()
                    selectedPlayer = plr
                    selectBtn.Text = plr.DisplayName .. "  ▾"
                    dropdown.Visible = false
                    refreshInventory()
                end)
            end
        end
        inventorySearch:GetPropertyChangedSignal("Text"):Connect(function()
            if dropdown.Visible then rebuildPlayerDropdown() end
        end)
        selectBtn.MouseButton1Click:Connect(function()
            dropdown.Visible = not dropdown.Visible
            if dropdown.Visible then rebuildPlayerDropdown() end
        end)
        refreshBtn.MouseButton1Click:Connect(refreshInventory)
        addConnection(Players.PlayerAdded:Connect(function()
            if dropdown.Visible then rebuildPlayerDropdown() end
        end))
        addConnection(Players.PlayerRemoving:Connect(function(plr)
            if plr == selectedPlayer then selectedPlayer = nil; refreshInventory() end
            if dropdown.Visible then rebuildPlayerDropdown() end
        end))

        local rangePanel = panelFor(p, 102)
        local rangeTitle = label(rangePanel, "EXTENDED ESP RANGE", 9, T.Accent, Enum.Font.RobotoMono)
        rangeTitle.Position = UDim2.new(0, 16, 0, 13)
        rangeTitle.Size = UDim2.new(1, -32, 0, 16)
        local rangeDesc = label(rangePanel, "Up to 70,000 studs when character data is present locally.", 10, T.Text, Enum.Font.SourceSansSemibold)
        rangeDesc.Position = UDim2.new(0, 16, 0, 36)
        rangeDesc.Size = UDim2.new(1, -32, 0, 18)
        local streamNote = label(rangePanel, "StreamingEnabled can prevent distant characters from existing on your client; this GUI cannot force them to load.", 9, T.Muted, Enum.Font.SourceSans)
        streamNote.Position = UDim2.new(0, 16, 0, 59)
        streamNote.Size = UDim2.new(1, -32, 0, 32)
        streamNote.TextWrapped = true
        streamNote.TextYAlignment = Enum.TextYAlignment.Top

        section(p, "Movement & player tools")

        -- These controls intentionally call server-authorised remotes. The
        -- server must validate the caller/target whitelist before applying
        -- knockback or flight; a client-only GUI cannot authoritatively fling
        -- another player's character.
        local actionPanel = panelFor(p, 390)
        local actionTitle = label(actionPanel, "PLAYER KNOCKBACK", 9, T.Accent, Enum.Font.RobotoMono)
        actionTitle.Position = UDim2.new(0, 16, 0, 12)
        actionTitle.Size = UDim2.new(1, -32, 0, 16)
        local actionDesc = label(actionPanel, "Select a player, then send an authorised knockback request.", 9, T.Muted, Enum.Font.SourceSans)
        actionDesc.Position = UDim2.new(0, 16, 0, 32)
        actionDesc.Size = UDim2.new(1, -32, 0, 25)
        actionDesc.TextWrapped = true

        local flingSelected = nil
        local flingSelect = button(actionPanel, "SELECT PLAYER  ▾", UDim2.new(0.58, -8, 0, 36), T.Surface3, T.AccentBright)
        flingSelect.Position = UDim2.new(0, 14, 0, 66)
        flingSelect.TextSize = 9
        local flingButton = button(actionPanel, "FLING", UDim2.new(0.42, -8, 0, 36), T.AccentSoft, T.AccentBright)
        flingButton.Position = UDim2.new(0.58, 0, 0, 66)
        flingButton.TextSize = 10

        local flingDrop = Instance.new("Frame")
        flingDrop.Name = "FlingPlayerDropdown"
        flingDrop.Visible = false
        flingDrop.BackgroundColor3 = T.Surface2
        flingDrop.BorderSizePixel = 0
        flingDrop.Position = UDim2.new(0, 14, 0, 105)
        flingDrop.Size = UDim2.new(0.58, -8, 0, 92)
        flingDrop.ZIndex = 40
        flingDrop.Parent = actionPanel
        corner(flingDrop, 11)
        stroke(flingDrop, T.AccentBright, 0.16, 1.2)
        local flingScroll = Instance.new("ScrollingFrame")
        flingScroll.Name = "FlingPlayerOptions"
        flingScroll.BackgroundTransparency = 1
        flingScroll.BorderSizePixel = 0
        flingScroll.Position = UDim2.fromOffset(5, 5)
        flingScroll.Size = UDim2.new(1, -10, 1, -10)
        flingScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        flingScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        flingScroll.ScrollBarThickness = 3
        flingScroll.ScrollBarImageColor3 = T.Accent
        flingScroll.ZIndex = 41
        flingScroll.Parent = flingDrop
        local flingSearch = Instance.new("TextBox")
        flingSearch.Name = "FlingPlayerSearch"
        flingSearch.PlaceholderText = "Search display name or @username..."
        flingSearch.Text = ""
        flingSearch.ClearTextOnFocus = false
        flingSearch.Font = Enum.Font.SourceSans
        flingSearch.TextSize = 9
        flingSearch.TextColor3 = T.Text
        flingSearch.PlaceholderColor3 = T.Quiet
        flingSearch.BackgroundColor3 = T.Surface3
        flingSearch.BorderSizePixel = 0
        flingSearch.Position = UDim2.fromOffset(5, 5)
        flingSearch.Size = UDim2.new(1, -10, 0, 25)
        flingSearch.ZIndex = 42
        flingSearch.Parent = flingDrop
        corner(flingSearch, 8)
        flingScroll.Position = UDim2.fromOffset(5, 35)
        flingScroll.Size = UDim2.new(1, -10, 1, -40)
        local flingLayout = Instance.new("UIListLayout")
        flingLayout.Padding = UDim.new(0, 3)
        flingLayout.Parent = flingScroll

        local function rebuildFlingPlayers()
            for _, child in ipairs(flingScroll:GetChildren()) do
                if child:IsA("TextButton") or child:IsA("TextLabel") then child:Destroy() end
            end
            local query = string.lower(flingSearch.Text or "")
            local candidates = {}
            for _, candidate in ipairs(getPlayerList()) do
                if query == "" or string.find(string.lower(candidate.DisplayName), query, 1, true)
                    or string.find(string.lower(candidate.Name), query, 1, true) then
                    table.insert(candidates, candidate)
                end
            end
            if #candidates == 0 then
                local empty = label(flingScroll, "No other players found.", 9, T.Muted, Enum.Font.SourceSans)
                empty.Size = UDim2.new(1, -6, 0, 26)
                empty.ZIndex = 42
                return
            end
            for i, plr in ipairs(candidates) do
                local option = button(flingScroll, plr.DisplayName .. "  @" .. plr.Name, UDim2.new(1, -4, 0, 27), T.Surface3, T.Text)
                option.Name = "FlingTarget_" .. plr.UserId
                option.TextXAlignment = Enum.TextXAlignment.Left
                option.TextSize = 9
                option.LayoutOrder = i
                option.ZIndex = 42
                option.MouseButton1Click:Connect(function()
                    flingSelected = plr
                    flingSelect.Text = plr.DisplayName .. "  ▾"
                    flingDrop.Visible = false
                end)
            end
        end
        flingSearch:GetPropertyChangedSignal("Text"):Connect(function()
            if flingDrop.Visible then rebuildFlingPlayers() end
        end)
        flingSelect.MouseButton1Click:Connect(function()
            flingDrop.Visible = not flingDrop.Visible
            if flingDrop.Visible then rebuildFlingPlayers() end
        end)
        flingButton.MouseButton1Click:Connect(function()
            if not flingSelected or not flingSelected.Parent then
                notify("Player knockback", "Choose a player first.")
                return
            end
            local remote = ReplicatedStorage:FindFirstChild("JT3R_FlingControl")
            if not remote or not remote:IsA("RemoteEvent") then
                notify("Player knockback", "Server controller missing. Add the authorised JT3R movement controller to your own experience.")
                return
            end
            remote:FireServer({Action = "Knockback", TargetUserId = flingSelected.UserId})
            notify("Player knockback", "Request sent for " .. flingSelected.Name .. ". The server decides whether it is authorised.")
        end)

        addConnection(Players.PlayerAdded:Connect(function()
            if flingDrop.Visible then rebuildFlingPlayers() end
        end))
        addConnection(Players.PlayerRemoving:Connect(function(plr)
            if plr == flingSelected then
                flingSelected = nil
                flingSelect.Text = "SELECT PLAYER  ▾"
            end
            if flingDrop.Visible then rebuildFlingPlayers() end
        end))

        section(p, "Owners only")
        local ownerPanel = panelFor(p, 126)
        stroke(ownerPanel, T.AccentBright, 0.24, 1.25)
        local ownerKicker = label(ownerPanel, "RESTRICTED MODULE  /  OWNER ACCESS", 8, T.Accent, Enum.Font.RobotoMono)
        ownerKicker.Position = UDim2.new(0, 15, 0, 12)
        ownerKicker.Size = UDim2.new(1, -30, 0, 14)
        local ownerTitle = label(ownerPanel, "DUPE", 19, T.Text, Enum.Font.Merriweather)
        ownerTitle.Position = UDim2.new(0, 15, 0, 31)
        ownerTitle.Size = UDim2.new(0.48, -15, 0, 28)
        local ownerLock = label(ownerPanel, "  LOCKED", 8, T.AccentBright, Enum.Font.RobotoMono, Enum.TextXAlignment.Right)
        ownerLock.AnchorPoint = Vector2.new(1, 0)
        ownerLock.Position = UDim2.new(1, -15, 0, 36)
        ownerLock.Size = UDim2.new(0.5, 0, 0, 18)
        local ownerDesc = label(ownerPanel, "Visible to everyone. Usage is disabled until owner permissions are configured.", 9, T.Muted, Enum.Font.SourceSans)
        ownerDesc.Position = UDim2.new(0, 15, 0, 65)
        ownerDesc.Size = UDim2.new(1, -30, 0, 26)
        ownerDesc.TextWrapped = true
        ownerDesc.TextYAlignment = Enum.TextYAlignment.Top
        local dupeButton = button(ownerPanel, "DUPE  •  LOCKED", UDim2.new(0, 122, 0, 32), T.Surface3, T.Quiet)
        dupeButton.AnchorPoint = Vector2.new(1, 1)
        dupeButton.Position = UDim2.new(1, -14, 1, -10)
        dupeButton.Active = false
        dupeButton.Selectable = false
        dupeButton.AutoButtonColor = false
        dupeButton.TextSize = 9
        dupeButton.TextTransparency = 0.12

        section(p, "Quick utilities")
        miniAction(p, "Test notification", "Preview the JT3R notification style.", "TEST", function()
            notify("JT3R notification", "Your interface notifications are working.")
        end)
        miniAction(p, "Return to dashboard", "Jump back to the main command overview.", "HOME", function()
            setPage("Home")
        end)
    end
end

local function applyPanelFinish()
    for _, obj in ipairs(screenGui:GetDescendants()) do
        if obj:IsA("Frame") and obj:GetAttribute("JT3RPanel") then
            obj.BackgroundTransparency = glassEnabled and 0.13 or 0
            local edge = obj:FindFirstChildOfClass("UIStroke")
            if edge then edge.Transparency = glassEnabled and 0.78 or 0.18 end
            local sheen = obj:FindFirstChildOfClass("UIGradient")
            if sheen then sheen.Enabled = glassEnabled end
        end
    end
end

-- Settings
do
    local p = pages.Settings
    section(p, "Appearance")
    local themePanel = panelFor(p, 142)
    local thTitle = label(themePanel, "Interface theme", 13, T.Text, Enum.Font.SourceSansSemibold)
    thTitle.Position = UDim2.new(0, 16, 0, 13)
    thTitle.Size = UDim2.new(1, -32, 0, 20)
    local thDesc = label(themePanel, "Choose an accent profile.", 10, T.Muted, Enum.Font.SourceSans)
    thDesc.Position = UDim2.new(0, 16, 0, 36)
    thDesc.Size = UDim2.new(1, -32, 0, 17)
    local themeButtons = {}
    local themeNames = {"Obsidian", "Platinum", "Crimson", "Midnight"}
    for i, name in ipairs(themeNames) do
        local b = button(themePanel, name, UDim2.new(0.22, 0, 0, 34), T.Surface2, T.Muted)
        b.Position = UDim2.new(0.02 + (i - 1) * 0.245, 0, 0, 83)
        b.TextSize = 9
        themeButtons[name] = b
    end
    section(p, "Surface & lighting")
    local finishPanel = panelFor(p, 112)
    local glassTitle = label(finishPanel, "Liquid glass finish", 12, T.Text, Enum.Font.SourceSansSemibold)
    glassTitle.Position = UDim2.new(0, 16, 0, 12)
    glassTitle.Size = UDim2.new(0.62, 0, 0, 20)
    local glassDesc = label(finishPanel, "Smoked translucent panels and soft edge sheen.", 9, T.Muted, Enum.Font.SourceSans)
    glassDesc.Position = UDim2.new(0, 16, 0, 35)
    glassDesc.Size = UDim2.new(1, -32, 0, 16)
    local glassButton = button(finishPanel, "ON", UDim2.fromOffset(58, 30), T.AccentSoft, T.AccentBright)
    glassButton.AnchorPoint = Vector2.new(1, 0)
    glassButton.Position = UDim2.new(1, -14, 0, 13)
    glassButton.MouseButton1Click:Connect(function()
        glassEnabled = not glassEnabled
        glassButton.Text = glassEnabled and "ON" or "OFF"
        applyPanelFinish()
        notify("Surface finish", glassEnabled and "Liquid glass enabled." or "Solid surfaces enabled.")
    end)
    local lightTitle = label(finishPanel, "Ambient edge lighting", 12, T.Text, Enum.Font.SourceSansSemibold)
    lightTitle.Position = UDim2.new(0, 16, 0, 65)
    lightTitle.Size = UDim2.new(0.62, 0, 0, 20)
    local lightDesc = label(finishPanel, "A restrained champagne halo around the window.", 9, T.Muted, Enum.Font.SourceSans)
    lightDesc.Position = UDim2.new(0, 16, 0, 87)
    lightDesc.Size = UDim2.new(1, -32, 0, 16)
    local lightButton = button(finishPanel, "ON", UDim2.fromOffset(58, 30), T.AccentSoft, T.AccentBright)
    lightButton.AnchorPoint = Vector2.new(1, 0)
    lightButton.Position = UDim2.new(1, -14, 0, 66)
    lightButton.MouseButton1Click:Connect(function()
        ambientEnabled = not ambientEnabled
        ambientHalo.Visible = ambientEnabled
        lightButton.Text = ambientEnabled and "ON" or "OFF"
        notify("Ambient lighting", ambientEnabled and "Champagne edge lighting enabled." or "Ambient lighting disabled.")
    end)

    local applyScale, applyTheme

    section(p, "Motion & feedback")
    local motionPanel = panelFor(p, 76)
    local motionTitle = label(motionPanel, "Interface animations", 12, T.Text, Enum.Font.SourceSansSemibold)
    motionTitle.Position = UDim2.new(0, 15, 0, 10)
    motionTitle.Size = UDim2.new(0.66, 0, 0, 20)
    local motionDesc = label(motionPanel, "Page fades, toast movement and subtle UI motion.", 9, T.Muted, Enum.Font.SourceSans)
    motionDesc.Position = UDim2.new(0, 15, 0, 34)
    motionDesc.Size = UDim2.new(1, -88, 0, 26)
    motionDesc.TextWrapped = true
    local motionButton = button(motionPanel, "ON", UDim2.fromOffset(58, 30), T.AccentSoft, T.AccentBright)
    motionButton.AnchorPoint = Vector2.new(1, 0)
    motionButton.Position = UDim2.new(1, -13, 0, 20)
    motionButton.MouseButton1Click:Connect(function()
        animationsEnabled = not animationsEnabled
        motionButton.Text = animationsEnabled and "ON" or "OFF"
        motionButton.BackgroundColor3 = animationsEnabled and T.AccentSoft or T.Surface3
        motionButton.TextColor3 = animationsEnabled and T.AccentBright or T.Muted
        notify("Interface motion", animationsEnabled and "Smooth animations enabled." or "Reduced motion enabled.")
    end)

    section(p, "Accent lighting")
    local rgbPanel = panelFor(p, 76)
    local rgbTitle = label(rgbPanel, "RAINBOW / RGB ACCENTS", 12, T.Text, Enum.Font.SourceSansSemibold)
    rgbTitle.Position = UDim2.new(0, 15, 0, 10)
    rgbTitle.Size = UDim2.new(0.62, 0, 0, 20)
    local rgbDesc = label(rgbPanel, "Slow colour movement on selected trim only.", 9, T.Muted, Enum.Font.SourceSans)
    rgbDesc.Position = UDim2.new(0, 15, 0, 34)
    rgbDesc.Size = UDim2.new(1, -30, 0, 15)
    local rgbButton = button(rgbPanel, "OFF", UDim2.fromOffset(58, 30), T.Surface3, T.Muted)
    rgbButton.AnchorPoint = Vector2.new(1, 0)
    rgbButton.Position = UDim2.new(1, -13, 0, 12)
    local function syncRGBButton()
        rgbButton.Text = rgbModeEnabled and "ON" or "OFF"
        rgbButton.BackgroundColor3 = rgbModeEnabled and T.AccentSoft or T.Surface3
        rgbButton.TextColor3 = rgbModeEnabled and T.AccentBright or T.Muted
    end
    syncRGBButton()
    rgbButton.Activated:Connect(function()
        setRGBMode(not rgbModeEnabled)
        syncRGBButton()
    end)
    rgbModeButton:GetPropertyChangedSignal("Text"):Connect(syncRGBButton)


    section(p, "Quick controls")
    local quickPanel = panelFor(p, 76)
    local resetTitle = label(quickPanel, "Restore default appearance", 11, T.Text, Enum.Font.SourceSansSemibold)
    resetTitle.Position = UDim2.new(0, 14, 0, 8)
    resetTitle.Size = UDim2.new(1, -130, 0, 20)
    local resetDesc = label(quickPanel, "Reset theme, lighting, scale and motion settings.", 8, T.Muted, Enum.Font.SourceSans)
    resetDesc.Position = UDim2.new(0, 14, 0, 32)
    resetDesc.Size = UDim2.new(1, -130, 0, 18)
    local resetButton = button(quickPanel, "RESET", UDim2.fromOffset(92, 32), T.Surface3, T.AccentBright)
    resetButton.AnchorPoint = Vector2.new(1, 0.5)
    resetButton.Position = UDim2.new(1, -12, 0.5, 0)
    local resetArmed = false
    resetButton.Activated:Connect(function()
        if not resetArmed then
            resetArmed = true
            resetButton.Text = "CONFIRM?"
            notify("Confirm reset", "Tap RESET again to restore default appearance.")
            task.delay(4, function()
                if resetButton and resetButton.Parent then
                    resetArmed = false
                    resetButton.Text = "RESET"
                end
            end)
            return
        end
        resetArmed = false
        resetButton.Text = "RESET"
        applyTheme("Obsidian")
        glassEnabled = true
        applyPanelFinish()
        ambientEnabled = true
        ambientHalo.Visible = true
        applyScale(1)
        animationsEnabled = true
        motionButton.Text = "ON"
        motionButton.BackgroundColor3 = T.AccentSoft
        motionButton.TextColor3 = T.AccentBright
        glassButton.Text = "ON"
        lightButton.Text = "ON"
        setRGBMode(false)
        syncRGBButton()
        notify("Defaults restored", "Obsidian appearance and motion settings restored.")
    end)

    section(p, "Configurations")
    local configPanel = panelFor(p, 276)
    local configTitle = label(configPanel, "PERSISTENT CONFIGURATION LIBRARY", 10, T.Text, Enum.Font.RobotoMono)
    configTitle.Position = UDim2.new(0, 15, 0, 10)
    configTitle.Size = UDim2.new(1, -30, 0, 16)
    local configDesc = label(configPanel, "Named presets are stored on this device and remain after rejoining.", 9, T.Muted, Enum.Font.SourceSans)
    configDesc.Position = UDim2.new(0, 15, 0, 29)
    configDesc.Size = UDim2.new(1, -30, 0, 14)

    local configName = Instance.new("TextBox")
    configName.Name = "ConfigName"
    configName.ClearTextOnFocus = false
    configName.PlaceholderText = "Enter a preset name"
    configName.Text = "My Config"
    configName.TextSize = 11
    configName.Font = Enum.Font.SourceSans
    configName.TextColor3 = T.Text
    configName.PlaceholderColor3 = T.Quiet
    configName.BackgroundColor3 = T.Surface2
    configName.BorderSizePixel = 0
    configName.Size = UDim2.new(1, -28, 0, 32)
    configName.Position = UDim2.new(0, 14, 0, 51)
    configName.Parent = configPanel
    corner(configName, 9)
    padding(configName, 10, 10, 0, 0)

    local configSave = button(configPanel, "SAVE / OVERWRITE", UDim2.new(0.48, -5, 0, 30), T.AccentSoft, T.AccentBright)
    configSave.Position = UDim2.new(0, 14, 0, 91)
    local configLoad = button(configPanel, "LOAD", UDim2.new(0.24, -4, 0, 30), T.Surface2, T.Text)
    configLoad.Position = UDim2.new(0.52, 0, 0, 91)
    local configDelete = button(configPanel, "DELETE", UDim2.new(0.24, -4, 0, 30), T.Surface2, T.Danger)
    configDelete.Position = UDim2.new(0.76, -1, 0, 91)

    local configStatus = label(configPanel, "Checking device storage...", 8, T.Quiet, Enum.Font.SourceSans)
    configStatus.Position = UDim2.new(0, 15, 0, 127)
    configStatus.Size = UDim2.new(1, -30, 0, 14)

    local configList = Instance.new("ScrollingFrame")
    configList.Name = "SavedConfigList"
    configList.BackgroundColor3 = T.Surface2
    configList.BackgroundTransparency = 0.18
    configList.BorderSizePixel = 0
    configList.Position = UDim2.new(0, 14, 0, 148)
    configList.Size = UDim2.new(1, -28, 0, 112)
    configList.ScrollBarThickness = 2
    configList.ScrollBarImageColor3 = T.Accent
    configList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    configList.CanvasSize = UDim2.new(0, 0, 0, 0)
    configList.Parent = configPanel
    corner(configList, 10)
    padding(configList, 7, 7, 7, 7)
    local configListLayout = listLayout(configList, Enum.FillDirection.Vertical, 5)

    local configFolder = "JT3R/FUNHOUSE/Configs"
    local configStorageReady = false
    local function configPath(name)
        return configFolder .. "/" .. name .. ".json"
    end
    local function cleanConfigName(name)
        name = tostring(name or ""):gsub("^%s+", ""):gsub("%s+$", "")
        name = name:gsub("[^%w _%-]", ""):gsub("%s+", "_")
        if #name > 28 then name = name:sub(1, 28) end
        return name
    end
    local function ensureConfigStorage()
        if type(writefile) ~= "function" or type(readfile) ~= "function"
            or type(isfile) ~= "function" or type(listfiles) ~= "function" then
            return false, "This executor does not expose the required device file APIs."
        end
        local ok = pcall(function()
            if type(isfolder) == "function" and not isfolder("JT3R") then makefolder("JT3R") end
            if type(isfolder) == "function" and not isfolder("JT3R/FUNHOUSE") then makefolder("JT3R/FUNHOUSE") end
            if type(isfolder) == "function" and not isfolder(configFolder) then makefolder(configFolder) end
        end)
        if not ok then return false, "Could not create the JT3R config folder." end
        local listed, files = pcall(listfiles, configFolder)
        if not listed then return false, "Could not read the config folder." end
        return true
    end
    local function captureConfig()
        return {
            version = 1,
            theme = currentThemeName,
            glass = glassEnabled,
            ambient = ambientEnabled,
            scale = userScale,
            animations = animationsEnabled,
        }
    end
    local function applySavedConfig(saved)
        if type(saved) ~= "table" then return false end
        if saved.theme and Themes[saved.theme] and applyTheme then applyTheme(saved.theme) end
        glassEnabled = saved.glass ~= false
        applyPanelFinish()
        ambientEnabled = saved.ambient ~= false
        ambientHalo.Visible = ambientEnabled
        applyScale(tonumber(saved.scale) or 1)
        animationsEnabled = saved.animations ~= false
        motionButton.Text = animationsEnabled and "ON" or "OFF"
        motionButton.BackgroundColor3 = animationsEnabled and T.AccentSoft or T.Surface3
        motionButton.TextColor3 = animationsEnabled and T.AccentBright or T.Muted
        glassButton.Text = glassEnabled and "ON" or "OFF"
        lightButton.Text = ambientEnabled and "ON" or "OFF"
        return true
    end
    local function refreshConfigList()
        for _, child in ipairs(configList:GetChildren()) do
            if child:IsA("TextButton") or child.Name == "EmptyMessage" then child:Destroy() end
        end
        if not configStorageReady then
            configStatus.Text = "Persistent storage unavailable in this executor."
            return
        end
        local ok, files = pcall(listfiles, configFolder)
        if not ok then
            configStatus.Text = "Unable to list saved presets."
            return
        end
        local names = {}
        for _, path in ipairs(files) do
            local name = tostring(path):match("([^/\\]+)%.json$")
            if name then table.insert(names, name) end
        end
        table.sort(names, function(a, b) return string.lower(a) < string.lower(b) end)
        configStatus.Text = tostring(#names) .. " saved preset(s)  •  Tap one to select"
        if #names == 0 then
            local empty = label(configList, "No presets saved yet.", 9, T.Quiet, Enum.Font.SourceSans)
            empty.Name = "EmptyMessage"
            empty.Size = UDim2.new(1, 0, 0, 24)
            return
        end
        for index, name in ipairs(names) do
            local item = button(configList, name, UDim2.new(1, 0, 0, 28), T.Surface3, T.Text)
            item.Name = "Preset_" .. name
            item.LayoutOrder = index
            item.TextXAlignment = Enum.TextXAlignment.Left
            item.TextSize = 10
            padding(item, 10, 8, 0, 0)
            item.MouseButton1Click:Connect(function()
                configName.Text = name
                configStatus.Text = "Selected preset: " .. name
            end)
        end
    end
    local storageOK, storageMessage = ensureConfigStorage()
    configStorageReady = storageOK
    if storageOK then
        configStatus.Text = "Device storage ready • presets persist between sessions"
        refreshConfigList()
    else
        configStatus.Text = storageMessage .. " Session-only saving is unavailable here."
    end

    configSave.MouseButton1Click:Connect(function()
        if not configStorageReady then
            notify("Configuration", "Persistent saving is not supported by this executor.")
            return
        end
        local name = cleanConfigName(configName.Text)
        if name == "" then
            notify("Configuration", "Enter a valid preset name first.")
            return
        end
        local ok, encoded = pcall(function() return HttpService:JSONEncode(captureConfig()) end)
        if not ok then
            notify("Configuration", "Could not encode this preset.")
            return
        end
        local written = pcall(writefile, configPath(name), encoded)
        if not written then
            notify("Configuration", "Could not save the preset to device storage.")
            return
        end
        configName.Text = name
        refreshConfigList()
        notify("Configuration", name .. " saved on this device.")
    end)
    configLoad.MouseButton1Click:Connect(function()
        if not configStorageReady then
            notify("Configuration", "Persistent saving is not supported by this executor.")
            return
        end
        local name = cleanConfigName(configName.Text)
        if name == "" or not isfile(configPath(name)) then
            notify("Configuration", "That preset was not found.")
            return
        end
        local ok, saved = pcall(function()
            return HttpService:JSONDecode(readfile(configPath(name)))
        end)
        if not ok or not applySavedConfig(saved) then
            notify("Configuration", "Preset could not be read or was invalid.")
            return
        end
        notify("Configuration", name .. " loaded.")
    end)
    configDelete.MouseButton1Click:Connect(function()
        if not configStorageReady or type(delfile) ~= "function" then
            notify("Configuration", "Delete is not supported by this executor.")
            return
        end
        local name = cleanConfigName(configName.Text)
        if name == "" or not isfile(configPath(name)) then
            notify("Configuration", "That preset was not found.")
            return
        end
        local ok = pcall(delfile, configPath(name))
        if not ok then
            notify("Configuration", "Could not delete that preset.")
            return
        end
        refreshConfigList()
        notify("Configuration", name .. " deleted from this device.")
    end)

    section(p, "Interface")
    local uiPanel = panelFor(p, 86)
    local scaleTitle = label(uiPanel, "Interface scale", 12, T.Text, Enum.Font.SourceSansSemibold)
    scaleTitle.Position = UDim2.new(0, 16, 0, 13)
    scaleTitle.Size = UDim2.new(0.55, 0, 0, 20)
    local scaleValue = label(uiPanel, "100%", 10, T.Accent, Enum.Font.RobotoMono, Enum.TextXAlignment.Right)
    scaleValue.Position = UDim2.new(0.55, 0, 0, 13)
    scaleValue.Size = UDim2.new(0.4, -16, 0, 20)
    local scaleTrack = Instance.new("Frame")
    scaleTrack.BackgroundColor3 = T.Surface3
    scaleTrack.BorderSizePixel = 0
    scaleTrack.Position = UDim2.new(0, 16, 0, 50)
    scaleTrack.Size = UDim2.new(1, -32, 0, 5)
    scaleTrack.Parent = uiPanel
    corner(scaleTrack, 5)
    local scaleFill = Instance.new("Frame")
    scaleFill.BackgroundColor3 = T.Accent
    scaleFill.BorderSizePixel = 0
    scaleFill.Size = UDim2.new(0.5, 0, 1, 0)
    scaleFill.Parent = scaleTrack
    corner(scaleFill, 5)
    local scaleKnob = Instance.new("TextButton")
    scaleKnob.Text = ""
    scaleKnob.AutoButtonColor = false
    scaleKnob.BackgroundColor3 = T.AccentBright
    scaleKnob.Size = UDim2.fromOffset(13, 13)
    scaleKnob.AnchorPoint = Vector2.new(0.5, 0.5)
    scaleKnob.Position = UDim2.new(0.5, 0, 0.5, 0)
    scaleKnob.Parent = scaleTrack
    corner(scaleKnob, 10)
    applyScale = function(value)
        value = math.clamp(value, 0.82, 1.08)
        userScale = value
        shellScale.Scale = value
        scaleFill.Size = UDim2.new((value - 0.82) / 0.26, 0, 1, 0)
        scaleKnob.Position = UDim2.new((value - 0.82) / 0.26, 0, 0.5, 0)
        scaleValue.Text = tostring(math.floor(value * 100 + 0.5)) .. "%"
    end
    applyScale(1)
    local draggingScale = false
    local function updateScale(input)
        local x = math.clamp((input.Position.X - scaleTrack.AbsolutePosition.X) / scaleTrack.AbsoluteSize.X, 0, 1)
        applyScale(0.82 + x * 0.26)
    end
    scaleKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingScale = true
            updateScale(input)
        end
    end)
    addConnection(UserInputService.InputChanged:Connect(function(input)
        if draggingScale and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateScale(input)
        end
    end))
    addConnection(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingScale = false
        end
    end))
    applyTheme = function(name)
        local previous = T
        local selected = Themes[name]
        if not selected then return end
        local paletteKeys = {"Background", "Surface", "Surface2", "Surface3", "Border", "Accent",
            "AccentBright", "AccentSoft", "Text", "Muted", "Quiet", "Success", "Danger"}
        local colorMap = {}
        for _, key in ipairs(paletteKeys) do
            colorMap[previous[key]] = selected[key]
        end
        T = selected
        currentThemeName = name
        for _, object in ipairs(screenGui:GetDescendants()) do
            if object:IsA("GuiObject") then
                local ok, oldColor = pcall(function() return object.BackgroundColor3 end)
                if ok and colorMap[oldColor] then object.BackgroundColor3 = colorMap[oldColor] end
                if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
                    local oldText = object.TextColor3
                    if colorMap[oldText] then object.TextColor3 = colorMap[oldText] end
                end
            elseif object:IsA("UIStroke") then
                local oldStroke = object.Color
                if colorMap[oldStroke] then object.Color = colorMap[oldStroke] end
            end
        end
        for themeName, themeButton in pairs(themeButtons) do
            themeButton.BackgroundColor3 = themeName == name and T.AccentSoft or T.Surface2
            themeButton.TextColor3 = themeName == name and T.AccentBright or T.Muted
        end
        for pageName, nav in pairs(pageButtons) do
            local selectedPage = pageName == currentPage
            nav.BackgroundColor3 = selectedPage and T.AccentSoft or T.Surface
            nav.TextColor3 = selectedPage and T.AccentBright or T.Muted
            local navIcon = nav:FindFirstChild("NavIcon")
            if navIcon then navIcon.TextColor3 = selectedPage and T.AccentBright or T.Quiet end
        end
        topAccent.BackgroundColor3 = T.Accent
        notify("Appearance updated", name .. " theme applied.")
    end
    for name, b in pairs(themeButtons) do
        b.MouseButton1Click:Connect(function()
            applyTheme(name)
        end)
    end
    section(p, "Session controls")
    local exitPanel = panelFor(p, 78)
    local exitTitle = label(exitPanel, "Uninject JT3R", 12, T.Text, Enum.Font.SourceSansSemibold)
    exitTitle.Position = UDim2.new(0, 15, 0, 10)
    exitTitle.Size = UDim2.new(1, -130, 0, 20)
    local exitDesc = label(exitPanel, "Close the interface and disconnect its listeners.", 9, T.Muted, Enum.Font.SourceSans)
    exitDesc.Position = UDim2.new(0, 15, 0, 34)
    exitDesc.Size = UDim2.new(1, -130, 0, 16)
    local exitButton = button(exitPanel, "UNINJECT", UDim2.fromOffset(96, 34), T.Danger, T.Text)
    exitButton.AnchorPoint = Vector2.new(1, 0.5)
    exitButton.Position = UDim2.new(1, -12, 0.5, 0)
    exitButton.MouseButton1Click:Connect(function()
        notify("JT3R", "Uninjecting interface...")
        task.delay(0.12, uninject)
    end)
end

-- Console
do
    local p = pages.Console
    section(p, "Session log")
    local logPanel = panelFor(p, 126)
    local logTitle = label(logPanel, "JT3R FUNHOUSE v8.0 initialised", 12, T.Text, Enum.Font.SourceSansSemibold)
    logTitle.Position = UDim2.new(0, 16, 0, 16)
    logTitle.Size = UDim2.new(1, -32, 0, 20)
    local logDesc = label(logPanel, "UI v8.0  •  Obsidian Atelier  •  Local session", 10, T.Muted, Enum.Font.SourceSans)
    logDesc.Position = UDim2.new(0, 16, 0, 43)
    logDesc.Size = UDim2.new(1, -32, 0, 18)
    local logState = label(logPanel, "●  STATUS     READY", 9, T.Success, Enum.Font.RobotoMono)
    logState.Position = UDim2.new(0, 16, 0, 78)
    logState.Size = UDim2.new(1, -32, 0, 18)
    local logTime = label(logPanel, os.date("%H:%M:%S") .. "  •  " .. os.date("%d %b %Y"), 8, T.Quiet, Enum.Font.SourceSans)
    logTime.AnchorPoint = Vector2.new(1, 0)
    logTime.Position = UDim2.new(1, -16, 0, 16)
    logTime.Size = UDim2.new(0.48, 0, 0, 18)
    logTime.TextXAlignment = Enum.TextXAlignment.Right
    section(p, "Actions")
    local clearPanel = panelFor(p, 62)
    local clearText = label(clearPanel, "Clear local session log", 11, T.Text, Enum.Font.SourceSansSemibold)
    clearText.Position = UDim2.new(0, 15, 0, 10)
    clearText.Size = UDim2.new(1, -125, 0, 40)
    local clear = button(clearPanel, "CLEAR", UDim2.fromOffset(88, 34), T.Surface2, T.AccentBright)
    clear.AnchorPoint = Vector2.new(1, 0.5)
    clear.Position = UDim2.new(1, -12, 0.5, 0)
    clear.MouseButton1Click:Connect(function()
        logTitle.Text = "Session log cleared"
        logDesc.Text = "No additional events recorded."
        logState.Text = "●  STATUS     READY"
        logTime.Text = os.date("%H:%M:%S") .. "  •  " .. os.date("%d %b %Y")
        notify("Console", "Local session log cleared.")
    end)
    section(p, "Interface")
    local exitPanel = panelFor(p, 68)
    local exitText = label(exitPanel, "End this local interface session", 10, T.Text, Enum.Font.SourceSansSemibold)
    exitText.Position = UDim2.new(0, 14, 0, 10)
    exitText.Size = UDim2.new(1, -118, 0, 42)
    local exit = button(exitPanel, "UNINJECT", UDim2.fromOffset(88, 34), T.Danger, T.Text)
    exit.AnchorPoint = Vector2.new(1, 0.5)
    exit.Position = UDim2.new(1, -12, 0.5, 0)
    exit.MouseButton1Click:Connect(function() uninject() end)
end

--// Navigation buttons
for index, item in ipairs(navItems) do
    local name, glyph = item[1], item[2]
    local b = Instance.new("TextButton")
    b.Name = name
    b.AutoButtonColor = false
    b.BackgroundColor3 = T.Surface
    b.BorderSizePixel = 0
    b.Size = UDim2.new(1, 0, 0, 42)
    b.Text = ""
    b.ClipsDescendants = true
    b.LayoutOrder = index
    b.Parent = navHolder
    corner(b, 12)
    luxurySurface(b, true)
    local navInset = Instance.new("Frame")
    navInset.Name = "NavInset"
    navInset.BackgroundTransparency = 1
    navInset.BorderSizePixel = 0
    navInset.Position = UDim2.new(0, 4, 0, 4)
    navInset.Size = UDim2.new(1, -8, 1, -8)
    navInset.ZIndex = 2
    navInset.Active = false
    navInset.Parent = b
    corner(navInset, 9)
    local navInsetStroke = stroke(navInset, T.AccentBright, 0.96, 1)
    navInsetStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local navGradient=Instance.new("UIGradient")
    navGradient.Color=ColorSequence.new(Color3.fromRGB(32,28,22),Color3.fromRGB(17,17,18))
    navGradient.Parent=b
    local activeMarker = Instance.new("Frame")
    activeMarker.Name = "ActiveGoldMarker"
    activeMarker.BackgroundColor3 = T.AccentBright
    activeMarker.BorderSizePixel = 0
    activeMarker.Position = UDim2.new(0, 0, 0.18, 0)
    activeMarker.Size = UDim2.new(0, 3, 0.64, 0)
    activeMarker.Visible = false
    activeMarker.Parent = b
    corner(activeMarker, 3)
    local activeDot = Instance.new("Frame")
    activeDot.Name = "ActiveNavDot"
    activeDot.BackgroundColor3 = T.AccentBright
    activeDot.BorderSizePixel = 0
    activeDot.AnchorPoint = Vector2.new(1, 0.5)
    activeDot.Position = UDim2.new(1, -10, 0.5, 0)
    activeDot.Size = UDim2.fromOffset(4, 4)
    activeDot.Visible = false
    activeDot.Parent = b
    corner(activeDot, 4)
    local navStroke = Instance.new("UIStroke")
    navStroke.Name = "NavOutline"
    navStroke.Color = T.Accent
    navStroke.Transparency = 1
    navStroke.Thickness = 1
    navStroke.Parent = b
    local icon = label(b, glyph, 9, T.Accent, Enum.Font.RobotoMono, Enum.TextXAlignment.Center)
    icon.Name = "NavIcon"
    icon.Position = UDim2.new(0, 5, 0, 0)
    icon.Size = UDim2.new(0, 27, 1, 0)
    local txt = label(b, string.upper(name), 10, T.Muted, Enum.Font.SourceSansSemibold)
    txt.Name = name
    txt.Position = UDim2.new(0, 37, 0, 0)
    txt.Size = UDim2.new(1, -51, 1, 0)
    pageButtons[name] = b
    b.MouseEnter:Connect(function()
        if currentPage ~= name then
            tween(b, 0.14, {BackgroundColor3 = T.Surface3})
            tween(navStroke, 0.14, {Transparency = 0.72})
        end
    end)
    b.MouseLeave:Connect(function()
        if currentPage ~= name then
            tween(b, 0.14, {BackgroundColor3 = T.Surface})
            tween(navStroke, 0.14, {Transparency = 1})
        end
    end)
    b.Activated:Connect(function()
        tween(b, 0.09, {BackgroundColor3 = T.AccentSoft}, Enum.EasingStyle.Quad)
        if icon then
            local originalSize = icon.Size
            tween(icon, 0.14, {Rotation = 8, TextSize = 20}, Enum.EasingStyle.Back)
            task.delay(0.14, function()
                if icon.Parent then
                    tween(icon, 0.2, {Rotation = 0, TextSize = 17}, Enum.EasingStyle.Back)
                end
            end)
        end
        setPage(name)
    end)
end

--// Responsive sizing
local function updateResponsive()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local viewport = camera.ViewportSize
    local mobile = viewport.X < 720 or (UserInputService.TouchEnabled and viewport.Y < 600)
    local homeHero = pages.Home and pages.Home:FindFirstChild("SignatureHero")
    if homeHero then
        local heroTitle = homeHero:FindFirstChild("HeroTitle")
        local heroSeal = homeHero:FindFirstChild("HeroSeal")
        local heroGlow = homeHero:FindFirstChild("HeroGlow")
        local heroRing = homeHero:FindFirstChild("HeroRing")
        if mobile then
            if heroTitle then
                heroTitle.Position = UDim2.new(0, 19, 0, 46)
                heroTitle.Size = UDim2.new(1, -112, 0, 64)
                heroTitle.TextSize = 19
            end
            if heroSeal then
                heroSeal.AnchorPoint = Vector2.new(1, 0.5)
                heroSeal.Position = UDim2.new(1, -17, 0.52, 0)
                heroSeal.Size = UDim2.fromOffset(76, 32)
                heroSeal.TextSize = 18
            end
            if heroGlow then heroGlow.Size = UDim2.fromOffset(94, 94); heroGlow.Position = UDim2.new(1, -5, 0.52, 0) end
            if heroRing then heroRing.Size = UDim2.fromOffset(80, 80); heroRing.Position = UDim2.new(1, -10, 0.52, 0) end
        else
            if heroTitle then
                heroTitle.Position = UDim2.new(0, 19, 0, 43)
                heroTitle.Size = UDim2.new(1, -148, 0, 68)
                heroTitle.TextSize = 26
            end
            if heroSeal then
                heroSeal.AnchorPoint = Vector2.new(1, 0.5)
                heroSeal.Position = UDim2.new(1, -27, 0.52, 0)
                heroSeal.Size = UDim2.fromOffset(104, 42)
                heroSeal.TextSize = 25
            end
            if heroGlow then heroGlow.Size = UDim2.fromOffset(148, 148); heroGlow.Position = UDim2.new(1, -10, 0.52, 0) end
            if heroRing then heroRing.Size = UDim2.fromOffset(122, 122); heroRing.Position = UDim2.new(1, -17, 0.52, 0) end
        end
    end
    local shortcutPanel = pages.Home and pages.Home:FindFirstChild("WorkspaceShortcuts")
    local shortcutGrid = shortcutPanel and shortcutPanel:FindFirstChild("ShortcutGrid")
    if shortcutGrid then
        if mobile then
            shortcutGrid.FillDirectionMaxCells = 1
            shortcutGrid.CellSize = UDim2.new(1, 0, 0, 54)
            shortcutGrid.CellPadding = UDim2.new(0, 0, 0, 7)
            if shortcutPanel then shortcutPanel.Size = UDim2.new(1, 0, 0, shortcutGrid.AbsoluteContentSize.Y + 24) end
            for _, shortcut in ipairs(shortcutPanel:GetChildren()) do
                if shortcut:IsA("TextButton") then
                    local icon = shortcut:FindFirstChild("ShortcutIcon")
                    local title = shortcut:FindFirstChild("ShortcutTitle")
                    local detail = shortcut:FindFirstChild("ShortcutDetail")
                    if icon then icon.Position = UDim2.new(0, 8, 0, 9); icon.Size = UDim2.fromOffset(36, 36) end
                    if title then title.Position = UDim2.new(0, 52, 0, 7); title.Size = UDim2.new(1, -64, 0, 18); title.TextSize = 10 end
                    if detail then detail.Position = UDim2.new(0, 52, 0, 28); detail.Size = UDim2.new(1, -64, 0, 14); detail.TextSize = 7 end
                end
            end
        else
            shortcutGrid.FillDirectionMaxCells = 2
            shortcutGrid.CellSize = UDim2.new(0.48, 0, 0, 56)
            shortcutGrid.CellPadding = UDim2.new(0.025, 0, 0, 8)
            if shortcutPanel then shortcutPanel.Size = UDim2.new(1, 0, 0, shortcutGrid.AbsoluteContentSize.Y + 24) end
            for _, shortcut in ipairs(shortcutPanel:GetChildren()) do
                if shortcut:IsA("TextButton") then
                    local icon = shortcut:FindFirstChild("ShortcutIcon")
                    local title = shortcut:FindFirstChild("ShortcutTitle")
                    local detail = shortcut:FindFirstChild("ShortcutDetail")
                    if icon then icon.Position = UDim2.new(0, 8, 0, 10); icon.Size = UDim2.fromOffset(36, 36) end
                    if title then title.Position = UDim2.new(0, 52, 0, 8); title.Size = UDim2.new(1, -64, 0, 18); title.TextSize = 10 end
                    if detail then detail.Position = UDim2.new(0, 52, 0, 29); detail.Size = UDim2.new(1, -64, 0, 14); detail.TextSize = 7 end
                end
            end
        end
    end
    if mobile then
        shell.Size = UDim2.new(0, math.max(300, math.min(viewport.X - 22, 900)), 0, math.max(300, math.min(viewport.Y - 24, 760)))
        ambientHalo.Size = UDim2.new(0, math.max(318, math.min(viewport.X - 14, 900)) + 22, 0, math.max(300, math.min(viewport.Y - 24, 760)) + 22)
        shellScale.Scale = userScale
        -- Mobile gets a floating, two-row navigation dock with readable labels.
        mobileDock = true
        sidebar.Position = UDim2.new(0, 10, 1, -88)
        sidebar.Size = UDim2.new(1, -20, 0, 72)
        sidebar.BackgroundColor3 = Color3.fromRGB(12, 13, 15)
        sidebar.BackgroundTransparency = 0.02
        sidebar.ClipsDescendants = true
        local dockCorner = sidebar:FindFirstChildOfClass("UICorner")
        if not dockCorner then
            dockCorner = Instance.new("UICorner")
            dockCorner.CornerRadius = UDim.new(0, 16)
            dockCorner.Parent = sidebar
        end
        local dockStroke = sidebar:FindFirstChild("DockFrameStroke")
        if not dockStroke then
            dockStroke = Instance.new("UIStroke")
            dockStroke.Name = "DockFrameStroke"
            dockStroke.Parent = sidebar
        end
        dockStroke.Color = T.Accent
        dockStroke.Transparency = 0.62
        dockStroke.Thickness = 1
        local dockGradient = sidebar:FindFirstChild("DockGradient")
        if not dockGradient then
            dockGradient = Instance.new("UIGradient")
            dockGradient.Name = "DockGradient"
            dockGradient.Rotation = 90
            dockGradient.Parent = sidebar
        end
        dockGradient.Color = ColorSequence.new(Color3.fromRGB(27, 25, 21), Color3.fromRGB(10, 11, 13))
        navCaption.Visible = false
        navCaptionRule.Visible = false
        sideInset.Position = UDim2.new(0, 12, 0, 0)
        sideInset.Size = UDim2.new(1, -24, 0, 1)
        sideInset.BackgroundTransparency = 0.28
        navHolder.Position = UDim2.new(0, 9, 0, 17)
        navHolder.Size = UDim2.new(1, -18, 0, 48)
        navHolder.ScrollingDirection = Enum.ScrollingDirection.Y
        navHolder.ScrollBarThickness = 0
        navHolder.ScrollingEnabled = false
        navHolder.AutomaticCanvasSize = Enum.AutomaticSize.None
        navHolder.CanvasSize = UDim2.new(0, 0, 0, 48)
        local oldList = navHolder:FindFirstChildOfClass("UIListLayout")
        if oldList then oldList:Destroy() end
        local dockGrid = navHolder:FindFirstChild("MobileNavigationGrid")
        if not dockGrid then
            dockGrid = Instance.new("UIGridLayout")
            dockGrid.Name = "MobileNavigationGrid"
            dockGrid.Parent = navHolder
        end
        dockGrid.SortOrder = Enum.SortOrder.LayoutOrder
        dockGrid.FillDirection = Enum.FillDirection.Horizontal
        dockGrid.FillDirectionMaxCells = 4
        dockGrid.CellSize = UDim2.new(0.25, -5, 0, 22)
        dockGrid.CellPadding = UDim2.new(0, 5, 0, 4)
        local dockTitle = sidebar:FindFirstChild("DockTitle")
        if not dockTitle then
            dockTitle = label(sidebar, "NAVIGATION", 7, T.Accent, Enum.Font.RobotoMono)
            dockTitle.Name = "DockTitle"
            dockTitle.Position = UDim2.new(0, 12, 0, 2)
            dockTitle.Size = UDim2.new(0, 90, 0, 12)
        end
        dockTitle.Visible = true
        local dockCount = sidebar:FindFirstChild("DockCount")
        if not dockCount then
            dockCount = label(sidebar, "08  /  PAGES", 6, T.Quiet, Enum.Font.RobotoMono, Enum.TextXAlignment.Right)
            dockCount.Name = "DockCount"
            dockCount.AnchorPoint = Vector2.new(1, 0)
            dockCount.Position = UDim2.new(1, -12, 0, 2)
            dockCount.Size = UDim2.new(0, 90, 0, 12)
        end
        dockCount.Visible = true
        for pageName, navButton in pairs(pageButtons) do
            navButton.Size = UDim2.new(0.25, -5, 0, 22)
            navButton.BackgroundColor3 = T.Surface2
            navButton.ClipsDescendants = true
            local navCorner = navButton:FindFirstChildOfClass("UICorner")
            if navCorner then navCorner.CornerRadius = UDim.new(0, 7) end
            local navIcon = navButton:FindFirstChild("NavIcon")
            local navText = navButton:FindFirstChild(pageName)
            if navIcon then
                navIcon.Position = UDim2.new(0, 5, 0, 0)
                navIcon.Size = UDim2.new(0, 13, 1, 0)
                navIcon.TextSize = 9
                navIcon.TextXAlignment = Enum.TextXAlignment.Center
            end
            if navText then
                navText.Visible = true
                navText.Position = UDim2.new(0, 21, 0, 0)
                navText.Size = UDim2.new(1, -24, 1, 0)
                navText.TextSize = 8
                navText.Font = Enum.Font.SourceSansSemibold
                navText.TextXAlignment = Enum.TextXAlignment.Left
            end
            local marker = navButton:FindFirstChild("ActiveGoldMarker")
            if marker then
                marker.Position = UDim2.new(0.18, 0, 1, -2)
                marker.Size = UDim2.new(0.64, 0, 0, 2)
            end
            local activeDot = navButton:FindFirstChild("ActiveNavDot")
            if activeDot then activeDot.Visible = false end
            local navOutline = navButton:FindFirstChild("NavOutline")
            if navOutline then navOutline.Transparency = 0.9 end
        end
        content.Position = UDim2.new(0, 0, 0, 0)
        content.Size = UDim2.new(1, 0, 1, 0)
        pageTop.Position = UDim2.new(0, 16, 0, 17)
        pageTop.Size = UDim2.new(1, -32, 0, 48)
        for _, page in pairs(pageFrames) do
            page.Position = UDim2.new(0, 16, 0, 78)
            page.Size = UDim2.new(1, -32, 1, -180)
        end
        brandMark.Position = UDim2.new(0, 12, 0, 13)
        brandMark.Size = UDim2.fromOffset(48, 50)
        brandName.Position = UDim2.new(0, 70, 0, 12)
        brandName.Size = UDim2.new(0, 120, 0, 27)
        brandSub.Text = "OBSIDIAN ATELIER  /  PRIVATE SUITE"
        brandSub.Position = UDim2.new(0, 71, 0, 40)
        brandSub.Size = UDim2.new(0, 170, 0, 14)
        logoMinimizeHitbox.Size = UDim2.fromOffset(194, 54)
        brandSub.TextSize = 7
        brandSub.Visible = true
        headerPlan.Visible = true
        headerPlan.AnchorPoint = Vector2.new(0, 0)
        headerPlan.Position = UDim2.new(0, 71, 0, 57)
        headerPlan.Size = UDim2.fromOffset(72, 16)
        headerPlan.TextSize = 7
        statusText.Visible = false
        statusDot.Visible = false
        headerClock.Visible = false
        headerDate.Visible = false
        headerRight.Size = UDim2.new(0, 58, 0, 30)
        headerRight.Position = UDim2.new(1, -8, 0, 20)
        minimizeButton.Position = UDim2.new(0, 0, 0, 2)
        minimizeButton.Size = UDim2.fromOffset(26, 26)
        closeButton.Position = UDim2.new(0, 32, 0, 2)
        closeButton.Size = UDim2.fromOffset(26, 26)
    else
        shell.Size = UDim2.new(0, 900, 0, 600)
        shellScale.Scale = userScale * math.min(1, viewport.X / 1040, viewport.Y / 740)
        ambientHalo.Size = UDim2.new(0, 900 * shellScale.Scale + 24, 0, 600 * shellScale.Scale + 24)
        mobileDock = false
        sidebar.Position = UDim2.new(0, 0, 0, 0)
        sidebar.Size = UDim2.new(0, 180, 1, 0)
        sidebar.BackgroundColor3 = T.Surface
        sidebar.BackgroundTransparency = 0
        sidebar.ClipsDescendants = false
        navCaption.Visible = true
        navCaptionRule.Visible = true
        sideInset.Position = UDim2.new(1, -1, 0, 16)
        sideInset.Size = UDim2.new(0, 1, 1, -32)
        sideInset.BackgroundTransparency = 0.35
        navHolder.ScrollingDirection = Enum.ScrollingDirection.Y
        navHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
        navHolder.ScrollBarThickness = 2
        navHolder.ScrollingEnabled = true
        navHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
        local oldGrid = navHolder:FindFirstChild("MobileNavigationGrid")
        if oldGrid then oldGrid:Destroy() end
        if not navHolder:FindFirstChildOfClass("UIListLayout") then
            listLayout(navHolder, Enum.FillDirection.Vertical, 5)
        end
        local dockTitle = sidebar:FindFirstChild("DockTitle")
        if dockTitle then dockTitle.Visible = false end
        local dockCount = sidebar:FindFirstChild("DockCount")
        if dockCount then dockCount.Visible = false end
        navCaption.Text = "JT3R  /  OBSIDIAN"
        navCaption.TextXAlignment = Enum.TextXAlignment.Left
        navCaption.Position = UDim2.new(0, 17, 0, 20)
        navCaption.Size = UDim2.new(1, -30, 0, 18)
        navHolder.Position = UDim2.new(0, 9, 0, 56)
        navHolder.Size = UDim2.new(1, -18, 1, -68)
        for pageName, navButton in pairs(pageButtons) do
            navButton.Size = UDim2.new(1, 0, 0, 46)
            navButton.BackgroundColor3 = T.Surface
            navButton.ClipsDescendants = true
            local navIcon = navButton:FindFirstChild("NavIcon")
            local navText = navButton:FindFirstChild(pageName)
            if navIcon then navIcon.Position = UDim2.new(0, 5, 0, 0); navIcon.Size = UDim2.new(0, 27, 1, 0); navIcon.TextSize = 10 end
            if navText then navText.Visible = true; navText.Position = UDim2.new(0, 37, 0, 0); navText.Size = UDim2.new(1, -51, 1, 0); navText.TextSize = 10; navText.TextXAlignment = Enum.TextXAlignment.Left end
            local navCorner = navButton:FindFirstChildOfClass("UICorner")
            if navCorner then navCorner.CornerRadius = UDim.new(0, 12) end
            local marker = navButton:FindFirstChild("ActiveGoldMarker")
            if marker then marker.Position = UDim2.new(0, 0, 0.18, 0); marker.Size = UDim2.new(0, 3, 0.64, 0) end
            local activeDot = navButton:FindFirstChild("ActiveNavDot")
            if activeDot then activeDot.Visible = true end
            local navOutline = navButton:FindFirstChild("NavOutline")
            if navOutline then navOutline.Transparency = 1 end
        end
        content.Position = UDim2.new(0, 180, 0, 0)
        content.Size = UDim2.new(1, -180, 1, 0)
        pageTop.Position = UDim2.new(0, 25, 0, 19)
        pageTop.Size = UDim2.new(1, -50, 0, 52)
        for _, page in pairs(pageFrames) do
            page.Position = UDim2.new(0, 25, 0, 83)
            page.Size = UDim2.new(1, -50, 1, -101)
        end
        brandMark.Position = UDim2.new(0, 18, 0, 13)
        brandMark.Size = UDim2.fromOffset(54, 52)
        brandName.Position = UDim2.new(0, 84, 0, 12)
        brandName.Size = UDim2.new(0, 190, 0, 28)
brandName.TextStrokeColor3 = T.Accent
brandName.TextStrokeTransparency = 0.78
        brandSub.Position = UDim2.new(0, 85, 0, 42)
        brandSub.Size = UDim2.new(0, 240, 0, 16)
        logoMinimizeHitbox.Size = UDim2.fromOffset(268, 54)
        brandSub.TextSize = 8
        brandSub.Visible = true
        headerPlan.Visible = true
        headerPlan.AnchorPoint = Vector2.new(1, 0)
        headerPlan.Position = UDim2.new(1, -250, 0, 27)
        headerPlan.Size = UDim2.fromOffset(82, 24)
        headerPlan.TextSize = 8
        statusText.Visible = true
        statusDot.Visible = true
        headerClock.Visible = true
        headerDate.Visible = true
        statusText.Size = UDim2.new(0, 70, 0, 20)
        headerRight.Size = UDim2.new(0, 132, 0, 30)
        headerRight.Position = UDim2.new(1, -14, 0, 36)
        headerClock.Position = UDim2.new(1, -194, 0, 9)
        headerDate.Position = UDim2.new(1, -194, 0, 29)
        minimizeButton.Position = UDim2.new(1, -60, 0, 2)
        minimizeButton.Size = UDim2.fromOffset(26, 26)
        closeButton.Position = UDim2.new(1, -28, 0, 2)
        closeButton.Size = UDim2.fromOffset(26, 26)
        statusText.Text = "LIVE"
    end
end

local lastViewport = Vector2.new(0, 0)
local function refreshResponsive()
    local camera = workspace.CurrentCamera
    if camera and camera.ViewportSize ~= lastViewport then
        lastViewport = camera.ViewportSize
        updateResponsive()
    end
end
refreshResponsive()
addConnection(RunService.RenderStepped:Connect(refreshResponsive))

-- Premium motion layer: drifting metallic sheen and breathing window edge.
task.spawn(function()
    while screenGui.Parent do
        if animationsEnabled and not isMinimized then
            tween(headerSheen, 3.8, {Rotation = 180}, Enum.EasingStyle.Sine)
            tween(shellOuterGlow, 2.2, {Transparency = 0.68, Thickness = 9}, Enum.EasingStyle.Sine)
            tween(markGradient, 2.6, {Rotation = 315}, Enum.EasingStyle.Sine)
            task.wait(2.6)
            if not screenGui.Parent then break end
            tween(headerSheen, 3.8, {Rotation = 0}, Enum.EasingStyle.Sine)
            tween(shellOuterGlow, 2.2, {Transparency = 0.88, Thickness = 6}, Enum.EasingStyle.Sine)
            tween(markGradient, 2.6, {Rotation = 135}, Enum.EasingStyle.Sine)
            task.wait(2.6)
        else
            task.wait(0.5)
        end
    end
end)

-- Premium micro-interactions: subtle panel entrance and logo ring rotation.
task.spawn(function()
    while screenGui.Parent do
        if animationsEnabled and not isMinimized then
            local ring = brandMark:FindFirstChild("LogoSeal")
            if ring then tween(ring, 5.5, {Rotation = 90}, Enum.EasingStyle.Sine) end
            tween(topAccent, 2.4, {BackgroundTransparency = 0.05}, Enum.EasingStyle.Sine)
            task.wait(2.4)
            if not screenGui.Parent then break end
            if ring then tween(ring, 5.5, {Rotation = 0}, Enum.EasingStyle.Sine) end
            tween(topAccent, 2.4, {BackgroundTransparency = 0.32}, Enum.EasingStyle.Sine)
            task.wait(2.4)
        else
            task.wait(0.5)
        end
    end
end)

-- Slow sparkle pass across broad bars and premium panels.
task.spawn(function()
    local cursor=1
    while screenGui.Parent do
        if animationsEnabled and not isMinimized and #luxurySparkles>0 then
            local spark=luxurySparkles[cursor]
            if spark and spark.Parent then
                tween(spark,0.42,{BackgroundTransparency=0.02,Size=UDim2.fromOffset(4,4)},Enum.EasingStyle.Sine)
                task.delay(0.44,function()
                    if spark and spark.Parent then tween(spark,0.6,{BackgroundTransparency=0.58,Size=UDim2.fromOffset(2,2)},Enum.EasingStyle.Sine) end
                end)
            end
            cursor=cursor%#luxurySparkles+1
            task.wait(0.055)
        else task.wait(0.4) end
    end
end)

-- Slow metallic sweep across the header.
task.spawn(function()
    local sweep = Instance.new("Frame")
    sweep.Name = "HeaderMetallicSweep"
    sweep.BackgroundColor3 = Color3.new(1, 1, 1)
    sweep.BackgroundTransparency = 0.82
    sweep.BorderSizePixel = 0
    sweep.Size = UDim2.new(0, 54, 1, 0)
    sweep.Position = UDim2.new(0, -60, 0, 0)
    sweep.ZIndex = 4
    sweep.Parent = header
    local sweepGradient = Instance.new("UIGradient")
    sweepGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.18),
        NumberSequenceKeypoint.new(1, 1)
    })
    sweepGradient.Parent = sweep
    while screenGui.Parent do
        if animationsEnabled and not isMinimized then
            sweep.Position = UDim2.new(0, -60, 0, 0)
            tween(sweep, 2.8, {Position = UDim2.new(1, 10, 0, 0)}, Enum.EasingStyle.Sine)
            task.wait(3.1)
        else
            task.wait(0.5)
        end
    end
end)

-- Coordinated gold logo glow pulse and ambient lighting.
task.spawn(function()
    while screenGui.Parent do
        if animationsEnabled and not isMinimized then
            tween(logoOuterGlow, 1.55, {Transparency = 0.16, Thickness = 10}, Enum.EasingStyle.Sine)
            tween(logoInnerGlow, 1.55, {Transparency = 0.04}, Enum.EasingStyle.Sine)
            task.wait(1.55)
            if not screenGui.Parent then break end
            tween(logoOuterGlow, 1.75, {Transparency = 0.42, Thickness = 7}, Enum.EasingStyle.Sine)
            tween(logoInnerGlow, 1.75, {Transparency = 0.2}, Enum.EasingStyle.Sine)
            task.wait(1.75)
        else
            task.wait(0.45)
        end
    end
end)

-- Subtle ambient illumination pulse; kept deliberately slow to avoid visual clutter.
task.spawn(function()
    while screenGui.Parent do
        if ambientEnabled and not isMinimized then
            tween(ambientHalo, 2.8, {BackgroundTransparency = 0.92}, Enum.EasingStyle.Sine)
            task.wait(2.8)
            if not screenGui.Parent then break end
            tween(ambientHalo, 2.8, {BackgroundTransparency = 0.84}, Enum.EasingStyle.Sine)
            task.wait(2.8)
        else
            task.wait(0.5)
        end
    end
end)

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    task.defer(refreshResponsive)
end)

--// Dragging window (header only)
local dragging = false
local dragMoved = false
local dragStart, startPosition
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local px, py = input.Position.X, input.Position.Y
        local logoPos, logoSize = logoMinimizeHitbox.AbsolutePosition, logoMinimizeHitbox.AbsoluteSize
        if px >= logoPos.X and px <= logoPos.X + logoSize.X and py >= logoPos.Y and py <= logoPos.Y + logoSize.Y then return end
        dragging = true
        dragMoved = false
        dragStart = input.Position
        startPosition = shell.Position
    end
end)
addConnection(UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        if math.abs(delta.X) + math.abs(delta.Y) > 7 then dragMoved = true end
        if dragMoved then
            shell.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
            ambientHalo.Position = shell.Position
        end
    end
end))
addConnection(UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end))

uninject = function()
    if not isOpen then return end
    isOpen = false
    for _, connection in ipairs(connections) do
        pcall(function() connection:Disconnect() end)
    end
    pcall(function()
        for _, object in ipairs(PlayerGui:GetDescendants()) do
            if object.Name == "JT3R_PlayerInfo" then object:Destroy() end
        end
        for _, player in ipairs(Players:GetPlayers()) do
            local character = player.Character
            if character then
                for _, object in ipairs(character:GetDescendants()) do
                    if object.Name == "JT3R_PlayerHighlight" then object:Destroy() end
                end
            end
        end
    end)
    if screenGui then
        pcall(function() screenGui:Destroy() end)
    end
    if _G.JT3R_FUNHOUSE then _G.JT3R_FUNHOUSE = nil end
end

local function minimize()
    if isMinimized or not isOpen then return end
    isMinimized = true
    dragging = false
    shell.Visible = false
    ambientHalo.Visible = false
    restore.Visible = true
    restore.Active = true
    restore.Selectable = true
    restore.ZIndex = 100
    restore.Position = UDim2.new(0, 18, 0.62, 0)
    restore.BackgroundTransparency = 0
    restore.Text = "JT3R"
    restore.TextTransparency = 0
    restoreGlow.Transparency = 0.18
    if animationsEnabled then
        restore.Size = UDim2.fromOffset(58, 58)
        tween(restore, 0.24, {Size = UDim2.fromOffset(68, 68)}, Enum.EasingStyle.Back)
    end
end

local function restoreWindow()
    isMinimized = false
    shell.Visible = true
    ambientHalo.Visible = ambientEnabled
    restore.Visible = false
    if animationsEnabled then
        local target = shell.Position
        shellScale.Scale = shellScale.Scale * 0.965
        tween(shellScale, 0.28, {Scale = userScale}, Enum.EasingStyle.Back)
        shell.Position = UDim2.new(target.X.Scale, target.X.Offset, target.Y.Scale, target.Y.Offset + 8)
        tween(shell, 0.28, {Position = target}, Enum.EasingStyle.Quart)
    end
end

-- The full brand lockup is a mobile-friendly minimise target.
logoMinimizeHitbox.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then task.defer(minimize) end
end)
minimizeButton.Activated:Connect(minimize)
restore.Activated:Connect(restoreWindow)
closeButton.MouseButton1Click:Connect(uninject)

-- Floating button drag support
local restoreDragging = false
local restoreMoved = false
local restoreStart, restorePosition
restore.Active = true
restore.Selectable = true
restore.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        restoreDragging = true
        restoreMoved = false
        restoreStart = input.Position
        restorePosition = restore.Position
    end
end)
addConnection(UserInputService.InputChanged:Connect(function(input)
    if restoreDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - restoreStart
        if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then restoreMoved = true end
        restore.Position = UDim2.new(restorePosition.X.Scale, restorePosition.X.Offset + delta.X, restorePosition.Y.Scale, restorePosition.Y.Offset + delta.Y)
    end
end))
addConnection(UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        restoreDragging = false
    end
end))

--// Keyboard shortcut for desktop
addConnection(UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F4 then
        if isMinimized or not shell.Visible then
            restoreWindow()
        else
            minimize()
        end
    end
end))


--// First-run welcome: shown once when local file storage is available.
do
    if not sessionPreferences.welcomed then
        local welcome = Instance.new("Frame")
        welcome.Name = "JT3RFirstRunWelcome"
        welcome.Size = UDim2.fromScale(1, 1)
        welcome.BackgroundColor3 = Color3.fromRGB(3, 4, 6)
        welcome.BackgroundTransparency = 0.18
        welcome.BorderSizePixel = 0
        welcome.ZIndex = 200
        welcome.Parent = screenGui
        local card = Instance.new("Frame")
        card.Name = "WelcomeCard"
        card.AnchorPoint = Vector2.new(0.5, 0.5)
        card.Position = UDim2.fromScale(0.5, 0.5)
        card.Size = UDim2.new(0.88, 0, 0, 258)
        card.BackgroundColor3 = T.Surface
        card.BorderSizePixel = 0
        card.ZIndex = 201
        card.Parent = welcome
        corner(card, 18)
        stroke(card, T.Accent, 0.25, 1.2)
        local cardScale = Instance.new("UIScale")
        cardScale.Scale = 0.92
        cardScale.Parent = card
        local brand = label(card, "JT3R", 26, T.AccentBright, Enum.Font.Merriweather)
        brand.Position = UDim2.new(0, 20, 0, 22)
        brand.Size = UDim2.new(1, -40, 0, 38)
        brand.TextXAlignment = Enum.TextXAlignment.Center
        brand.ZIndex = 202
        local eyebrow = label(card, "OBSIDIAN ATELIER  /  WELCOME", 8, T.Accent, Enum.Font.RobotoMono)
        eyebrow.Position = UDim2.new(0, 20, 0, 62)
        eyebrow.Size = UDim2.new(1, -40, 0, 18)
        eyebrow.TextXAlignment = Enum.TextXAlignment.Center
        eyebrow.ZIndex = 202
        local heading = label(card, "Your workspace is ready.", 17, T.Text, Enum.Font.SourceSansSemibold)
        heading.Position = UDim2.new(0, 20, 0, 99)
        heading.Size = UDim2.new(1, -40, 0, 25)
        heading.TextXAlignment = Enum.TextXAlignment.Center
        heading.ZIndex = 202
        local detail = label(card, "Choose your pages from the navigation. Personalise themes, motion and saved presets in Settings.", 10, T.Muted, Enum.Font.SourceSans)
        detail.Position = UDim2.new(0, 28, 0, 132)
        detail.Size = UDim2.new(1, -56, 0, 42)
        detail.TextWrapped = true
        detail.TextXAlignment = Enum.TextXAlignment.Center
        detail.ZIndex = 202
        local startButton = button(card, "ENTER FUNHOUSE", UDim2.new(1, -48, 0, 38), T.Accent, Color3.fromRGB(17, 15, 12))
        startButton.Position = UDim2.new(0, 24, 1, -56)
        startButton.ZIndex = 203
        startButton.Activated:Connect(function()
            sessionPreferences.welcomed = true
            savePreferences(currentPage, true)
            TweenService:Create(cardScale, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Scale = 0.96}):Play()
            TweenService:Create(welcome, TweenInfo.new(0.22), {BackgroundTransparency = 1}):Play()
            task.wait(0.24)
            if welcome.Parent then welcome:Destroy() end
            notify("Welcome", "Your JT3R workspace is ready.")
        end)
        TweenService:Create(cardScale, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    end
end

--// Initial state
setPage((pages[sessionPreferences.page] and sessionPreferences.page) or "Home")
updateResponsive()
task.delay(0.35, function()
    if screenGui.Parent then
        notify("JT3R ready", "Obsidian Atelier  •  v8.0")
    end
end)

--// Public local controls for future expansion
local JT3R = {}
function JT3R.Notify(title, message)
    notify(tostring(title or "JT3R"), tostring(message or ""))
end
function JT3R.SetPage(name)
    if pages[name] then setPage(name) end
end
function JT3R.Destroy()
    uninject()
end
function JT3R.Uninject()
    uninject()
end
function JT3R.Diagnostics()
    local camera = workspace.CurrentCamera
    return {
        version = "8.0",
        open = isOpen,
        minimized = isMinimized,
        currentPage = currentPage,
        registeredConnections = #connections,
        screenGuiPresent = screenGui ~= nil and screenGui.Parent ~= nil,
        viewport = camera and camera.ViewportSize or nil,
        mobile = UserInputService.TouchEnabled,
        animations = animationsEnabled,
        theme = currentThemeName,
    }
end

_G.JT3R_FUNHOUSE = JT3R
