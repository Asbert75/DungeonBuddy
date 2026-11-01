local _, Q = ...

local function HexToColor(hex)
    local r, g, b = hex:match("#?(%x%x)(%x%x)(%x%x)")
    return { tonumber(r, 16) / 255, tonumber(g, 16) / 255, tonumber(b, 16) / 255, 1 }
end

Q.Themes = {}
Q.ThemeOrder = { "Horde", "Alliance", "Silver", "Sun", "Moon", "Midnight" }

Q.Themes.Horde = {
    Brand = HexToColor("#cf615d"),
    Background = {
        Primary   = HexToColor("#100b0b"),
        Secondary = HexToColor("#191717"),
        Tertiary  = HexToColor("#272522"),
    },
    Border = {
        Default = HexToColor("#534c3d"),
        Accent  = HexToColor("#BE8F31"),
    },
    Text = {
        Primary   = HexToColor("#EFE8D3"),
        Secondary = HexToColor("#AAA38F"),
        Accent    = HexToColor("#DDAB41"),
    },
}

Q.Themes.Alliance = {
    Brand = HexToColor("#2a5aa4"),
    Background = {
        Primary   = HexToColor("#0f131a"),
        Secondary = HexToColor("#181c22"),
        Tertiary  = HexToColor("#1f2730"),
    },
    Border = {
        Default = HexToColor("#2e3b4b"),
        Accent  = HexToColor("#4a90d9"),
    },
    Text = {
        Primary   = HexToColor("#e6ebf0"),
        Secondary = HexToColor("#a0aab8"),
        Accent    = HexToColor("#DDAB41"),
    },
}

Q.Themes.Sun = {
    Brand = HexToColor("#FFCF91"),
    Background = {
        Primary   = HexToColor("#12120F"),
        Secondary = HexToColor("#1C1B1A"),
        Tertiary  = HexToColor("#282624"),
    },
    Border = {
        Default = HexToColor("#423F3B"),
        Accent  = HexToColor("#e0a458"),
    },
    Text = {
        Primary   = HexToColor("#ECE6DB"),
        Secondary = HexToColor("#AAA59F"),
        Accent    = HexToColor("#DDAB41"),
    },
}

Q.Themes.Moon = {
    Brand = HexToColor("#5B9BD5"),
    Background = {
        Primary   = HexToColor("#0b0f17"),
        Secondary = HexToColor("#121822"),
        Tertiary  = HexToColor("#1b2331"),
    },
    Border = {
        Default = HexToColor("#2f3b52"),
        Accent  = HexToColor("#4a90d9"),
    },
    Text = {
        Primary   = HexToColor("#e1e8f2"),
        Secondary = HexToColor("#94a3b8"),
        Accent    = HexToColor("#DDAB41"),
    },
}

Q.Themes.Silver = {
    Brand = HexToColor("#B9B9B9"),
    Background = {
        Primary   = HexToColor("#131313"),
        Secondary = HexToColor("#191919"),
        Tertiary  = HexToColor("#2B2B2B"),
    },
    Border = {
        Default = HexToColor("#4D4D4D"),
        Accent  = HexToColor("#BFBFBF"),
    },
    Text = {
        Primary   = HexToColor("#E8EBE3"),
        Secondary = HexToColor("#A6A9A2"),
        Accent    = HexToColor("#DDAB41"),
    },
}

Q.Themes.Midnight = {
    Brand = HexToColor("#b07cf0"),
    Background = {
        Primary   = HexToColor("#120d18"),
        Secondary = HexToColor("#1a1520"),
        Tertiary  = HexToColor("#272030"),
    },
    Border = {
        Default = HexToColor("#473a5c"),
        Accent  = HexToColor("#9a6ad6"),
    },
    Text = {
        Primary   = HexToColor("#ece4f5"),
        Secondary = HexToColor("#a99bbd"),
        Accent    = HexToColor("#DDAB41"),
    },
}

-- Q.Theme is the live theme. The themed color tables are filled in place by Q:ApplyThemePalette so references to them stay valid.
Q.Theme = {
    Brand = {},
    Background = {},
    Border = {},
    Text = {
        Disabled = HexToColor("#828282"),
    },
    Status = {
        Success = HexToColor("#639745"),
        Error   = HexToColor("#C24439"),
        Info    = HexToColor("#4287f5"),
    },
    WaypointColor = HexToColor("#DDAB41"),
    DifficultyColors = {
        Red = { r = 163 / 255, g = 59 / 255, b = 57 / 255 },
        Orange = { r = 196 / 255, g = 120 / 255, b = 43 / 255 },
        Yellow = { r = 255 / 255, g = 239 / 255, b = 0 / 255 },
        Green = { r = 35 / 255, g = 213 / 255, b = 0 / 255 },
        Gray = { r = 146 / 255, g = 146 / 255, b = 146 / 255 },
    },
    Alpha = {
        ButtonBackground = 0.15,
        ButtonBackgroundHover = 0.45,
        ButtonBorder = 0.75,
        ButtonBorderHover = 1,
        Hover = 0.1,
        Pressed = 0.2,
    },
    Padding = {
        S  = 9,
        M  = 18,
        L  = 27,
        XL = 36,
    },
    FontSize = {
        XS   = 8,
        S    = 10,
        M    = 12,
        L    = 14,
        XL   = 16,
        XXL  = 18,
        XXXL = 20,
    },
    -- Defaults
    QuestColorUnavailable = { r = 163 / 255, g = 59 / 255, b = 57 / 255 },
    QuestColorAvailable = { r = 35 / 255, g = 213 / 255, b = 0 / 255 },
    QuestColorInProgress = { r = 255 / 255, g = 239 / 255, b = 0 / 255 },
    QuestColorCompleted = { r = 146 / 255, g = 146 / 255, b = 146 / 255 },
}

local COLOR_GROUPS = { "Background", "Border", "Text" }

local function CopyColor(target, key, color)
    local out = target[key] or {}
    out[1], out[2], out[3], out[4] = color[1], color[2], color[3], color[4] or 1
    target[key] = out
end

function Q:ApplyThemePalette(name)
    local palette = Q.Themes[name] or Q.Themes.Sun
    local default = Q.Themes.Sun
    local brand = palette.Brand or default.Brand

    CopyColor(Q.Theme, "Brand", brand)
    for _, group in ipairs(COLOR_GROUPS) do
        local target = Q.Theme[group]
        for key, color in pairs(default[group]) do
            local source = (palette[group] and palette[group][key]) or color
            CopyColor(target, key, source)
        end
    end
    CopyColor(Q.Theme.Border, "Brand", brand)
    CopyColor(Q.Theme.Text, "Brand", brand)
end

Q:ApplyThemePalette("Sun")
