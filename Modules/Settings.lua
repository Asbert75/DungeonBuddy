local _, Q = ...
local Settings = Q.Addon:NewModule("Settings")
Q.Settings = Settings
local AceGUI = LibStub("AceGUI-3.0")

function Settings:Create()
    if self.frame then
        return self.frame
    end

    local paddingL = Q.Theme.Padding.L
    local panelWidth = 1000
    local contentWidth = panelWidth - (2 * paddingL)
    local frame = Q:CreateBackdropFrame("DungeonBuddy_SettingsFrame", UIParent, panelWidth, 700, "HIGH", "Primary", "Default")
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
    Q:SetPixelPerfectPoint(title, "TOPLEFT", frame, "TOPLEFT", 18, -18)

    --------------------------------------------------
    -- Create Checkbox-Setting Frames
    --------------------------------------------------
    local checkboxContainer = Q:CreateFrame("CheckboxContainer", frame, contentWidth, 45)
    Q:SetPixelPerfectPoint(checkboxContainer, "TOPLEFT", title, "BOTTOMLEFT", 0, 0)

    local toggleableSettings = {
        {
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
            path = "ShowRemindersOnLevelUp",
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
            path = "AutoWaypoint",
            title = "Automatic quest giver waypoints",
            description = "Automatically adds a TomTom waypoint to the quest giver when a quest notification appears on level up.",
        },
        {
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
            path = "HideCompletedQuests",
            title = "Hide completed quests",
            description = "Remove completed quests from the quest log.",
            onChange = function()
                if Q.QuestLog and Q.QuestLog.frame then
                    Q.QuestLog:RefreshAndPopulate()
                end
            end,
        },
    }

    self.toggleableCheckboxes = {}

    for index, setting in ipairs(toggleableSettings) do
        local y = paddingL + (index - 1) * 55

        local row = Q:CreateBackdropFrame("Frame", checkboxContainer, contentWidth, 45, "HIGH", "Secondary", "Default", 0.6, 0.6)
        Q:SetPixelPerfectPoint(row, "TOPLEFT", checkboxContainer, "TOPLEFT", 0, -y)

        local label = Q:CreateText(nil, row, setting.title, Q.Theme.Font.M, "Accent")
        Q:SetPixelPerfectPoint(label, "TOPLEFT", row, "TOPLEFT", 12, -8)
        local description = Q:CreateText(nil, row, setting.description, Q.Theme.Font.S, "Primary")
        Q:SetPixelPerfectPoint(description, "TOPLEFT", label, "BOTTOMLEFT", 0, -4)

        local checkbox = Q:CreateCheckbox(nil, row, 29, 29, nil, "Tertiary", "Default", function(self, checked)
            Q:SetSetting(setting.path, checked and true or false)
            if setting.onChange then
                setting.onChange(checked and true or false)
            end
        end)
        checkbox:SetFrameStrata("TOOLTIP")
        Q:SetPixelPerfectPoint(checkbox, "RIGHT", row, "RIGHT", -12, -1)
        checkbox:SetChecked(Q:GetSetting(setting.path) and true or false)
        self.toggleableCheckboxes[setting.path] = checkbox
    end

    --------------------------------------------------
    -- Create Container for Color Pickers
    --------------------------------------------------
    local questColorContainer = Q:CreateBackdropFrame("QuestColorContainer", frame, contentWidth, 128, "HIGH", "Secondary", "Default", 0.6, 0.6)
    Q:SetPixelPerfectPoint(questColorContainer, "TOPLEFT", checkboxContainer, "TOPLEFT", 0, -((#toggleableSettings * 55) + paddingL))

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
