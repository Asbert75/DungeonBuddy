local _, Q = ...
local Settings = Q.Addon:NewModule("Settings")
Q.Settings = Settings
Settings.settings = {}
local AceGUI = LibStub("AceGUI-3.0")

local PANEL_WIDTH = 1000
local CONTENT_WIDTH = PANEL_WIDTH - (2 * Q.Theme.Padding.M)
local Sections = {
    General = { name = "General", title = "General" },
    Notifications = { name = "Notifications", title = "Notifications" },
    QuestLog = { name = "QuestLog", title = "Quest Tracker" },
}

local function GetSectionSettings(sectionName)
        local allSettings = {
        {
            section = Sections.General.name,
            type = "checkbox",
            path = "MinimapButton.Hide",
            title = "Hide minimap button",
            description = "Hide the minimap button. Can also be toggled using /db minimap.",
            onChange = function(value)
                Q.MinimapButton:Toggle()
            end,
        },
        {
            section = Sections.Notifications.name,
            type = "checkbox",
            path = "ShowNotificationOnLevelUp",
            title = "Notifications on level up",
            description = "Show a notification on level up when the first quest of a chain leading to a dungeon quest is available.",
            onChange = function()
                Q.Notification:UpdateLevelUpRegistration()
            end,
        },
        {
            section = Sections.Notifications.name,
            type = "checkbox",
            path = "ShowNotificationForAllQuests",
            title = "Notifications for all quests",
            description = "Enable notifications for all dungeon quests, not just the first quest in a chain."
        },
        {
            section = Sections.Notifications.name,
            type = "checkbox",
            path = "AutoWaypoint",
            title = "Automatic quest giver waypoints",
            description = "Automatically adds a waypoint to the quest giver when a quest notification appears.",
        },
        {
            section = Sections.Notifications.name,
            type = "checkbox",
            path = "RemindOnZoneChange",
            title = "Reminders when switching to a new zone",
            description = "Show a notification when switching to a new zone if there are relevant quests available (not just chain starters).",
            onChange = function()
                Q.AutoReminder:UpdateRegistration()
            end,
        },
        {
            section = Sections.QuestLog.name,
            type = "checkbox",
            path = "HideCompletedQuests",
            title = "Hide completed quests",
            description = "Remove completed quests from the dungeon buddy tracker.",
            onChange = function()
                if Q.QuestLog and Q.QuestLog.frame then
                    Q.QuestLog:RefreshAndPopulate()
                end
            end,
        },
        {
            section = Sections.QuestLog.name,
            type = "checkbox",
            path = "ShowAllQuestsForAvailableDungeon",
            title = "Instantly show all dungeon quests when one is available",
            description = "Enable showing all quests for a dungeon as soon as you have a single quest available in that dungeon. Also adds a required level display row to quests you are not high enough level for.",
            onChange = function()
                if Q.QuestLog and Q.QuestLog.frame then
                    Q.QuestLog:RefreshAndPopulate()
                end
            end,
        },
        {
            section = Sections.General.name,
            type = "checkbox",
            path = "ShowSuggestedQuestLevel",
            title = "Suggested quest levels",
            description = "Display the suggested quest level for each quest in notifications/tracker.",
            onChange = function()
                if Q.QuestLog and Q.QuestLog.frame then
                    Q.QuestLog:RefreshAndPopulate()
                end
            end,
        }
    }

    local sectionSettings = {}
    for _, setting in ipairs(allSettings) do
        if setting.section == sectionName then
            table.insert(sectionSettings, setting)
        end
    end
    return sectionSettings
end

local SETTING_ROW_HEIGHT = 55
local CHECKBOX_SIZE = 29

-- Rows grow taller when the description wraps onto extra lines.
local function GetDescriptionLayout(settings, rowWidth)
    local textWidth = rowWidth - (Q.Theme.Padding.L * 5) - CHECKBOX_SIZE
    local unit = Q:PixelPerfect(1)

    local measure = Q:CreateText(nil, UIParent, "", Q.Theme.Font.S, "Primary")
    measure:SetWordWrap(true)
    measure:SetWidth(textWidth * unit)

    measure:SetText("X")
    local lineHeight = measure:GetStringHeight() / unit

    local heights = {}
    for index, setting in ipairs(settings) do
        measure:SetText(setting.description or "")
        local textHeight = measure:GetStringHeight() / unit
        heights[index] = SETTING_ROW_HEIGHT + math.max(0, math.ceil(textHeight - lineHeight))
    end

    measure:Hide()
    return textWidth, heights
end

function Settings:CreateSection(sectionName, sectionTitle, anchorFrame)
    local paddingM, paddingS = Q.Theme.Padding.M, Q.Theme.Padding.S
    local fontL = Q.Theme.Font.L

    local sectionSettings = GetSectionSettings(sectionName)
    local textWidth, rowHeights = GetDescriptionLayout(sectionSettings, CONTENT_WIDTH - (2 * paddingM))

    local sectionHeight = fontL + (paddingM * 2)
    for index in ipairs(sectionSettings) do
        sectionHeight = sectionHeight + paddingM + rowHeights[index]
    end
    local sectionFrame = Q:CreateBackdropFrame("DungeonBuddy_"..sectionName.."SettingsFrame", anchorFrame == self.scrollChild and anchorFrame or anchorFrame:GetParent(), CONTENT_WIDTH, sectionHeight, "HIGH", "Primary", "Accent", 0, 0)
    local anchorPoint = anchorFrame == self.scrollChild and "TOPLEFT" or "BOTTOMLEFT"
    Q:SetPixelPerfectPoint(sectionFrame, "TOPLEFT", anchorFrame, anchorPoint, 0, 0)

    local sectionTitle = Q:CreateText(sectionName.."SettingsTitle", sectionFrame, sectionTitle, fontL, "Accent", 1)
    Q:SetPixelPerfectPoint(sectionTitle, "TOPLEFT", sectionFrame, "TOPLEFT", paddingM, -paddingM)

    local y = 0
    for index, setting in ipairs(sectionSettings) do
        y = y + paddingM
        local rowHeight = rowHeights[index]

        local row = Q:CreateBackdropFrame("Setting_"..setting.path, sectionFrame, CONTENT_WIDTH - (2 * paddingM), rowHeight, "HIGH", "Secondary", "Default", 0.6, 0.6)
        Q:SetPixelPerfectPoint(row, "TOPLEFT", sectionFrame, "TOPLEFT", paddingM, -(paddingM + fontL + y))
        y = y + rowHeight

        row.gradient = row:CreateTexture(nil, "BACKGROUND", nil, 1)
        row.gradient:SetAllPoints(row)
        row.gradient:SetColorTexture(1, 1, 1, 1)
        local bottomR, bottomG, bottomB = unpack(Q.Theme.Background.Tertiary)
        row.gradient:SetGradient("VERTICAL", CreateColor(bottomR, bottomG, bottomB, 0.25), CreateColor(0, 0, 0, 0))

        local label = Q:CreateText(nil, row, setting.title, Q.Theme.Font.M, "Accent")
        Q:SetPixelPerfectPoint(label, "TOPLEFT", row, "TOPLEFT", paddingS, -13)
        local description = Q:CreateText(nil, row, setting.description, Q.Theme.Font.S, "Primary")
        Q:SetPixelPerfectPoint(description, "TOPLEFT", label, "BOTTOMLEFT", 0, -4)
        Q:SetPixelPerfectWidth(description, textWidth)
        description:SetJustifyH("LEFT")
        description:SetWordWrap(true)

        local checkbox = Q:CreateCheckbox(nil, row, 29, 29, nil, "Tertiary", "Default", function(self, checked)
            Q:SetSetting(setting.path, checked and true or false)
            if setting.onChange then
                setting.onChange(checked and true or false)
            end
        end)
        checkbox:SetFrameStrata("TOOLTIP")
        Q:SetPixelPerfectPoint(checkbox, "TOPRIGHT", row, "TOPRIGHT", -paddingS, -(math.floor((rowHeight - CHECKBOX_SIZE) / 2) + 1))
        checkbox:SetChecked(Q:GetSetting(setting.path) and true or false)
        self.settings[setting.path] = checkbox
    end

    return sectionFrame
end

function Settings:Create()
    if self.frame then
        return self.frame
    end

    local paddingS, paddingM = Q.Theme.Padding.S, Q.Theme.Padding.M
    local frame = Q:CreateBackdropFrame("DungeonBuddy_SettingsFrame", UIParent, PANEL_WIDTH, 700, "TOOLTIP", "Primary", "Default", 0.9, 0.25)
    self.frame = frame
    Q:SetPixelPerfectPoint(frame, "CENTER", UIParent, "CENTER", 0, 0)
    
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        Q:ClampFrameToScreen(self)
    end)

    Q:CreateCloseButton(frame)

    local title = Q:CreateText("SettingsTitle", frame, "Dungeon Buddy Settings", Q.Theme.Font.XL, "Accent", 1)
    Q:SetPixelPerfectPoint(title, "TOPLEFT", frame, "TOPLEFT", paddingM, -paddingM)

    local contentContainer = CreateFrame("ScrollFrame", "DungeonBuddy_SettingsScrollFrame", frame, "UIPanelScrollFrameTemplate")
    self.contentContainer = contentContainer
    Q:SetPixelPerfectPoint(contentContainer, "TOPLEFT", frame, "TOPLEFT", paddingM, -(paddingM + Q.Theme.Font.XL + Q.Theme.Padding.S))
    Q:SetPixelPerfectPoint(contentContainer, "BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 2)
    contentContainer:EnableMouseWheel(true)

    local scrollChild = CreateFrame("Frame", "DungeonBuddy_SettingsScrollChild", contentContainer)
    Q:SetPixelPerfectSize(scrollChild, CONTENT_WIDTH, 1)
    contentContainer:SetScrollChild(scrollChild)
    contentContainer:SetScript("OnSizeChanged", function(self, width)
        -- OnSizeChanged already provides the width in UI-scaled units; don't scale it again.
        scrollChild:SetWidth(width)
    end)
    self.scrollChild = scrollChild

    local scrollBar = _G[contentContainer:GetName() .. "ScrollBar"]
    if scrollBar then
        scrollBar:ClearAllPoints()
        scrollBar:SetValueStep(Q:PixelPerfect(10))
        scrollBar:SetObeyStepOnDrag(true)
        Q:SetPixelPerfectPoint(scrollBar, "TOPRIGHT", contentContainer, "TOPRIGHT", -1, -20)
        Q:SetPixelPerfectPoint(scrollBar, "BOTTOMRIGHT", contentContainer, "BOTTOMRIGHT", -1, 20)

        for _, arrow in ipairs({
            { suffix = "ScrollUpButton" },
            { suffix = "ScrollDownButton" },
        }) do
            local button = _G[scrollBar:GetName() .. arrow.suffix]
            button:HookScript("OnShow", function(self)
                self:Hide()
            end)
            if button then
                button:Hide()
            end
        end

        local track = scrollBar:CreateTexture(nil, "BACKGROUND")
        track:SetAllPoints()
        track:SetColorTexture(unpack(Q.Theme.Background.Tertiary))

        local thumb = scrollBar:GetThumbTexture()
        for _, region in ipairs({ scrollBar:GetRegions() }) do
            if region ~= thumb and region:GetObjectType() == "Texture" then
                region:SetTexture(nil)
                region:Hide()
            end
        end
        if thumb then
            thumb:SetTexture(nil)
            thumb:SetColorTexture(unpack(Q.Theme.Border.Default))
            Q:SetPixelPerfectWidth(thumb, 4)
        end
    end

    -- Scroll offsets must be whole physical pixels, otherwise child borders render at differing thicknesses.
    local function SnapScroll(offset)
        local unit = Q:PixelPerfect(1)
        return math.floor(offset / unit + 0.0001) * unit
    end

    contentContainer:HookScript("OnVerticalScroll", function(self, offset)
        local snapped = SnapScroll(offset)
        if math.abs(snapped - offset) > 0.00001 then
            self:SetVerticalScroll(snapped)
        end
    end)

    contentContainer:SetScript("OnMouseWheel", function(self, delta)
        local step = Q:PixelPerfect(10)
        local maxScroll = SnapScroll(math.max(0, scrollChild:GetHeight() - self:GetHeight()))
        self:SetVerticalScroll(math.max(0, math.min(maxScroll, SnapScroll(self:GetVerticalScroll()) - delta * step)))
    end)

    --------------------------------------------------
    -- General Settings
    --------------------------------------------------
    local generalSettingsFrame = self:CreateSection(Sections.General.name, Sections.General.title, scrollChild)

    --------------------------------------------------
    -- Notification Settings
    --------------------------------------------------
    local notificationSettingsFrame = self:CreateSection(Sections.Notifications.name, Sections.Notifications.title, generalSettingsFrame)

    --------------------------------------------------
    -- Quest Log Settings
    --------------------------------------------------
    local questLogSettingsFrame = self:CreateSection(Sections.QuestLog.name, Sections.QuestLog.title, notificationSettingsFrame)

    -- Setting: Quest Colors
    -- Get last setting in QuestLog section to anchor to
    local settingCount = #GetSectionSettings(Sections.QuestLog.name)
    local anchorFrame = _G["Setting_" .. GetSectionSettings(Sections.QuestLog.name)[settingCount].path] or nil

    local questColorContainer = Q:CreateBackdropFrame("QuestColorContainer", questLogSettingsFrame, CONTENT_WIDTH - (2 * paddingM), 128, "MEDIUM", "Secondary", "Default", 0.6, 0.6)
    Q:SetPixelPerfectPoint(questColorContainer, "TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, -paddingM)

    local label = Q:CreateText(nil, questColorContainer, "Quest Colors", Q.Theme.Font.M, "Accent")
    Q:SetPixelPerfectPoint(label, "TOPLEFT", questColorContainer, "TOPLEFT", paddingS, -13)
    local description = Q:CreateText(nil, questColorContainer, "Customize the colors for different quest states.", Q.Theme.Font.S, "Primary")
    Q:SetPixelPerfectPoint(description, "TOPLEFT", label, "BOTTOMLEFT", 0, -4)

    local colorSettings = {
        { path = "QuestColorAvailable", label = "Available", x = 270, y = 48 },
        { path = "QuestColorUnavailable", label = "Unavailable", x = paddingS, y = 48 },
        { path = "QuestColorInProgress", label = "In Quest Log", x = paddingS, y = 88 },
        { path = "QuestColorCompleted", label = "Completed", x = 270, y = 88 },
    }

    self.colorPickers = {}
    for _, setting in ipairs(colorSettings) do
        local color = Q:GetSetting(setting.path)
        local picker = AceGUI:Create("ColorPicker")
        picker:SetLabel(setting.label)
        picker:SetColor(color.r, color.g, color.b, 1)
        Q:SetPixelPerfectWidth(picker, 260)
        picker.frame:SetParent(questColorContainer)
        picker.frame:ClearAllPoints()
        Q:SetPixelPerfectPoint(picker.frame, "TOPLEFT", questColorContainer, "TOPLEFT", setting.x, -setting.y)
        picker.frame:Show()
        picker:SetCallback("OnValueChanged", function(_, _, r, g, b)
            Q:SetSetting(setting.path, { r = r, g = g, b = b })
            if Q.QuestLog and Q.QuestLog.frame then
                Q.QuestLog:RefreshAndPopulate()
            end
        end)
        self.colorPickers[setting.path] = picker
    end

     local resetColorHandlers = {
        ["OnClick"] = function()
            for _, color in ipairs(colorSettings) do
                Q:SetSetting(color.path, Q.Theme[color.path])
            end
            for path, picker in pairs(self.colorPickers or {}) do
                local color = Q:GetSetting(path)
                picker:SetColor(color.r, color.g, color.b, 1)
            end

            if Q.QuestLog and Q.QuestLog.frame then
                Q.QuestLog:RefreshAndPopulate()
            end
        end
    }
    local resetColorsButton = Q:CreateButton(nil, questColorContainer, "Reset Colors", 120, 40, Q.Theme.Font.M, Q.Theme.Status.Error, resetColorHandlers)
    Q:SetPixelPerfectPoint(resetColorsButton, "BOTTOMRIGHT", questColorContainer, "BOTTOMRIGHT", -paddingS, paddingS)

    questLogSettingsFrame:SetHeight(resetColorsButton:GetHeight() + questLogSettingsFrame:GetHeight() + Q:PixelPerfect(paddingM) + questColorContainer:GetHeight())
    scrollChild:SetHeight(
        generalSettingsFrame:GetHeight()
        + notificationSettingsFrame:GetHeight()
        + questLogSettingsFrame:GetHeight()
        + Q:PixelPerfect(paddingS * 4)
        - Q:PixelPerfect(2)
    )

    self.frame:Hide()
    return frame
end

function Settings:RefreshCheckbox(path)
    local checkbox = self.settings[path]
    if checkbox then
        checkbox:SetChecked(Q:GetSetting(path) and true or false)
    end
end

function Settings:Toggle()
    if self.frame and self.frame:IsShown() then
        self:Hide()
    else
        self:Show()
    end
end

function Settings:Show()
    if not self.frame then
        self:Create()
    end

    for path, picker in pairs(self.colorPickers or {}) do
        local color = Q:GetSetting(path)
        picker:SetColor(color.r, color.g, color.b, 1)
    end
    self.frame:Show()
end

function Settings:Hide()
    if self.frame then
        self.frame:Hide()
    end
end
