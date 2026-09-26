--========================================================--
--              LUXURYXHUB - COMPACT UI                  --
--========================================================--

local UI = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer

--========================================================--
-- COLORS
--========================================================--

local COLORS = {
    Background = Color3.fromRGB(16, 17, 24),
    Panel      = Color3.fromRGB(23, 24, 33),
    Card       = Color3.fromRGB(30, 31, 43),
    CardHover  = Color3.fromRGB(37, 38, 52),

    Text       = Color3.fromRGB(245, 245, 250),
    SubText    = Color3.fromRGB(155, 158, 175),

    Accent     = Color3.fromRGB(170, 90, 255),
    Accent2    = Color3.fromRGB(225, 85, 255),

    Green      = Color3.fromRGB(70, 210, 130),
    Red        = Color3.fromRGB(220, 75, 85),

    Stroke     = Color3.fromRGB(55, 57, 72),
}

--========================================================--
-- CLEAN OLD UI
--========================================================--

pcall(function()
    local old = CoreGui:FindFirstChild("LuxuryXHUB_CompactUI")
    if old then
        old:Destroy()
    end
end)

--========================================================--
-- HELPERS
--========================================================--

local function Create(className, properties, parent)
    local object = Instance.new(className)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    object.Parent = parent

    return object
end

local function Corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = object
    return c
end

local function Stroke(object, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or COLORS.Stroke
    s.Thickness = thickness or 1
    s.Transparency = 0.15
    s.Parent = object
    return s
end

local function Tween(object, properties, duration)
    return TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.2,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        properties
    )
end

--========================================================--
-- GUI
--========================================================--

local ScreenGui = Create("ScreenGui", {
    Name = "LuxuryXHUB_CompactUI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, CoreGui)

UI.Gui = ScreenGui

--========================================================--
-- OPEN BUTTON
--========================================================--

local OpenButton = Create("TextButton", {
    Name = "OpenButton",

    Size = UDim2.fromOffset(48, 48),

    Position = UDim2.new(
        0,
        15,
        0.5,
        -24
    ),

    BackgroundColor3 = COLORS.Panel,

    BorderSizePixel = 0,

    Text = "⚡",

    TextColor3 = COLORS.Text,

    TextSize = 20,

    Font = Enum.Font.GothamBold,

    AutoButtonColor = false,
}, ScreenGui)

Corner(OpenButton, 14)
Stroke(OpenButton, COLORS.Accent, 1)

--========================================================--
-- MAIN PANEL
--========================================================--

local Main = Create("Frame", {
    Name = "Main",

    Size = UDim2.fromOffset(360, 390),

    Position = UDim2.new(
        0.5,
        -180,
        0.5,
        -195
    ),

    BackgroundColor3 = COLORS.Background,

    BorderSizePixel = 0,
}, ScreenGui)

Corner(Main, 13)
Stroke(Main, COLORS.Stroke, 1)

UI.Main = Main

--========================================================--
-- HEADER
--========================================================--

local Header = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 58),

    BackgroundColor3 = COLORS.Panel,

    BorderSizePixel = 0,
}, Main)

Corner(Header, 13)

local Title = Create("TextLabel", {
    BackgroundTransparency = 1,

    Position = UDim2.fromOffset(16, 7),

    Size = UDim2.new(1, -80, 0, 23),

    Text = "⚡ LuxuryXHUB",

    TextColor3 = COLORS.Text,

    TextSize = 16,

    Font = Enum.Font.GothamBold,

    TextXAlignment = Enum.TextXAlignment.Left,
}, Header)

local Status = Create("TextLabel", {
    BackgroundTransparency = 1,

    Position = UDim2.fromOffset(17, 30),

    Size = UDim2.new(1, -80, 0, 17),

    Text = "● ONLINE",

    TextColor3 = COLORS.Green,

    TextSize = 10,

    Font = Enum.Font.GothamMedium,

    TextXAlignment = Enum.TextXAlignment.Left,
}, Header)

local CloseButton = Create("TextButton", {
    Size = UDim2.fromOffset(32, 32),

    Position = UDim2.new(1, -43, 0, 13),

    BackgroundColor3 = COLORS.Card,

    BorderSizePixel = 0,

    Text = "×",

    TextColor3 = COLORS.Text,

    TextSize = 20,

    Font = Enum.Font.GothamBold,

    AutoButtonColor = false,
}, Header)

Corner(CloseButton, 9)

--========================================================--
-- TAB BAR
--========================================================--

local TabBar = Create("Frame", {
    Size = UDim2.new(1, -20, 0, 40),

    Position = UDim2.fromOffset(10, 67),

    BackgroundTransparency = 1,
}, Main)

local TabLayout = Create("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,

    HorizontalAlignment = Enum.HorizontalAlignment.Center,

    Padding = UDim.new(0, 5),
}, TabBar)

local Content = Create("Frame", {
    Size = UDim2.new(1, -20, 1, -118),

    Position = UDim2.fromOffset(10, 110),

    BackgroundTransparency = 1,
}, Main)

UI.Content = Content

--========================================================--
-- PAGE SYSTEM
--========================================================--

local Pages = {}
local Tabs = {}
local CurrentPage

local function CreatePage(name)
    local page = Create("ScrollingFrame", {
        Name = name,

        Size = UDim2.fromScale(1, 1),

        BackgroundTransparency = 1,

        BorderSizePixel = 0,

        ScrollBarThickness = 3,

        ScrollBarImageColor3 = COLORS.Accent,

        CanvasSize = UDim2.new(0, 0, 0, 0),

        AutomaticCanvasSize = Enum.AutomaticSize.Y,

        Visible = false,
    }, Content)

    Create("UIListLayout", {
        Padding = UDim.new(0, 7),

        SortOrder = Enum.SortOrder.LayoutOrder,
    }, page)

    Create("UIPadding", {
        PaddingTop = UDim.new(0, 2),
        PaddingBottom = UDim.new(0, 8),
    }, page)

    Pages[name] = page

    return page
end

local function ShowPage(name)
    for pageName, page in pairs(Pages) do
        page.Visible = pageName == name
    end

    for tabName, tab in pairs(Tabs) do
        local active = tabName == name

        Tween(
            tab,
            {
                BackgroundColor3 =
                    active
                    and COLORS.Accent
                    or COLORS.Card
            },
            0.18
        ):Play()
    end

    CurrentPage = name
end

local function CreateTab(name, text)
    local tab = Create("TextButton", {
        Size = UDim2.fromOffset(76, 34),

        BackgroundColor3 = COLORS.Card,

        BorderSizePixel = 0,

        Text = text,

        TextColor3 = COLORS.Text,

        TextSize = 10,

        Font = Enum.Font.GothamBold,

        AutoButtonColor = false,
    }, TabBar)

    Corner(tab, 8)
    Stroke(tab)

    Tabs[name] = tab

    tab.MouseButton1Click:Connect(function()
        ShowPage(name)
    end)

    return tab
end

--========================================================--
-- TOGGLE CREATOR
--========================================================--

local function AddToggle(parent, icon, title, description, getter, setter)

    local Card = Create("Frame", {
        Size = UDim2.new(1, -4, 0, 58),

        BackgroundColor3 = COLORS.Card,

        BorderSizePixel = 0,
    }, parent)

    Corner(Card, 9)
    Stroke(Card)

    local Icon = Create("TextLabel", {
        Size = UDim2.fromOffset(34, 34),

        Position = UDim2.fromOffset(10, 12),

        BackgroundColor3 = COLORS.Panel,

        BorderSizePixel = 0,

        Text = icon,

        TextColor3 = COLORS.Text,

        TextSize = 15,

        Font = Enum.Font.GothamBold,
    }, Card)

    Corner(Icon, 8)

    local Name = Create("TextLabel", {
        BackgroundTransparency = 1,

        Position = UDim2.fromOffset(52, 7),

        Size = UDim2.new(1, -125, 0, 19),

        Text = title,

        TextColor3 = COLORS.Text,

        TextSize = 12,

        Font = Enum.Font.GothamBold,

        TextXAlignment = Enum.TextXAlignment.Left,
    }, Card)

    local Description = Create("TextLabel", {
        BackgroundTransparency = 1,

        Position = UDim2.fromOffset(52, 27),

        Size = UDim2.new(1, -125, 0, 17),

        Text = description,

        TextColor3 = COLORS.SubText,

        TextSize = 9,

        Font = Enum.Font.Gotham,

        TextTruncate = Enum.TextTruncate.AtEnd,

        TextXAlignment = Enum.TextXAlignment.Left,
    }, Card)

    local Toggle = Create("TextButton", {
        Size = UDim2.fromOffset(48, 24),

        Position = UDim2.new(1, -60, 0.5, -12),

        BackgroundColor3 = COLORS.Red,

        BorderSizePixel = 0,

        Text = "",

        AutoButtonColor = false,
    }, Card)

    Corner(Toggle, 12)

    local Knob = Create("Frame", {
        Size = UDim2.fromOffset(18, 18),

        Position = UDim2.fromOffset(3, 3),

        BackgroundColor3 = Color3.fromRGB(245,245,245),

        BorderSizePixel = 0,
    }, Toggle)

    Corner(Knob, 9)

    local function Refresh()

        local enabled = false

        pcall(function()
            enabled = getter()
        end)

        if enabled then

            Tween(
                Toggle,
                {
                    BackgroundColor3 = COLORS.Green
                },
                0.15
            ):Play()

            Tween(
                Knob,
                {
                    Position = UDim2.new(
                        1,
                        -21,
                        0,
                        3
                    )
                },
                0.15
            ):Play()

        else

            Tween(
                Toggle,
                {
                    BackgroundColor3 = COLORS.Red
                },
                0.15
            ):Play()

            Tween(
                Knob,
                {
                    Position = UDim2.fromOffset(3,3)
                },
                0.15
            ):Play()

        end
    end

    Toggle.MouseButton1Click:Connect(function()

        local current = false

        pcall(function()
            current = getter()
        end)

        pcall(function()
            setter(not current)
        end)

        task.defer(Refresh)

    end)

    Refresh()

    return Card
end

--========================================================--
-- ACTION BUTTON
--========================================================--

local function AddAction(parent, icon, title, description, callback)

    local Button = Create("TextButton", {
        Size = UDim2.new(1, -4, 0, 52),

        BackgroundColor3 = COLORS.Card,

        BorderSizePixel = 0,

        Text = "",

        AutoButtonColor = false,
    }, parent)

    Corner(Button, 9)
    Stroke(Button)

    local Icon = Create("TextLabel", {
        BackgroundTransparency = 1,

        Position = UDim2.fromOffset(12, 0),

        Size = UDim2.fromOffset(30, 52),

        Text = icon,

        TextColor3 = COLORS.Text,

        TextSize = 17,

        Font = Enum.Font.GothamBold,
    }, Button)

    local Name = Create("TextLabel", {
        BackgroundTransparency = 1,

        Position = UDim2.fromOffset(50, 7),

        Size = UDim2.new(1, -60, 0, 18),

        Text = title,

        TextColor3 = COLORS.Text,

        TextSize = 12,

        Font = Enum.Font.GothamBold,

        TextXAlignment = Enum.TextXAlignment.Left,
    }, Button)

    local Desc = Create("TextLabel", {
        BackgroundTransparency = 1,

        Position = UDim2.fromOffset(50, 26),

        Size = UDim2.new(1, -60, 0, 16),

        Text = description,

        TextColor3 = COLORS.SubText,

        TextSize = 9,

        Font = Enum.Font.Gotham,

        TextXAlignment = Enum.TextXAlignment.Left,
    }, Button)

    Button.MouseEnter:Connect(function()
        Tween(
            Button,
            {
                BackgroundColor3 = COLORS.CardHover
            },
            0.12
        ):Play()
    end)

    Button.MouseLeave:Connect(function()
        Tween(
            Button,
            {
                BackgroundColor3 = COLORS.Card
            },
            0.12
        ):Play()
    end)

    Button.MouseButton1Click:Connect(function()
        pcall(callback)
    end)

    return Button
end

--========================================================--
-- CREATE TABS
--========================================================--

CreateTab("FARM", "🏋 FARM")
CreateTab("EGG", "🥚 EGG")
CreateTab("PLAYER", "👤 PLAYER")
CreateTab("OTHER", "⚙ OTHER")

--========================================================--
-- FARM PAGE
--========================================================--

local FarmPage = CreatePage("FARM")

AddToggle(
    FarmPage,
    "🏋",
    "Auto Train",
    "Tự động train",
    function()
        return Config.AutoTrain
    end,
    function(state)
        Config.AutoTrain = state

        if state then
            Farm.startAutoTrain()
        else
            Farm.stopAutoTrain()
        end
    end
)

AddToggle(
    FarmPage,
    "💰",
    "Auto Sell",
    "Tự động bán",
    function()
        return Config.AutoSell
    end,
    function(state)
        Config.AutoSell = state

        if state then
            Farm.startAutoSell()
        else
            Farm.stopAutoSell()
        end
    end
)

AddToggle(
    FarmPage,
    "🔄",
    "Auto Rebirth",
    "Tự động rebirth",
    function()
        return Config.AutoRebirth
    end,
    function(state)
        Config.AutoRebirth = state

        if state then
            Farm.startAutoRebirth()
        else
            Farm.stopAutoRebirth()
        end
    end
)

AddToggle(
    FarmPage,
    "🏋",
    "Auto Buy Dumbell",
    "Tự động mua dumbell",
    function()
        return Config.AutoBuyDumbell
    end,
    function(state)
        Config.AutoBuyDumbell = state

        if state then
            Farm.startAutoBuyDumbell()
        else
            Farm.stopAutoBuyDumbell()
        end
    end
)

AddToggle(
    FarmPage,
    "📦",
    "Auto Upgrade Carry",
    "Tự động nâng Carry",
    function()
        return Config.AutoUpgradeCarry
    end,
    function(state)
        Config.AutoUpgradeCarry = state

        if state then
            Farm.startAutoUpgradeCarry()
        else
            Farm.stopAutoUpgradeCarry()
        end
    end
)

AddToggle(
    FarmPage,
    "⚔",
    "Auto Buy Gear",
    "Tự động mua Gear",
    function()
        return Config.AutoBuyGear
    end,
    function(state)
        Config.AutoBuyGear = state

        if state then
            Farm.startAutoBuyGear()
        else
            Farm.stopAutoBuyGear()
        end
    end
)

--========================================================--
-- EGG PAGE
--========================================================--

local EggPage = CreatePage("EGG")

AddToggle(
    EggPage,
    "🥚",
    "Auto Pull Egg",
    "Tự động kéo Egg",
    function()
        return Config.AutoPullEgg
    end,
    function(state)
        Config.AutoPullEgg = state

        if state then
            Farm.startAutoPullEgg()
        else
            Farm.stopAutoPullEgg()
        end
    end
)

AddToggle(
    EggPage,
    "👁",
    "Egg ESP",
    "Hiển thị Egg ESP",
    function()
        return Config.EggESP
    end,
    function(state)
        Config.EggESP = state

        if state then
            ESP.start()
            ESP.setEnabled(true)
        else
            ESP.setEnabled(false)
        end
    end
)

AddAction(
    EggPage,
    "🎯",
    "Target Egg: " .. tostring(Config.TargetEggTier),
    "Tier mục tiêu hiện tại",
    function()
        local current = table.find(
            Config.TIERS,
            Config.TargetEggTier
        ) or 1

        current = current + 1

        if current > #Config.TIERS then
            current = 1
        end

        Config.TargetEggTier = Config.TIERS[current]
    end
)

--========================================================--
-- PLAYER PAGE
--========================================================--

local PlayerPage = CreatePage("PLAYER")

AddToggle(
    PlayerPage,
    "♻",
    "Auto Revive",
    "Tự động revive",
    function()
        return Config.AutoRevive
    end,
    function(state)
        Config.AutoRevive = state
    end
)

AddToggle(
    PlayerPage,
    "🚀",
    "Speed Boost",
    "Tăng WalkSpeed / JumpPower",
    function()
        return Config.SpeedBoost
    end,
    function(state)
        Config.SpeedBoost = state
        Universal.setSpeed(state)
    end
)

AddToggle(
    PlayerPage,
    "🛡",
    "Anti AFK",
    "Không bị AFK kick",
    function()
        return Config.AntiAFK
    end,
    function(state)
        Config.AntiAFK = state
        Universal.setAntiAFK(state)
    end
)

AddToggle(
    PlayerPage,
    "👻",
    "Noclip",
    "Đi xuyên vật thể",
    function()
        return false
    end,
    function(state)
        Farm.setNoclip(state)
    end
)

--========================================================--
-- OTHER PAGE
--========================================================--

local OtherPage = CreatePage("OTHER")

AddToggle(
    OtherPage,
    "📱",
    "Low Graphics",
    "Giảm chất lượng đồ họa",
    function()
        return Config.LowGraphics
    end,
    function(state)
        Config.LowGraphics = state
        Universal.setLowGraphics(state)
    end
)

AddAction(
    OtherPage,
    "🏠",
    "Teleport Spawn",
    "Về khu vực Spawn",
    function()
        Farm.teleportToSpawn()
    end
)

AddAction(
    OtherPage,
    "🔄",
    "Refresh ESP",
    "Làm mới ESP",
    function()
        ESP.destroy()

        if Config.EggESP then
            ESP.start()
            ESP.setEnabled(true)
        end
    end
)

--========================================================--
-- OPEN / CLOSE
--========================================================--

local function OpenMenu()

    Main.Visible = true

    Main.Size = UDim2.fromOffset(330, 360)

    Tween(
        Main,
        {
            Size = UDim2.fromOffset(360, 390)
        },
        0.2
    ):Play()

end

local function CloseMenu()

    local tween = Tween(
        Main,
        {
            Size = UDim2.fromOffset(330, 360)
        },
        0.15
    )

    tween:Play()

    tween.Completed:Once(function()
        Main.Visible = false
    end)

end

OpenButton.MouseButton1Click:Connect(function()

    if Main.Visible then
        CloseMenu()
    else
        OpenMenu()
    end

end)

CloseButton.MouseButton1Click:Connect(function()
    CloseMenu()
end)

--========================================================--
-- DRAG MAIN PANEL
--========================================================--

do

    local dragging = false
    local dragStart
    local startPosition

    Header.InputBegan:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true

            dragStart = input.Position
            startPosition = Main.Position

            input.Changed:Connect(function()

                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end

            end)

        end

    end)

    UserInputService.InputChanged:Connect(fuwait(Config.TrainInterval or 0.1)
    end)
end
function Farm.stopAutoTrain()   Config.AutoTrain        = false end

function Farm.startAutoSell()
    loop("AutoSell", function() return Config.AutoSell end, function()
        Remotes.fire("Sell All Friends")
        task.wait(Config.SellInterval or 2)
    end)
end
function Farm.stopAutoSell()    Config.AutoSell         = false end

function Farm.startAutoRebirth()
    loop("AutoRebirth", function() return Config.AutoRebirth end, function()
        Remotes.fire("Rebirth")
        task.wait(Config.RebirthInterval or 1)
    end)
end
function Farm.stopAutoRebirth() Config.AutoRebirth      = false end

function Farm.startAutoBuyDumbell()
    loop("AutoBuyDumbell", function() return Config.AutoBuyDumbell end, function()
        for i = 1, 30 do
            if not (Runtime.Running and Config.AutoBuyDumbell) then break end
            Remotes.buyDumbell(i)
            task.wait(0.05)
        end
        task.wait(1)
    end)
end
function Farm.stopAutoBuyDumbell() Config.AutoBuyDumbell = false end

function Farm.startAutoUpgradeCarry()
    loop("AutoUpgradeCarry", function() return Config.AutoUpgradeCarry end, function()
        Remotes.fire("Upgrade Carry Limit")
        task.wait(1)
    end)
end
function Farm.stopAutoUpgradeCarry() Config.AutoUpgradeCarry = false end

function Farm.startAutoBuyGear()
    loop("AutoBuyGear", function() return Config.AutoBuyGear end, function()
        Remotes.fire("Buy Gear", tostring(Config.BuyGearId or "6"), "Buy")
        task.wait(Config.BuyGearInterval or 1)
    end)
end
function Farm.stopAutoBuyGear() Config.AutoBuyGear      = false end

function Farm.startAutoPullEgg()
    if Farm.Threads["AutoPullEgg"] then return end
    Farm.Threads["AutoPullEgg"] = task.spawn(function()
        if Config.SafeHover then Farm.setFloat(true) Farm.setNoclip(true) end
        while Runtime.Running and Config.AutoPullEgg do
            local tier = Config.TargetEggTier or "Celestial"
            local part = Farm.getPartForTier(tier)
            if part then
                local flyH = Config.FlyHeight or 16
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    local target = part.Position + Vector3.new(0, flyH, 0)
                    if (root.Position - target).Magnitude > 8 then
                        Farm.teleportTo(part.CFrame, flyH)
                        task.wait(0.15)
                    end
                end
                Remotes.invoke("Strange: Claim Egg", tier)
                Remotes.fire("Activate Dumbell")
            end
            task.wait(0.1)
        end
        Farm.setFloat(false)
        Farm.setNoclip(false)
        Farm.Threads["AutoPullEgg"] = nil
    end)
end
function Farm.stopAutoPullEgg()
    Config.AutoPullEgg = false
    Farm.setFloat(false)
    Farm.setNoclip(false)
end

-- ── 4. ESP ───────────────────────────────────────────────────────────
local ESP = { Enabled = true, Billboards = {}, Connection = nil }

function ESP.createBillboard(part, tierName, color)
    if part:FindFirstChild("LuxuryXHUB_ESP") then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name         = "LuxuryXHUB_ESP"
    billboard.Adornee      = part
    billboard.Size         = UDim2.new(0, 180, 0, 50)
    billboard.StudsOffset  = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop  = true
    billboard.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Size                   = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3       = Color3.fromRGB(15, 17, 24)
    frame.BackgroundTransparency = 0.35
    frame.BorderSizePixel        = 0
    frame.Parent                 = billboard

    local fc = Instance.new("UICorner") fc.CornerRadius = UDim.new(0, 8) fc.Parent = frame
    local fs = Instance.new("UIStroke") fs.Color = color or Color3.fromRGB(255,255,255) fs.Thickness = 1.5 fs.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size                 = UDim2.new(1, 0, 0.55, 0)
    title.BackgroundTransparency = 1
    title.Text                 = "🥚 " .. string.upper(tierName)
    title.TextColor3           = color or Color3.fromRGB(255, 255, 255)
    title.Font                 = Enum.Font.GothamBold
    title.TextSize             = 13
    title.Parent               = frame

    local distLbl = Instance.new("TextLabel")
    distLbl.Name                 = "DistLabel"
    distLbl.Position             = UDim2.new(0, 0, 0.55, 0)
    distLbl.Size                 = UDim2.new(1, 0, 0.45, 0)
    distLbl.BackgroundTransparency = 1
    distLbl.Text                 = "... studs"
    distLbl.TextColor3           = Color3.fromRGB(200, 205, 220)
    distLbl.Font                 = Enum.Font.Gotham
    distLbl.TextSize             = 11
    distLbl.Parent               = frame

    billboard.Parent = part
    table.insert(ESP.Billboards, { Part = part, DistLabel = distLbl, Billboard = billboard })
end

function ESP.init()
    local map  = workspace:FindFirstChild("Map")
    local sp   = map and map:FindFirstChild("SpawnParts")
    if not sp then return end
    for _, tf in ipairs(sp:GetChildren()) do
        local color = Config.TIER_COLORS[tf.Name] or Color3.fromRGB(255,255,255)
        for _, p in ipairs(tf:GetChildren()) do
            if p:IsA("BasePart") then ESP.createBillboard(p, tf.Name, color) end
        end
    end
    if ESP.Connection then return end
    ESP.Connection = RunService.RenderStepped:Connect(function()
        if not ESP.Enabled then return end
        local char    = LocalPlayer.Character
        local root    = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local rootPos = root.Position
        local live    = {}
        for _, item in ipairs(ESP.Billboards) do
            if item.Part and item.Part.Parent and item.Billboard and item.Billboard.Parent then
                if item.DistLabel then
                    item.DistLabel.Text = math.floor((item.Part.Position - rootPos).Magnitude) .. " studs"
                end
                live[#live+1] = item
            else
                pcall(function() if item.Billboard then item.Billboard:Destroy() end end)
            end
        end
        ESP.Billboards = live
    end)
    Runtime.trackConn(ESP.Connection)
end

function ESP.setEnabled(state)
    ESP.Enabled = state
    local live = {}
    for _, item in ipairs(ESP.Billboards) do
        if item.Billboard and item.Billboard.Parent then
            item.Billboard.Enabled = state
            live[#live+1] = item
        end
    end
    ESP.Billboards = live
end

function ESP.destroy()
    if ESP.Connection then ESP.Connection:Disconnect() ESP.Connection = nil end
    for _, item in ipairs(ESP.Billboards) do
        pcall(function() if item.Billboard then item.Billboard:Destroy() end end)
    end
    ESP.Billboards = {}
end

-- ── 5. Universal Utilities ───────────────────────────────────────────
local Universal = {}

do
    local TeleportService = game:GetService("TeleportService")
    local HttpService     = game:GetService("HttpService")
    local LOADER_URL      = "https://raw.githubusercontent.com/LostInSyntaxx/RideAPet/main/loader.lua"

    local _afkConn   = nil
    local _speedConn = nil
    local _origQual  = nil

    local function queueReload()
        pcall(function()
            local qot = (syn and syn.queue_on_teleport)
                or (typeof(queue_on_teleport) == "function" and queue_on_teleport)
                or (Fluxus and Fluxus.queue_on_teleport)
            if qot then
                qot(('task.wait(3) pcall(function() loadstring(game:HttpGet("%s"))() end)'):format(LOADER_URL))
            end
        end)
    end

    function Universal.setAntiAFK(enable)
        if _afkConn then pcall(function() _afkConn:Disconnect() end) _afkConn = nil end
        if enable then
            _afkConn = Runtime.trackConn(LocalPlayer.Idled:Connect(function()
                pcall(function()
                    local vu = game:GetService("VirtualUser")
                    vu:CaptureController()
                    vu:ClickButton2(Vector2.new())
                end)
            end))
        end
    end
    function Universal.stopAntiAFK() Universal.setAntiAFK(false) end

    local function applySpeed()
        pcall(function()
            local char = LocalPlayer.Character
            local hum  = char and char:FindFirstChildWhichIsA("Humanoid")
            if hum then hum.WalkSpeed = Config.WalkSpeed hum.JumpPower = Config.JumpPower end
        end)
    end

    function Universal.setSpeed(enable)
        if _speedConn then pcall(function() _speedConn:Disconnect() end) _speedConn = nil end
        if enable then
            applySpeed()
            _speedConn = Runtime.trackConn(LocalPlayer.CharacterAdded:Connect(function()
                task.wait(0.5)
                applySpeed()
            end))
        else
            pcall(function()
                local char = LocalPlayer.Character
                local hum  = char and char:FindFirstChildWhichIsA("Humanoid")
                if hum then hum.WalkSpeed = 16 hum.JumpPower = 50 end
            end)
        end
    end
    function Universal.stopSpeed() Universal.setSpeed(false) end

    function Universal.setLowGraphics(enable)
        pcall(function()
            local lighting = game:GetService("Lighting")
            if enable then
                lighting.GlobalShadows = false
                lighting.FogEnd        = 9e4
                lighting.FogStart      = 9e4
            else
                lighting.GlobalShadows = true
                lighting.FogEnd        = 100000
                lighting.FogStart      = 0
            end
        end)
        pcall(function()
            local gs = UserSettings():GetService("UserGameSettings")
            if enable then
                _origQual = gs.SavedQualityLevel
                

                pcall(function()
                    gs.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
                end)
            else
                if _origQual then
                    pcall(function()
                        gs.SavedQualityLevel = _origQual
                    end)
                end
            end
        end)
    end
end

-- ── 6. Compact Fire UI ───────────────────────────────────────────────
local UI = {}

pcall(function()
    local old = CoreGui:FindFirstChild("LuxuryXHUB_FireUI")
    if old then old:Destroy() end
end)

local COLORS = {
    BG = Color3.fromRGB(16,17,24),
    PANEL = Color3.fromRGB(23,24,33),
    CARD = Color3.fromRGB(30,31,43),
    CARD_HOVER = Color3.fromRGB(38,39,53),
    TEXT = Color3.fromRGB(245,245,250),
    SUB = Color3.fromRGB(155,158,175),
    ACCENT = Color3.fromRGB(170,90,255),
    GREEN = Color3.fromRGB(70,210,130),
    RED = Color3.fromRGB(220,75,85),
    STROKE = Color3.fromRGB(55,57,72),
}

local function New(class, props, parent)
    local x = Instance.new(class)
    for k,v in pairs(props or {}) do x[k] = v end
    x.Parent = parent
    return x
end

local function Round(x, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,r or 8)
    c.Parent = x
end

local function Outline(x)
    local s = Instance.new("UIStroke")
    s.Color = COLORS.STROKE
    s.Transparency = 0.12
    s.Thickness = 1
    s.Parent = x
end

local Gui = New("ScreenGui", {
    Name = "LuxuryXHUB_FireUI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, CoreGui)

local Open = New("TextButton", {
    Size = UDim2.fromOffset(50,50),
    Position = UDim2.new(0,14,0.5,-25),
    BackgroundColor3 = COLORS.PANEL,
    BorderSizePixel = 0,
    Text = "⚡",
    TextColor3 = COLORS.TEXT,
    TextSize = 21,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
}, Gui)
Round(Open,15)
Outline(Open)

local Main = New("Frame", {
    Size = UDim2.fromOffset(360,390),
    Position = UDim2.new(0.5,-180,0.5,-195),
    BackgroundColor3 = COLORS.BG,
    BorderSizePixel = 0,
}, Gui)
Round(Main,14)
Outline(Main)

local Header = New("Frame", {
    Size = UDim2.new(1,0,0,57),
    BackgroundColor3 = COLORS.PANEL,
    BorderSizePixel = 0,
}, Main)
Round(Header,14)

New("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(15,7),
    Size = UDim2.new(1,-70,0,22),
    Text = "⚡ LuxuryXHUB",
    TextColor3 = COLORS.TEXT,
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
}, Header)

New("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(16,30),
    Size = UDim2.new(1,-70,0,17),
    Text = "● FIRE • ONLINE",
    TextColor3 = COLORS.GREEN,
    TextSize = 9,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
}, Header)

local Close = New("TextButton", {
    Size = UDim2.fromOffset(31,31),
    Position = UDim2.new(1,-42,0,13),
    BackgroundColor3 = COLORS.CARD,
    BorderSizePixel = 0,
    Text = "×",
    TextColor3 = COLORS.TEXT,
    TextSize = 19,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
}, Header)
Round(Close,8)

local TabsBar = New("Frame", {
    Size = UDim2.new(1,-20,0,38),
    Position = UDim2.fromOffset(10,65),
    BackgroundTransparency = 1,
}, Main)

local TabLayout = New("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    Padding = UDim.new(0,5),
}, TabsBar)

local Content = New("Frame", {
    Size = UDim2.new(1,-20,1,-112),
    Position = UDim2.fromOffset(10,108),
    BackgroundTransparency = 1,
}, Main)

local Pages, Tabs = {}, {}

local function Page(name)
    local p = New("ScrollingFrame", {
        Size = UDim2.fromScale(1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = COLORS.ACCENT,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
    }, Content)
    New("UIListLayout", {
        Padding = UDim.new(0,7),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, p)
    New("UIPadding", {
        PaddingTop = UDim.new(0,2),
        PaddingBottom = UDim.new(0,8),
    }, p)
    Pages[name] = p
    return p
end

local function Show(name)
    for n,p in pairs(Pages) do p.Visible = (n == name) end
    for n,t in pairs(Tabs) do
        t.BackgroundColor3 = (n == name) and COLORS.ACCENT or COLORS.CARD
    end
end

local function Tab(name,text)
    local t = New("TextButton", {
        Size = UDim2.fromOffset(78,33),
        BackgroundColor3 = COLORS.CARD,
        BorderSizePixel = 0,
        Text = text,
        TextColor3 = COLORS.TEXT,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
    }, TabsBar)
    Round(t,8)
    Outline(t)
    Tabs[name] = t
    t.MouseButton1Click:Connect(function() Show(name) end)
end

local function Toggle(parent, icon, title, desc, get, set)
    local card = New("Frame", {
        Size = UDim2.new(1,-4,0,58),
        BackgroundColor3 = COLORS.CARD,
        BorderSizePixel = 0,
    }, parent)
    Round(card,9)
    Outline(card)

    local ic = New("TextLabel", {
        Size = UDim2.fromOffset(34,34),
        Position = UDim2.fromOffset(10,12),
        BackgroundColor3 = COLORS.PANEL,
        BorderSizePixel = 0,
        Text = icon,
        TextColor3 = COLORS.TEXT,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
    }, card)
    Round(ic,8)

    New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(52,7),
        Size = UDim2.new(1,-125,0,18),
        Text = title,
        TextColor3 = COLORS.TEXT,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)

    New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(52,27),
        Size = UDim2.new(1,-125,0,17),
        Text = desc,
        TextColor3 = COLORS.SUB,
        TextSize = 9,
        Font = Enum.Font.Gotham,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)

    local sw = New("TextButton", {
        Size = UDim2.fromOffset(48,24),
        Position = UDim2.new(1,-60,0.5,-12),
        BackgroundColor3 = COLORS.RED,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
    }, card)
    Round(sw,12)

    local knob = New("Frame", {
        Size = UDim2.fromOffset(18,18),
        Position = UDim2.fromOffset(3,3),
        BackgroundColor3 = COLORS.TEXT,
        BorderSizePixel = 0,
    }, sw)
    Round(knob,9)

    local function refresh()
        local on = false
        pcall(function() on = get() end)
        sw.BackgroundColor3 = on and COLORS.GREEN or COLORS.RED
        knob.Position = on
            and UDim2.new(1,-21,0,3)
            or UDim2.fromOffset(3,3)
    end

    sw.MouseButton1Click:Connect(function()
        local old = false
        pcall(function() old = get() end)
        pcall(function() set(not old) end)
        task.defer(refresh)
    end)

    refresh()
end

local function Action(parent, icon, title, desc, fn)
    local b = New("TextButton", {
        Size = UDim2.new(1,-4,0,50),
        BackgroundColor3 = COLORS.CARD,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
    }, parent)
    Round(b,9)
    Outline(b)

    New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(12,0),
        Size = UDim2.fromOffset(30,50),
        Text = icon,
        TextColor3 = COLORS.TEXT,
        TextSize = 17,
        Font = Enum.Font.GothamBold,
    }, b)

    New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(50,6),
        Size = UDim2.new(1,-60,0,18),
        Text = title,
        TextColor3 = COLORS.TEXT,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, b)

    New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(50,25),
        Size = UDim2.new(1,-60,0,16),
        Text = desc,
        TextColor3 = COLORS.SUB,
        TextSize = 9,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, b)

    b.MouseEnter:Connect(function() b.BackgroundColor3 = COLORS.CARD_HOVER end)
    b.MouseLeave:Connect(function() b.BackgroundColor3 = COLORS.CARD end)
    b.MouseButton1Click:Connect(function() pcall(fn) end)
end

Tab("FARM","🏋 FARM")
Tab("EGG","🥚 EGG")
Tab("PLAYER","👤 PLAYER")
Tab("OTHER","⚙ OTHER")

local FarmPage = Page("FARM")
Toggle(FarmPage,"🏋","Auto Train","Tự động train",
    function() return Config.AutoTrain end,
    function(v)
        Config.AutoTrain=v
        if v then Farm.startAutoTrain() else Farm.stopAutoTrain() end
    end)

Toggle(FarmPage,"💰","Auto Sell","Tự động bán",
    function() return Config.AutoSell end,
    function(v)
        Config.AutoSell=v
        if v then Farm.startAutoSell() else Farm.stopAutoSell() end
    end)

Toggle(FarmPage,"🔄","Auto Rebirth","Tự động rebirth",
    function() return Config.AutoRebirth end,
    function(v)
        Config.AutoRebirth=v
        if v then Farm.startAutoRebirth() else Farm.stopAutoRebirth() end
    end)

Toggle(FarmPage,"🏋","Auto Buy Dumbell","Tự động mua Dumbell",
    function() return Config.AutoBuyDumbell end,
    function(v)
        Config.AutoBuyDumbell=v
        if v then Farm.startAutoBuyDumbell() else Farm.stopAutoBuyDumbell() end
    end)

Toggle(FarmPage,"📦","Auto Upgrade Carry","Tự động nâng Carry",
    function() return Config.AutoUpgradeCarry end,
    function(v)
        Config.AutoUpgradeCarry=v
        if v then Farm.startAutoUpgradeCarry() else Farm.stopAutoUpgradeCarry() end
    end)

Toggle(FarmPage,"⚔","Auto Buy Gear","Tự động mua Gear",
    function() return Config.AutoBuyGear end,
    function(v)
        Config.AutoBuyGear=v
        if v then Farm.startAutoBuyGear() else Farm.stopAutoBuyGear() end
    end)

local EggPage = Page("EGG")
Toggle(EggPage,"🥚","Auto Pull Egg","Tự động Pull Egg",
    function() return Config.AutoPullEgg end,
    function(v)
        Config.AutoPullEgg=v
        if v then Farm.startAutoPullEgg() else Farm.stopAutoPullEgg() end
    end)

Toggle(EggPage,"👁","Egg ESP","Hiển thị Egg ESP",
    function() return Config.EggESP end,
    function(v)
        Config.EggESP=v
        if v then ESP.init(); ESP.setEnabled(true) else ESP.setEnabled(false) end
    end)

Action(EggPage,"🎯","Target Egg","Đổi Egg mục tiêu",
    function()
        local i = table.find(Config.TIERS,Config.TargetEggTier) or 1
        i = (i % #Config.TIERS) + 1
        Config.TargetEggTier = Config.TIERS[i]
    end)

local PlayerPage = Page("PLAYER")
Toggle(PlayerPage,"♻","Auto Revive","Tự động revive",
    function() return Config.AutoRevive end,
    function(v) Config.AutoRevive=v end)

Toggle(PlayerPage,"🚀","Speed Boost","Tăng WalkSpeed / JumpPower",
    function() return Config.SpeedBoost end,
    function(v)
        Config.SpeedBoost=v
        Universal.setSpeed(v)
    end)

Toggle(PlayerPage,"🛡","Anti AFK","Chống AFK kick",
    function() return Config.AntiAFK end,
    function(v)
        Config.AntiAFK=v
        Universal.setAntiAFK(v)
    end)

Toggle(PlayerPage,"👻","Noclip","Đi xuyên vật thể",
    function() return false end,
    function(v) Farm.setNoclip(v) end)

local OtherPage = Page("OTHER")
Toggle(OtherPage,"📱","Low Graphics","Giảm đồ họa",
    function() return Config.LowGraphics end,
    function(v)
        Config.LowGraphics=v
        Universal.setLowGraphics(v)
    end)

Action(OtherPage,"🏠","Teleport Spawn","Về Spawn",
    function() Farm.teleportToSpawn() end)

Action(OtherPage,"👁","Refresh ESP","Làm mới ESP",
    function()
        ESP.destroy()
        if Config.EggESP then
            ESP.init()
            ESP.setEnabled(true)
        end
    end)

-- Open / close
local function SetVisible(v)
    Main.Visible = v
end

Open.MouseButton1Click:Connect(function()
    SetVisible(not Main.Visible)
end)

Close.MouseButton1Click:Connect(function()
    SetVisible(false)
end)

-- Drag on mobile / mouse
do
    local dragging = false
    local startInput
    local startPos

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startInput = input.Position
            startPos = Main.Position
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then return end

        local delta = input.Position - startInput

        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end)
end

Show("FARM")

-- Expose UI
UI.Gui = Gui
UI.Main = Main
UI.Open = function() SetVisible(true) end
UI.Close = function() SetVisible(false) end
UI.Toggle = function() SetVisible(not Main.Visible) end

getgenv().LuxuryXHUB_FireUI = UI

-- Keep GUI after respawn
Runtime.trackConn(LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if Gui and not Gui.Parent then
        Gui.Parent = CoreGui
    end
end))

-- Initial universal states
pcall(function() Universal.setAntiAFK(Config.AntiAFK) end)
pcall(function() Universal.setSpeed(Config.SpeedBoost) end)
pcall(function() Universal.setLowGraphics(Config.LowGraphics) end)

-- Start defaults that are enabled in Config.
pcall(function()
    if Config.AutoRevive then
        -- AutoRevive is handled by the existing Heartbeat logic.
    end
end)

pcall(function()
    if Config.EggESP then
        ESP.init()
        ESP.setEnabled(true)
    end
end)

-- Unload hook
local PreviousUnload = getgenv().LuxuryXHUB_PullAnEgg
    and getgenv().LuxuryXHUB_PullAnEgg.Unload

getgenv().LuxuryXHUB_PullAnEgg = getgenv().LuxuryXHUB_PullAnEgg or {}

getgenv().LuxuryXHUB_PullAnEgg.Unload = function()
    Runtime.Running = false

    pcall(function() Farm.stopAutoTrain() end)
    pcall(function() Farm.stopAutoSell() end)
    pcall(function() Farm.stopAutoRebirth() end)
    pcall(function() Farm.stopAutoBuyDumbell() end)
    pcall(function() Farm.stopAutoUpgradeCarry() end)
    pcall(function() Farm.stopAutoBuyGear() end)
    pcall(function() Farm.stopAutoPullEgg() end)
    pcall(function() Farm.setFloat(false) end)
    pcall(function() Farm.setNoclip(false) end)
    pcall(function() Universal.stopAntiAFK() end)
    pcall(function() Universal.stopSpeed() end)
    pcall(function() ESP.destroy() end)

    for _,c in ipairs(Runtime.Connections) do
        pcall(function() c:Disconnect() end)
    end

    Runtime.Connections = {}

    pcall(function()
        if Gui then Gui:Destroy() end
    end)
end

if PreviousUnload and PreviousUnload ~= getgenv().LuxuryXHUB_PullAnEgg.Unload then
    pcall(PreviousUnload)
end

return UI
