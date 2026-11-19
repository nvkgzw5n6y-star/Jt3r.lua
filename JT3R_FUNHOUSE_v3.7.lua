--[[
    JT3R FUNHOUSE v3.7
    Obsidian Atelier Edition
    Standalone UI shell for Roblox experiences.

    The ESP page includes client-side R6/R15 character visualisation for
    the owner's own Roblox experience: boxes, names, highlights, health,
    team filtering, distance filtering, RGB accents and body-part diagnostics and a server-authorised, whitelist-controlled hitbox expander. It does not include
    aim assistance, automation, anti-cheat bypasses or recording concealment.

    Upload this file to GitHub as JT3R_FUNHOUSE_v3.7.lua.
]]

--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
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

--// JT3R FUNZONE startup sequence
do
    local splashGui = Instance.new("ScreenGui")
    splashGui.Name = "JT3R_FUNZONE_Startup"
    splashGui.IgnoreGuiInset = true
    splashGui.ResetOnSpawn = false
    splashGui.DisplayOrder = 9999
    splashGui.Parent = PlayerGui

    local backdrop = Instance.new("Frame")
    backdrop.Size = UDim2.fromScale(1, 1)
    backdrop.BackgroundColor3 = Color3.fromRGB(8, 9, 11)
    backdrop.BorderSizePixel = 0
    backdrop.Parent = splashGui

    local mark = Instance.new("TextLabel")
    mark.BackgroundTransparency = 1
    mark.AnchorPoint = Vector2.new(0.5, 0.5)
    mark.Position = UDim2.fromScale(0.5, 0.39)
    mark.Size = UDim2.new(0.9, 0, 0, 62)
    mark.Font = Enum.Font.GothamBlack
    mark.Text = "JT3R"
    mark.TextColor3 = Color3.fromRGB(225, 190, 125)
    mark.TextScaled = true
    mark.Parent = backdrop

    local subtitle = Instance.new("TextLabel")
    subtitle.BackgroundTransparency = 1
    subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
    subtitle.Position = UDim2.fromScale(0.5, 0.48)
    subtitle.Size = UDim2.new(0.9, 0, 0, 24)
    subtitle.Font = Enum.Font.GothamSemibold
    subtitle.Text = "FUNZONE  /  PRIVATE SESSION"
    subtitle.TextColor3 = Color3.fromRGB(238, 232, 219)
    subtitle.TextSize = 12
    subtitle.Parent = backdrop

    local state = Instance.new("TextLabel")
    state.BackgroundTransparency = 1
    state.AnchorPoint = Vector2.new(0.5, 0.5)
    state.Position = UDim2.fromScale(0.5, 0.62)
    state.Size = UDim2.new(0.9, 0, 0, 20)
    state.Font = Enum.Font.GothamMedium
    state.Text = "INITIALISING INTERFACE"
    state.TextColor3 = Color3.fromRGB(157, 153, 145)
    state.TextSize = 10
    state.Parent = backdrop

    local track = Instance.new("Frame")
    track.AnchorPoint = Vector2.new(0.5, 0.5)
    track.Position = UDim2.fromScale(0.5, 0.68)
    track.Size = UDim2.new(0.58, 0, 0, 4)
    track.BackgroundColor3 = Color3.fromRGB(43, 42, 39)
    track.BorderSizePixel = 0
    track.Parent = backdrop
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(225, 190, 125)
    fill.BorderSizePixel = 0
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local started = os.clock()
    local duration = 4.8
    local phases = {"LOADING CORE MODULES", "PREPARING VISUAL SYSTEMS", "BUILDING COMMAND CENTRE", "READY"}
    while os.clock() - started < duration do
        local alpha = math.clamp((os.clock() - started) / duration, 0, 1)
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        local phase = math.clamp(math.floor(alpha * #phases) + 1, 1, #phases)
        state.Text = phases[phase]
        task.wait(0.04)
    end
    fill.Size = UDim2.new(1, 0, 1, 0)
    task.wait(0.12)
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
ambientHalo.Size = UDim2.new(1, 44, 1, 44)
ambientHalo.BackgroundColor3 = T.Accent
ambientHalo.BackgroundTransparency = 0.88
ambientHalo.BorderSizePixel = 0
ambientHalo.ZIndex = 0
ambientHalo.Parent = screenGui
corner(ambientHalo, 28)
local haloGradient = Instance.new("UIGradient")
haloGradient.Rotation = 35
haloGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.42),
    NumberSequenceKeypoint.new(0.5, 0.82),
    NumberSequenceKeypoint.new(1, 0.42),
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
corner(shell, 18)
stroke(shell, T.Accent, 0.72, 1.2)
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
stroke(brandMark, T.AccentBright, 0.08, 1.4)
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
local brandGlyph = label(markInner, "J", 29, T.AccentBright, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
brandGlyph.Position = UDim2.new(0, 0, 0, -4)
brandGlyph.Size = UDim2.new(1, 0, 0, 35)
local markWord = label(markInner, "T3R", 7, T.Text, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
markWord.Position = UDim2.new(0, 0, 1, -14)
markWord.Size = UDim2.new(1, 0, 0, 10)
local markBar = Instance.new("Frame")
markBar.BackgroundColor3 = T.AccentBright
markBar.BorderSizePixel = 0
markBar.AnchorPoint = Vector2.new(0.5, 0)
markBar.Position = UDim2.new(0.5, 0, 0, 31)
markBar.Size = UDim2.fromOffset(18, 1)
markBar.Parent = markInner

local brandName = label(header, "JT3R", 20, T.Text, Enum.Font.GothamBlack)
brandName.Position = UDim2.new(0, 84, 0, 12)
brandName.Size = UDim2.new(0, 190, 0, 28)

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
logoMinimizeHitbox.Size = UDim2.fromOffset(255, 48)
logoMinimizeHitbox.ZIndex = 20
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

local minimizeButton = button(headerRight, "—", UDim2.fromOffset(36, 36), T.Surface2, T.AccentBright)
minimizeButton.Position = UDim2.new(1, -78, 0, 3)
minimizeButton.TextSize = 18

local closeButton = button(headerRight, "⏻", UDim2.fromOffset(36, 36), T.Surface2, T.Danger)
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
navHolder.Position = UDim2.new(0, 12, 0, 54)
navHolder.Size = UDim2.new(1, -24, 0, 300)
navHolder.Parent = sidebar
listLayout(navHolder, Enum.FillDirection.Vertical, 6)

local navItems = {
    {"Home", "⌂"}, {"Aim", "◎"}, {"ESP", "◈"}, {"Visuals", "◇"},
    {"Misc", "✣"}, {"Settings", "⚙"}, {"Console", "▤"}
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

local footerVersion = label(footer, "V3.5", 9, T.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
footerVersion.AnchorPoint = Vector2.new(1, 0)
footerVersion.Position = UDim2.new(1, -20, 0, 7)
footerVersion.Size = UDim2.new(0, 60, 0, 18)

--// Floating restore button
local restore = button(screenGui, "J", UDim2.fromOffset(48, 48), T.Accent, T.Background)
restore.Name = "JT3RRestore"
restore.Visible = false
restore.Position = UDim2.new(0, 20, 0.55, 0)
restore.TextSize = 22
restore.Font = Enum.Font.GothamBlack
corner(restore, 16)
stroke(restore, T.AccentBright, 0.1, 1.2)

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
    tween(toast, 0.22, {BackgroundTransparency = 0})
    tween(outline, 0.22, {Transparency = 0.15})
    task.delay(3.2, function()
        if toast and toast.Parent then
            tween(toast, 0.2, {BackgroundTransparency = 1})
            task.wait(0.22)
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
    corner(frame, 13)
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
    for pageName, buttonObject in pairs(pageButtons) do
        local selected = pageName == name
        buttonObject.BackgroundColor3 = selected and T.AccentSoft or T.Surface
        buttonObject.TextColor3 = selected and T.AccentBright or T.Muted
        local iconLabel = buttonObject:FindFirstChild("NavIcon")
        if iconLabel then iconLabel.TextColor3 = selected and T.AccentBright or T.Quiet end
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
    corner(f, 13)
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
    stroke(heroRing, T.Accent, 0.52, 1.2)
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
    infoLine(envPanel, 81, "SCRIPT VERSION", "3.3", "ScriptVersionValue")
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
    Aim = {"TARGETING WORKSPACE", "Aim workspace", "A dedicated visual workspace for organising future interface preferences."},
    ESP = {"LIVE PLAYER VISUALS", "Player visualisation", "Local character boxes, names, health and highlight controls for your own experience."},
    Visuals = {"PRESENTATION WORKSPACE", "Visual presentation", "Tune the look and feel of the JT3R interface itself."},
    Misc = {"UTILITY WORKSPACE", "Session utilities", "Small local tools for notifications, navigation and interface housekeeping."},
}
for _, name in ipairs({"Aim", "ESP", "Visuals", "Misc"}) do
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
    local iconText = label(iconTile, ({Aim="◎", ESP="◈", Visuals="✧", Misc="⌘"})[name], 21, T.AccentBright, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
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
            Lines = false, TeamCheck = false, Distance = true, MaxDistance = 70000, RGB = false,
            HitboxDebug = false}
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
                if item.DebugBoxes then
                    for _, selection in ipairs(item.DebugBoxes) do
                        if selection then selection:Destroy() end
                    end
                end
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
            highlight.FillTransparency = 0.78
            highlight.OutlineTransparency = 0.08
            highlight.Enabled = false
            highlight.Parent = character

            local billboard = Instance.new("BillboardGui")
            billboard.Name = "JT3R_PlayerInfo"
            billboard.Adornee = getCharacterRoot(character)
            billboard.Size = UDim2.fromOffset(76, 104)
            billboard.StudsOffset = Vector3.new(0, 0.65, 0)
            billboard.AlwaysOnTop = true
            billboard.Enabled = false
            billboard.Parent = PlayerGui

            local box = Instance.new("Frame")
            box.Name = "Box"
            box.BackgroundTransparency = 1
            box.Size = UDim2.new(1, -8, 1, -28)
            box.Position = UDim2.new(0, 4, 0, 25)
            box.Parent = billboard
            local boxStroke = Instance.new("UIStroke")
            boxStroke.Color = T.AccentBright
            boxStroke.Thickness = 1.05
            boxStroke.Transparency = 0.05
            boxStroke.Parent = box

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Name = "PlayerName"
            nameLabel.BackgroundColor3 = Color3.fromRGB(12, 13, 15)
            nameLabel.BackgroundTransparency = 0.12
            nameLabel.BorderSizePixel = 0
            nameLabel.Size = UDim2.new(1, 34, 0, 29)
            nameLabel.Position = UDim2.new(0, -17, 0, -7)
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextSize = 11
            nameLabel.TextWrapped = true
            nameLabel.TextYAlignment = Enum.TextYAlignment.Center
            nameLabel.TextColor3 = T.Text
            nameLabel.TextStrokeTransparency = 0.75
            nameLabel.Text = player.DisplayName
            nameLabel.Parent = billboard
            local nameCorner = Instance.new("UICorner")
            nameCorner.CornerRadius = UDim.new(0, 5)
            nameCorner.Parent = nameLabel

            local healthBack = Instance.new("Frame")
            healthBack.Name = "HealthBack"
            healthBack.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            healthBack.BorderSizePixel = 0
            healthBack.Size = UDim2.new(1, -8, 0, 4)
            healthBack.Position = UDim2.new(0, 4, 1, -4)
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
            local debugBoxes = {}
            -- Visual-only diagnostic outlines around body parts; no part sizes or collisions are changed.
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") and not part:FindFirstAncestorOfClass("Accessory") then
                    local selection = Instance.new("SelectionBox")
                    selection.Name = "JT3R_HitboxDiagnostic"
                    selection.Adornee = part
                    selection.Color3 = T.AccentBright
                    selection.LineThickness = 0.025
                    selection.SurfaceTransparency = 1
                    selection.Visible = false
                    selection.Parent = part
                    table.insert(debugBoxes, selection)
                end
            end
            espObjects[player] = {Billboard = billboard, Highlight = highlight, Box = box,
                BoxStroke = boxStroke, Name = nameLabel, HealthBack = healthBack, HealthFill = healthFill,
                Tracer = tracer, DebugBoxes = debugBoxes}
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
                local eligible, root, humanoid = isEligible(player, character)
                if not eligible or not espState.Enabled then
                    item.Billboard.Enabled = false
                    item.Highlight.Enabled = false
                    item.Tracer.Visible = false
                    for _, selection in ipairs(item.DebugBoxes or {}) do
                        selection.Visible = false
                    end
                else
                    local color = espState.RGB and rgbColor or T.AccentBright
                    item.Billboard.Adornee = root
                    item.Billboard.Enabled = espState.Boxes or espState.Names or espState.Health
                    for _, selection in ipairs(item.DebugBoxes or {}) do
                        selection.Visible = espState.HitboxDebug
                    end
                    item.Box.Visible = espState.Boxes
                    item.BoxStroke.Color = color
                    local studs = math.floor((root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                    item.Name.Visible = espState.Names
                    item.Name.Text = player.DisplayName .. "\n" .. tostring(studs) .. " studs"
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

        section(p, "Live player visuals")
        local livePanel = panelFor(p, 82)
        local liveTitle = label(livePanel, "LOCAL VISUAL LAYER", 9, T.Accent, Enum.Font.GothamBold)
        liveTitle.Position = UDim2.new(0, 15, 0, 12)
        liveTitle.Size = UDim2.new(1, -30, 0, 15)
        local liveStatus = label(livePanel, "WAITING FOR PLAYER CHARACTERS", 11, T.Text, Enum.Font.GothamSemibold)
        liveStatus.Position = UDim2.new(0, 15, 0, 35)
        liveStatus.Size = UDim2.new(1, -30, 0, 20)

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
            notify("ESP distance", "Maximum range set to " .. espState.MaxDistance .. " studs.")
        end)
        interfaceSwitch(p, "RGB highlight mode", "Cycle a restrained spectrum across boxes and highlights.", espState.RGB, function(on)
            espState.RGB = on
        end)
        section(p, "Character diagnostics")
        interfaceSwitch(p, "Hitbox debug outlines", "Outline each R6/R15 body part for visual diagnostics.", espState.HitboxDebug, function(on)
            espState.HitboxDebug = on
            notify("Hitbox diagnostics", on and "Body-part outlines enabled." or "Body-part outlines disabled.")
        end)
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
        section(p, "Session note")
        textBlock(p, "EXPERIENCE VISUALS", "Client-side player display", "ESP is client-side. Functional hitbox expansion requires the companion server script in ServerScriptService and your UserId in its whitelist. It scales R6/R15 body parts on the server and restores their original sizes when disabled.")
    elseif name == "Visuals" then
        section(p, "Character diagnostics")
        textBlock(p, "R6 / R15 BODY OUTLINES", "Open the ESP tab and enable Hitbox debug outlines to see visual outlines around character body parts. This is a diagnostic display only; it does not resize or alter character parts.")
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
        section(p, "Visual profile")
        textBlock(p, "SIGNATURE FINISH", "Obsidian and champagne", "The interface uses layered dark surfaces, restrained gold highlights and soft motion to keep the layout premium without clutter.")
    elseif name == "Misc" then
        section(p, "Quick utilities")
        miniAction(p, "Test notification", "Preview the JT3R notification style.", "TEST", function()
            notify("JT3R notification", "Your interface notifications are working.")
        end)
        miniAction(p, "Return to dashboard", "Jump back to the main command overview.", "HOME", function()
            setPage("Home")
        end)
        miniAction(p, "Session status", "Show a quick local session status message.", "CHECK", function()
            notify("Session status", "JT3R interface is active.")
        end)
        miniAction(p, "Interface refresh", "Return the dashboard to its default presentation.", "REFRESH", function()
            setPage("Home")
            notify("JT3R", "Dashboard view restored.")
        end)
        section(p, "About this build")
        textBlock(p, "JT3R FUNHOUSE", "Signature Command Centre", "Version 3.5  •  Obsidian Atelier  •  Mobile + desktop interface")
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
        for _, obj in ipairs(screenGui:GetDescendants()) do
            if obj:IsA("Frame") and (obj.Parent == pages.Home or obj.Parent == pages.Aim
                or obj.Parent == pages.ESP or obj.Parent == pages.Visuals or obj.Parent == pages.Misc
                or obj.Parent == pages.Settings or obj.Parent == pages.Console) then
                obj.BackgroundTransparency = glassEnabled and 0.13 or 0
            end
        end
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

    section(p, "Accent lighting")
    local rgbPanel = panelFor(p, 76)
    local rgbTitle = label(rgbPanel, "RGB accent cycle", 12, T.Text, Enum.Font.GothamMedium)
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
        notify("Accent lighting", rgbEnabled and "Subtle RGB cycle enabled." or "RGB cycle disabled.")
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
    local configPanel = panelFor(p, 92)
    local configTitle = label(configPanel, "LOCAL CONFIGURATION", 10, T.Text, Enum.Font.GothamBold)
    configTitle.Position = UDim2.new(0, 15, 0, 10)
    configTitle.Size = UDim2.new(1, -30, 0, 16)
    local configDesc = label(configPanel, "Save or restore this session's interface preferences.", 9, T.Muted, Enum.Font.Gotham)
    configDesc.Position = UDim2.new(0, 15, 0, 29)
    configDesc.Size = UDim2.new(1, -30, 0, 14)
    local configSave = button(configPanel, "SAVE", UDim2.new(0.32, -6, 0, 30), T.AccentSoft, T.AccentBright)
    configSave.Position = UDim2.new(0, 14, 0, 53)
    local configLoad = button(configPanel, "LOAD", UDim2.new(0.32, -6, 0, 30), T.Surface2, T.Text)
    configLoad.Position = UDim2.new(0.34, 0, 0, 53)
    local configReset = button(configPanel, "RESET", UDim2.new(0.32, -6, 0, 30), T.Surface2, T.Muted)
    configReset.Position = UDim2.new(0.68, -2, 0, 53)
    local savedConfig
    configSave.MouseButton1Click:Connect(function()
        savedConfig = {theme = currentThemeName, glass = glassEnabled, ambient = ambientEnabled, scale = userScale}
        notify("Configuration", "Current preferences saved for this session.")
    end)
    configLoad.MouseButton1Click:Connect(function()
        if not savedConfig then
            notify("Configuration", "No saved configuration in this session yet.")
            return
        end
        if savedConfig.theme and applyTheme then applyTheme(savedConfig.theme) end
        glassEnabled = savedConfig.glass
        ambientEnabled = savedConfig.ambient
        ambientHalo.Visible = ambientEnabled
        applyScale(savedConfig.scale or 1)
        glassButton.Text = glassEnabled and "ON" or "OFF"
        lightButton.Text = ambientEnabled and "ON" or "OFF"
        notify("Configuration", "Saved preferences restored.")
    end)
    configReset.MouseButton1Click:Connect(function()
        savedConfig = nil
        applyScale(1)
        if currentThemeName ~= "Obsidian" and applyTheme then applyTheme("Obsidian") end
        glassEnabled = true
        ambientEnabled = true
        ambientHalo.Visible = true
        glassButton.Text = "ON"
        lightButton.Text = "ON"
        notify("Configuration", "Default interface preferences restored.")
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
    local logTitle = label(logPanel, "JT3R interface initialised", 12, T.Text, Enum.Font.GothamMedium)
    logTitle.Position = UDim2.new(0, 16, 0, 16)
    logTitle.Size = UDim2.new(1, -32, 0, 20)
    local logDesc = label(logPanel, "UI v3.7  •  Obsidian Atelier  •  Local session", 10, T.Muted, Enum.Font.Gotham)
    logDesc.Position = UDim2.new(0, 16, 0, 43)
    logDesc.Size = UDim2.new(1, -32, 0, 18)
    local logState = label(logPanel, "STATUS     READY", 9, T.Success, Enum.Font.GothamBold)
    logState.Position = UDim2.new(0, 16, 0, 78)
    logState.Size = UDim2.new(1, -32, 0, 18)
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
        logState.Text = "STATUS     READY"
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
    b.Size = UDim2.new(1, 0, 0, 43)
    b.Text = ""
    b.LayoutOrder = index
    b.Parent = navHolder
    corner(b, 9)
    local icon = label(b, glyph, 17, T.Quiet, Enum.Font.GothamMedium, Enum.TextXAlignment.Center)
    icon.Name = "NavIcon"
    icon.Position = UDim2.new(0, 8, 0, 0)
    icon.Size = UDim2.new(0, 28, 1, 0)
    local txt = label(b, name, 11, T.Muted, Enum.Font.GothamMedium)
    txt.Position = UDim2.new(0, 43, 0, 0)
    txt.Size = UDim2.new(1, -50, 1, 0)
    pageButtons[name] = b
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
            if shortcutPanel then shortcutPanel.Size = UDim2.new(1, 0, 0, 340) end
        else
            shortcutGrid.FillDirectionMaxCells = 2
            shortcutGrid.CellSize = UDim2.new(0.48, 0, 0, 52)
            shortcutGrid.CellPadding = UDim2.new(0.025, 0, 0, 8)
            if shortcutPanel then shortcutPanel.Size = UDim2.new(1, 0, 0, 202) end
        end
    end
    if mobile then
        shell.Size = UDim2.new(0, math.max(300, math.min(viewport.X - 22, 900)), 0, math.max(300, math.min(viewport.Y - 24, 760)))
        ambientHalo.Size = UDim2.new(1, 34, 1, 34)
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
        logoMinimizeHitbox.Size = UDim2.fromOffset(225, 48)
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
        closeButton.Position = UDim2.new(0, 40, 0, 3)
    else
        shell.Size = UDim2.new(0, 850, 0, 570)
        ambientHalo.Size = UDim2.new(1, 44, 1, 44)
        shellScale.Scale = userScale * math.min(1, viewport.X / 1000, viewport.Y / 700)
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
local dragStart, startPosition
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = shell.Position
    end
end)
addConnection(UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        shell.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        ambientHalo.Position = shell.Position
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

logoMinimizeHitbox.MouseButton1Click:Connect(function()
    if isMinimized then restoreWindow() else minimize() end
end)

minimizeButton.MouseButton1Click:Connect(minimize)
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
    if input.KeyCode == Enum.KeyCode.RightShift then
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
        notify("Welcome to JT3R", "Obsidian Atelier  •  v3.5")
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
