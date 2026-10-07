local _, Q = ...
local Settings = Q.Addon:NewModule("Settings")
Q.Settings = Settings
Settings.settings = {}
local AceGUI = LibStub("AceGUI-3.0")

local PANEL_WIDTH = 1000
local CONTENT_WIDTH = PANEL_WIDTH - (2 * Q.Theme.Padding.M)
local Sections = {
    General = "General",
    Notifications = "Notifications",
    QuestLog = "QuestLog",
}

local function GetSectionSettings(sectionName)
        local allSettings = {
        {
            section = Sections.General,
            type = "checkbox",
            path = "MinimapButton.Hide",
            title = "Hide minimap button",
            description = "Hide the minimap button. Can also be toggled using /db minimap.",
            onChange = function(value)
                local icon = LibStub("LibDBIcon-1.0")
                if value then
                    icon:Hide("DungeonBuddy")
                else
                    icon:Show("DungeonBuddy")
                end
            end,
        },
        {
            section = Sections.Notifications,
            type = "checkbox",
            path = "ShowNotificationOnLevelUp",
            title = "Show notifications on level up",
            description = "Show a notification on level up when the first quest of a chain leading to a dungeon quest is available.",
            onChange = function(value)
                if value then
                    Q.Notification:OnEnable()
                else
                    Q.Notification:OnDisable()
                end
            end,
        },
        {
            section = Sections.Notifications,
            type = "checkbox",
            path = "ShowNotificationForAllQuests",
            title = "Show notifications for all quests",
            description = "Enable notifications for all quests, not just the first quest in a chain leading to a dungeon quest."
        },
        {
            section = Sections.Notifications,
            type = "checkbox",
            path = "AutoWaypoint",
            title = "Automatic quest giver waypoints",
            description = "Automatically adds a TomTom waypoint to the quest giver when a quest notification appears.",
        },
        {
            section = Sections.Notifications,
            type = "checkbox",
            path = "RemindOnZoneChange",
            title = "Reminders on zone change",
            description = "Show an extra notification when entering a new zone if there are relevant quests available.",
            onChange = function(value)
                if value then
                    Q.AutoReminder:OnEnable()
                else
                    Q.AutoReminder:OnDisable()
                end
            end,
        },
        {
            section = Sections.QuestLog,
            type = "checkbox",
            path = "HideCompletedQuests",
            title = "Hide completed quests",
            description = "Remove completed quests from the dungeon buddy tracker.",
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

function Settings:CreateSection(sectionName, anchorFrame)
    local paddingL, paddingM, paddingS = Q.Theme.Padding.L, Q.Theme.Padding.M, Q.Theme.Padding.S
    local fontL = Q.Theme.Font.L

    local sectionHeight = fontL + (paddingM * 2)
    for _, setting in ipairs(GetSectionSettings(sectionName)) do
        sectionHeight = sectionHeight + paddingM + 55
    end
    local sectionFrame = Q:CreateBackdropFrame("DungeonBuddy_"..sectionName.."SettingsFrame", anchorFrame == self.scrollChild and anchorFrame or anchorFrame:GetParent(), CONTENT_WIDTH, sectionHeight, "HIGH", "Primary", "Default")
    local anchorPoint = anchorFrame == self.scrollChild and "TOPLEFT" or "BOTTOMLEFT"
    Q:SetPixelPerfectPoint(sectionFrame, "TOPLEFT", anchorFrame, anchorPoint, 0, -paddingM)
    local sectionTitle = Q:CreateText(sectionName.."SettingsTitle", sectionFrame, sectionName, fontL, "Accent", 1)
    Q:SetPixelPerfectPoint(sectionTitle, "TOPLEFT", sectionFrame, "TOPLEFT", paddingM, -paddingM)

    for index, setting in ipairs(GetSectionSettings(sectionName)) do
        local y = (index * paddingM) + (index - 1) * 55

        local row = Q:CreateBackdropFrame("Setting_"..setting.path, sectionFrame, CONTENT_WIDTH - (2 * paddingM), 55, "HIGH", "Secondary", "Default", 0.6, 0.6)
        Q:SetPixelPerfectPoint(row, "TOPLEFT", sectionTitle, "BOTTOMLEFT", 0, -y)

        local label = Q:CreateText(nil, row, setting.title, Q.Theme.Font.M, "Accent")
        Q:SetPixelPerfectPoint(label, "TOPLEFT", row, "TOPLEFT", paddingS, -13)
        local description = Q:CreateText(nil, row, setting.description, Q.Theme.Font.S, "Primary")
        Q:SetPixelPerfectPoint(description, "TOPLEFT", label, "BOTTOMLEFT", 0, -4)

        local checkbox = Q:CreateCheckbox(nil, row, 29, 29, nil, "Tertiary", "Default", function(self, checked)
            Q:SetSetting(setting.path, checked and true or false)
            if setting.onChange then
                setting.onChange(checked and true or false)
            end
        end)
        checkbox:SetFrameStrata("TOOLTIP")
        Q:SetPixelPerfectPoint(checkbox, "RIGHT", row, "RIGHT", -paddingS, -1)
        checkbox:SetChecked(Q:GetSetting(setting.path) and true or false)
        self.settings[setting.path] = checkbox
    end

    return sectionFrame
end

function Settings:Create()
    if self.frame then
        return self.frame
    end

    local paddingM, paddingL = Q.Theme.Padding.M, Q.Theme.Padding.L
    local frame = Q:CreateBackdropFrame("DungeonBuddy_SettingsFrame", UIParent, PANEL_WIDTH, 700, "HIGH", "Primary", "Default")
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
    Q:SetPixelPerfectPoint(contentContainer, "TOPLEFT", title, "BOTTOMLEFT", 0, -Q.Theme.Padding.S)
    Q:SetPixelPerfectPoint(contentContainer, "BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
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

    contentContainer:SetScript("OnMouseWheel", function(self, delta)
        local step = 10
        local maxScroll = math.max(0, scrollChild:GetHeight() - self:GetHeight())
        self:SetVerticalScroll(math.max(0, math.min(maxScroll, self:GetVerticalScroll() - delta * step)))
    end)

    --------------------------------------------------
    -- General Settings
    --------------------------------------------------
    local generalSettingsFrame = self:CreateSection(Sections.General, scrollChild)

    --------------------------------------------------
    -- Notification Settings
    --------------------------------------------------
    local notificationSettingsFrame = self:CreateSection(Sections.Notifications, generalSettingsFrame)

    --------------------------------------------------
    -- Quest Log Settings
    --------------------------------------------------
    local questLogSettingsFrame = self:CreateSection(Sections.QuestLog, notificationSettingsFrame)

    -- Setting: Quest Colors
    local anchorFrame = _G["Setting_HideCompletedQuests"]
    local questColorContainer = Q:CreateBackdropFrame("QuestColorContainer", questLogSettingsFrame, CONTENT_WIDTH - (2 * paddingM), 128, "HIGH", "Secondary", "Default")
    Q:SetPixelPerfectPoint(questColorContainer, "TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, -paddingM)

    local label = Q:CreateText(nil, questColorContainer, "Quest Colors", Q.Theme.Font.M, "Accent")
    Q:SetPixelPerfectPoint(label, "TOPLEFT", questColorContainer, "TOPLEFT", 12, -8)
    local description = Q:CreateText(nil, questColorContainer, "Customize the colors for different quest states.", Q.Theme.Font.S, "Primary")
    Q:SetPixelPerfectPoint(description, "TOPLEFT", label, "BOTTOMLEFT", 0, -4)

    local colorSettings = {
        { path = "QuestColorAvailable", label = "Available", x = 470, y = 48 },
        { path = "QuestColorUnavailable", label = "Unavailable", x = 12, y = 48 },
        { path = "QuestColorInProgress", label = "In Quest Log", x = 12, y = 88 },
        { path = "QuestColorCompleted", label = "Completed", x = 470, y = 88 },
    }

    self.colorPickers = {}
    for _, setting in ipairs(colorSettings) do
        local color = Q:GetSetting(setting.path)
        local picker = AceGUI:Create("ColorPicker")
        picker:SetLabel(setting.label)
        picker:SetColor(color.r, color.g, color.b, 1)
        Q:SetPixelPerfectWidth(picker, 420)
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

    questLogSettingsFrame:SetHeight(questLogSettingsFrame:GetHeight() + Q:PixelPerfect(paddingM) + questColorContainer:GetHeight())
    scrollChild:SetHeight(
        generalSettingsFrame:GetHeight()
        + notificationSettingsFrame:GetHeight()
        + questLogSettingsFrame:GetHeight()
        + Q:PixelPerfect(paddingM * 4)
        - 5
    )

    self.frame:Hide()
    return frame
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
