--[[
    JT3R FUNHOUSE v2.1
    Executive Luxury Edition
    Standalone UI shell for Roblox experiences.

    This is an interface framework only. It does not implement aim assistance,
    ESP, player tracking, automation, anti-cheat bypasses, or other gameplay
    modifications. The Aim, ESP, Visuals and Misc pages are intentionally
    clean workspaces for your own future UI development.

    Upload this file to GitHub as JT3R_FUNHOUSE_v2.1.lua.
]]

--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// Cleanup previous copy
local GUI_NAME = "JT3R_FUNHOUSE_V21"
pcall(function()
    local old = (gethui and gethui()) or CoreGui
    local existing = old:FindFirstChild(GUI_NAME)
    if existing then existing:Destroy() end
end)

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
brandMark.Position = UDim2.new(0, 22, 0, 17)
brandMark.Size = UDim2.fromOffset(44, 44)
brandMark.BackgroundColor3 = T.Accent
brandMark.BorderSizePixel = 0
brandMark.Parent = header
corner(brandMark, 13)
stroke(brandMark, T.AccentBright, 0.12, 1.3)
local markGradient = Instance.new("UIGradient")
markGradient.Rotation = 135
markGradient.Color = ColorSequence.new(T.AccentBright, T.Accent)
markGradient.Parent = brandMark

local brandGlyph = label(brandMark, "J", 27, T.Background, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
brandGlyph.Size = UDim2.fromScale(1, 1)

local brandName = label(header, "JT3R", 19, T.Text, Enum.Font.GothamBlack)
brandName.Position = UDim2.new(0, 78, 0, 16)
brandName.Size = UDim2.new(0, 180, 0, 24)

local brandSub = label(header, "FUNHOUSE     /     EXECUTIVE", 9, T.Muted, Enum.Font.GothamMedium)
brandSub.Position = UDim2.new(0, 79, 0, 42)
brandSub.Size = UDim2.new(0, 240, 0, 16)

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
headerRight.Position = UDim2.new(1, -18, 0, 18)
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

local closeButton = button(headerRight, "×", UDim2.fromOffset(36, 36), T.Surface2, T.Muted)
closeButton.Position = UDim2.new(1, -36, 0, 3)
closeButton.TextSize = 18

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

local footerText = label(footer, "JT3R     /     EXECUTIVE EDITION", 9, T.Quiet, Enum.Font.GothamMedium)
footerText.Position = UDim2.new(0, 20, 0, 7)
footerText.Size = UDim2.new(0.7, 0, 0, 18)

local footerVersion = label(footer, "V2.1", 9, T.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
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

-- Home
do
    local p = pages.Home
    section(p, "Welcome")
    local hero = panelFor(p, 154)
    local heroTag = label(hero, "PRIVATE WORKSPACE  /  JT3R", 9, T.Accent, Enum.Font.GothamBold)
    heroTag.Position = UDim2.new(0, 19, 0, 18)
    heroTag.Size = UDim2.new(1, -38, 0, 16)
    local heroTitle = label(hero, "A more considered\ncontrol experience.", 22, T.Text, Enum.Font.GothamSemibold)
    heroTitle.Position = UDim2.new(0, 19, 0, 43)
    heroTitle.Size = UDim2.new(1, -38, 0, 58)
    heroTitle.TextYAlignment = Enum.TextYAlignment.Top
    heroTitle.TextWrapped = true
    local heroDesc = label(hero, "Designed with restraint. Built around your workflow.", 10, T.Muted, Enum.Font.Gotham)
    heroDesc.Position = UDim2.new(0, 19, 1, -35)
    heroDesc.Size = UDim2.new(1, -38, 0, 18)
    section(p, "At a glance")
    local overview = panelFor(p, 82)
    local overviewTitle = label(overview, "Interface", 12, T.Text, Enum.Font.GothamMedium)
    overviewTitle.Position = UDim2.new(0, 16, 0, 14)
    overviewTitle.Size = UDim2.new(0.5, 0, 0, 18)
    local overviewValue = label(overview, "READY", 10, T.Success, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
    overviewValue.Position = UDim2.new(0.5, 0, 0, 14)
    overviewValue.Size = UDim2.new(0.5, -16, 0, 18)
    local overviewDesc = label(overview, "Local interface session is running.", 10, T.Muted, Enum.Font.Gotham)
    overviewDesc.Position = UDim2.new(0, 16, 0, 43)
    overviewDesc.Size = UDim2.new(1, -32, 0, 18)
    section(p, "Quick access")
    local quick = panelFor(p, 58)
    local quickLayout = Instance.new("UIGridLayout")
    quickLayout.CellSize = UDim2.new(0.32, 0, 0, 36)
    quickLayout.CellPadding = UDim2.new(0.02, 0, 0, 0)
    quickLayout.FillDirectionMaxCells = 3
    quickLayout.Parent = quick
    padding(quick, 12, 12, 11, 11)
    for _, target in ipairs({"Settings", "Console", "Misc"}) do
        local q = button(quick, target, UDim2.new(0, 0, 0, 36), T.Surface2, T.Muted)
        q.MouseButton1Click:Connect(function() setPage(target) end)
    end
end

-- Intentionally clean future-work pages; no fake toggles or demo controls.
for _, name in ipairs({"Aim", "ESP", "Visuals", "Misc"}) do
    local p = pages[name]
    section(p, "Workspace")
    textBlock(p, "Reserved section", name .. " workspace", "This section is intentionally clear and ready for your future implementation.")
    section(p, "Structure")
    local f = panelFor(p, 64)
    local left = label(f, "SECTION STATUS", 9, T.Quiet, Enum.Font.GothamBold)
    left.Position = UDim2.new(0, 16, 0, 12)
    left.Size = UDim2.new(0.6, 0, 0, 16)
    local right = label(f, "STANDBY", 9, T.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
    right.Position = UDim2.new(0.6, 0, 0, 12)
    right.Size = UDim2.new(0.4, -16, 0, 16)
    local desc = label(f, "No modules are currently attached.", 10, T.Muted, Enum.Font.Gotham)
    desc.Position = UDim2.new(0, 16, 0, 34)
    desc.Size = UDim2.new(1, -32, 0, 16)
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
    local function applyScale(value)
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
    local function applyTheme(name)
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
end

-- Console
do
    local p = pages.Console
    section(p, "Session log")
    local logPanel = panelFor(p, 126)
    local logTitle = label(logPanel, "JT3R interface initialised", 12, T.Text, Enum.Font.GothamMedium)
    logTitle.Position = UDim2.new(0, 16, 0, 16)
    logTitle.Size = UDim2.new(1, -32, 0, 20)
    local logDesc = label(logPanel, "UI v2.1  •  Executive Liquid Glass  •  Local session", 10, T.Muted, Enum.Font.Gotham)
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
end

--// Navigation buttons
for index, item in ipairs(navItems) do
    local name, glyph = item[1], item[2]
    local b = Instance.new("TextButton")
    b.Name = name
    b.AutoButtonColor = false
    b.BackgroundColor3 = T.Surface
    b.BorderSizePixel = 0
    b.Size = UDim2.new(1, 0, 0, 39)
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
        brandSub.Text = "FUNHOUSE  /  EXECUTIVE"
        statusText.Text = "ACTIVE"
        headerRight.Size = UDim2.new(0, 112, 0, 42)
        minimizeButton.Position = UDim2.new(1, -78, 0, 3)
        closeButton.Position = UDim2.new(1, -36, 0, 3)
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
        headerRight.Size = UDim2.new(0, 170, 0, 42)
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

minimizeButton.MouseButton1Click:Connect(minimize)
restore.MouseButton1Click:Connect(restoreWindow)
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    for _, connection in ipairs(connections) do
        pcall(function() connection:Disconnect() end)
    end
end)

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
        notify("Welcome to JT3R", "Executive Liquid Glass  •  v2.1")
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
    if screenGui then screenGui:Destroy() end
    for _, connection in ipairs(connections) do
        pcall(function() connection:Disconnect() end)
    end
end

_G.JT3R_FUNHOUSE = JT3R
