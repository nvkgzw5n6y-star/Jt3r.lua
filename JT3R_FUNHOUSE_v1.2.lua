--[[
    JT3R FUNHOUSE | LUXURY EDITION v1.2
    Mobile-first interface shell for Roblox client environments.

    IMPORTANT:
    - This is a standalone UI/demo panel only.
    - Aim and ESP pages are visual settings previews and do not affect gameplay.
    - No player tracking, targeting, remote-event calls, anti-cheat bypasses,
      automation, or other gameplay advantages are included.
    - Profile data is session-only and is lost when the UI is closed.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    warn("JT3R FUNHOUSE: LocalPlayer unavailable. Run this from a client context.")
    return
end

-- Clean up an older copy before creating this one.
local GUI_NAME = "JT3R_FUNHOUSE_V12"
pcall(function()
    local oldParent = (typeof(gethui) == "function" and gethui()) or CoreGui
    local old = oldParent:FindFirstChild(GUI_NAME)
    if old then old:Destroy() end
end)

local function getGuiParent()
    if typeof(gethui) == "function" then
        local ok, result = pcall(gethui)
        if ok and result then return result end
    end
    return CoreGui
end

local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() gui.Parent = getGuiParent() end)
if not gui.Parent then
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local Theme = {
    Background = Color3.fromRGB(12, 12, 13),
    Panel = Color3.fromRGB(20, 20, 21),
    Panel2 = Color3.fromRGB(27, 26, 25),
    Panel3 = Color3.fromRGB(35, 33, 30),
    Cream = Color3.fromRGB(242, 233, 216),
    Muted = Color3.fromRGB(157, 151, 140),
    Gold = Color3.fromRGB(211, 171, 91),
    GoldLight = Color3.fromRGB(239, 207, 139),
    Stroke = Color3.fromRGB(75, 63, 43),
    Green = Color3.fromRGB(126, 181, 132),
    Red = Color3.fromRGB(194, 105, 96),
}

local function tween(object, duration, properties, style)
    local info = TweenInfo.new(duration or 0.18, style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local animation = TweenService:Create(object, info, properties)
    animation:Play()
    return animation
end

local function corner(parent, radius)
    local item = Instance.new("UICorner")
    item.CornerRadius = UDim.new(0, radius or 12)
    item.Parent = parent
    return item
end

local function stroke(parent, color, transparency, thickness)
    local item = Instance.new("UIStroke")
    item.Color = color or Theme.Stroke
    item.Transparency = transparency or 0.35
    item.Thickness = thickness or 1
    item.Parent = parent
    return item
end

local function padding(parent, left, right, top, bottom)
    local item = Instance.new("UIPadding")
    item.PaddingLeft = UDim.new(0, left or 0)
    item.PaddingRight = UDim.new(0, right or 0)
    item.PaddingTop = UDim.new(0, top or 0)
    item.PaddingBottom = UDim.new(0, bottom or 0)
    item.Parent = parent
    return item
end

local function label(parent, text, size, color, font, xAlign)
    local item = Instance.new("TextLabel")
    item.BackgroundTransparency = 1
    item.Text = text or ""
    item.TextSize = size or 13
    item.TextColor3 = color or Theme.Cream
    item.Font = font or Enum.Font.Gotham
    item.TextXAlignment = xAlign or Enum.TextXAlignment.Left
    item.TextYAlignment = Enum.TextYAlignment.Center
    item.TextWrapped = false
    item.Parent = parent
    return item
end

local function button(parent, text, size, bg, fg)
    local item = Instance.new("TextButton")
    item.AutoButtonColor = false
    item.Text = text or ""
    item.TextSize = 13
    item.Font = Enum.Font.GothamMedium
    item.TextColor3 = fg or Theme.Cream
    item.BackgroundColor3 = bg or Theme.Panel2
    item.Size = size or UDim2.new(1, 0, 0, 42)
    item.Parent = parent
    corner(item, 10)
    return item
end

local function makeCard(parent, titleText, descriptionText)
    local card = Instance.new("Frame")
    card.BackgroundColor3 = Theme.Panel
    card.Size = UDim2.new(1, 0, 0, 76)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.Parent = parent
    corner(card, 13)
    stroke(card, Theme.Stroke, 0.55, 1)
    padding(card, 14, 14, 12, 12)

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout.Parent = card

    local title = label(card, titleText, 13, Theme.Cream, Enum.Font.GothamSemibold)
    title.Size = UDim2.new(1, 0, 0, 18)
    title.LayoutOrder = 1

    if descriptionText and descriptionText ~= "" then
        local desc = label(card, descriptionText, 11, Theme.Muted, Enum.Font.Gotham)
        desc.Size = UDim2.new(1, 0, 0, 30)
        desc.TextWrapped = true
        desc.TextYAlignment = Enum.TextYAlignment.Top
        desc.LayoutOrder = 2
    end
    return card
end

local state = {
    theme = "Gold",
    animations = true,
    compact = false,
    floating = true,
    notifications = true,
    showHints = true,
    aimPreview = false,
    aimSmoothness = 45,
    fovPreview = 90,
    boxPreview = false,
    namePreview = false,
    distancePreview = false,
    crosshairPreview = false,
    watermark = true,
    blurPreview = false,
    profile = "Default",
}

local themePresets = {
    Gold = {Gold = Color3.fromRGB(211,171,91), GoldLight = Color3.fromRGB(239,207,139), Stroke = Color3.fromRGB(75,63,43)},
    Purple = {Gold = Color3.fromRGB(174,139,211), GoldLight = Color3.fromRGB(211,185,239), Stroke = Color3.fromRGB(69,54,83)},
    Blue = {Gold = Color3.fromRGB(126,174,211), GoldLight = Color3.fromRGB(177,211,239), Stroke = Color3.fromRGB(49,68,82)},
    Red = {Gold = Color3.fromRGB(203,119,105), GoldLight = Color3.fromRGB(235,166,151), Stroke = Color3.fromRGB(82,52,47)},
}

local screen = Instance.new("Frame")
screen.Name = "ScreenRoot"
screen.BackgroundTransparency = 1
screen.Size = UDim2.fromScale(1, 1)
screen.Parent = gui

local main = Instance.new("Frame")
main.Name = "MainWindow"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.fromOffset(390, 650)
main.BackgroundColor3 = Theme.Background
main.ClipsDescendants = true
main.Parent = screen
corner(main, 18)
local mainOutline = stroke(main, Theme.Stroke, 0.15, 1.2)

local mainScale = Instance.new("UIScale")
mainScale.Scale = 1
mainScale.Parent = main

local header = Instance.new("Frame")
header.Name = "Header"
header.BackgroundColor3 = Theme.Panel
header.Size = UDim2.new(1, 0, 0, 66)
header.Parent = main
corner(header, 18)

local headerMask = Instance.new("Frame")
headerMask.BackgroundColor3 = Theme.Panel
headerMask.BorderSizePixel = 0
headerMask.Position = UDim2.new(0, 0, 1, -18)
headerMask.Size = UDim2.new(1, 0, 0, 18)
headerMask.Parent = header

local brandMark = Instance.new("Frame")
brandMark.BackgroundColor3 = Theme.Gold
brandMark.Position = UDim2.new(0, 15, 0, 15)
brandMark.Size = UDim2.fromOffset(36, 36)
brandMark.Parent = header
corner(brandMark, 11)
local markText = label(brandMark, "J", 22, Theme.Background, Enum.Font.GothamBlack, Enum.TextXAlignment.Center)
markText.Size = UDim2.fromScale(1, 1)

local brand = label(header, "JT3R", 16, Theme.Cream, Enum.Font.GothamBlack)
brand.Position = UDim2.new(0, 61, 0, 12)
brand.Size = UDim2.new(1, -150, 0, 22)
local subBrand = label(header, "F U N H O U S E   /   L U X U R Y", 8, Theme.Muted, Enum.Font.GothamMedium)
subBrand.Position = UDim2.new(0, 62, 0, 34)
subBrand.Size = UDim2.new(1, -150, 0, 14)

local minimize = button(header, "—", UDim2.fromOffset(32, 32), Theme.Panel2, Theme.GoldLight)
minimize.Position = UDim2.new(1, -82, 0, 17)
minimize.TextSize = 18
local close = button(header, "×", UDim2.fromOffset(32, 32), Theme.Panel2, Theme.Muted)
close.Position = UDim2.new(1, -43, 0, 17)
close.TextSize = 20

local tabBar = Instance.new("ScrollingFrame")
tabBar.Name = "TabBar"
tabBar.BackgroundTransparency = 1
tabBar.BorderSizePixel = 0
tabBar.Position = UDim2.new(0, 12, 0, 76)
tabBar.Size = UDim2.new(1, -24, 0, 43)
tabBar.ScrollBarThickness = 0
tabBar.ScrollingDirection = Enum.ScrollingDirection.X
tabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
tabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
tabBar.Parent = main
local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 7)
tabLayout.Parent = tabBar

local content = Instance.new("Frame")
content.Name = "Content"
content.BackgroundTransparency = 1
content.Position = UDim2.new(0, 12, 0, 128)
content.Size = UDim2.new(1, -24, 1, -169)
content.Parent = main

local footer = Instance.new("Frame")
footer.BackgroundColor3 = Theme.Panel
footer.Position = UDim2.new(0, 0, 1, -31)
footer.Size = UDim2.new(1, 0, 0, 31)
footer.Parent = main
local footerLine = Instance.new("Frame")
footerLine.BackgroundColor3 = Theme.Stroke
footerLine.BackgroundTransparency = 0.5
footerLine.BorderSizePixel = 0
footerLine.Size = UDim2.new(1, 0, 0, 1)
footerLine.Parent = footer
local footerText = label(footer, "●  READY  /  UI SESSION", 9, Theme.Muted, Enum.Font.GothamMedium)
footerText.Position = UDim2.new(0, 15, 0, 1)
footerText.Size = UDim2.new(1, -30, 1, -1)

local toastHolder = Instance.new("Frame")
toastHolder.Name = "ToastHolder"
toastHolder.BackgroundTransparency = 1
toastHolder.AnchorPoint = Vector2.new(0.5, 0)
toastHolder.Position = UDim2.new(0.5, 0, 0, 24)
toastHolder.Size = UDim2.new(0.86, 0, 0, 54)
toastHolder.ZIndex = 50
toastHolder.Parent = screen

local function notify(titleText, messageText)
    if not state.notifications then return end
    local toast = Instance.new("Frame")
    toast.BackgroundColor3 = Theme.Panel2
    toast.Size = UDim2.new(1, 0, 0, 50)
    toast.Position = UDim2.new(0, 0, 0, -12)
    toast.BackgroundTransparency = 0.05
    toast.ZIndex = 51
    toast.Parent = toastHolder
    corner(toast, 12)
    stroke(toast, Theme.Gold, 0.25, 1)
    local t = label(toast, titleText or "JT3R", 12, Theme.GoldLight, Enum.Font.GothamBold)
    t.Position = UDim2.new(0, 13, 0, 6)
    t.Size = UDim2.new(1, -26, 0, 16)
    t.ZIndex = 52
    local m = label(toast, messageText or "Done.", 10, Theme.Muted, Enum.Font.Gotham)
    m.Position = UDim2.new(0, 13, 0, 24)
    m.Size = UDim2.new(1, -26, 0, 15)
    m.ZIndex = 52
    tween(toast, 0.22, {Position = UDim2.new(0, 0, 0, 0)})
    task.delay(2.4, function()
        if toast and toast.Parent then
            tween(toast, 0.18, {Position = UDim2.new(0, 0, 0, -12), BackgroundTransparency = 1})
            task.wait(0.2)
            if toast then toast:Destroy() end
        end
    end)
end

local function updateTheme(name)
    local preset = themePresets[name]
    if not preset then return end
    state.theme = name
    Theme.Gold = preset.Gold
    Theme.GoldLight = preset.GoldLight
    Theme.Stroke = preset.Stroke
    -- Recolour persistent interface elements.
    brandMark.BackgroundColor3 = Theme.Gold
    markText.TextColor3 = Theme.Background
    mainOutline.Color = Theme.Stroke
    footerLine.BackgroundColor3 = Theme.Stroke
    for _, descendant in ipairs(gui:GetDescendants()) do
        if descendant:IsA("UIStroke") then
            descendant.Color = Theme.Stroke
        elseif descendant:IsA("TextButton") and descendant.Name == "JT3RTab" then
            -- Tab colours are refreshed by renderTabs below.
        end
    end
end

local pages = {}
local currentTab = "Home"
local tabButtons = {}
local renderTabs

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Size = UDim2.fromScale(1, 1)
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Theme.Gold
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = content
    local list = Instance.new("UIListLayout")
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 9)
    list.Parent = page
    padding(page, 1, 5, 1, 12)
    pages[name] = page
    return page
end

local function addSection(parent, text)
    local section = label(parent, string.upper(text), 9, Theme.Gold, Enum.Font.GothamBold)
    section.Size = UDim2.new(1, 0, 0, 18)
    return section
end

local function addInfo(parent, titleText, descText, tagText)
    local card = makeCard(parent, titleText, descText)
    if tagText then
        local tag = label(card, tagText, 9, Theme.GoldLight, Enum.Font.GothamBold)
        tag.Size = UDim2.new(1, 0, 0, 14)
        tag.LayoutOrder = 3
    end
    return card
end

local function addToggle(parent, titleText, descText, initial, callback)
    local card = makeCard(parent, titleText, descText)
    card.Size = UDim2.new(1, 0, 0, descText and 82 or 58)
    card.AutomaticSize = Enum.AutomaticSize.None
    local toggle = Instance.new("TextButton")
    toggle.Name = "Toggle"
    toggle.AutoButtonColor = false
    toggle.Text = ""
    toggle.BackgroundColor3 = initial and Theme.Gold or Theme.Panel3
    toggle.Size = UDim2.fromOffset(42, 23)
    toggle.Position = UDim2.new(1, -56, 0, descText and 15 or 17)
    toggle.Parent = card
    corner(toggle, 20)
    local knob = Instance.new("Frame")
    knob.BackgroundColor3 = initial and Theme.Background or Theme.Muted
    knob.Size = UDim2.fromOffset(17, 17)
    knob.Position = initial and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    knob.Parent = toggle
    corner(knob, 20)
    local value = initial
    local function setValue(nextValue, quiet)
        value = nextValue
        tween(toggle, 0.16, {BackgroundColor3 = value and Theme.Gold or Theme.Panel3})
        tween(knob, 0.16, {Position = value and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = value and Theme.Background or Theme.Muted})
        if callback then callback(value) end
    end
    toggle.Activated:Connect(function() setValue(not value) end)
    return {Set = setValue, Get = function() return value end, Button = toggle}
end

local function addAction(parent, titleText, descText, actionText, callback)
    local card = makeCard(parent, titleText, descText)
    card.Size = UDim2.new(1, 0, 0, descText and 91 or 67)
    card.AutomaticSize = Enum.AutomaticSize.None
    local action = button(card, actionText or "OPEN", UDim2.fromOffset(82, 30), Theme.Panel3, Theme.GoldLight)
    action.Position = UDim2.new(1, -96, 0, descText and 48 or 18)
    action.TextSize = 10
    action.Activated:Connect(function()
        if callback then callback() end
    end)
    return action
end

local function addSlider(parent, titleText, descText, minimum, maximum, initial, callback)
    local card = makeCard(parent, titleText, descText)
    card.Size = UDim2.new(1, 0, 0, 92)
    card.AutomaticSize = Enum.AutomaticSize.None
    local valueLabel = label(card, tostring(initial), 11, Theme.GoldLight, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
    valueLabel.Position = UDim2.new(1, -2, 0, 11)
    valueLabel.Size = UDim2.fromOffset(45, 18)
    local track = Instance.new("Frame")
    track.BackgroundColor3 = Theme.Panel3
    track.Position = UDim2.new(0, 0, 1, -23)
    track.Size = UDim2.new(1, 0, 0, 6)
    track.Parent = card
    corner(track, 8)
    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = Theme.Gold
    fill.Size = UDim2.new((initial - minimum) / (maximum - minimum), 0, 1, 0)
    fill.Parent = track
    corner(fill, 8)
    local knob = Instance.new("Frame")
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.BackgroundColor3 = Theme.GoldLight
    knob.Size = UDim2.fromOffset(14, 14)
    knob.Position = UDim2.new((initial - minimum) / (maximum - minimum), 0, 0.5, 0)
    knob.Parent = track
    corner(knob, 20)
    local hit = Instance.new("TextButton")
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.Size = UDim2.new(1, 0, 0, 26)
    hit.Position = UDim2.new(0, 0, 1, -33)
    hit.Parent = card
    local dragging = false
    local activeInput = nil
    local value = initial
    local function setFromX(x)
        local width = math.max(track.AbsoluteSize.X, 1)
        local alpha = math.clamp((x - track.AbsolutePosition.X) / width, 0, 1)
        value = math.floor(minimum + (maximum - minimum) * alpha + 0.5)
        local progress = (value - minimum) / (maximum - minimum)
        fill.Size = UDim2.new(progress, 0, 1, 0)
        knob.Position = UDim2.new(progress, 0, 0.5, 0)
        valueLabel.Text = tostring(value)
        if callback then callback(value) end
    end
    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            activeInput = input
            setFromX(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and ((activeInput and activeInput.UserInputType == Enum.UserInputType.Touch and input == activeInput) or input.UserInputType == Enum.UserInputType.MouseMovement) then
            setFromX(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input == activeInput or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            activeInput = nil
        end
    end)
    return {Get = function() return value end}
end

-- HOME
local home = createPage("Home")
addSection(home, "Welcome back")
local welcome = makeCard(home, "JT3R FUNHOUSE", "A clean, luxury control panel built to stay comfortable on smaller screens.")
welcome.Size = UDim2.new(1, 0, 0, 112)
welcome.AutomaticSize = Enum.AutomaticSize.None
local version = label(welcome, "VERSION 1.2   •   MOBILE EDITION", 9, Theme.Gold, Enum.Font.GothamBold)
version.Size = UDim2.new(1, 0, 0, 16)
version.LayoutOrder = 3
addSection(home, "Quick overview")
addInfo(home, "Interface status", "Your panel is running locally. No game settings are being changed.", "●  ONLINE")
addInfo(home, "Current profile", "Profiles are stored for this session only.", "DEFAULT")
addSection(home, "Quick actions")
addAction(home, "Reset interface settings", "Return the panel options to their default values.", "RESET", function()
    state.animations = true; state.compact = false; state.floating = true; state.notifications = true
    state.showHints = true; state.aimPreview = false; state.aimSmoothness = 45; state.fovPreview = 90
    state.boxPreview = false; state.namePreview = false; state.distancePreview = false
    state.crosshairPreview = false; state.watermark = true; state.blurPreview = false
    state.profile = "Default"
    notify("Settings reset", "Default interface preferences restored.")
    if renderTabs then renderTabs() end
end)

-- AIM (preview only)
local aim = createPage("Aim")
addSection(aim, "Aim panel preview")
addInfo(aim, "Visual demo only", "These controls are placeholders for interface styling. They do not target, track, or modify other players.", "NO GAMEPLAY EFFECT")
addToggle(aim, "Aim panel preview", "Show the selected state inside this UI only.", state.aimPreview, function(v) state.aimPreview = v end)
addSlider(aim, "Preview smoothness", "Decorative slider value only.", 1, 100, state.aimSmoothness, function(v) state.aimSmoothness = v end)
addSlider(aim, "Preview field size", "A sample setting for the interface mock-up.", 30, 180, state.fovPreview, function(v) state.fovPreview = v end)

-- ESP (preview only)
local esp = createPage("ESP")
addSection(esp, "ESP panel preview")
addInfo(esp, "Visual demo only", "No player highlighting, names, distance reading, or through-wall display is implemented.", "NO PLAYER TRACKING")
addToggle(esp, "Box preview toggle", "Stores a visual preference only.", state.boxPreview, function(v) state.boxPreview = v end)
addToggle(esp, "Name preview toggle", "Stores a visual preference only.", state.namePreview, function(v) state.namePreview = v end)
addToggle(esp, "Distance preview toggle", "Stores a visual preference only.", state.distancePreview, function(v) state.distancePreview = v end)

-- VISUALS
local visuals = createPage("Visuals")
addSection(visuals, "Interface visuals")
addToggle(visuals, "Crosshair preview", "A preference placeholder; no crosshair is drawn into the game world.", state.crosshairPreview, function(v) state.crosshairPreview = v end)
addToggle(visuals, "Watermark", "Show the JT3R identity in the interface header.", state.watermark, function(v)
    state.watermark = v
    brand.Visible = v
    subBrand.Visible = v
end)
addToggle(visuals, "Blur preview", "Visual preference placeholder. No game lighting is changed.", state.blurPreview, function(v) state.blurPreview = v end)

-- MISC
local misc = createPage("Misc")
addSection(misc, "General options")
addToggle(misc, "Notifications", "Show small confirmation messages.", state.notifications, function(v) state.notifications = v end)
addToggle(misc, "Show hints", "Keep explanatory notes visible in the interface.", state.showHints, function(v) state.showHints = v end)
addAction(misc, "About this panel", "A standalone interface shell. It does not include gameplay automation or exploits.", "VIEW", function()
    notify("JT3R FUNHOUSE", "Luxury Edition • Mobile-first UI shell")
end)

-- SETTINGS
local settings = createPage("Settings")
addSection(settings, "Personalise")
addInfo(settings, "Colour theme", "Choose an accent colour. Black and cream remain the base palette.")
local themeRow = Instance.new("Frame")
themeRow.BackgroundTransparency = 1
themeRow.Size = UDim2.new(1, 0, 0, 42)
themeRow.Parent = settings
local themeLayout = Instance.new("UIListLayout")
themeLayout.FillDirection = Enum.FillDirection.Horizontal
themeLayout.Padding = UDim.new(0, 7)
themeLayout.Parent = themeRow
for _, name in ipairs({"Gold", "Purple", "Blue", "Red"}) do
    local preset = themePresets[name]
    local choice = button(themeRow, name, UDim2.new(0.25, -6, 1, 0), Theme.Panel2, Theme.Cream)
    choice.Name = "ThemeChoice"
    choice.TextSize = 10
    choice.Activated:Connect(function()
        updateTheme(name)
        notify("Theme changed", name .. " accent selected.")
        if renderTabs then renderTabs() end
    end)
    local dot = Instance.new("Frame")
    dot.BackgroundColor3 = preset.Gold
    dot.Size = UDim2.fromOffset(7, 7)
    dot.Position = UDim2.new(0, 7, 0.5, -3)
    dot.Parent = choice
    corner(dot, 10)
end
addToggle(settings, "Smooth animations", "Use short transitions for menus and controls.", state.animations, function(v) state.animations = v end)
addToggle(settings, "Compact layout", "Reserved for a future layout preset; current spacing stays optimised for touch.", state.compact, function(v) state.compact = v end)
addToggle(settings, "Floating restore icon", "Keep the JT3R bubble available after minimising.", state.floating, function(v) state.floating = v end)
addSection(settings, "Session profile")
addAction(settings, "Save current profile", "Save your current interface preferences until this UI is closed.", "SAVE", function()
    state.profile = "Saved Session"
    notify("Profile saved", "Saved in this session only.")
end)
addAction(settings, "Load default profile", "Restore the default theme and interface preferences.", "LOAD", function()
    state.theme = "Gold"; updateTheme("Gold")
    state.animations = true; state.compact = false; state.floating = true; state.notifications = true
    state.showHints = true; state.aimPreview = false; state.aimSmoothness = 45; state.fovPreview = 90
    state.boxPreview = false; state.namePreview = false; state.distancePreview = false
    state.crosshairPreview = false; state.watermark = true; state.blurPreview = false
    brand.Visible = true; subBrand.Visible = true
    notify("Default loaded", "Interface preferences restored.")
    if renderTabs then renderTabs() end
end)

-- CONSOLE
local console = createPage("Console")
addSection(console, "Session console")
addInfo(console, "JT3R initialised", "The interface shell loaded. This panel does not execute game commands.", "INFO")
addInfo(console, "Privacy", "No data is sent to a server by this UI. Settings remain local to this running session.", "LOCAL ONLY")
addAction(console, "Copy status text", "Copy a short status line to your clipboard when supported by the environment.", "COPY", function()
    local line = "JT3R FUNHOUSE v1.2 | UI shell active | Theme: " .. tostring(state.theme)
    if typeof(setclipboard) == "function" then
        pcall(setclipboard, line)
        notify("Copied", "Status text copied.")
    else
        notify("Clipboard unavailable", "Clipboard helper is not available here.")
    end
end)

local tabNames = {"Home", "Aim", "ESP", "Visuals", "Misc", "Settings", "Console"}
renderTabs = function()
    for _, child in ipairs(tabBar:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    tabButtons = {}
    for index, name in ipairs(tabNames) do
        local tab = button(tabBar, name, UDim2.fromOffset(name == "Settings" and 74 or 66, 34), Theme.Panel2, Theme.Muted)
        tab.Name = "JT3RTab"
        tab.LayoutOrder = index
        tab.TextSize = 10
        tabButtons[name] = tab
        tab.Activated:Connect(function()
            currentTab = name
            for pageName, page in pairs(pages) do page.Visible = pageName == name end
            renderTabs()
        end)
        if name == currentTab then
            tab.BackgroundColor3 = Theme.Gold
            tab.TextColor3 = Theme.Background
            tab.Font = Enum.Font.GothamBold
        end
    end
end
for name, page in pairs(pages) do page.Visible = name == currentTab end
renderTabs()

-- Responsive sizing: designed around the iPhone 11's portrait viewport.
local function updateViewport()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local viewport = camera.ViewportSize
    local width = math.min(520, math.max(300, viewport.X - 24))
    local height = math.min(700, math.max(390, viewport.Y - 42))
    main.Size = UDim2.fromOffset(width, height)
    local scale = 1
    if viewport.X < 360 then scale = 0.92 end
    mainScale.Scale = scale
    main.Position = UDim2.fromScale(0.5, 0.5)
end
updateViewport()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateViewport)
end

-- Dragging: header for the window; floating badge for restore icon.
local function makeDraggable(handle, target, onMoved)
    local dragging = false
    local dragStart, startPosition
    local activeTouch
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            activeTouch = input.UserInputType == Enum.UserInputType.Touch and input or nil
            dragStart = input.Position
            startPosition = target.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        local valid = (activeTouch and input == activeTouch) or (not activeTouch and input.UserInputType == Enum.UserInputType.MouseMovement)
        if valid then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
            if onMoved then onMoved() end
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input == activeTouch then
            dragging = false
            activeTouch = nil
        end
    end)
end
makeDraggable(header, main)

local floating = button(screen, "J", UDim2.fromOffset(52, 52), Theme.Gold, Theme.Background)
floating.Name = "FloatingJT3R"
floating.AnchorPoint = Vector2.new(1, 1)
floating.Position = UDim2.new(1, -18, 1, -28)
floating.TextSize = 22
floating.Font = Enum.Font.GothamBlack
floating.Visible = false
floating.ZIndex = 20
local floatStroke = stroke(floating, Theme.GoldLight, 0.1, 1.2)

local floatMoved = false
local floatDragging = false
local floatStart, floatPosition, floatTouch
floating.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        floatDragging = true
        floatMoved = false
        floatTouch = input.UserInputType == Enum.UserInputType.Touch and input or nil
        floatStart = input.Position
        floatPosition = floating.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    local valid = (floatTouch and input == floatTouch) or (not floatTouch and input.UserInputType == Enum.UserInputType.MouseMovement)
    if floatDragging and valid then
        local delta = input.Position - floatStart
        if math.abs(delta.X) + math.abs(delta.Y) > 5 then floatMoved = true end
        floating.Position = UDim2.new(floatPosition.X.Scale, floatPosition.X.Offset + delta.X, floatPosition.Y.Scale, floatPosition.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if floatDragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input == floatTouch) then
        floatDragging = false
        floatTouch = nil
    end
end)
floating.Activated:Connect(function()
    if floatMoved then return end
    main.Visible = true
    floating.Visible = false
    tween(main, 0.2, {Position = UDim2.fromScale(0.5, 0.5)})
end)

minimize.Activated:Connect(function()
    main.Visible = false
    floating.Visible = state.floating
    if floating.Visible then
        tween(floating, 0.18, {BackgroundColor3 = Theme.Gold})
    end
end)
close.Activated:Connect(function()
    gui:Destroy()
end)

-- Desktop convenience key. Touch users can always use the header controls.
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if main.Visible then
            main.Visible = false
            floating.Visible = state.floating
        else
            main.Visible = true
            floating.Visible = false
        end
    end
end)

-- Theme-aware refresh for elements created before a theme change.
local originalNotify = notify
notify("JT3R FUNHOUSE", "Luxury Edition v1.2 ready.")

print("JT3R FUNHOUSE v1.2 loaded. UI shell only; no gameplay modifications.")
