local ADDON_NAME, Q = ...

local function SetThemeTint(frame, color, alpha)
    local r, g, b = unpack(color)
    frame:SetBackdropColor(r, g, b, alpha)
end

function Q:PrettyPrint(message)
    DEFAULT_CHAT_FRAME:AddMessage("|cfff0c25a" .. ADDON_NAME .. ":|r " .. tostring(message))
end

function Q:ColorToHex(color)
    local r = color.r or color[1]
    local g = color.g or color[2]
    local b = color.b or color[3]
    r = math.max(0, math.min(1, r))
    g = math.max(0, math.min(1, g))
    b = math.max(0, math.min(1, b))
    return string.format("|cff%02x%02x%02x", math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5),
        math.floor(b * 255 + 0.5))
end

function Q:HexToColor(hex)
    local r, g, b = hex:match("#?(%x%x)(%x%x)(%x%x)")
    return { tonumber(r, 16) / 255, tonumber(g, 16) / 255, tonumber(b, 16) / 255, 1 }
end

function Q:PixelPerfect(value)
    if not value then return 0 end
    local _, screenHeight = GetPhysicalScreenSize()
    local uiScale = UIParent:GetEffectiveScale()
    local pixelSize = 768 / screenHeight / uiScale
    return pixelSize * math.floor((value / pixelSize) + 0.5333)
end

local themedObjects = setmetatable({}, { __mode = "k" })

-- Registers an object whose colors depend on the theme; apply(object) is called whenever the theme changes.
function Q:RegisterThemed(object, apply)
    themedObjects[object] = apply
end

-- Characters without a saved theme get the theme matching their faction.
function Q:LoadTheme()
    local theme = Q:GetSetting("Theme")
    if theme == "DungeonBuddy" then
        theme = "Sunrise"
    end
    if not Q.Themes[theme] then
        local faction = UnitFactionGroup("player")
        theme = Q.Themes[faction] and faction or "Sunrise"
    end

    Q:SetSetting("Theme", theme)
    Q:ApplyThemePalette(theme)
end

local function RefreshThemedObjects()
    for object, apply in pairs(themedObjects) do
        apply(object)
    end

    if Q.QuestLog and Q.QuestLog.frame then
        Q.QuestLog:RefreshAndPopulate()
    end
    if Q.Notification then
        Q.Notification:RefreshTheme()
    end
end

function Q:SetTheme(name)
    if not Q.Themes[name] then
        name = "Sunrise"
    end

    Q:SetSetting("Theme", name)
    Q:ApplyThemePalette(name)
    RefreshThemedObjects()
end

function Q:SetBackdrop(frame, backgroundKey, borderKey, backgroundAlpha, borderAlpha)
    local pixelPerfect = Q:PixelPerfect(1)

    frame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = pixelPerfect,
        insets = { left = pixelPerfect, right = pixelPerfect, top = pixelPerfect, bottom = pixelPerfect },
    })

    local function ApplyColors()
        local bgR, bgG, bgB, bgA = unpack(Q.Theme.Background[backgroundKey or "Primary"])
        frame:SetBackdropColor(bgR, bgG, bgB, backgroundAlpha or bgA)

        local borderR, borderG, borderB, borderA = unpack(Q.Theme.Border[borderKey or "Default"])
        frame:SetBackdropBorderColor(borderR, borderG, borderB, borderAlpha or borderA)
    end

    ApplyColors()
    Q:RegisterThemed(frame, ApplyColors)
end

function Q:SetTextColor(frame, textKey, textAlpha)
    local function ApplyColor()
        local textR, textG, textB, textA = unpack(Q.Theme.Text[textKey or "Primary"])
        frame:SetTextColor(textR, textG, textB, textAlpha or textA)
    end

    ApplyColor()
    Q:RegisterThemed(frame, ApplyColor)
end

function Q:SetThemedColorTexture(texture, group, key, alpha)
    local function ApplyColor()
        local color = Q.Theme[group][key]
        texture:SetColorTexture(color[1], color[2], color[3], alpha or color[4] or 1)
    end

    ApplyColor()
    Q:RegisterThemed(texture, ApplyColor)
end

function Q.ApplyBrandTitle(fontString)
    fontString:SetText("DUNGEON" .. Q:ColorToHex(Q.Theme.Text.Primary) .. "BUDDY")
    fontString:SetTextColor(unpack(Q.Theme.Text.Brand))
end

function Q:SetPixelPerfectSize(frame, width, height)
    frame:SetSize(Q:PixelPerfect(width), Q:PixelPerfect(height))
end

function Q:SetPixelPerfectHeight(frame, height)
    frame:SetHeight(Q:PixelPerfect(height))
end

function Q:SetPixelPerfectWidth(frame, width)
    frame:SetWidth(Q:PixelPerfect(width))
end

function Q:SetPixelPerfectPoint(frame, point, relativeTo, relativePoint, x, y)
    frame:SetPoint(point, relativeTo, relativePoint, Q:PixelPerfect(x), Q:PixelPerfect(y))
end

-- Places a frame by its center offset from the screen center, but anchors its bottom-left corner on a whole pixel.
function Q:SetPixelPerfectCenterPoint(frame, x, y)
    local left = UIParent:GetWidth() / 2 + x - frame:GetWidth() / 2
    local bottom = UIParent:GetHeight() / 2 + y - frame:GetHeight() / 2
    frame:ClearAllPoints()
    frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", Q:PixelPerfect(left), Q:PixelPerfect(bottom))
end

--#region UI Creation Functions
-- Creates a font string without registering it for theme changes, for text whose color is managed by its owner.
local function BuildText(frameName, parent, text, fontSize, colorKey, textAlpha)
    local fontString = parent:CreateFontString(frameName, "OVERLAY", "GameFontNormal")
    fontString:SetText(text)

    local textR, textG, textB, textA = unpack(Q.Theme.Text[colorKey or "Primary"])
    fontString:SetTextColor(textR, textG, textB, textAlpha or textA)
    fontString:SetFont("Fonts\\FRIZQT__.TTF", Q:PixelPerfect(fontSize))

    return fontString
end

function Q:CreateCloseButton(parent, name)
    local button = CreateFrame("Button", name, parent, "BackdropTemplate")
    Q:SetPixelPerfectSize(button, 24, 24)
    Q:SetPixelPerfectPoint(button, "TOPRIGHT", parent, "TOPRIGHT", -4, -4)
    button:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = Q:PixelPerfect(1),
        insets = { left = 0, right = 0, top = 0, bottom = 0 },
    })

    local text = BuildText(nil, button, "x", Q.Theme.FontSize.L, "Accent")
    button.cross = text
    Q:SetPixelPerfectPoint(text, "CENTER", button, "CENTER", 1, 1)

    local function ApplyStyle(isHovered, isPressed)
        local r, g, b = unpack(Q.Theme.Status.Error)
        button:SetBackdropColor(r, g, b,
            isHovered and Q.Theme.Alpha.ButtonBackgroundHover or Q.Theme.Alpha.ButtonBackground)
        button:SetBackdropBorderColor(r, g, b,
            isHovered and Q.Theme.Alpha.ButtonBorderHover or Q.Theme.Alpha.ButtonBorder)

        if isPressed then
            button.cross:SetTextColor(unpack(Q.Theme.Text.Secondary))
        elseif isHovered then
            button.cross:SetTextColor(unpack(Q.Theme.Text.Primary))
        else
            button.cross:SetTextColor(r, g, b)
        end
    end

    ApplyStyle(false, false)
    Q:RegisterThemed(button, function()
        ApplyStyle(button:IsMouseOver(), false)
    end)
    button:SetScript("OnEnter", function()
        ApplyStyle(true, false)
    end)
    button:SetScript("OnLeave", function()
        ApplyStyle(false, false)
    end)
    button:SetScript("OnMouseDown", function()
        ApplyStyle(true, true)
    end)
    button:SetScript("OnMouseUp", function(self)
        ApplyStyle(self:IsMouseOver(), false)
    end)

    button:SetScript("OnClick", function()
        parent:Hide()
    end)

    return button
end

function Q:CreateText(frameName, parent, text, fontSize, colorKey, textAlpha)
    local fontString = BuildText(frameName, parent, text, fontSize, colorKey, textAlpha)

    Q:RegisterThemed(fontString, function()
        local textR, textG, textB, textA = unpack(Q.Theme.Text[colorKey or "Primary"])
        fontString:SetTextColor(textR, textG, textB, textAlpha or textA)
    end)

    return fontString
end

function Q:CreateTexture(frameName, parent, width, height, path)
    path = path or {}
    local texture = parent:CreateTexture(frameName, "ARTWORK")
    Q:SetPixelPerfectSize(texture, width, height)

    if path.atlas then
        texture:SetAtlas(path.atlas)
    end
    if path.texture then
        texture:SetTexture(path.texture)
    end

    return texture
end

function Q:CreateIconBorder(parent, icon)
    local border = {}
    local thickness = Q:PixelPerfect(1)
    local edges = {
        { "TOPLEFT",    "TOPRIGHT",    true },
        { "BOTTOMLEFT", "BOTTOMRIGHT", true },
        { "TOPLEFT",    "BOTTOMLEFT",  false },
        { "TOPRIGHT",   "BOTTOMRIGHT", false },
    }

    for index, points in ipairs(edges) do
        local edge = parent:CreateTexture(nil, "OVERLAY")
        edge:SetColorTexture(1, 1, 1, 1)
        edge:SetPoint(points[1], icon, points[1], 0, 0)
        edge:SetPoint(points[2], icon, points[2], 0, 0)
        if points[3] then
            edge:SetHeight(thickness)
        else
            edge:SetWidth(thickness)
        end
        edge:Hide()
        border[index] = edge
    end

    return border
end

function Q:SetIconBorderColor(border, color)
    for _, edge in ipairs(border) do
        edge:SetColorTexture(color[1], color[2], color[3], color[4] or 1)
    end
end

function Q:SetIconBorderShown(border, shown)
    for _, edge in ipairs(border) do
        edge:SetShown(shown)
    end
end

function Q:CreateBackdropFrame(frameName, parent, width, height, strata, backgroundKey, borderKey, backgroundAlpha,
                               borderAlpha)
    local frame = CreateFrame("Frame", frameName, parent, "BackdropTemplate")
    Q:SetPixelPerfectSize(frame, width, height)
    frame:SetFrameStrata(strata or "MEDIUM")
    Q:SetBackdrop(frame, backgroundKey, borderKey, backgroundAlpha, borderAlpha)

    return frame
end

function Q:CreateFrame(frameName, parent, width, height, strata)
    local frame = CreateFrame("Frame", frameName, parent)
    Q:SetPixelPerfectSize(frame, width, height)
    frame:SetFrameStrata(strata or "MEDIUM")

    return frame
end

function Q:CreateButton(frameName, parent, text, width, height, fontSize, color, handlers)
    handlers = handlers or {}

    local button = CreateFrame("Button", frameName, parent, "BackdropTemplate")
    Q:SetPixelPerfectSize(button, width, height)
    button:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = Q:PixelPerfect(1),
        insets = { left = 0, right = 0, top = 0, bottom = 0 },
    })

    local label = BuildText(nil, button, text, fontSize, "Accent")
    button.label = label
    label:SetJustifyH("CENTER")
    Q:SetPixelPerfectPoint(label, "CENTER", button, "CENTER", 0, 0)

    local function ApplyStyle(isHovered, isPressed)
        local r, g, b = unpack(color)
        button:SetBackdropColor(r, g, b,
            isHovered and Q.Theme.Alpha.ButtonBackgroundHover or Q.Theme.Alpha.ButtonBackground)
        button:SetBackdropBorderColor(r, g, b,
            isHovered and Q.Theme.Alpha.ButtonBorderHover or Q.Theme.Alpha.ButtonBorder)

        if isPressed then
            label:SetTextColor(unpack(Q.Theme.Text.Secondary))
        elseif isHovered then
            label:SetTextColor(unpack(Q.Theme.Text.Primary))
        else
            label:SetTextColor(r, g, b)
        end
    end

    ApplyStyle(false, false)
    Q:RegisterThemed(button, function()
        ApplyStyle(button:IsMouseOver(), false)
    end)

    function button:SetColor(newColor)
        color = newColor
        ApplyStyle(self:IsMouseOver(), false)
    end

    button:SetScript("OnEnter", function(self)
        if self.isDisabled then
            return
        end

        ApplyStyle(true, false)
        if handlers.OnMouseEnter then
            handlers.OnMouseEnter(self)
        end
    end)
    button:SetScript("OnLeave", function(self)
        ApplyStyle(false, false)
        if handlers.OnMouseLeave then
            handlers.OnMouseLeave(self)
        end
    end)
    button:SetScript("OnMouseDown", function(self)
        if self.isDisabled then
            return
        end

        ApplyStyle(true, true)
        if handlers.OnMouseDown then
            handlers.OnMouseDown(self)
        end
    end)
    button:SetScript("OnMouseUp", function(self)
        if self.isDisabled then
            return
        end

        ApplyStyle(self:IsMouseOver(), false)
        if handlers.OnMouseUp then
            handlers.OnMouseUp(self)
        end
    end)
    button:SetScript("OnClick", function(self)
        if self.isDisabled then
            return
        end

        if handlers.OnClick then
            handlers.OnClick(self)
        end
    end)

    return button
end

function Q:CreateCheckbox(frameName, parent, width, height, strata, backgroundKey, borderKey, onChange)
    local checkbox = CreateFrame("CheckButton", frameName, parent, "BackdropTemplate")
    Q:SetPixelPerfectSize(checkbox, width, height)
    checkbox:SetFrameStrata(strata or "MEDIUM")
    Q:SetBackdrop(checkbox, backgroundKey, borderKey)
    checkbox:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")

    checkbox:SetScript("OnClick", function(self)
        if onChange then
            onChange(self, self:GetChecked())
        end
    end)

    checkbox:SetScript("OnEnter", function(self)
        SetThemeTint(self, Q.Theme.Text.Primary, Q.Theme.Alpha.Hover)
    end)
    checkbox:SetScript("OnLeave", function(self)
        Q:SetBackdrop(self, backgroundKey, borderKey)
    end)
    checkbox:SetScript("OnMouseDown", function(self)
        SetThemeTint(self, Q.Theme.Text.Primary, Q.Theme.Alpha.Pressed)
    end)
    checkbox:SetScript("OnMouseUp", function(self)
        if self:IsMouseOver() then
            SetThemeTint(self, Q.Theme.Text.Primary, Q.Theme.Alpha.Hover)
        else
            Q:SetBackdrop(self, backgroundKey, borderKey)
        end
    end)

    return checkbox
end

--#endregion

function Q:GetTooltip()
    if not self.Tooltip then
        local tooltip = CreateFrame("GameTooltip", "DungeonBuddyTooltip", UIParent,
            "GameTooltipTemplate, BackdropTemplate")
        Q:SetBackdrop(tooltip, "Primary", "Default", 0.9, 0.25)
        if tooltip.NineSlice then tooltip.NineSlice:SetAlpha(0) end
        self.Tooltip = tooltip
    end
    return self.Tooltip
end

--#region Animations
function Q:AddFadeInAnimation(frame, duration, callback)
    local fadeIn = frame:CreateAnimationGroup()
    local alpha = fadeIn:CreateAnimation("Alpha")
    alpha:SetDuration(duration or 0.5)
    alpha:SetFromAlpha(0)
    alpha:SetToAlpha(1)
    fadeIn:SetScript("OnFinished", function()
        frame:SetAlpha(1)
        if callback then
            callback()
        end
    end)
    return fadeIn
end

function Q:AddFadeOutAnimation(frame, duration, callback)
    local fadeOut = frame:CreateAnimationGroup()
    local alpha = fadeOut:CreateAnimation("Alpha")
    alpha:SetDuration(duration or 0.5)
    alpha:SetFromAlpha(1)
    alpha:SetToAlpha(0)
    fadeOut:SetScript("OnFinished", function()
        frame:SetAlpha(0)
        frame:Hide()
        if callback then
            callback()
        end
    end)
    return fadeOut
end

--#endregion

function Q:ClampFrameToScreen(frame)
    local width, height = frame:GetSize()
    local screenWidth, screenHeight = GetScreenWidth(), GetScreenHeight()
    local minVisibleW = width * 0.10
    local minVisibleH = height * 0.10

    local left = frame:GetLeft()
    local right = frame:GetRight()
    local top = frame:GetTop()
    local bottom = frame:GetBottom()

    if not left or not right or not top or not bottom then
        return
    end

    local needsClamp = false
    local clampedLeft, clampedTop = left, top

    if right < minVisibleW then
        clampedLeft = minVisibleW - width
        needsClamp = true
    elseif left > screenWidth - minVisibleW then
        clampedLeft = screenWidth - minVisibleW
        needsClamp = true
    end

    if top < minVisibleH then
        clampedTop = minVisibleH
        needsClamp = true
    elseif bottom > screenHeight - minVisibleH then
        clampedTop = screenHeight - minVisibleH + height
        needsClamp = true
    end

    if needsClamp then
        frame:ClearAllPoints()
        Q:SetPixelPerfectPoint(frame, "TOPLEFT", UIParent, "BOTTOMLEFT", clampedLeft, clampedTop)
    end
end
