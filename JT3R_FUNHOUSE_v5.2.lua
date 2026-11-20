--[[
    JT3R FUNHOUSE v5.2
    Obsidian Atelier — RGB Edition
    Standalone UI shell for Roblox experiences.

    The ESP page includes client-side R6/R15 character visualisation for
    the owner's own Roblox experience: boxes, names, highlights, health,
    team filtering, distance filtering, RGB accents and body-part diagnostics and a server-authorised, whitelist-controlled hitbox expander. It does not include
    aim assistance, automation, anti-cheat bypasses or recording concealment.

    Upload this file to GitHub as JT3R_FUNHOUSE_v5.2.lua.
]]

--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// Cleanup previous copy
local GUI_NAME = "JT3R_FUNHOUSE_V22"
pcall(function()
    local old = (gethui and gethui()) or CoreGui
    local existing = old:FindFirstChild(GUI_NAME)
    if existing then existing:Destroy() end
end)

--// JT3R FUNZONE access gate
-- Client-side key check: this is a convenience gate, not secure licensing.
do
    local accepted = false
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
    card.Size = UDim2.new(0.9, 0, 0, 292)
    card.BackgroundColor3 = Color3.fromRGB(14, 15, 18)
    card.BackgroundTransparency = 1
    card.BorderSizePixel = 0
    card.Parent = backdrop
    card.ClipsDescendants = true
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 22)
    local sizeLimit = Instance.new("UISizeConstraint")
    sizeLimit.MinSize = Vector2.new(290, 292)
    sizeLimit.MaxSize = Vector2.new(430, 292)
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
    glow.Position = UDim2.new(0.5, 0, 0, -34)
    glow.Size = UDim2.new(0.75, 0, 0, 76)
    glow.BackgroundColor3 = Color3.fromRGB(209, 164, 94)
    glow.BackgroundTransparency = 0.86
    glow.BorderSizePixel = 0
    glow.Parent = card
    Instance.new("UICorner", glow).CornerRadius = UDim.new(1, 0)

    local brand = Instance.new("TextLabel")
    brand.BackgroundTransparency = 1
    brand.Position = UDim2.new(0, 25, 0, 28)
    brand.Size = UDim2.new(1, -50, 0, 38)
    brand.Font = Enum.Font.Merriweather
    brand.Text = "JT3R"
    brand.TextColor3 = Color3.fromRGB(255, 224, 173)
    brand.TextSize = 29
    brand.TextXAlignment = Enum.TextXAlignment.Center
    brand.Parent = card

    local eyebrow = Instance.new("TextLabel")
    eyebrow.BackgroundTransparency = 1
    eyebrow.Position = UDim2.new(0, 20, 0, 70)
    eyebrow.Size = UDim2.new(1, -40, 0, 18)
    eyebrow.Font = Enum.Font.RobotoMono
    eyebrow.Text = "FUNHOUSE  /  PRIVATE ACCESS"
    eyebrow.TextColor3 = Color3.fromRGB(208, 168, 105)
    eyebrow.TextSize = 9
    eyebrow.Parent = card

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 24, 0, 112)
    title.Size = UDim2.new(1, -48, 0, 26)
    title.Font = Enum.Font.SourceSansSemibold
    title.Text = "Enter your access key"
    title.TextColor3 = Color3.fromRGB(246, 240, 229)
    title.TextSize = 17
    title.Parent = card

    local hint = Instance.new("TextLabel")
    hint.BackgroundTransparency = 1
    hint.Position = UDim2.new(0, 24, 0, 142)
    hint.Size = UDim2.new(1, -48, 0, 20)
    hint.Font = Enum.Font.SourceSans
    hint.Text = "A key is required to open the command centre."
    hint.TextColor3 = Color3.fromRGB(143, 139, 130)
    hint.TextSize = 10
    hint.Parent = card

    local keyBox = Instance.new("TextBox")
    keyBox.Name = "AccessKeyInput"
    keyBox.Position = UDim2.new(0, 24, 0, 178)
    keyBox.Size = UDim2.new(1, -48, 0, 42)
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
    status.Position = UDim2.new(0, 24, 0, 224)
    status.Size = UDim2.new(1, -48, 0, 16)
    status.Font = Enum.Font.SourceSansSemibold
    status.Text = "ACCESS REQUIRED"
    status.TextColor3 = Color3.fromRGB(153, 135, 107)
    status.TextSize = 8
    status.Parent = card

    local unlock = Instance.new("TextButton")
    unlock.Name = "UnlockButton"
    unlock.Position = UDim2.new(0, 24, 1, -47)
    unlock.Size = UDim2.new(1, -48, 0, 34)
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
            TweenService:Create(glow, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.78, Size = UDim2.new(0.84, 0, 0, 88)}):Play()
            task.wait(1.8)
            if not keyGui.Parent or accepted then break end
            TweenService:Create(glow, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.9, Size = UDim2.new(0.72, 0, 0, 70)}):Play()
            task.wait(1.8)
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
        if string.lower((keyBox.Text or ""):gsub("%s+", "")) == "funzone" then
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
    card.Size = UDim2.new(0.88, 0, 0, 236)
    card.BackgroundColor3 = Color3.fromRGB(13, 14, 17)
    card.BackgroundTransparency = 1
    card.BorderSizePixel = 0
    card.Parent = shade
    card.ClipsDescendants = true
    local cardConstraint = Instance.new("UISizeConstraint")
    cardConstraint.MinSize = Vector2.new(300, 236)
    cardConstraint.MaxSize = Vector2.new(520, 236)
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

    local emblem = Instance.new("Frame")
    emblem.Name = "SignatureEmblem"
    emblem.Position = UDim2.new(0, 24, 0, 27)
    emblem.Size = UDim2.fromOffset(82, 82)
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
    diamond.Size = UDim2.fromOffset(54, 54)
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
    logo.TextSize = 27
    logo.Parent = emblem

    local wordmark = Instance.new("TextLabel")
    wordmark.BackgroundTransparency = 1
    wordmark.Position = UDim2.new(0, 124, 0, 34)
    wordmark.Size = UDim2.new(1, -146, 0, 42)
    wordmark.Font = Enum.Font.Merriweather
    wordmark.Text = "JT3R FUNHOUSE"
    wordmark.TextColor3 = Color3.fromRGB(248, 241, 228)
    wordmark.TextSize = 22
    wordmark.TextXAlignment = Enum.TextXAlignment.Left
    wordmark.Parent = card

    local edition = Instance.new("TextLabel")
    edition.BackgroundTransparency = 1
    edition.Position = UDim2.new(0, 126, 0, 76)
    edition.Size = UDim2.new(1, -148, 0, 22)
    edition.Font = Enum.Font.RobotoMono
    edition.Text = "O B S I D I A N   /   P R I V A T E   E D I T I O N"
    edition.TextColor3 = Color3.fromRGB(218, 181, 117)
    edition.TextSize = 9
    edition.TextXAlignment = Enum.TextXAlignment.Left
    edition.Parent = card

    local status = Instance.new("TextLabel")
    status.BackgroundTransparency = 1
    status.Position = UDim2.new(0, 25, 0, 139)
    status.Size = UDim2.new(1, -50, 0, 18)
    status.Font = Enum.Font.SourceSansSemibold
    status.Text = "PREPARING YOUR SESSION"
    status.TextColor3 = Color3.fromRGB(224, 215, 198)
    status.TextSize = 10
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Parent = card

    local statusRight = Instance.new("TextLabel")
    statusRight.BackgroundTransparency = 1
    statusRight.AnchorPoint = Vector2.new(1, 0)
    statusRight.Position = UDim2.new(1, -25, 0, 139)
    statusRight.Size = UDim2.fromOffset(42, 18)
    statusRight.Font = Enum.Font.RobotoMono
    statusRight.Text = "0%"
    statusRight.TextColor3 = Color3.fromRGB(235, 199, 139)
    statusRight.TextSize = 10
    statusRight.TextXAlignment = Enum.TextXAlignment.Right
    statusRight.Parent = card

    local track = Instance.new("Frame")
    track.Position = UDim2.new(0, 25, 0, 166)
    track.Size = UDim2.new(1, -50, 0, 7)
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
    footer.Position = UDim2.new(0, 25, 0, 190)
    footer.Size = UDim2.new(1, -50, 0, 18)
    footer.Font = Enum.Font.SourceSans
    footer.Text = "DESIGNED TO STAND APART     •     v5.2"
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
    TweenService:Create(diamond, TweenInfo.new(1.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Rotation = 0}):Play()
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
    local started, duration = os.clock(), 3.4
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
        Background = Color3.fromRGB(12, 13, 15),
        Surface = Color3.fromRGB(19, 20, 23),
        Surface2 = Color3.fromRGB(25, 26, 29),
        Surface3 = Color3.fromRGB(32, 33, 37),
        Border = Color3.fromRGB(48, 46, 41),
        Accent = Color3.fromRGB(205, 169, 105),
        AccentBright = Color3.fromRGB(235, 204, 145),
        AccentSoft = Color3.fromRGB(72, 59, 39),
        Text = Color3.fromRGB(242, 237, 226),
        Muted = Color3.fromRGB(157, 153, 145),
        Quiet = Color3.fromRGB(105, 104, 101),
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
    corner(b, 10)
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
shell.Size = UDim2.new(0, 850, 0, 570)
shell.BackgroundColor3 = T.Background
shell.BackgroundTransparency = 0.12
shell.BorderSizePixel = 0
shell.ZIndex = 1
shell.ClipsDescendants = true
shell.Parent = screenGui
corner(shell, 24)
stroke(shell, T.AccentBright, 0.56, 1.5)
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
header.Size = UDim2.new(1, 0, 0, 78)
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

local brandSub = label(header, "FUNHOUSE   /   PRIVATE COLLECTION", 8, T.Accent, Enum.Font.RobotoMono)
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
headerPlan.Text = "STANDARD"
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
headerRight.Position = UDim2.new(1, -18, 0, 34)
headerRight.Size = UDim2.new(0, 170, 0, 42)
headerRight.Parent = header

local statusDot = Instance.new("Frame")
statusDot.BackgroundColor3 = T.Success
statusDot.Position = UDim2.new(0, 3, 0, 17)
statusDot.Size = UDim2.fromOffset(7, 7)
statusDot.Parent = headerRight
corner(statusDot, 8)

local statusText = label(headerRight, "SESSION ACTIVE", 9, T.Muted, Enum.Font.SourceSansSemibold)
statusText.Position = UDim2.new(0, 16, 0, 10)
statusText.Size = UDim2.new(0, 100, 0, 20)

local minimizeButton = button(headerRight, "—", UDim2.fromOffset(36, 36), Color3.fromRGB(57, 47, 31), T.AccentBright)
minimizeButton.Name = "MinimiseControl"
minimizeButton.Font = Enum.Font.RobotoMono
minimizeButton.TextSize = 21
stroke(minimizeButton, T.AccentBright, 0.12, 1.5)
minimizeButton.TextStrokeColor3 = T.Accent
minimizeButton.TextStrokeTransparency = 0.45
minimizeButton.Position = UDim2.new(1, -78, 0, 3)
minimizeButton.TextSize = 18

local closeButton = button(headerRight, "×", UDim2.fromOffset(36, 36), Color3.fromRGB(77, 31, 29), Color3.fromRGB(255, 218, 210))
closeButton.Name = "CloseControl"
closeButton.Font = Enum.Font.RobotoMono
closeButton.TextSize = 23
stroke(closeButton, Color3.fromRGB(245, 128, 112), 0.08, 1.5)
closeButton.TextStrokeColor3 = Color3.fromRGB(245, 128, 112)
closeButton.TextStrokeTransparency = 0.58
closeButton.Position = UDim2.new(1, -36, 0, 3)
closeButton.TextSize = 16

--// Main body and navigation
local body = Instance.new("Frame")
body.BackgroundTransparency = 1
body.Position = UDim2.new(0, 0, 0, 79)
body.Size = UDim2.new(1, 0, 1, -111)
body.Parent = shell

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.BackgroundColor3 = T.Surface
sidebar.BorderSizePixel = 0
sidebar.Size = UDim2.new(0, 174, 1, 0)
sidebar.Parent = body

local sideInset = Instance.new("Frame")
sideInset.BackgroundColor3 = T.Border
sideInset.BackgroundTransparency = 0.35
sideInset.BorderSizePixel = 0
sideInset.Position = UDim2.new(1, -1, 0, 16)
sideInset.Size = UDim2.new(0, 1, 1, -32)
sideInset.Parent = sidebar

local navCaption = label(sidebar, "WORKSPACE", 9, T.Quiet, Enum.Font.RobotoMono)
navCaption.Position = UDim2.new(0, 20, 0, 24)
navCaption.Size = UDim2.new(1, -35, 0, 18)

local navHolder = Instance.new("ScrollingFrame")
navHolder.Name = "NavigationScroll"
navHolder.BackgroundTransparency = 1
navHolder.BorderSizePixel = 0
navHolder.Position = UDim2.new(0, 10, 0, 50)
navHolder.Size = UDim2.new(1, -20, 1, -62)
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
listLayout(navHolder, Enum.FillDirection.Vertical, 6)

local navItems = {
    {"Home", "01"}, {"Aim", "02"}, {"ESP", "03"}, {"Visuals", "04"},
    {"Fly", "05"}, {"Misc", "06"}, {"Settings", "07"}, {"Console", "08"}
}

local content = Instance.new("Frame")
content.Name = "Content"
content.BackgroundTransparency = 1
content.Position = UDim2.new(0, 174, 0, 0)
content.Size = UDim2.new(1, -174, 1, 0)
content.ClipsDescendants = true
content.Parent = body

local pageTop = Instance.new("Frame")
pageTop.BackgroundTransparency = 1
pageTop.Position = UDim2.new(0, 28, 0, 19)
pageTop.Size = UDim2.new(1, -56, 0, 52)
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

local footerText = label(footer, "JT3R     /     PRIVATE INTERFACE COLLECTION", 9, T.Quiet, Enum.Font.RobotoMono)
footerText.Position = UDim2.new(0, 20, 0, 7)
footerText.Size = UDim2.new(0.7, 0, 0, 18)

local footerVersion = label(footer, "V5.1", 9, T.Accent, Enum.Font.RobotoMono, Enum.TextXAlignment.Right)
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
    local glint=Instance.new("Frame")
    glint.Name="MetallicGlint"; glint.BackgroundColor3=T.AccentBright; glint.BackgroundTransparency=0.88
    glint.BorderSizePixel=0; glint.AnchorPoint=Vector2.new(1,0)
    glint.Position=UDim2.new(1,-14,0,8); glint.Size=UDim2.new(0,compact and 34 or 58,0,1); glint.Parent=frame
    local grad=Instance.new("UIGradient")
    grad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.45,0.08),NumberSequenceKeypoint.new(1,1)})
    grad.Parent=glint
    for i=1,3 do
        local spark=Instance.new("Frame"); spark.Name="GoldSparkle"; spark.AnchorPoint=Vector2.new(0.5,0.5)
        spark.Position=UDim2.new(1,-(16+(i-1)*(compact and 10 or 17)),0,8+(i%2)*5)
        spark.Size=UDim2.fromOffset(i==2 and 3 or 2,i==2 and 3 or 2); spark.Rotation=45
        spark.BackgroundColor3=i==2 and Color3.fromRGB(255,231,187) or T.Accent
        spark.BackgroundTransparency=0.45; spark.BorderSizePixel=0; spark.Parent=frame
        table.insert(luxurySparkles,spark)
    end
    local edge=Instance.new("Frame"); edge.Name="TopMetallicRule"; edge.BackgroundColor3=T.AccentBright
    edge.BackgroundTransparency=0.78; edge.BorderSizePixel=0; edge.Position=UDim2.new(0,16,0,0)
    edge.Size=UDim2.new(compact and 0.28 or 0.42,0,0,1); edge.Parent=frame
    local lowerRule=Instance.new("Frame")
    lowerRule.Name="LowerMetallicRule"
    lowerRule.BackgroundColor3=T.Accent
    lowerRule.BackgroundTransparency=0.91
    lowerRule.BorderSizePixel=0
    lowerRule.AnchorPoint=Vector2.new(1,1)
    lowerRule.Position=UDim2.new(1,-16,1,-1)
    lowerRule.Size=UDim2.new(compact and 0.16 or 0.24,0,0,1)
    lowerRule.Parent=frame
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
    corner(frame, 19)
    luxurySurface(frame, false)
    frame:SetAttribute("JT3RPanel", true)
    local panelEdge = stroke(frame, T.Accent, glassEnabled and 0.62 or 0.12, 1.15)
    panelEdge.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local sheen = Instance.new("UIGradient")
    sheen.Rotation = 110
    sheen.Color = ColorSequence.new(Color3.fromRGB(45, 41, 34), T.Surface)
    sheen.Transparency = NumberSequence.new(0.52, 0.08)
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

local function setPage(name)
    currentPage = name
    pageTitle.Text = name
    pageEyebrow.Text = name == "Home" and "OVERVIEW" or "WORKSPACE  /  " .. string.upper(name)
    if animationsEnabled then
        pageTitle.TextTransparency = 1
        pageEyebrow.TextTransparency = 1
        tween(pageTitle, 0.28, {TextTransparency = 0}, Enum.EasingStyle.Quart)
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
        local marker = buttonObject:FindFirstChild("ActiveGoldMarker")
        if marker then
            marker.Visible = selected
            marker.BackgroundColor3 = T.AccentBright
            if selected then
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
    scroll.Position = UDim2.new(0, 28, 0, 83)
    scroll.Size = UDim2.new(1, -56, 1, -101)
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
    local l = label(f, text:upper(), 9, T.Accent, Enum.Font.RobotoMono)
    l.Size = UDim2.fromScale(1, 1)
end

local function panelFor(parent, height)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = T.Surface
    f.BackgroundTransparency = glassEnabled and 0.13 or 0
    f.BorderSizePixel = 0
    f.Size = UDim2.new(1, 0, 0, height)
    f.Parent = parent
    corner(f, 19)
    luxurySurface(f, false)
    f:SetAttribute("JT3RPanel", true)
    stroke(f, T.Accent, glassEnabled and 0.78 or 0.18, 1)
    local sheen = Instance.new("UIGradient")
    sheen.Rotation = 110
    sheen.Color = ColorSequence.new(Color3.fromRGB(45, 41, 34), T.Surface)
    sheen.Transparency = NumberSequence.new(0.42, 0.06)
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

-- Home / Executive dashboard
do
    local p = pages.Home
    section(p, "Command overview")
    local hero = panelFor(p, 204)
    hero.Name = "SignatureHero"
    hero.BackgroundColor3 = Color3.fromRGB(25, 23, 19)
    stroke(hero, T.AccentBright, 0.34, 1.2)
    local heroGradient = Instance.new("UIGradient")
    heroGradient.Rotation = 18
    heroGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(49, 40, 27)),
        ColorSequenceKeypoint.new(0.42, Color3.fromRGB(26, 24, 21)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 15, 17))
    })
    heroGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.02),
        NumberSequenceKeypoint.new(0.62, 0.08),
        NumberSequenceKeypoint.new(1, 0.02)
    })
    heroGradient.Parent = hero
    local heroLeftRule = Instance.new("Frame")
    heroLeftRule.Name = "HeroGoldSpine"
    heroLeftRule.BackgroundColor3 = T.AccentBright
    heroLeftRule.BorderSizePixel = 0
    heroLeftRule.Position = UDim2.new(0, 0, 0, 18)
    heroLeftRule.Size = UDim2.new(0, 2, 1, -36)
    heroLeftRule.Parent = hero
    local heroGlow = Instance.new("Frame")
    heroGlow.BackgroundColor3 = T.Accent
    heroGlow.BackgroundTransparency = 0.91
    heroGlow.BorderSizePixel = 0
    heroGlow.AnchorPoint = Vector2.new(1, 0)
    heroGlow.Position = UDim2.new(1, -12, 0, 12)
    heroGlow.Size = UDim2.fromOffset(142, 142)
    heroGlow.Name = "HeroGlow"
    heroGlow.Parent = hero
    corner(heroGlow, 72)
    local heroRing = Instance.new("Frame")
    heroRing.BackgroundTransparency = 1
    heroRing.AnchorPoint = Vector2.new(1, 0)
    heroRing.Position = UDim2.new(1, -16, 0, 16)
    heroRing.Size = UDim2.fromOffset(116, 116)
    heroRing.Name = "HeroRing"
    heroRing.Parent = hero
    corner(heroRing, 60)
    local ringStroke = stroke(heroRing, T.Accent, 0.52, 1.2)
    task.spawn(function()
        while screenGui.Parent and heroRing.Parent do
            if animationsEnabled and not isMinimized then
                tween(ringStroke, 1.5, {Transparency = 0.2, Thickness = 1.8}, Enum.EasingStyle.Sine)
                task.wait(1.5)
                if ringStroke and ringStroke.Parent then
                    tween(ringStroke, 1.5, {Transparency = 0.58, Thickness = 1.1}, Enum.EasingStyle.Sine)
                end
                task.wait(1.5)
            else
                task.wait(0.25)
            end
        end
    end)
    local heroSeal = label(hero, "JT3R", 24, T.AccentBright, Enum.Font.Merriweather, Enum.TextXAlignment.Center)
    heroSeal.Name = "HeroSeal"
    heroSeal.AnchorPoint = Vector2.new(0.5, 0.5)
    heroSeal.Position = UDim2.new(1, -74, 0, 66)
    heroSeal.Size = UDim2.fromOffset(112, 38)
    heroSeal.TextTransparency = 0.12
    local sealLine = Instance.new("Frame")
    sealLine.BackgroundColor3 = T.Accent
    sealLine.BackgroundTransparency = 0.25
    sealLine.BorderSizePixel = 0
    sealLine.AnchorPoint = Vector2.new(0.5, 0)
    sealLine.Position = UDim2.new(1, -74, 0, 91)
    sealLine.Size = UDim2.fromOffset(62, 1)
    sealLine.Parent = hero
    local heroTag = label(hero, "PRIVATE COLLECTION     /     NO. 001", 8, T.AccentBright, Enum.Font.RobotoMono)
    heroTag.Position = UDim2.new(0, 22, 0, 17)
    heroTag.Size = UDim2.new(1, -44, 0, 17)
    heroTag.TextTransparency = 0.05
    local heroTitle = label(hero, "THE COMMAND\nIS YOURS.", 25, T.Text, Enum.Font.Merriweather)
    heroTitle.Name = "HeroTitle"
    heroTitle.Position = UDim2.new(0, 19, 0, 43)
    heroTitle.Size = UDim2.new(1, -142, 0, 66)
    heroTitle.TextYAlignment = Enum.TextYAlignment.Top
    heroTitle.TextWrapped = true
    local heroDesc = label(hero, "A refined command experience, built around your standard.", 9, T.Muted, Enum.Font.SourceSans)
    heroDesc.Position = UDim2.new(0, 19, 1, -43)
    heroDesc.Size = UDim2.new(1, -38, 0, 18)
    local heroRule = Instance.new("Frame")
    heroRule.BackgroundColor3 = T.Accent
    heroRule.BackgroundTransparency = 0.25
    heroRule.BorderSizePixel = 0
    heroRule.Position = UDim2.new(0, 19, 1, -18)
    heroRule.Size = UDim2.new(0, 78, 0, 2)
    heroRule.Parent = hero
    local heroMeta = label(hero, "OBSIDIAN     /     GOLD ACCENTS     /     MOBILE FIRST", 7, T.Muted, Enum.Font.RobotoMono)
    heroMeta.Position = UDim2.new(0, 22, 1, -31)
    heroMeta.Size = UDim2.new(1, -44, 0, 10)
    local heroEdition = label(hero, "SIGNATURE EDITION", 7, T.AccentBright, Enum.Font.RobotoMono, Enum.TextXAlignment.Right)
    heroEdition.AnchorPoint = Vector2.new(1, 0)
    heroEdition.Position = UDim2.new(1, -18, 0, 17)
    heroEdition.Size = UDim2.new(0, 116, 0, 14)
    heroEdition.TextTransparency = 0.14

    section(p, "Live session")
    local live = panelFor(p, 94)
    local liveTime = label(live, "00:00:00", 25, T.Text, Enum.Font.Merriweather)
    liveTime.Position = UDim2.new(0, 17, 0, 13)
    liveTime.Size = UDim2.new(0.56, 0, 0, 34)
    local liveCaption = label(live, "SESSION UPTIME", 8, T.Accent, Enum.Font.RobotoMono)
    liveCaption.Position = UDim2.new(0, 18, 0, 55)
    liveCaption.Size = UDim2.new(0.56, 0, 0, 14)
    local liveDivider = Instance.new("Frame")
    liveDivider.BackgroundColor3 = T.Border
    liveDivider.BorderSizePixel = 0
    liveDivider.Position = UDim2.new(0.62, 0, 0, 18)
    liveDivider.Size = UDim2.new(0, 1, 0, 58)
    liveDivider.Parent = live
    local liveStatus = label(live, "ONLINE", 10, T.Success, Enum.Font.RobotoMono)
    liveStatus.Position = UDim2.new(0.68, 0, 0, 23)
    liveStatus.Size = UDim2.new(0.3, -12, 0, 18)
    local liveStatusRule = Instance.new("Frame")
    liveStatusRule.BackgroundColor3 = T.Success
    liveStatusRule.BorderSizePixel = 0
    liveStatusRule.Position = UDim2.new(0.68, 0, 0, 47)
    liveStatusRule.Size = UDim2.new(0, 28, 0, 1)
    liveStatusRule.Parent = live
    local liveTheme = label(live, "OBSIDIAN EDITION", 8, T.Muted, Enum.Font.SourceSansSemibold)
    liveTheme.Position = UDim2.new(0.68, 0, 0, 48)
    liveTheme.Size = UDim2.new(0.3, -12, 0, 16)

    section(p, "Player profile")
    local profile = panelFor(p, 78)
    profile.Name = "PlayerProfileCard"
    local profileAvatar = Instance.new("ImageLabel")
    profileAvatar.Name = "ProfileAvatar"
    profileAvatar.BackgroundColor3 = T.Surface3
    profileAvatar.BorderSizePixel = 0
    profileAvatar.Position = UDim2.new(0, 13, 0, 11)
    profileAvatar.Size = UDim2.fromOffset(56, 56)
    profileAvatar.Image = ""
    profileAvatar.Parent = profile
    corner(profileAvatar, 12)
    stroke(profileAvatar, T.Accent, 0.45, 1)
    local profileName = label(profile, LocalPlayer.DisplayName or LocalPlayer.Name, 13, T.Text, Enum.Font.RobotoMono)
    profileName.Position = UDim2.new(0, 82, 0, 15)
    profileName.Size = UDim2.new(1, -96, 0, 20)
    local profileHandle = label(profile, "@" .. LocalPlayer.Name, 10, T.Muted, Enum.Font.SourceSansSemibold)
    profileHandle.Position = UDim2.new(0, 82, 0, 38)
    profileHandle.Size = UDim2.new(1, -96, 0, 16)
    local profileTag = label(profile, "LOCAL SESSION  •  PLAYER PROFILE", 7, T.Accent, Enum.Font.RobotoMono)
    profileTag.Position = UDim2.new(0, 82, 0, 57)
    profileTag.Size = UDim2.new(1, -96, 0, 12)
    task.spawn(function()
        local ok, imageUrl = pcall(function()
            return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)
        if ok and profileAvatar and profileAvatar.Parent then profileAvatar.Image = imageUrl end
    end)

    section(p, "Command snapshot")
    local snapshot = Instance.new("Frame")
    snapshot.BackgroundTransparency = 1
    snapshot.Size = UDim2.new(1, 0, 0, 86)
    snapshot.Parent = p
    local snapshotLayout = Instance.new("UIListLayout")
    snapshotLayout.FillDirection = Enum.FillDirection.Horizontal
    snapshotLayout.SortOrder = Enum.SortOrder.LayoutOrder
    snapshotLayout.Padding = UDim.new(0, 8)
    snapshotLayout.Parent = snapshot
    local snapshotItems = {
        {"07", "WORKSPACES", "AVAILABLE"},
        {"04", "THEMES", "BUILT IN"},
        {"LIVE", "SESSION", "LOCAL"},
    }
    for index, item in ipairs(snapshotItems) do
        local tile = Instance.new("Frame")
        tile.BackgroundColor3 = Color3.fromRGB(22, 21, 19)
        tile.BackgroundTransparency = 0.02
        tile.BorderSizePixel = 0
        tile.Size = UDim2.new(1/3, -6, 1, 0)
        tile.LayoutOrder = index
        tile.Parent = snapshot
        corner(tile, 12)
        stroke(tile, T.Accent, 0.72, 1)
        local metricBar = Instance.new("Frame")
        metricBar.BackgroundColor3 = T.Accent
        metricBar.BorderSizePixel = 0
        metricBar.Position = UDim2.new(0, 12, 0, 10)
        metricBar.Size = UDim2.fromOffset(22, 2)
        metricBar.Parent = tile
        local metric = label(tile, item[1], 18, T.AccentBright, Enum.Font.Merriweather)
        metric.Position = UDim2.new(0, 12, 0, 17)
        metric.Size = UDim2.new(1, -20, 0, 25)
        local metricName = label(tile, item[2], 8, T.Text, Enum.Font.RobotoMono)
        metricName.Position = UDim2.new(0, 12, 0, 47)
        metricName.Size = UDim2.new(1, -20, 0, 13)
        local metricHint = label(tile, item[3], 7, T.Quiet, Enum.Font.SourceSansSemibold)
        metricHint.Position = UDim2.new(0, 12, 0, 64)
        metricHint.Size = UDim2.new(1, -20, 0, 11)
    end

    section(p, "Workspace shortcuts")
    local quick = panelFor(p, 270)
    quick.Name = "WorkspaceShortcuts"
    local quickLayout = Instance.new("UIGridLayout")
    quickLayout.Name = "ShortcutGrid"
    quickLayout.CellSize = UDim2.new(0.48, 0, 0, 52)
    quickLayout.CellPadding = UDim2.new(0.025, 0, 0, 8)
    quickLayout.FillDirectionMaxCells = 2
    quickLayout.SortOrder = Enum.SortOrder.LayoutOrder
    quickLayout.Parent = quick
    padding(quick, 12, 12, 12, 12)
    local shortcutData = {
        {"Home", "H", "COMMAND OVERVIEW"},
        {"Aim", "A", "PERSONAL WORKSPACE"},
        {"ESP", "E", "INFORMATION LAYOUT"},
        {"Visuals", "V", "VISUAL EXPERIENCE"},
        {"Misc", "M", "SESSION UTILITIES"},
        {"Settings", "S", "PREFERENCES"},
        {"Console", "C", "ACTIVITY LOG"},
        {"Fly", "F", "FLIGHT CONTROLS"},
    }
    for i, item in ipairs(shortcutData) do
        local target, glyph, detail = item[1], item[2], item[3]
        local q = Instance.new("TextButton")
        q.Name = target .. "Shortcut"
        q.AutoButtonColor = false
        q.Text = ""
        q.BackgroundColor3 = T.Surface2
        q.BorderSizePixel = 0
        q.LayoutOrder = i
        q.ZIndex = 3
        q.Parent = quick
        corner(q, 10)
        stroke(q, T.Border, 0.18, 1)
        local qRail = Instance.new("Frame")
        qRail.Name = "ShortcutGoldRail"
        qRail.BackgroundColor3 = T.Accent
        qRail.BackgroundTransparency = 0.28
        qRail.BorderSizePixel = 0
        qRail.Position = UDim2.new(0, 0, 0.2, 0)
        qRail.Size = UDim2.new(0, 2, 0.6, 0)
        qRail.ZIndex = 4
        qRail.Parent = q
        corner(qRail, 2)
        local qIcon = Instance.new("Frame")
        qIcon.BackgroundColor3 = T.AccentSoft
        qIcon.BorderSizePixel = 0
        qIcon.Position = UDim2.new(0, 8, 0, 8)
        qIcon.Size = UDim2.fromOffset(36, 36)
        qIcon.Name = "ShortcutIcon"
        qIcon.ZIndex = 4
        qIcon.Parent = q
        corner(qIcon, 9)
        local qGlyph = label(qIcon, glyph, 15, T.AccentBright, Enum.Font.RobotoMono, Enum.TextXAlignment.Center)
        qGlyph.Name = "ShortcutGlyph"
        qGlyph.Size = UDim2.fromScale(1, 1)
        qGlyph.ZIndex = 5
        local qTitle = label(q, target:upper(), 10, T.Text, Enum.Font.RobotoMono)
        qTitle.Name = "ShortcutTitle"
        qTitle.Position = UDim2.new(0, 52, 0, 7)
        qTitle.Size = UDim2.new(1, -66, 0, 18)
        qTitle.TextTransparency = 0
        qTitle.TextStrokeTransparency = 0.88
        qTitle.ZIndex = 5
        local qDetail = label(q, detail, 7, T.Muted, Enum.Font.RobotoMono)
        qDetail.Name = "ShortcutDetail"
        qDetail.Position = UDim2.new(0, 52, 0, 27)
        qDetail.Size = UDim2.new(1, -66, 0, 14)
        qDetail.TextTransparency = 0
        qDetail.ZIndex = 5
        local qArrow = label(q, "›", 17, T.Accent, Enum.Font.RobotoMono, Enum.TextXAlignment.Center)
        qArrow.Name = "ShortcutArrow"
        qArrow.AnchorPoint = Vector2.new(1, 0.5)
        qArrow.Position = UDim2.new(1, -7, 0.5, 0)
        qArrow.Size = UDim2.fromOffset(14, 20)
        qArrow.ZIndex = 5
        q.Activated:Connect(function()
            TweenService:Create(qIcon, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = -7}):Play()
            task.delay(0.13, function()
                if qIcon.Parent then TweenService:Create(qIcon, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = 0}):Play() end
            end)
            setPage(target)
        end)
        q.MouseEnter:Connect(function()
            tween(q, 0.16, {BackgroundColor3 = T.AccentSoft})
            tween(qIcon, 0.16, {BackgroundColor3 = T.Accent})
            tween(qRail, 0.16, {BackgroundTransparency = 0})
        end)
        q.MouseLeave:Connect(function()
            tween(q, 0.16, {BackgroundColor3 = T.Surface2})
            tween(qIcon, 0.16, {BackgroundColor3 = T.AccentSoft})
            tween(qRail, 0.16, {BackgroundTransparency = 0.28})
        end)
    end
    quickLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        quick.Size = UDim2.new(1, 0, 0, quickLayout.AbsoluteContentSize.Y + 24)
    end)
    quick.Size = UDim2.new(1, 0, 0, quickLayout.AbsoluteContentSize.Y + 24)

    section(p, "Interface information")
    local info = panelFor(p, 72)
    local infoTitle = label(info, "JT3R  /  EXECUTIVE COMMAND CENTRE", 10, T.Text, Enum.Font.RobotoMono)
    infoTitle.Position = UDim2.new(0, 16, 0, 12)
    infoTitle.Size = UDim2.new(1, -32, 0, 17)
    local infoDesc = label(info, "SIGNATURE BUILD  •  LOCAL PRESENTATION CONTROLS", 9, T.Muted, Enum.Font.SourceSans)
    infoDesc.Position = UDim2.new(0, 16, 0, 38)
    infoDesc.Size = UDim2.new(1, -32, 0, 16)

    -- Membership card: the status is intentionally FREE until a future licence system verifies a key.
    section(p, "Membership")
    local memberPanel = panelFor(p, 88)
    memberPanel.Name = "MembershipPanel"
    local memberBadge = label(memberPanel, "STANDARD", 16, T.AccentBright, Enum.Font.Merriweather)
    memberBadge.Position = UDim2.new(0, 16, 0, 12)
    memberBadge.Size = UDim2.new(0, 100, 0, 25)
    local memberTitle = label(memberPanel, "CURRENT ACCESS PLAN", 8, T.Accent, Enum.Font.RobotoMono)
    memberTitle.Position = UDim2.new(0, 17, 0, 40)
    memberTitle.Size = UDim2.new(0, 170, 0, 13)
    local memberDesc = label(memberPanel, "Standard access  •  Premium features unlock with a verified premium key", 9, T.Muted, Enum.Font.SourceSans)
    memberDesc.Position = UDim2.new(0, 17, 0, 61)
    memberDesc.Size = UDim2.new(1, -34, 0, 16)
    memberDesc.TextTruncate = Enum.TextTruncate.AtEnd

    section(p, "Environment details")
    local envPanel = panelFor(p, 212)
    envPanel.Name = "EnvironmentPanel"
    local envTitle = label(envPanel, "EXECUTOR & CLIENT", 9, T.Accent, Enum.Font.RobotoMono)
    envTitle.Position = UDim2.new(0, 15, 0, 12)
    envTitle.Size = UDim2.new(1, -30, 0, 15)
    local function infoLine(parent, y, keyText, valueText, valueName)
        local k = label(parent, keyText, 9, T.Quiet, Enum.Font.SourceSansSemibold)
        k.Position = UDim2.new(0, 15, 0, y)
        k.Size = UDim2.new(0.42, -8, 0, 17)
        local v = label(parent, valueText, 9, T.Text, Enum.Font.SourceSansSemibold, Enum.TextXAlignment.Right)
        v.Name = valueName or (keyText:gsub("%W", "") .. "Value")
        v.Position = UDim2.new(0.42, 0, 0, y)
        v.Size = UDim2.new(0.58, -15, 0, 17)
        v.TextTruncate = Enum.TextTruncate.AtEnd
        return v
    end
    local executorName, executorVersion = "Unavailable", "Unavailable"
    local identify = identifyexecutor or identify_executor
    if type(identify) == "function" then
        local ok, name, version = pcall(identify)
        if ok and name then executorName = tostring(name) end
        if ok and version then executorVersion = tostring(version) end
    elseif type(getexecutorname) == "function" then
        local ok, name = pcall(getexecutorname)
        if ok and name then executorName = tostring(name) end
    end
    infoLine(envPanel, 37, "EXECUTOR", executorName, "ExecutorValue")
    infoLine(envPanel, 59, "EXECUTOR VERSION", executorVersion, "ExecutorVersionValue")
    infoLine(envPanel, 81, "SCRIPT VERSION", "4.4", "ScriptVersionValue")
    local envDivider = Instance.new("Frame")
    envDivider.BackgroundColor3 = T.Border
    envDivider.BorderSizePixel = 0
    envDivider.Position = UDim2.new(0, 15, 0, 108)
    envDivider.Size = UDim2.new(1, -30, 0, 1)
    envDivider.Parent = envPanel
    local serverTitle = label(envPanel, "CURRENT SERVER", 9, T.Accent, Enum.Font.RobotoMono)
    serverTitle.Position = UDim2.new(0, 15, 0, 117)
    serverTitle.Size = UDim2.new(1, -30, 0, 14)
    local serverJob = tostring(game.JobId or "")
    if serverJob == "" then serverJob = "Unavailable" end
    infoLine(envPanel, 137, "PLAYERS / CAPACITY", tostring(#Players:GetPlayers()) .. " / " .. tostring(Players.MaxPlayers), "PlayerCountValue")
    infoLine(envPanel, 155, "REGION", "Unavailable", "RegionValue")
    infoLine(envPanel, 173, "SERVER ID", serverJob, "ServerIdValue")
    local pingText = "Unavailable"
    pcall(function()
        pingText = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    end)
    infoLine(envPanel, 191, "LATENCY", pingText, "LatencyValue")

    local joinPanel = panelFor(p, 86)
    joinPanel.Name = "ServerActions"
    local joinTitle = label(joinPanel, "SERVER ACTIONS", 9, T.Accent, Enum.Font.RobotoMono)
    joinTitle.Position = UDim2.new(0, 15, 0, 10)
    joinTitle.Size = UDim2.new(1, -30, 0, 15)
    local copyJoin = button(joinPanel, "COPY JOIN SCRIPT", UDim2.new(0.5, -21, 0, 34), T.AccentSoft, T.AccentBright)
    copyJoin.Position = UDim2.new(0, 14, 0, 39)
    copyJoin.TextSize = 9
    local rejoin = button(joinPanel, "REJOIN SERVER", UDim2.new(0.5, -21, 0, 34), T.Surface3, T.Text)
    rejoin.Position = UDim2.new(0.5, 7, 0, 39)
    rejoin.TextSize = 9
    local TeleportService = game:GetService("TeleportService")
    local joinCode = string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game:GetService("Players").LocalPlayer)', game.PlaceId, serverJob)
    copyJoin.MouseButton1Click:Connect(function()
        local copier = setclipboard or toclipboard
        if type(copier) == "function" then
            local ok = pcall(copier, joinCode)
            notify("Server join", ok and "Join script copied to clipboard." or "Clipboard access was unavailable.")
        else
            notify("Server join", "Clipboard support is unavailable in this executor.")
        end
    end)
    rejoin.MouseButton1Click:Connect(function()
        if serverJob == "Unavailable" then
            notify("Rejoin server", "This session has no available server instance ID.")
            return
        end
        local ok, err = pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, serverJob, LocalPlayer)
        end)
        if not ok then notify("Rejoin server", "Teleport request failed: " .. tostring(err)) end
    end)

    -- Refresh values that can change while the dashboard is open.
    task.spawn(function()
        while screenGui.Parent do
            local count = tostring(#Players:GetPlayers()) .. " / " .. tostring(Players.MaxPlayers)
            local value = envPanel:FindFirstChild("PlayerCountValue")
            if value then value.Text = count end
            local pingValue = envPanel:FindFirstChild("LatencyValue")
            if pingValue then
                local currentPing = "Unavailable"
                pcall(function()
                    currentPing = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
                end)
                pingValue.Text = currentPing
            end
            task.wait(3)
        end
    end)

    task.spawn(function()
        while screenGui.Parent do
            local elapsed = math.max(0, math.floor(os.clock() - sessionStartedAt))
            local hours = math.floor(elapsed / 3600)
            local minutes = math.floor((elapsed % 3600) / 60)
            local seconds = elapsed % 60
            liveTime.Text = string.format("%02d:%02d:%02d", hours, minutes, seconds)
            headerClock.Text = os.date("%H:%M:%S")
            headerDate.Text = os.date("%a  •  %d %b %Y")
            liveTheme.Text = string.upper(currentThemeName) .. " EDITION"
            task.wait(1)
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
    local logTitle = label(logPanel, "JT3R FUNHOUSE v5.1 initialised", 12, T.Text, Enum.Font.SourceSansSemibold)
    logTitle.Position = UDim2.new(0, 16, 0, 16)
    logTitle.Size = UDim2.new(1, -32, 0, 20)
    local logDesc = label(logPanel, "UI v5.1  •  Obsidian Atelier  •  Local session", 10, T.Muted, Enum.Font.SourceSans)
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
    b.Size = UDim2.new(1, 0, 0, 46)
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
    local navStroke = Instance.new("UIStroke")
    navStroke.Name = "NavOutline"
    navStroke.Color = T.Accent
    navStroke.Transparency = 1
    navStroke.Thickness = 1
    navStroke.Parent = b
    local icon = label(b, glyph, 9, T.Accent, Enum.Font.RobotoMono, Enum.TextXAlignment.Center)
    icon.Name = "NavIcon"
    icon.Position = UDim2.new(0, 8, 0, 0)
    icon.Size = UDim2.new(0, 28, 1, 0)
    local txt = label(b, string.upper(name), 10, T.Muted, Enum.Font.RobotoMono)
    txt.Position = UDim2.new(0, 43, 0, 0)
    txt.Size = UDim2.new(1, -50, 1, 0)
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
            if heroTitle then heroTitle.Size = UDim2.new(1, -92, 0, 66); heroTitle.TextSize = 19 end
            if heroSeal then heroSeal.Position = UDim2.new(1, -43, 0, 65); heroSeal.Size = UDim2.fromOffset(72, 34); heroSeal.TextSize = 18 end
            if heroGlow then heroGlow.Size = UDim2.fromOffset(92, 92); heroGlow.Position = UDim2.new(1, -6, 0, 12) end
            if heroRing then heroRing.Size = UDim2.fromOffset(78, 78); heroRing.Position = UDim2.new(1, -10, 0, 18) end
        else
            if heroTitle then heroTitle.Size = UDim2.new(1, -142, 0, 66); heroTitle.TextSize = 25 end
            if heroSeal then heroSeal.Position = UDim2.new(1, -74, 0, 66); heroSeal.Size = UDim2.fromOffset(112, 38); heroSeal.TextSize = 24 end
            if heroGlow then heroGlow.Size = UDim2.fromOffset(142, 142); heroGlow.Position = UDim2.new(1, -12, 0, 12) end
            if heroRing then heroRing.Size = UDim2.fromOffset(116, 116); heroRing.Position = UDim2.new(1, -16, 0, 16) end
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
        sidebar.Size = UDim2.new(0, 118, 1, 0)
        navCaption.Text = "MENU"
        content.Position = UDim2.new(0, 118, 0, 0)
        content.Size = UDim2.new(1, -118, 1, 0)
        pageTop.Position = UDim2.new(0, 18, 0, 17)
        pageTop.Size = UDim2.new(1, -36, 0, 48)
        for _, page in pairs(pageFrames) do
            page.Position = UDim2.new(0, 18, 0, 78)
            page.Size = UDim2.new(1, -36, 1, -94)
        end
        brandMark.Position = UDim2.new(0, 12, 0, 13)
        brandMark.Size = UDim2.fromOffset(48, 50)
        brandName.Position = UDim2.new(0, 70, 0, 12)
        brandName.Size = UDim2.new(0, 120, 0, 27)
        brandSub.Text = "FUNHOUSE  /  PRIVATE COLLECTION"
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
        headerRight.Size = UDim2.new(0, 78, 0, 42)
        headerRight.Position = UDim2.new(1, -8, 0, 18)
        minimizeButton.Position = UDim2.new(0, 0, 0, 3)
        minimizeButton.Size = UDim2.fromOffset(36, 36)
        closeButton.Position = UDim2.new(0, 40, 0, 3)
        closeButton.Size = UDim2.fromOffset(36, 36)
    else
        shell.Size = UDim2.new(0, 850, 0, 570)
        shellScale.Scale = userScale * math.min(1, viewport.X / 1000, viewport.Y / 700)
        ambientHalo.Size = UDim2.new(0, 850 * shellScale.Scale + 24, 0, 570 * shellScale.Scale + 24)
        sidebar.Size = UDim2.new(0, 174, 1, 0)
        content.Position = UDim2.new(0, 174, 0, 0)
        content.Size = UDim2.new(1, -174, 1, 0)
        pageTop.Position = UDim2.new(0, 28, 0, 19)
        pageTop.Size = UDim2.new(1, -56, 0, 52)
        for _, page in pairs(pageFrames) do
            page.Position = UDim2.new(0, 28, 0, 83)
            page.Size = UDim2.new(1, -56, 1, -101)
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
        headerRight.Size = UDim2.new(0, 170, 0, 42)
        headerRight.Position = UDim2.new(1, -18, 0, 34)
        headerClock.Position = UDim2.new(1, -194, 0, 9)
        headerDate.Position = UDim2.new(1, -194, 0, 29)
        minimizeButton.Position = UDim2.new(1, -78, 0, 3)
        closeButton.Position = UDim2.new(1, -36, 0, 3)
        statusText.Text = "SESSION ACTIVE"
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

--// Initial state
setPage("Home")
updateResponsive()
task.delay(0.35, function()
    if screenGui.Parent then
        notify("Welcome to JT3R", "Obsidian Atelier  •  v5.1")
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

_G.JT3R_FUNHOUSE = JT3R
