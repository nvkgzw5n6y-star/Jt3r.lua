--[[
    JT3R FUNHOUSE v4.6
    Obsidian Atelier Edition
    Standalone UI shell for Roblox experiences.

    The ESP page includes client-side R6/R15 character visualisation for
    the owner's own Roblox experience: boxes, names, highlights, health,
    team filtering, distance filtering, RGB accents and body-part diagnostics and a server-authorised, whitelist-controlled hitbox expander. It does not include
    aim assistance, automation, anti-cheat bypasses or recording concealment.

    Upload this file to GitHub as JT3R_FUNHOUSE_v4.6.lua.
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
    shade.BackgroundTransparency = 0.24
    shade.BorderSizePixel = 0
    shade.Parent = splashGui

    local card = Instance.new("Frame")
    card.Name = "StartupCard"
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.fromScale(0.5, 0.5)
    card.Size = UDim2.new(0.88, 0, 0, 236)
    card.BackgroundColor3 = Color3.fromRGB(13, 14, 17)
    card.BackgroundTransparency = 0.02
    card.BorderSizePixel = 0
    card.Parent = shade
    card.ClipsDescendants = true
    local cardConstraint = Instance.new("UISizeConstraint")
    cardConstraint.MinSize = Vector2.new(300, 236)
    cardConstraint.MaxSize = Vector2.new(520, 236)
    cardConstraint.Parent = card
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 26)
    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Color3.fromRGB(230, 190, 122)
    cardStroke.Transparency = 0.12
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
    logo.Font = Enum.Font.GothamBlack
    logo.Text = "JT3R"
    logo.TextColor3 = Color3.fromRGB(255, 224, 173)
    logo.TextSize = 27
    logo.Parent = emblem

    local wordmark = Instance.new("TextLabel")
    wordmark.BackgroundTransparency = 1
    wordmark.Position = UDim2.new(0, 124, 0, 34)
    wordmark.Size = UDim2.new(1, -146, 0, 42)
    wordmark.Font = Enum.Font.GothamBlack
    wordmark.Text = "JT3R FUNHOUSE"
    wordmark.TextColor3 = Color3.fromRGB(248, 241, 228)
    wordmark.TextSize = 22
    wordmark.TextXAlignment = Enum.TextXAlignment.Left
    wordmark.Parent = card

    local edition = Instance.new("TextLabel")
    edition.BackgroundTransparency = 1
    edition.Position = UDim2.new(0, 126, 0, 76)
    edition.Size = UDim2.new(1, -148, 0, 22)
    edition.Font = Enum.Font.GothamBold
    edition.Text = "O B S I D I A N   /   P R I V A T E   E D I T I O N"
    edition.TextColor3 = Color3.fromRGB(218, 181, 117)
    edition.TextSize = 9
    edition.TextXAlignment = Enum.TextXAlignment.Left
    edition.Parent = card

    local status = Instance.new("TextLabel")
    status.BackgroundTransparency = 1
    status.Position = UDim2.new(0, 25, 0, 139)
    status.Size = UDim2.new(1, -50, 0, 18)
    status.Font = Enum.Font.GothamSemibold
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
    statusRight.Font = Enum.Font.GothamBold
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
    footer.Font = Enum.Font.Gotham
    footer.Text = "DESIGNED TO STAND APART     •     v4.6"
    footer.TextColor3 = Color3.fromRGB(135, 130, 121)
    footer.TextSize = 8
    footer.TextXAlignment = Enum.TextXAlignment.Left
    footer.Parent = card

    local started, duration = os.clock(), 4.0
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
    task.wait(0.18)
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
    l.Font = font or Enum.Font.Gotham
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
    b.Font = Enum.Font.GothamMedium
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
topAccent.BackgroundColor3 = T.Accent
topAccent.BorderSizePixel = 0
topAccent.Size = UDim2.new(1, 0, 0, 2)
topAccent.Parent = shell

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
logoOuterGlow.Transparency = 0.78
logoOuterGlow.Thickness = 5
logoOuterGlow.Parent = brandMark
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
local brandGlyph = label(markInner, "JT", 18, T.AccentBright, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
brandGlyph.Position = UDim2.new(0, 0, 0, 1)
brandGlyph.TextStrokeColor3 = T.AccentBright
brandGlyph.TextStrokeTransparency = 0.55
brandGlyph.Size = UDim2.new(1, 0, 0, 35)
local markWord = label(markInner, "3R", 7, T.Text, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
markWord.Position = UDim2.new(0, 0, 1, -14)
markWord.Size = UDim2.new(1, 0, 0, 10)
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

local brandName = label(header, "JT3R", 20, T.Text, Enum.Font.GothamBlack)
brandName.Position = UDim2.new(0, 84, 0, 12)
brandName.Size = UDim2.new(0, 190, 0, 28)
brandName.TextStrokeColor3 = T.Accent
brandName.TextStrokeTransparency = 0.78

local brandSub = label(header, "FUNHOUSE   /   PRIVATE COLLECTION", 8, T.Accent, Enum.Font.GothamBold)
brandSub.Position = UDim2.new(0, 85, 0, 42)
brandSub.Size = UDim2.new(0, 240, 0, 16)

-- Invisible hit target makes the complete brand lockup a reliable minimise control.
local logoMinimizeHitbox = Instance.new("TextButton")
logoMinimizeHitbox.Name = "LogoMinimizeButton"
logoMinimizeHitbox.BackgroundTransparency = 1
logoMinimizeHitbox.BorderSizePixel = 0
logoMinimizeHitbox.Text = ""
logoMinimizeHitbox.AutoButtonColor = false
logoMinimizeHitbox.Position = UDim2.new(0, 8, 0, 7)
logoMinimizeHitbox.Size = UDim2.fromOffset(180, 48)
logoMinimizeHitbox.ZIndex = 2
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
headerPlan.Font = Enum.Font.GothamBold
headerPlan.Size = UDim2.fromOffset(82, 24)
headerPlan.AnchorPoint = Vector2.new(1, 0)
headerPlan.Position = UDim2.new(1, -250, 0, 27)
headerPlan.Parent = header
corner(headerPlan, 8)
stroke(headerPlan, T.Accent, 0.42, 1)

local headerClock = label(header, "00:00:00", 12, T.AccentBright, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
headerClock.AnchorPoint = Vector2.new(1, 0)
headerClock.Position = UDim2.new(1, -194, 0, 13)
headerClock.Size = UDim2.new(0, 120, 0, 18)
local headerDate = label(header, "LOCAL DEVICE TIME", 8, T.Quiet, Enum.Font.GothamMedium, Enum.TextXAlignment.Right)
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

local statusText = label(headerRight, "SESSION ACTIVE", 9, T.Muted, Enum.Font.GothamMedium)
statusText.Position = UDim2.new(0, 16, 0, 10)
statusText.Size = UDim2.new(0, 100, 0, 20)

local minimizeButton = button(headerRight, "—", UDim2.fromOffset(36, 36), Color3.fromRGB(57, 47, 31), T.AccentBright)
minimizeButton.Name = "MinimiseControl"
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 21
stroke(minimizeButton, T.AccentBright, 0.12, 1.5)
minimizeButton.TextStrokeColor3 = T.Accent
minimizeButton.TextStrokeTransparency = 0.45
minimizeButton.Position = UDim2.new(1, -78, 0, 3)
minimizeButton.TextSize = 18

local closeButton = button(headerRight, "✕", UDim2.fromOffset(36, 36), Color3.fromRGB(77, 31, 29), Color3.fromRGB(255, 218, 210))
closeButton.Name = "CloseControl"
closeButton.Font = Enum.Font.GothamBold
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

local navCaption = label(sidebar, "WORKSPACE", 9, T.Quiet, Enum.Font.GothamBold)
navCaption.Position = UDim2.new(0, 20, 0, 24)
navCaption.Size = UDim2.new(1, -35, 0, 18)

local navHolder = Instance.new("Frame")
navHolder.BackgroundTransparency = 1
navHolder.Position = UDim2.new(0, 12, 0, 50)
navHolder.Size = UDim2.new(1, -24, 0, 390)
navHolder.Parent = sidebar
listLayout(navHolder, Enum.FillDirection.Vertical, 4)

local navItems = {
    {"Home", "⌂"}, {"Aim", "◎"}, {"ESP", "◈"}, {"Visuals", "◇"},
    {"Fly", "✈"}, {"Dany Chaos", "✦"}, {"Misc", "✣"}, {"Settings", "⚙"}, {"Console", "▤"}
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

local pageEyebrow = label(pageTop, "OVERVIEW", 9, T.Accent, Enum.Font.GothamBold)
pageEyebrow.Position = UDim2.new(0, 0, 0, 0)
pageEyebrow.Size = UDim2.new(1, 0, 0, 14)

local pageTitle = label(pageTop, "Home", 23, T.Text, Enum.Font.GothamSemibold)
pageTitle.Position = UDim2.new(0, 0, 0, 15)
pageTitle.Size = UDim2.new(1, 0, 0, 32)

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

local footerText = label(footer, "JT3R     /     SIGNATURE COMMAND CENTRE", 9, T.Quiet, Enum.Font.GothamMedium)
footerText.Position = UDim2.new(0, 20, 0, 7)
footerText.Size = UDim2.new(0.7, 0, 0, 18)

local footerVersion = label(footer, "V4.4", 9, T.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
footerVersion.AnchorPoint = Vector2.new(1, 0)
footerVersion.Position = UDim2.new(1, -20, 0, 7)
footerVersion.Size = UDim2.new(0, 60, 0, 18)

--// Floating restore button
local restore = button(screenGui, "JT3R", UDim2.fromOffset(64, 64), Color3.fromRGB(37, 30, 22), T.AccentBright)
restore.TextSize = 15
restore.Font = Enum.Font.GothamBlack
restore.TextStrokeColor3 = T.Accent
restore.TextStrokeTransparency = 0.55
restore.Name = "JT3RRestore"
restore.Visible = false
restore.Position = UDim2.new(0, 20, 0.55, 0)
restore.TextSize = 16
restore.Font = Enum.Font.GothamBlack
restore.AutoButtonColor = false
corner(restore, 16)
stroke(restore, T.AccentBright, 0.04, 1.5)
local restoreGlow = Instance.new("UIStroke")
restoreGlow.Color = T.Accent
restoreGlow.Thickness = 5
restoreGlow.Transparency = 0.72
restoreGlow.Parent = restore

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
    local t1 = label(toast, title, 12, T.Text, Enum.Font.GothamSemibold)
    t1.Position = UDim2.new(0, 15, 0, 10)
    t1.Size = UDim2.new(1, -25, 0, 19)
    local t2 = label(toast, message, 10, T.Muted, Enum.Font.Gotham)
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

--// UI construction helpers
local function sectionHeader(text)
    local holder = Instance.new("Frame")
    holder.BackgroundTransparency = 1
    holder.Size = UDim2.new(1, 0, 0, 22)
    holder.Parent = pageScroll
    local txt = label(holder, text:upper(), 9, T.Accent, Enum.Font.GothamBold)
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
    frame:SetAttribute("JT3RPanel", true)
    stroke(frame, T.Accent, glassEnabled and 0.78 or 0.18, 1)
    local sheen = Instance.new("UIGradient")
    sheen.Rotation = 110
    sheen.Color = ColorSequence.new(Color3.fromRGB(45, 41, 34), T.Surface)
    sheen.Transparency = NumberSequence.new(0.42, 0.06)
    sheen.Parent = frame
    return frame
end

local function infoPanel(kicker, title, description, height)
    local frame = panel(height or 128)
    local k = label(frame, kicker:upper(), 9, T.Accent, Enum.Font.GothamBold)
    k.Position = UDim2.new(0, 18, 0, 15)
    k.Size = UDim2.new(1, -36, 0, 16)
    local h = label(frame, title, 17, T.Text, Enum.Font.GothamSemibold)
    h.Position = UDim2.new(0, 18, 0, 38)
    h.Size = UDim2.new(1, -36, 0, 25)
    local d = label(frame, description, 11, T.Muted, Enum.Font.Gotham)
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
    local a = label(row, title, 12, T.Text, Enum.Font.GothamMedium)
    a.Position = UDim2.new(0, 14, 0, 9)
    a.Size = UDim2.new(1, -130, 0, 19)
    local b = label(row, subtitle, 9, T.Muted, Enum.Font.Gotham)
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
        tween(pageTitle, 0.2, {TextTransparency = 0})
        tween(pageEyebrow, 0.2, {TextTransparency = 0})
    else
        pageTitle.TextTransparency = 0
        pageEyebrow.TextTransparency = 0
    end
    for pageName, buttonObject in pairs(pageButtons) do
        local selected = pageName == name
        buttonObject.BackgroundColor3 = selected and T.AccentSoft or T.Surface
        buttonObject.TextColor3 = selected and T.AccentBright or T.Muted
        local marker = buttonObject:FindFirstChild("ActiveGoldMarker")
        if marker then
            marker.Visible = selected
            marker.BackgroundColor3 = T.AccentBright
        end
        local outline = buttonObject:FindFirstChild("NavOutline")
        if outline then outline.Transparency = selected and 0.52 or 1; outline.Color = T.Accent end
        local iconLabel = buttonObject:FindFirstChild("NavIcon")
        if iconLabel then iconLabel.TextColor3 = selected and T.AccentBright or T.Quiet end
        local textLabel = buttonObject:FindFirstChild(name)
        if textLabel and textLabel:IsA("TextLabel") then
            textLabel.Font = selected and Enum.Font.GothamBold or Enum.Font.GothamMedium
        end
    end
    for pageName, frame in pairs(pageFrames) do
        frame.Visible = pageName == name
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
    local l = label(f, text:upper(), 9, T.Accent, Enum.Font.GothamBold)
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
    local eyebrow = label(f, top:upper(), 9, T.Accent, Enum.Font.GothamBold)
    eyebrow.Position = UDim2.new(0, 17, 0, 14)
    eyebrow.Size = UDim2.new(1, -34, 0, 15)
    local h = label(f, title, 16, T.Text, Enum.Font.GothamSemibold)
    h.Position = UDim2.new(0, 17, 0, 36)
    h.Size = UDim2.new(1, -34, 0, 24)
    local d = label(f, desc, 10, T.Muted, Enum.Font.Gotham)
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
    local title = label(row, titleText, 11, T.Text, Enum.Font.GothamSemibold)
    title.Position = UDim2.new(0, 14, 0, 10)
    title.Size = UDim2.new(1, -112, 0, 18)
    local detail = label(row, detailText, 9, T.Muted, Enum.Font.Gotham)
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
    stroke(hero, T.AccentBright, 0.42, 1.2)
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
    local heroSeal = label(hero, "JT3R", 24, T.AccentBright, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
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
    local heroTag = label(hero, "✦   PRIVATE COLLECTION   /   001", 8, T.AccentBright, Enum.Font.GothamBold)
    heroTag.Position = UDim2.new(0, 19, 0, 17)
    heroTag.Size = UDim2.new(1, -38, 0, 17)
    local heroTitle = label(hero, "THE COMMAND\nIS YOURS.", 25, T.Text, Enum.Font.GothamBlack)
    heroTitle.Name = "HeroTitle"
    heroTitle.Position = UDim2.new(0, 19, 0, 43)
    heroTitle.Size = UDim2.new(1, -142, 0, 66)
    heroTitle.TextYAlignment = Enum.TextYAlignment.Top
    heroTitle.TextWrapped = true
    local heroDesc = label(hero, "A refined command experience, built around your standard.", 9, T.Muted, Enum.Font.Gotham)
    heroDesc.Position = UDim2.new(0, 19, 1, -43)
    heroDesc.Size = UDim2.new(1, -38, 0, 18)
    local heroRule = Instance.new("Frame")
    heroRule.BackgroundColor3 = T.Accent
    heroRule.BackgroundTransparency = 0.25
    heroRule.BorderSizePixel = 0
    heroRule.Position = UDim2.new(0, 19, 1, -18)
    heroRule.Size = UDim2.new(0, 78, 0, 2)
    heroRule.Parent = hero
    local heroMeta = label(hero, "OBSIDIAN  •  GOLD ACCENTS  •  MOBILE FIRST", 7, T.Quiet, Enum.Font.GothamBold)
    heroMeta.Position = UDim2.new(0, 19, 1, -31)
    heroMeta.Size = UDim2.new(1, -38, 0, 10)

    section(p, "Live session")
    local live = panelFor(p, 94)
    local liveTime = label(live, "00:00:00", 25, T.Text, Enum.Font.GothamBlack)
    liveTime.Position = UDim2.new(0, 17, 0, 13)
    liveTime.Size = UDim2.new(0.56, 0, 0, 34)
    local liveCaption = label(live, "SESSION UPTIME", 8, T.Accent, Enum.Font.GothamBold)
    liveCaption.Position = UDim2.new(0, 18, 0, 55)
    liveCaption.Size = UDim2.new(0.56, 0, 0, 14)
    local liveDivider = Instance.new("Frame")
    liveDivider.BackgroundColor3 = T.Border
    liveDivider.BorderSizePixel = 0
    liveDivider.Position = UDim2.new(0.62, 0, 0, 18)
    liveDivider.Size = UDim2.new(0, 1, 0, 58)
    liveDivider.Parent = live
    local liveStatus = label(live, "●  ONLINE", 10, T.Success, Enum.Font.GothamBold)
    liveStatus.Position = UDim2.new(0.68, 0, 0, 23)
    liveStatus.Size = UDim2.new(0.3, -12, 0, 18)
    local liveTheme = label(live, "OBSIDIAN EDITION", 8, T.Muted, Enum.Font.GothamMedium)
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
    local profileName = label(profile, LocalPlayer.DisplayName or LocalPlayer.Name, 13, T.Text, Enum.Font.GothamBold)
    profileName.Position = UDim2.new(0, 82, 0, 15)
    profileName.Size = UDim2.new(1, -96, 0, 20)
    local profileHandle = label(profile, "@" .. LocalPlayer.Name, 10, T.Muted, Enum.Font.GothamMedium)
    profileHandle.Position = UDim2.new(0, 82, 0, 38)
    profileHandle.Size = UDim2.new(1, -96, 0, 16)
    local profileTag = label(profile, "LOCAL SESSION  •  PLAYER PROFILE", 7, T.Accent, Enum.Font.GothamBold)
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
        local metric = label(tile, item[1], 18, T.AccentBright, Enum.Font.GothamBlack)
        metric.Position = UDim2.new(0, 12, 0, 17)
        metric.Size = UDim2.new(1, -20, 0, 25)
        local metricName = label(tile, item[2], 8, T.Text, Enum.Font.GothamBold)
        metricName.Position = UDim2.new(0, 12, 0, 47)
        metricName.Size = UDim2.new(1, -20, 0, 13)
        local metricHint = label(tile, item[3], 7, T.Quiet, Enum.Font.GothamMedium)
        metricHint.Position = UDim2.new(0, 12, 0, 64)
        metricHint.Size = UDim2.new(1, -20, 0, 11)
    end

    section(p, "Workspace shortcuts")
    local quick = panelFor(p, 202)
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
        {"Aim", "◎", "PERSONAL WORKSPACE"},
        {"ESP", "◈", "INFORMATION LAYOUT"},
        {"Visuals", "✧", "VISUAL EXPERIENCE"},
        {"Misc", "⌘", "SESSION UTILITIES"},
        {"Settings", "⚙", "PREFERENCES"},
        {"Console", "▤", "ACTIVITY LOG"},
        {"Fly", "✈", "FLIGHT CONTROLS"},
        {"Dany Chaos", "✦", "INTERACTIVE EVENT"},
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
        q.Parent = quick
        corner(q, 10)
        stroke(q, T.Border, 0.3, 1)
        local qIcon = Instance.new("Frame")
        qIcon.BackgroundColor3 = T.AccentSoft
        qIcon.BorderSizePixel = 0
        qIcon.Position = UDim2.new(0, 8, 0, 8)
        qIcon.Size = UDim2.fromOffset(36, 36)
        qIcon.Name = "ShortcutIcon"
        qIcon.Parent = q
        corner(qIcon, 9)
        local qGlyph = label(qIcon, glyph, 17, T.AccentBright, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        qGlyph.Size = UDim2.fromScale(1, 1)
        local qTitle = label(q, target:upper(), 9, T.Text, Enum.Font.GothamBold)
        qTitle.Position = UDim2.new(0, 52, 0, 8)
        qTitle.Size = UDim2.new(1, -62, 0, 16)
        local qDetail = label(q, detail, 6, T.Quiet, Enum.Font.GothamBold)
        qDetail.Position = UDim2.new(0, 52, 0, 25)
        qDetail.Size = UDim2.new(1, -62, 0, 13)
        local qArrow = label(q, "›", 17, T.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        qArrow.AnchorPoint = Vector2.new(1, 0.5)
        qArrow.Position = UDim2.new(1, -7, 0.5, 0)
        qArrow.Size = UDim2.fromOffset(14, 20)
        q.MouseButton1Click:Connect(function()
            setPage(target)
        end)
        q.MouseEnter:Connect(function()
            tween(q, 0.16, {BackgroundColor3 = T.AccentSoft})
            tween(qIcon, 0.16, {BackgroundColor3 = T.Accent})
        end)
        q.MouseLeave:Connect(function()
            tween(q, 0.16, {BackgroundColor3 = T.Surface2})
            tween(qIcon, 0.16, {BackgroundColor3 = T.AccentSoft})
        end)
    end

    section(p, "Interface information")
    local info = panelFor(p, 72)
    local infoTitle = label(info, "JT3R  /  EXECUTIVE COMMAND CENTRE", 10, T.Text, Enum.Font.GothamBold)
    infoTitle.Position = UDim2.new(0, 16, 0, 12)
    infoTitle.Size = UDim2.new(1, -32, 0, 17)
    local infoDesc = label(info, "SIGNATURE BUILD  •  LOCAL PRESENTATION CONTROLS", 9, T.Muted, Enum.Font.Gotham)
    infoDesc.Position = UDim2.new(0, 16, 0, 38)
    infoDesc.Size = UDim2.new(1, -32, 0, 16)

    -- Membership card: the status is intentionally FREE until a future licence system verifies a key.
    section(p, "Membership")
    local memberPanel = panelFor(p, 88)
    memberPanel.Name = "MembershipPanel"
    local memberBadge = label(memberPanel, "STANDARD", 16, T.AccentBright, Enum.Font.GothamBlack)
    memberBadge.Position = UDim2.new(0, 16, 0, 12)
    memberBadge.Size = UDim2.new(0, 100, 0, 25)
    local memberTitle = label(memberPanel, "CURRENT ACCESS PLAN", 8, T.Accent, Enum.Font.GothamBold)
    memberTitle.Position = UDim2.new(0, 17, 0, 40)
    memberTitle.Size = UDim2.new(0, 170, 0, 13)
    local memberDesc = label(memberPanel, "Standard access  •  Premium features unlock with a verified premium key", 9, T.Muted, Enum.Font.Gotham)
    memberDesc.Position = UDim2.new(0, 17, 0, 61)
    memberDesc.Size = UDim2.new(1, -34, 0, 16)
    memberDesc.TextTruncate = Enum.TextTruncate.AtEnd

    section(p, "Environment details")
    local envPanel = panelFor(p, 212)
    envPanel.Name = "EnvironmentPanel"
    local envTitle = label(envPanel, "EXECUTOR & CLIENT", 9, T.Accent, Enum.Font.GothamBold)
    envTitle.Position = UDim2.new(0, 15, 0, 12)
    envTitle.Size = UDim2.new(1, -30, 0, 15)
    local function infoLine(parent, y, keyText, valueText, valueName)
        local k = label(parent, keyText, 9, T.Quiet, Enum.Font.GothamMedium)
        k.Position = UDim2.new(0, 15, 0, y)
        k.Size = UDim2.new(0.42, -8, 0, 17)
        local v = label(parent, valueText, 9, T.Text, Enum.Font.GothamSemibold, Enum.TextXAlignment.Right)
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
    local serverTitle = label(envPanel, "CURRENT SERVER", 9, T.Accent, Enum.Font.GothamBold)
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
    local joinTitle = label(joinPanel, "SERVER ACTIONS", 9, T.Accent, Enum.Font.GothamBold)
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
    ["Dany Chaos"] = {"INTERACTIVE EXPERIENCE", "¿Dany es hermoso?", "A playful yes-or-no event with a reveal sequence and escalating local-only visual chaos."},
    Aim = {"TARGETING WORKSPACE", "Aim workspace", "A dedicated visual workspace for organising future interface preferences."},
    ESP = {"LIVE PLAYER VISUALS", "Player visualisation", "Local character boxes, names, health and highlight controls for your own experience."},
    Visuals = {"PRESENTATION WORKSPACE", "Visual presentation", "Tune the look and feel of the JT3R interface itself."},
    Misc = {"UTILITY WORKSPACE", "Session utilities", "Small local tools for notifications, navigation and interface housekeeping."},
}
for _, name in ipairs({"Aim", "ESP", "Visuals", "Fly", "Dany Chaos", "Misc"}) do
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
    local iconText = label(iconTile, ({Aim="◎", ESP="◈", Visuals="✧", Fly="✈", ["Dany Chaos"]="✦", Misc="⌘"})[name], 21, T.AccentBright, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    iconText.Size = UDim2.fromScale(1, 1)
    local title = label(intro, copy[2], 17, T.Text, Enum.Font.GothamSemibold)
    title.Position = UDim2.new(0, 76, 0, 17)
    title.Size = UDim2.new(1, -92, 0, 25)
    local status = label(intro, "INTERFACE PREVIEW  /  READY", 8, T.Accent, Enum.Font.GothamBold)
    status.Position = UDim2.new(0, 76, 0, 45)
    status.Size = UDim2.new(1, -92, 0, 15)
    local desc = label(intro, copy[3], 10, T.Muted, Enum.Font.Gotham)
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
        local statValue = label(stat, item[1], 18, T.AccentBright, Enum.Font.GothamBlack)
        statValue.Position = UDim2.new(0, 13, 0, 8)
        statValue.Size = UDim2.new(1, -24, 0, 23)
        local statName = label(stat, item[2], 7, T.Muted, Enum.Font.GothamBold)
        statName.Position = UDim2.new(0, 13, 0, 37)
        statName.Size = UDim2.new(1, -24, 0, 13)
    end

    if name == "Aim" then
        local aimUiState = {Silent = false, Assist = false, Team = true, FOV = true}
        section(p, "Practice controls")
        textBlock(p, "STUDIO LINK", "Aim module workspace", "Mobile-friendly control layout is ready. Connect these switches to your own Studio practice-target system; this standalone loader does not redirect weapon rays or automate camera targeting.")
        interfaceSwitch(p, "Silent aim module", "UI switch only — connect your own Studio target logic.", aimUiState.Silent, function(on)
            aimUiState.Silent = on
            notify("Silent aim", on and "Module switch enabled — Studio logic not connected." or "Module switch disabled.")
        end)
        interfaceSwitch(p, "Camera aim assist", "UI switch only — intended for your own practice targets.", aimUiState.Assist, function(on)
            aimUiState.Assist = on
            notify("Aim assist", on and "Module switch enabled — Studio logic not connected." or "Module switch disabled.")
        end)
        interfaceSwitch(p, "Practice team filter", "Keep friendly practice dummies out of target lists.", aimUiState.Team, function(on)
            aimUiState.Team = on
        end)
        interfaceSwitch(p, "FOV guide preview", "Toggle a visual-only aiming guide in the interface.", aimUiState.FOV, function(on)
            aimUiState.FOV = on
        end)
        section(p, "Configuration")
        miniAction(p, "Aim strength", "Practice profile strength preset.", "CYCLE", function()
            notify("Aim profile", "Strength presets belong in your Studio practice module.")
        end)
        miniAction(p, "Target part", "Choose the target part in your Studio module.", "SELECT", function()
            notify("Target part", "Use Head or HumanoidRootPart in your Studio configuration.")
        end)
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
            nameLabel.Font = Enum.Font.GothamBold
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
            itemLabel.Font = Enum.Font.GothamMedium
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
        local flyBanner = label(flyPanel, "✈   JT3R FLIGHT", 17, T.AccentBright, Enum.Font.GothamBlack)
        flyBanner.Position = UDim2.new(0, 16, 0, 13)
        flyBanner.Size = UDim2.new(1, -32, 0, 24)
        local flySub = label(flyPanel, "CONTROLLED MOVEMENT  /  PC + MOBILE", 8, T.Accent, Enum.Font.GothamBold)
        flySub.Position = UDim2.new(0, 17, 0, 41)
        flySub.Size = UDim2.new(1, -34, 0, 15)
        local flyInfo = label(flyPanel, "PC  WASD to move  •  E rise  •  Q descend\nMOBILE  Analogue joystick + altitude buttons", 10, T.Muted, Enum.Font.Gotham)
        flyInfo.Position = UDim2.new(0, 16, 0, 65)
        flyInfo.Size = UDim2.new(1, -32, 0, 38)
        flyInfo.TextWrapped = true
        flyInfo.TextYAlignment = Enum.TextYAlignment.Top
        local flyStatusTop = label(flyPanel, "SERVER-AUTHORISED FLIGHT", 8, T.Success, Enum.Font.GothamBold)
        flyStatusTop.Position = UDim2.new(0, 16, 0, 112)
        flyStatusTop.Size = UDim2.new(1, -32, 0, 16)
        local flyButton = button(flyPanel, "ACTIVATE FLIGHT", UDim2.new(1, -28, 0, 38), T.AccentSoft, T.AccentBright)
        flyButton.Position = UDim2.new(0, 14, 0, 139)
        flyButton.TextSize = 10
        local flyStatus = label(flyPanel, "STANDBY  •  REQUIRES GAME SUPPORT", 8, T.Quiet, Enum.Font.GothamBold)
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
        local liftTitle = label(mobileControl, "ALTITUDE", 8, T.Muted, Enum.Font.GothamBold)
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
        local noteText = label(note, "This is not universal executor flight. Your own experience must provide a permission-checked JT3R_FlyControl RemoteEvent and server movement handler.", 9, T.Muted, Enum.Font.Gotham)
        noteText.Position = UDim2.new(0, 15, 0, 10)
        noteText.Size = UDim2.new(1, -30, 0, 46)
        noteText.TextWrapped = true
        noteText.TextYAlignment = Enum.TextYAlignment.Top

    elseif name == "Dany Chaos" then
        section(p, "The question")
        local danyCard = panelFor(p, 260)
        stroke(danyCard, Color3.fromRGB(174, 105, 240), 0.18, 1.5)
        local danyGlow = Instance.new("Frame")
        danyGlow.BackgroundColor3 = Color3.fromRGB(90, 35, 160)
        danyGlow.BackgroundTransparency = 0.76
        danyGlow.BorderSizePixel = 0
        danyGlow.Size = UDim2.new(1, -16, 1, -16)
        danyGlow.Position = UDim2.fromOffset(8, 8)
        danyGlow.Parent = danyCard
        corner(danyGlow, 16)
        local danyTitle = label(danyCard, "¿DANY ES HERMOSO?", 20, Color3.fromRGB(245, 225, 255), Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
        danyTitle.Position = UDim2.new(0, 12, 0, 25)
        danyTitle.Size = UDim2.new(1, -24, 0, 42)
        local danySub = label(danyCard, "Piensa MUY bien antes de responder... 👀", 10, T.Muted, Enum.Font.Gotham, Enum.TextXAlignment.Center)
        danySub.Position = UDim2.new(0, 12, 0, 76)
        danySub.Size = UDim2.new(1, -24, 0, 24)
        local yesBtn = button(danyCard, "SÍ  💖", UDim2.new(0.43, 0, 0, 48), Color3.fromRGB(39, 145, 91), Color3.fromRGB(255,255,255))
        yesBtn.Position = UDim2.new(0.05, 0, 0, 132)
        yesBtn.TextSize = 15
        yesBtn.Font = Enum.Font.GothamBold
        local noBtn = button(danyCard, "NO  💀", UDim2.new(0.43, 0, 0, 48), Color3.fromRGB(145, 42, 47), Color3.fromRGB(255,255,255))
        noBtn.Position = UDim2.new(0.52, 0, 0, 132)
        noBtn.TextSize = 15
        noBtn.Font = Enum.Font.GothamBold
        local danyFoot = label(danyCard, "LOCAL EVENT  •  VISUAL PRANK  •  CANCEL ANYTIME", 8, Color3.fromRGB(191, 157, 218), Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        danyFoot.Position = UDim2.new(0, 12, 1, -34)
        danyFoot.Size = UDim2.new(1, -24, 0, 16)
        local reveal = panelFor(p, 120)
        reveal.Visible = false
        local revealTitle = label(reveal, "JOSUEFLO2020  •  TE APRUEBA ✅", 15, Color3.fromRGB(220, 190, 255), Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
        revealTitle.Position = UDim2.new(0, 14, 0, 18)
        revealTitle.Size = UDim2.new(1, -28, 0, 26)
        local revealText = label(reveal, "Porque Dany SÍ es hermoso 💖", 12, T.Text, Enum.Font.GothamSemibold, Enum.TextXAlignment.Center)
        revealText.Position = UDim2.new(0, 14, 0, 53)
        revealText.Size = UDim2.new(1, -28, 0, 24)
        local revealAvatar = Instance.new("ImageLabel")
        revealAvatar.BackgroundTransparency = 1
        revealAvatar.Size = UDim2.fromOffset(48, 48)
        revealAvatar.Position = UDim2.new(0.5, -24, 1, -55)
        revealAvatar.Parent = reveal
        corner(revealAvatar, 24)
        task.spawn(function()
            local ok, imageUrl = pcall(function()
                local userId = Players:GetUserIdFromNameAsync("josueflo2020")
                return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
            end)
            if ok and revealAvatar.Parent then revealAvatar.Image = imageUrl end
        end)
        yesBtn.MouseButton1Click:Connect(function()
            reveal.Visible = true
            tween(danyCard, 0.25, {BackgroundTransparency = 0.3})
            notify("Dany", "Respuesta correcta. Josueflo2020 te aprueba 💜")
        end)
        local chaosActive = false
        local chaosGui, chaosBlur, chaosColor
        local chaosToken = 0
        local function stopChaos()
            chaosActive = false
            chaosToken += 1
            if chaosGui then chaosGui:Destroy(); chaosGui = nil end
            if chaosBlur then chaosBlur:Destroy(); chaosBlur = nil end
            if chaosColor then chaosColor:Destroy(); chaosColor = nil end
            notify("Dany Chaos", "Chaos cancelled. Your local view has been restored.")
        end
        noBtn.MouseButton1Click:Connect(function()
            if chaosActive then return end
            chaosActive = true
            chaosToken += 1
            local myToken = chaosToken
            chaosGui = Instance.new("ScreenGui")
            chaosGui.Name = "JT3R_DanyChaos"
            chaosGui.IgnoreGuiInset = true
            chaosGui.ResetOnSpawn = false
            chaosGui.DisplayOrder = 10000
            chaosGui.Parent = PlayerGui
            local overlay = Instance.new("Frame")
            overlay.Size = UDim2.fromScale(1,1)
            overlay.BackgroundColor3 = Color3.fromRGB(10,0,14)
            overlay.BackgroundTransparency = 0.22
            overlay.BorderSizePixel = 0
            overlay.Parent = chaosGui
            local headline = Instance.new("TextLabel")
            headline.BackgroundTransparency = 1
            headline.AnchorPoint = Vector2.new(0.5,0.5)
            headline.Position = UDim2.fromScale(0.5,0.42)
            headline.Size = UDim2.new(0.9,0,0,100)
            headline.Font = Enum.Font.GothamBlack
            headline.Text = "RESPONDISTE MAL..."
            headline.TextColor3 = Color3.fromRGB(255,75,85)
            headline.TextScaled = true
            headline.Parent = overlay
            local cancel = Instance.new("TextButton")
            cancel.Size = UDim2.fromOffset(176,42)
            cancel.AnchorPoint = Vector2.new(0.5,1)
            cancel.Position = UDim2.new(0.5,0,1,-28)
            cancel.BackgroundColor3 = Color3.fromRGB(45,35,48)
            cancel.TextColor3 = Color3.fromRGB(255,230,235)
            cancel.Text = "CANCEL CHAOS"
            cancel.Font = Enum.Font.GothamBold
            cancel.TextSize = 12
            cancel.Parent = overlay
            corner(cancel, 12)
            stroke(cancel, Color3.fromRGB(230,105,125), 0.2, 1.3)
            cancel.MouseButton1Click:Connect(stopChaos)
            chaosBlur = Instance.new("BlurEffect")
            chaosBlur.Size = 0
            chaosBlur.Parent = Lighting
            chaosColor = Instance.new("ColorCorrectionEffect")
            chaosColor.Brightness = 0
            chaosColor.Saturation = 0
            chaosColor.Parent = Lighting
            local function phase(at, fn)
                task.delay(at, function()
                    if not chaosActive or chaosToken ~= myToken then return end
                    fn()
                end)
            end
            phase(5, function()
                tween(chaosBlur, 3, {Size = 4})
                tween(chaosColor, 4, {TintColor = Color3.fromRGB(255,175,175), Saturation = -0.15})
                headline.Text = "ALGO NO ESTÁ BIEN..."
            end)
            phase(16, function()
                tween(chaosBlur, 3, {Size = 9})
                tween(chaosColor, 4, {TintColor = Color3.fromRGB(255,75,75), Saturation = -0.45, Brightness = -0.12})
                headline.Text = "ESTO ES TU CULPA 😈"
                for i = 1, 5 do
                    local glitch = Instance.new("TextLabel")
                    glitch.BackgroundTransparency = 1
                    glitch.Size = UDim2.new(0.8,0,0,54)
                    glitch.Position = UDim2.fromScale(math.random()*0.2, math.random()*0.7)
                    glitch.Text = ({"TODO SE ACABÓ","¿POR QUÉ?","DANY NO TE PERDONA"})[math.random(3)]
                    glitch.TextColor3 = Color3.fromRGB(255,55,65)
                    glitch.TextScaled = true
                    glitch.Font = Enum.Font.GothamBlack
                    glitch.Parent = overlay
                    task.delay(2.5, function() if glitch.Parent then glitch:Destroy() end end)
                end
            end)
            phase(30, function()
                tween(chaosBlur, 4, {Size = 18})
                tween(chaosColor, 4, {TintColor = Color3.fromRGB(255,20,25), Saturation = -0.9, Brightness = -0.35})
                headline.Text = "☠️  NO HAY VUELTA ATRÁS  ☠️"
                for i = 1, 8 do
                    local flash = Instance.new("Frame")
                    flash.Size = UDim2.fromScale(1,1)
                    flash.BackgroundColor3 = Color3.fromHSV(math.random(), 0.9, 1)
                    flash.BackgroundTransparency = 0.72
                    flash.BorderSizePixel = 0
                    flash.Parent = overlay
                    task.delay(0.18, function() if flash.Parent then flash:Destroy() end end)
                    task.wait(0.12)
                end
            end)
            phase(45, function()
                headline.Text = "HAS SIDO EXPULSADO DEL SERVIDOR 💀"
                tween(overlay, 1.2, {BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 0.02})
                task.delay(3, function()
                    if chaosActive and chaosToken == myToken then
                        LocalPlayer:Kick("Respondiste mal... Dany no te perdona 💀")
                    end
                end)
            end)
            notify("Dany Chaos", "The local visual sequence has started. You can cancel it at any time.")
        end)
        section(p, "How it works")
        local danyNote = panelFor(p, 74)
        local danyNoteText = label(danyNote, "Only your screen and local Lighting effects change. Other players and shared map parts are not moved. The final kick applies only to your own client, and CANCEL CHAOS stops the sequence.", 9, T.Muted, Enum.Font.Gotham)
        danyNoteText.Position = UDim2.new(0, 15, 0, 10)
        danyNoteText.Size = UDim2.new(1, -30, 0, 54)
        danyNoteText.TextWrapped = true
        danyNoteText.TextYAlignment = Enum.TextYAlignment.Top
    elseif name == "Misc" then
        section(p, "Player intelligence")
        local selectedPlayer = nil
        local inventoryPanel = panelFor(p, 300)
        local invTitle = label(inventoryPanel, "INVENTORY VIEWER", 9, T.Accent, Enum.Font.GothamBold)
        invTitle.Position = UDim2.new(0, 16, 0, 13)
        invTitle.Size = UDim2.new(1, -32, 0, 16)
        local invName = label(inventoryPanel, "Selected player: none", 13, T.Text, Enum.Font.GothamSemibold)
        invName.Position = UDim2.new(0, 16, 0, 35)
        invName.Size = UDim2.new(1, -32, 0, 20)
        local invStatus = label(inventoryPanel, "Choose a username, then refresh their locally visible Tools.", 9, T.Muted, Enum.Font.Gotham)
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
        inventorySearch.Font = Enum.Font.Gotham
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
        local inventoryText = label(inventoryPanel, "No inventory loaded.", 10, T.Text, Enum.Font.GothamMedium)
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
                local empty = label(playerScroll, "No other players in this server.", 9, T.Muted, Enum.Font.Gotham)
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
        local rangeTitle = label(rangePanel, "EXTENDED ESP RANGE", 9, T.Accent, Enum.Font.GothamBold)
        rangeTitle.Position = UDim2.new(0, 16, 0, 13)
        rangeTitle.Size = UDim2.new(1, -32, 0, 16)
        local rangeDesc = label(rangePanel, "Up to 70,000 studs when character data is present locally.", 10, T.Text, Enum.Font.GothamMedium)
        rangeDesc.Position = UDim2.new(0, 16, 0, 36)
        rangeDesc.Size = UDim2.new(1, -32, 0, 18)
        local streamNote = label(rangePanel, "StreamingEnabled can prevent distant characters from existing on your client; this GUI cannot force them to load.", 9, T.Muted, Enum.Font.Gotham)
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
        local actionTitle = label(actionPanel, "PLAYER KNOCKBACK", 9, T.Accent, Enum.Font.GothamBold)
        actionTitle.Position = UDim2.new(0, 16, 0, 12)
        actionTitle.Size = UDim2.new(1, -32, 0, 16)
        local actionDesc = label(actionPanel, "Select a player, then send an authorised knockback request.", 9, T.Muted, Enum.Font.Gotham)
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
        flingSearch.Font = Enum.Font.Gotham
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
                local empty = label(flingScroll, "No other players found.", 9, T.Muted, Enum.Font.Gotham)
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
    local thTitle = label(themePanel, "Interface theme", 13, T.Text, Enum.Font.GothamSemibold)
    thTitle.Position = UDim2.new(0, 16, 0, 13)
    thTitle.Size = UDim2.new(1, -32, 0, 20)
    local thDesc = label(themePanel, "Choose an accent profile.", 10, T.Muted, Enum.Font.Gotham)
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
    local glassTitle = label(finishPanel, "Liquid glass finish", 12, T.Text, Enum.Font.GothamMedium)
    glassTitle.Position = UDim2.new(0, 16, 0, 12)
    glassTitle.Size = UDim2.new(0.62, 0, 0, 20)
    local glassDesc = label(finishPanel, "Smoked translucent panels and soft edge sheen.", 9, T.Muted, Enum.Font.Gotham)
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
    local lightTitle = label(finishPanel, "Ambient edge lighting", 12, T.Text, Enum.Font.GothamMedium)
    lightTitle.Position = UDim2.new(0, 16, 0, 65)
    lightTitle.Size = UDim2.new(0.62, 0, 0, 20)
    local lightDesc = label(finishPanel, "A restrained champagne halo around the window.", 9, T.Muted, Enum.Font.Gotham)
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
    local motionTitle = label(motionPanel, "Interface animations", 12, T.Text, Enum.Font.GothamMedium)
    motionTitle.Position = UDim2.new(0, 15, 0, 10)
    motionTitle.Size = UDim2.new(0.66, 0, 0, 20)
    local motionDesc = label(motionPanel, "Page fades, toast movement and subtle UI motion.", 9, T.Muted, Enum.Font.Gotham)
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
    local rgbTitle = label(rgbPanel, "RAINBOW / RGB ACCENTS", 12, T.Text, Enum.Font.GothamMedium)
    rgbTitle.Position = UDim2.new(0, 15, 0, 10)
    rgbTitle.Size = UDim2.new(0.62, 0, 0, 20)
    local rgbDesc = label(rgbPanel, "Slow colour movement on selected trim only.", 9, T.Muted, Enum.Font.Gotham)
    rgbDesc.Position = UDim2.new(0, 15, 0, 34)
    rgbDesc.Size = UDim2.new(1, -30, 0, 15)
    local rgbButton = button(rgbPanel, "OFF", UDim2.fromOffset(58, 30), T.Surface3, T.Muted)
    rgbButton.AnchorPoint = Vector2.new(1, 0)
    rgbButton.Position = UDim2.new(1, -13, 0, 12)
    local rgbEnabled = false
    local rgbTargets = {topAccent, brandMark, ambientHalo}
    rgbButton.MouseButton1Click:Connect(function()
        rgbEnabled = not rgbEnabled
        rgbButton.Text = rgbEnabled and "ON" or "OFF"
        rgbButton.BackgroundColor3 = rgbEnabled and T.AccentSoft or T.Surface3
        rgbButton.TextColor3 = rgbEnabled and T.AccentBright or T.Muted
        if not rgbEnabled then
            for _, target in ipairs(rgbTargets) do
                if target and target.Parent then target.BackgroundColor3 = T.Accent end
            end
        end
        notify("Rainbow accents", rgbEnabled and "Rainbow accent cycle enabled." or "Rainbow accents disabled.")
    end)
    task.spawn(function()
        while screenGui.Parent do
            if rgbEnabled and not isMinimized then
                local hue = (os.clock() * 0.055) % 1
                local color = Color3.fromHSV(hue, 0.48, 0.95)
                for _, target in ipairs(rgbTargets) do
                    if target and target.Parent then target.BackgroundColor3 = color end
                end
            end
            task.wait(0.08)
        end
    end)

    section(p, "Configurations")
    local configPanel = panelFor(p, 276)
    local configTitle = label(configPanel, "PERSISTENT CONFIGURATION LIBRARY", 10, T.Text, Enum.Font.GothamBold)
    configTitle.Position = UDim2.new(0, 15, 0, 10)
    configTitle.Size = UDim2.new(1, -30, 0, 16)
    local configDesc = label(configPanel, "Named presets are stored on this device and remain after rejoining.", 9, T.Muted, Enum.Font.Gotham)
    configDesc.Position = UDim2.new(0, 15, 0, 29)
    configDesc.Size = UDim2.new(1, -30, 0, 14)

    local configName = Instance.new("TextBox")
    configName.Name = "ConfigName"
    configName.ClearTextOnFocus = false
    configName.PlaceholderText = "Enter a preset name"
    configName.Text = "My Config"
    configName.TextSize = 11
    configName.Font = Enum.Font.Gotham
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

    local configStatus = label(configPanel, "Checking device storage...", 8, T.Quiet, Enum.Font.Gotham)
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
            local empty = label(configList, "No presets saved yet.", 9, T.Quiet, Enum.Font.Gotham)
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
    local scaleTitle = label(uiPanel, "Interface scale", 12, T.Text, Enum.Font.GothamMedium)
    scaleTitle.Position = UDim2.new(0, 16, 0, 13)
    scaleTitle.Size = UDim2.new(0.55, 0, 0, 20)
    local scaleValue = label(uiPanel, "100%", 10, T.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
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
    local exitTitle = label(exitPanel, "Uninject JT3R", 12, T.Text, Enum.Font.GothamSemibold)
    exitTitle.Position = UDim2.new(0, 15, 0, 10)
    exitTitle.Size = UDim2.new(1, -130, 0, 20)
    local exitDesc = label(exitPanel, "Close the interface and disconnect its listeners.", 9, T.Muted, Enum.Font.Gotham)
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
    local logTitle = label(logPanel, "JT3R FUNHOUSE v4.6 initialised", 12, T.Text, Enum.Font.GothamMedium)
    logTitle.Position = UDim2.new(0, 16, 0, 16)
    logTitle.Size = UDim2.new(1, -32, 0, 20)
    local logDesc = label(logPanel, "UI v4.6  •  Obsidian Atelier  •  Local session", 10, T.Muted, Enum.Font.Gotham)
    logDesc.Position = UDim2.new(0, 16, 0, 43)
    logDesc.Size = UDim2.new(1, -32, 0, 18)
    local logState = label(logPanel, "●  STATUS     READY", 9, T.Success, Enum.Font.GothamBold)
    logState.Position = UDim2.new(0, 16, 0, 78)
    logState.Size = UDim2.new(1, -32, 0, 18)
    local logTime = label(logPanel, os.date("%H:%M:%S") .. "  •  " .. os.date("%d %b %Y"), 8, T.Quiet, Enum.Font.Gotham)
    logTime.AnchorPoint = Vector2.new(1, 0)
    logTime.Position = UDim2.new(1, -16, 0, 16)
    logTime.Size = UDim2.new(0.48, 0, 0, 18)
    logTime.TextXAlignment = Enum.TextXAlignment.Right
    section(p, "Actions")
    local clearPanel = panelFor(p, 62)
    local clearText = label(clearPanel, "Clear local session log", 11, T.Text, Enum.Font.GothamMedium)
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
    local exitText = label(exitPanel, "End this local interface session", 10, T.Text, Enum.Font.GothamMedium)
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
    b.Size = UDim2.new(1, 0, 0, 38)
    b.Text = ""
    b.LayoutOrder = index
    b.Parent = navHolder
    corner(b, 9)
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
    local icon = label(b, glyph, 17, T.Quiet, Enum.Font.GothamMedium, Enum.TextXAlignment.Center)
    icon.Name = "NavIcon"
    icon.Position = UDim2.new(0, 8, 0, 0)
    icon.Size = UDim2.new(0, 28, 1, 0)
    local txt = label(b, name, 11, T.Muted, Enum.Font.GothamMedium)
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
    b.MouseButton1Click:Connect(function()
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
            shortcutGrid.CellSize = UDim2.new(1, 0, 0, 46)
            shortcutGrid.CellPadding = UDim2.new(0, 0, 0, 7)
            if shortcutPanel then shortcutPanel.Size = UDim2.new(1, 0, 0, 430) end
        else
            shortcutGrid.FillDirectionMaxCells = 2
            shortcutGrid.CellSize = UDim2.new(0.48, 0, 0, 52)
            shortcutGrid.CellPadding = UDim2.new(0.025, 0, 0, 8)
            if shortcutPanel then shortcutPanel.Size = UDim2.new(1, 0, 0, 252) end
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
        logoMinimizeHitbox.Size = UDim2.fromOffset(178, 48)
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
        logoMinimizeHitbox.Size = UDim2.fromOffset(255, 48)
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
    isMinimized = true
    shell.Visible = false
    ambientHalo.Visible = false
    restore.Visible = true
    notify("JT3R FUNHOUSE", "Interface minimised.")
end

local function restoreWindow()
    isMinimized = false
    shell.Visible = true
    ambientHalo.Visible = ambientEnabled
    restore.Visible = false
end

-- Logo is decorative; only the explicit minimise control changes window state.\n\nminimizeButton.MouseButton1Click:Connect(minimize)
restore.MouseButton1Click:Connect(restoreWindow)
closeButton.MouseButton1Click:Connect(uninject)

-- Floating button drag support
local restoreDragging = false
local restoreMoved = false
local restoreStart, restorePosition
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
        if not restoreMoved and isMinimized then restoreWindow() end
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
        notify("Welcome to JT3R", "Obsidian Atelier  •  v4.6")
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
