local ADDON_NAME, Q = ...

local function SetThemeTint(frame, color, alpha)
    local r, g, b = unpack(color)
    frame:SetBackdropColor(r, g, b, alpha)
end

function Q:TruncateText(text, maxLength)
    if #text > maxLength then
        return text:sub(1, maxLength) .. "..."
    end
    return text
end

function Q:PrettyPrint(message)
    DEFAULT_CHAT_FRAME:AddMessage("|cfff0c25a"..ADDON_NAME..":|r " .. tostring(message))
end

function Q:PixelPerfect(value)
    if not value then return 0 end
    local _, screenHeight = GetPhysicalScreenSize()
    local uiScale = UIParent:GetEffectiveScale()
    local pixelSize = 768 / screenHeight / uiScale
    return pixelSize * math.floor((value / pixelSize) + 0.5333)
end

function Q:SetBackdrop(frame, backgroundKey, borderKey, backgroundAlpha, borderAlpha)
    local pixelPerfect = Q:PixelPerfect(1)

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

function Q:AddHighlight(frame, r, g, b, a)
    local highlight = frame:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetAllPoints()
    local primaryR, primaryG, primaryB = unpack(Q.Theme.Text.Primary)
    highlight:SetColorTexture(r or primaryR, g or primaryG, b or primaryB, a or Q.Theme.Alpha.Highlight)
    frame:SetHighlightTexture(highlight, "ADD")
end

function Q:SetPixelPerfectSize(frame, width, height)
    local pixelPerfect = Q:PixelPerfect(1)
    frame:SetSize(pixelPerfect * width, pixelPerfect * height)
end

function Q:SetPixelPerfectHeight(frame, height)
    local pixelPerfect = Q:PixelPerfect(1)
    frame:SetHeight(pixelPerfect * height)
end

function Q:SetPixelPerfectWidth(frame, width)
    local pixelPerfect = Q:PixelPerfect(1)
    frame:SetWidth(pixelPerfect * width)
end

function Q:SetPixelPerfectPoint(frame, point, relativeTo, relativePoint, x, y)
    local pixelPerfect = Q:PixelPerfect(1)
    frame:SetPoint(point, relativeTo, relativePoint, pixelPerfect * x, pixelPerfect * y)
end

--#region UI Creation Functions
function Q:CreateCloseButton(parent)
    local button = CreateFrame("Button", nil, parent, "BackdropTemplate")
    Q:SetPixelPerfectSize(button, 24, 24)
    Q:SetPixelPerfectPoint(button, "TOPRIGHT", parent, "TOPRIGHT", -4, -4)
    button:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = Q:PixelPerfect(1),
        insets = { left = 0, right = 0, top = 0, bottom = 0 },
    })

    local text = Q:CreateText(nil, button, "×", Q.Theme.Font.L, "Accent")
    button.cross = text
    Q:SetPixelPerfectPoint(text, "CENTER", button, "CENTER", 0, 1)

    local function ApplyStyle(isHovered, isPressed)
        local r, g, b = unpack(Q.Theme.Background.Tertiary)
        button:SetBackdropColor(r, g, b, 1)

        local borderColor = isHovered and Q.Theme.Border.Accent or Q.Theme.Border.Default
        button:SetBackdropBorderColor(unpack(borderColor))

        if isPressed then
            text:SetTextColor(unpack(Q.Theme.Text.Secondary))
        elseif isHovered then
            text:SetTextColor(unpack(Q.Theme.Text.Primary))
        else
            text:SetTextColor(unpack(Q.Theme.Text.Accent))
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
    local pixelPerfect = Q:PixelPerfect(1)

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

function Q:CreateButton(frameName, parent, text, width, height, fontSize, handlers)
    handlers = handlers or {}

    local button = CreateFrame("Button", frameName, parent, "BackdropTemplate")
    Q:SetPixelPerfectSize(button, width, height)
    button:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = Q:PixelPerfect(1),
        insets = { left = 0, right = 0, top = 0, bottom = 0 },
    })

    local label = Q:CreateText(nil, button, text, fontSize, "Accent")
    button.label = label
    label:SetJustifyH("CENTER")
    Q:SetPixelPerfectPoint(label, "CENTER", button, "CENTER", 1, 0)

    local function ApplyStyle(isHovered, isPressed)
        local r, g, b = unpack(Q.Theme.Background.Tertiary)
        button:SetBackdropColor(r, g, b, 1)

        local borderColor = isHovered and Q.Theme.Border.Accent or Q.Theme.Border.Default
        button:SetBackdropBorderColor(unpack(borderColor))

        if isPressed then
            label:SetTextColor(unpack(Q.Theme.Text.Secondary))
        elseif isHovered then
            label:SetTextColor(unpack(Q.Theme.Text.Primary))
        else
            label:SetTextColor(unpack(Q.Theme.Text.Accent))
        end
    end

    ApplyStyle(false, false)
    button:SetScript("OnEnter", function(self)
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
        ApplyStyle(true, true)
        if handlers.OnMouseDown then
            handlers.OnMouseDown(self)
        end
    end)
    button:SetScript("OnMouseUp", function(self)
        ApplyStyle(self:IsMouseOver(), false)
        if handlers.OnMouseUp then
            handlers.OnMouseUp(self)
        end
    end)
    button:SetScript("OnClick", function(self)
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
