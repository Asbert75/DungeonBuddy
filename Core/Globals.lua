local ADDON_NAME, Q = ...

local function SetThemeTint(frame, color, alpha)
    local r, g, b = unpack(color)
    frame:SetBackdropColor(r, g, b, alpha)
end

function Q:PrettyPrint(message)
    DEFAULT_CHAT_FRAME:AddMessage("|cfff0c25a"..ADDON_NAME..":|r " .. tostring(message))
end

function Q:ColorToHex(color)
    local r = color.r or color[1]
    local g = color.g or color[2]
    local b = color.b or color[3]
    r = math.max(0, math.min(1, r))
    g = math.max(0, math.min(1, g))
    b = math.max(0, math.min(1, b))
    return string.format("|cff%02x%02x%02x", math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5))
end

local function GetPixelsPerUnit(frame)
    frame = frame or UIParent
    local _, screenHeight = GetPhysicalScreenSize()
    local effectiveScale = frame:GetEffectiveScale()
    if not screenHeight or screenHeight <= 0 or not effectiveScale or effectiveScale <= 0 then
        return 1
    end

    -- WoW lays out UI in a virtual coordinate space that is 768 units tall.
    return effectiveScale * screenHeight / 768
end

local function RoundToNearestInteger(value)
    if value >= 0 then
        return math.floor(value + 0.5)
    end
    return math.ceil(value - 0.5)
end

-- Convert between physical screen pixels and frame-local UI units. Supplying
-- the target frame is important for nested frames with a different scale.
function Q:PixelsToUnits(pixels, frame)
    local pixelsPerUnit = GetPixelsPerUnit(frame)
    return RoundToNearestInteger(pixels * pixelsPerUnit) / pixelsPerUnit
end

function Q:UnitsToPixels(units, frame)
    return units * GetPixelsPerUnit(frame)
end

local function EnableRoundLayout(region)
    if not region then return end

    if region.SetRoundLayoutToNearestPixel then
        region:SetRoundLayoutToNearestPixel(true)
    end

    if region.GetRegions then
        for _, childRegion in ipairs({ region:GetRegions() }) do
            EnableRoundLayout(childRegion)
        end
    end

    if region.GetChildren then
        for _, childFrame in ipairs({ region:GetChildren() }) do
            EnableRoundLayout(childFrame)
        end
    end
end

-- Use WoW's native pixel rounding without rewriting relative anchors.
function Q:SnapScreenFrame(frame)
    EnableRoundLayout(frame)
end

-- Compatibility helper: its argument is a physical-pixel amount, as used by
-- the existing addon call sites; the return value is frame-local UI units.
function Q:PixelPerfect(value, frame)
    if value == nil then return 0 end
    return self:PixelsToUnits(value, frame or UIParent)
end

function Q:SetBackdrop(frame, backgroundKey, borderKey, backgroundAlpha, borderAlpha)
    local pixelPerfect = Q:PixelPerfect(1, frame)

    frame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = pixelPerfect,
        insets = { left = pixelPerfect, right = pixelPerfect, top = pixelPerfect, bottom = pixelPerfect },
    })

    local bgR, bgG, bgB, bgA = unpack(Q.Theme.Background[backgroundKey or "Primary"])
    frame:SetBackdropColor(bgR, bgG, bgB, backgroundAlpha or bgA)

    local borderR, borderG, borderB, borderA = unpack(Q.Theme.Border[borderKey or "Default"])
    frame:SetBackdropBorderColor(borderR, borderG, borderB, borderAlpha or borderA)
end

function Q:SetTextColor(frame, textKey, textAlpha)
    local textR, textG, textB, textA = unpack(Q.Theme.Text[textKey or "Primary"])
    frame:SetTextColor(textR, textG, textB, textAlpha or textA)
end

function Q:SetPixelPerfectSize(frame, width, height)
    frame:SetSize(Q:PixelPerfect(width, frame), Q:PixelPerfect(height, frame))
    Q:SnapScreenFrame(frame)
end

function Q:SetPixelPerfectHeight(frame, height)
    frame:SetHeight(Q:PixelPerfect(height, frame))
    Q:SnapScreenFrame(frame)
end

function Q:SetPixelPerfectWidth(frame, width)
    frame:SetWidth(Q:PixelPerfect(width, frame))
    Q:SnapScreenFrame(frame)
end

function Q:SetPixelPerfectPoint(frame, point, relativeTo, relativePoint, x, y)
    frame:SetPoint(point, relativeTo, relativePoint,
        Q:PixelPerfect(x or 0, frame), Q:PixelPerfect(y or 0, frame))
    Q:SnapScreenFrame(frame)
end

--#region UI Creation Functions
function Q:CreateCloseButton(parent, name)
    local button = CreateFrame("Button", name, parent, "BackdropTemplate")
    Q:SetPixelPerfectSize(button, 24, 24)
    Q:SetPixelPerfectPoint(button, "TOPRIGHT", parent, "TOPRIGHT", -4, -4)
    button:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = Q:PixelPerfect(1, button),
        insets = { left = 0, right = 0, top = 0, bottom = 0 },
    })

    local text = Q:CreateText(nil, button, "x", Q.Theme.Font.L, "Accent")
    button.cross = text
    Q:SetPixelPerfectPoint(text, "CENTER", button, "CENTER", 1, 1)

    local function ApplyStyle(isHovered, isPressed)
        local r, g, b = unpack(Q.Theme.Status.Error)
        button:SetBackdropColor(r, g, b, isHovered and Q.Theme.Alpha.ButtonBackgroundHover or Q.Theme.Alpha.ButtonBackground)
        button:SetBackdropBorderColor(r, g, b, isHovered and Q.Theme.Alpha.ButtonBorderHover or Q.Theme.Alpha.ButtonBorder)

        if isPressed then
            button.cross:SetTextColor(unpack(Q.Theme.Text.Secondary))
        elseif isHovered then
            button.cross:SetTextColor(unpack(Q.Theme.Text.Primary))
        else
            button.cross:SetTextColor(r, g, b)
        end
    end

    ApplyStyle(false, false)
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
    local pixelPerfect = Q:PixelPerfect(1, parent)

    local fontString = parent:CreateFontString(frameName, "OVERLAY", "GameFontNormal")
    fontString:SetText(text)

    local textR, textG, textB, textA = unpack(Q.Theme.Text[colorKey or "Primary"])
    fontString:SetTextColor(textR, textG, textB, textAlpha or textA)
    fontString:SetFont("Fonts\\FRIZQT__.TTF", pixelPerfect * fontSize)

    return fontString
end

function Q:CreateTexture(frameName, parent, width, height, atlas)
    local texture = parent:CreateTexture(frameName, "ARTWORK")
    Q:SetPixelPerfectSize(texture, width, height)
    
    if atlas then
        texture:SetAtlas(atlas)
    end

    return texture
end

function Q:CreateIconBorder(parent, icon)
    local border = {}
    local thickness = Q:PixelPerfect(1, icon)
    local edges = {
        { "TOPLEFT", "TOPRIGHT", true },
        { "BOTTOMLEFT", "BOTTOMRIGHT", true },
        { "TOPLEFT", "BOTTOMLEFT", false },
        { "TOPRIGHT", "BOTTOMRIGHT", false },
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
        Q:SnapScreenFrame(edge)
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
  
function Q:CreateBackdropFrame(frameName, parent, width, height, strata, backgroundKey, borderKey, backgroundAlpha, borderAlpha)
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
        edgeSize = Q:PixelPerfect(1, button),
        insets = { left = 0, right = 0, top = 0, bottom = 0 },
    })

    local label = Q:CreateText(nil, button, text, fontSize, "Accent")
    button.label = label
    label:SetJustifyH("CENTER")
    Q:SetPixelPerfectPoint(label, "CENTER", button, "CENTER", 0, 0)

    local function ApplyStyle(isHovered, isPressed)
        local r, g, b = unpack(color)
        button:SetBackdropColor(r, g, b, isHovered and Q.Theme.Alpha.ButtonBackgroundHover or Q.Theme.Alpha.ButtonBackground)
        button:SetBackdropBorderColor(r, g, b, isHovered and Q.Theme.Alpha.ButtonBorderHover or Q.Theme.Alpha.ButtonBorder)

        if isPressed then
            label:SetTextColor(unpack(Q.Theme.Text.Secondary))
        elseif isHovered then
            label:SetTextColor(unpack(Q.Theme.Text.Primary))
        else
            label:SetTextColor(r, g, b)
        end
    end

    ApplyStyle(false, false)

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
        local tooltip = CreateFrame("GameTooltip", "DungeonBuddyTooltip", UIParent, "GameTooltipTemplate, BackdropTemplate")
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
        frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", clampedLeft, clampedTop)
        Q:SnapScreenFrame(frame)
    end
end
