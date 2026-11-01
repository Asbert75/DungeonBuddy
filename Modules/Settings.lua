local _, Q = ...
local Settings = Q.Addon:NewModule("Settings")
Q.Settings = Settings
Settings.settings = {}
local AceGUI = LibStub("AceGUI-3.0")

local PANEL_WIDTH = 900
local PANEL_HEIGHT = 700
local SIDEBAR_WIDTH = 200
local CONTENT_WIDTH = PANEL_WIDTH - SIDEBAR_WIDTH
local NAV_BUTTON_HEIGHT = 40
local Sections = {
    General = { name = "General", title = "General" },
    Notifications = { name = "Notifications", title = "Notifications" },
    QuestLog = { name = "QuestLog", title = "Quest Tracker" },
    Theme = { name = "Theme", title = "Theme" },
}
local SectionOrder = { Sections.General, Sections.Notifications, Sections.QuestLog, Sections.Theme }

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
            description =
            "Show a notification on level up when the first quest of a chain leading to a instance quest is available.",
            onChange = function()
                Q.Notification:UpdateLevelUpRegistration()
            end,
        },
        {
            section = Sections.Notifications.name,
            type = "checkbox",
            path = "ShowNotificationForAllQuests",
            title = "Notifications for all quests",
            description = "Enable notifications for all instance quests, not just the first quest in a chain."
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
            description =
            "Show a notification when switching to a new zone if there are relevant quests available (not just chain starters).",
            onChange = function()
                Q.AutoReminder:UpdateRegistration()
            end,
        },
        {
            section = Sections.QuestLog.name,
            type = "checkbox",
            path = "HideCompletedQuests",
            title = "Hide completed quests",
            description = "Remove completed quests from the Dungeon Buddy tracker.",
            onChange = function()
                if Q.QuestLog and Q.QuestLog.frame then
                    Q.QuestLog:RefreshAndPopulate()
                end
            end,
        },
        {
            section = Sections.QuestLog.name,
            type = "checkbox",
            path = "ShowAllQuestsForAvailableInstance",
            title = "Instantly show all instance quests when one is available",
            description =
            "Enable showing all quests for a instance as soon as you have a single quest available in that instance.",
            onChange = function()
                if Q.QuestLog and Q.QuestLog.frame then
                    Q.QuestLog:RefreshAndPopulate()
                end
            end,
        },
        {
            section = Sections.QuestLog.name,
            type = "checkbox",
            path = "CollapseEachChainStep",
            title = "Enable collapsing each step in a chain",
            description = "Allow every quest in a chain to be collapsed, not just the final quest.",
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

local function GetDescriptionLayout(settings, rowWidth)
    local textWidth = rowWidth - (Q.Theme.Padding.L * 5) - CHECKBOX_SIZE
    local unit = Q:PixelPerfect(1)

    local measure = Q:CreateText(nil, UIParent, "", Q.Theme.FontSize.S, "Primary")
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

function Settings:CreateSection(sectionName, sectionTitle, parent)
    local paddingM, paddingS = Q.Theme.Padding.M, Q.Theme.Padding.S
    local fontL = Q.Theme.FontSize.L

    local sectionSettings = GetSectionSettings(sectionName)
    local textWidth, rowHeights = GetDescriptionLayout(sectionSettings, CONTENT_WIDTH - (2 * paddingM))

    local sectionHeight = fontL + (paddingM * 2)
    for index in ipairs(sectionSettings) do
        sectionHeight = sectionHeight + paddingM + rowHeights[index]
    end
    local sectionFrame = Q:CreateBackdropFrame("DungeonBuddy_" .. sectionName .. "SettingsFrame", parent, CONTENT_WIDTH,
        sectionHeight, "DIALOG", "Primary", "Accent", 0, 0)
    Q:SetPixelPerfectPoint(sectionFrame, "TOPLEFT", parent, "TOPLEFT", 0, 0)

    local sectionTitle = Q:CreateText(sectionName .. "SettingsTitle", sectionFrame, sectionTitle, fontL, "Brand", 1)
    sectionTitle:SetPoint("TOPLEFT", sectionFrame, "TOPLEFT", paddingM, -paddingM)

    local resetPosition = ({
        [Sections.Notifications.name] = function() Q.Notification:ResetPosition() end,
        [Sections.QuestLog.name] = function() Q.QuestLog:ResetPosition() end,
    })[sectionName]
    if resetPosition then
        local resetButton = Q:CreateButton(nil, parent, "Reset Position", 160, 32, Q.Theme.FontSize.M,
            Q.Theme.Status.Error, {
                OnClick = resetPosition,
            })
        Q:SetPixelPerfectPoint(resetButton, "BOTTOMRIGHT", parent, "BOTTOMRIGHT", -paddingM, paddingM)
    end

    local y = 0
    for index, setting in ipairs(sectionSettings) do
        y = y + paddingM
        local rowHeight = rowHeights[index]

        local row = Q:CreateBackdropFrame("Setting_" .. setting.path, sectionFrame, CONTENT_WIDTH - (2 * paddingM),
            rowHeight, "DIALOG", "Secondary", "Default", 0.6, 0.2)
        Q:SetPixelPerfectPoint(row, "TOPLEFT", sectionFrame, "TOPLEFT", paddingM, -(paddingM + fontL + y))
        y = y + rowHeight

        local label = Q:CreateText(nil, row, setting.title, Q.Theme.FontSize.M, "Primary")
        label:SetPoint("TOPLEFT", row, "TOPLEFT", paddingS, -13)
        local description = Q:CreateText(nil, row, setting.description, Q.Theme.FontSize.S, "Secondary")
        description:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, -4)
        description:SetWidth(textWidth)
        description:SetJustifyH("LEFT")
        description:SetWordWrap(true)

        local stateBar = row:CreateTexture(nil, "BORDER")
        stateBar:SetPoint("TOPLEFT", row, "TOPLEFT", 0, 0)
        stateBar:SetPoint("BOTTOMLEFT", row, "BOTTOMLEFT", 0, 0)
        stateBar:SetWidth(Q:PixelPerfect(3))
        local function UpdateTint(checked)
            local color = checked and Q.Theme.Status.Success or Q.Theme.Status.Error
            stateBar:SetColorTexture(color[1], color[2], color[3], 1)
        end

        local stateHighlight = row:CreateTexture(nil, "BACKGROUND", nil, 1)
        stateHighlight:SetAllPoints(row)
        stateHighlight:SetColorTexture(1, 1, 1, 1)
        local color = Q:GetSetting(setting.path) and Q.Theme.Status.Success or Q.Theme.Status.Error
        stateHighlight:SetGradient("HORIZONTAL", CreateColor(color[1], color[2], color[3], 0.03), CreateColor(0, 0, 0, 0))
        local function UpdateGradient(checked)
            local color = checked and Q.Theme.Status.Success or Q.Theme.Status.Error
            stateHighlight:SetGradient("HORIZONTAL", CreateColor(color[1], color[2], color[3], 0.03),
                CreateColor(0, 0, 0, 0))
        end

        local checkbox = Q:CreateCheckbox(nil, row, 29, 29, "DIALOG", "Tertiary", "Default", function(self, checked)
            Q:SetSetting(setting.path, checked and true or false)
            UpdateTint(checked)
            UpdateGradient(checked)
            if setting.onChange then
                setting.onChange(checked and true or false)
            end
        end)
        Q:SetPixelPerfectPoint(checkbox, "TOPRIGHT", row, "TOPRIGHT", -paddingS,
            -(math.floor((rowHeight - CHECKBOX_SIZE) / 2) + 1))
        checkbox:SetChecked(Q:GetSetting(setting.path) and true or false)
        UpdateTint(checkbox:GetChecked())
        hooksecurefunc(checkbox, "SetChecked", function(_, checked)
            UpdateTint(checked and true or false)
            UpdateGradient(checked and true or false)
        end)
        self.settings[setting.path] = checkbox

        local hover = row:CreateTexture(nil, "BORDER", nil, 1)
        hover:SetAllPoints(row)
        local hoverColor = Q.Theme.Text.Primary
        hover:SetColorTexture(hoverColor[1], hoverColor[2], hoverColor[3], 0.04)
        hover:Hide()

        row:EnableMouse(true)
        row:SetScript("OnEnter", function() hover:Show() end)
        row:SetScript("OnLeave", function()
            if not checkbox:IsMouseOver() then hover:Hide() end
        end)
        row:SetScript("OnMouseUp", function(_, button)
            if button == "LeftButton" then
                checkbox:Click()
            end
        end)
        checkbox:HookScript("OnEnter", function() hover:Show() end)
        checkbox:HookScript("OnLeave", function()
            if not row:IsMouseOver() then hover:Hide() end
        end)
    end

    return sectionFrame
end

function Settings:Create()
    if self.frame then
        return self.frame
    end

    local paddingS, paddingM = Q.Theme.Padding.S, Q.Theme.Padding.M
    local frame = Q:CreateBackdropFrame("DungeonBuddy_SettingsFrame", UIParent, PANEL_WIDTH, PANEL_HEIGHT, "DIALOG",
        "Primary", "Default", 0.9, 0.5)
    self.frame = frame
    Q:SetPixelPerfectCenterPoint(frame, 0, 0)

    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        self:SetUserPlaced(false)
        Q:ClampFrameToScreen(self)

        local x, y = self:GetCenter()
        local centerX, centerY = UIParent:GetCenter()
        Q:SetPixelPerfectCenterPoint(self, Q:PixelPerfect(x - centerX) or 0, Q:PixelPerfect(y - centerY) or 0)
    end)
    frame:SetUserPlaced(false)

    Q:CreateCloseButton(frame)

    local sidebar = CreateFrame("Frame", nil, frame)
    sidebar:SetFrameStrata("DIALOG")
    Q:SetPixelPerfectPoint(sidebar, "TOPLEFT", frame, "TOPLEFT", 0, 0)
    Q:SetPixelPerfectPoint(sidebar, "BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
    Q:SetPixelPerfectWidth(sidebar, SIDEBAR_WIDTH)
    self.sidebar = sidebar

    local sidebarBackground = sidebar:CreateTexture(nil, "BACKGROUND")
    sidebarBackground:SetAllPoints(sidebar)
    Q:SetThemedColorTexture(sidebarBackground, "Background", "Secondary", 0.5)

    local title = Q:CreateText("SettingsTitle", sidebar, "", Q.Theme.FontSize.XL, "Brand", 1)
    Q:RegisterThemed(title, Q.ApplyBrandTitle)
    Q.ApplyBrandTitle(title)
    title:SetPoint("TOPLEFT", sidebar, "TOPLEFT", paddingM, -paddingM)

    local headerHeight = paddingM + Q.Theme.FontSize.XL + paddingM
    local headerDivider = sidebar:CreateTexture(nil, "ARTWORK")
    headerDivider:SetHeight(Q:PixelPerfect(1))
    Q:SetPixelPerfectPoint(headerDivider, "TOPLEFT", sidebar, "TOPLEFT", 0, -headerHeight)
    Q:SetPixelPerfectPoint(headerDivider, "TOPRIGHT", sidebar, "TOPRIGHT", 0, -headerHeight)
    Q:SetThemedColorTexture(headerDivider, "Border", "Default", 1)

    local sidebarDivider = frame:CreateTexture(nil, "ARTWORK")
    sidebarDivider:SetWidth(Q:PixelPerfect(1))
    Q:SetPixelPerfectPoint(sidebarDivider, "TOPLEFT", frame, "TOPLEFT", SIDEBAR_WIDTH, 0)
    Q:SetPixelPerfectPoint(sidebarDivider, "BOTTOMLEFT", frame, "BOTTOMLEFT", SIDEBAR_WIDTH, 0)
    Q:SetThemedColorTexture(sidebarDivider, "Border", "Default", 1)

    local content = CreateFrame("Frame", nil, frame)
    content:SetFrameStrata("DIALOG")
    Q:SetPixelPerfectPoint(content, "TOPLEFT", frame, "TOPLEFT", SIDEBAR_WIDTH + 1, 0)
    Q:SetPixelPerfectPoint(content, "BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
    self.content = content

    self.pages = {}
    self.navButtons = {}

    local function SelectPage(name)
        self.selectedPage = name
        for pageName, page in pairs(self.pages) do
            page:SetShown(pageName == name)
        end
        for buttonName, button in pairs(self.navButtons) do
            button:UpdateState()
        end
    end

    for index, section in ipairs(SectionOrder) do
        local button = CreateFrame("Button", nil, sidebar)
        button:SetFrameStrata("DIALOG")
        Q:SetPixelPerfectHeight(button, NAV_BUTTON_HEIGHT)
        Q:SetPixelPerfectPoint(button, "TOPLEFT", sidebar, "TOPLEFT", paddingS,
            -(headerHeight + paddingS + (index - 1) * (NAV_BUTTON_HEIGHT + paddingS)))
        Q:SetPixelPerfectPoint(button, "TOPRIGHT", sidebar, "TOPRIGHT", -paddingS,
            -(headerHeight + paddingS + (index - 1) * (NAV_BUTTON_HEIGHT + paddingS)))

        local base = button:CreateTexture(nil, "BACKGROUND")
        base:SetAllPoints(button)
        local hover = button:CreateTexture(nil, "BORDER")
        hover:SetAllPoints(button)
        local selected = button:CreateTexture(nil, "ARTWORK")
        selected:SetAllPoints(button)
        local accent = button:CreateTexture(nil, "OVERLAY")
        accent:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
        accent:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 0, 0)
        accent:SetWidth(Q:PixelPerfect(3))

        local label = Q:CreateText(nil, button, section.title, Q.Theme.FontSize.M, "Primary")
        label:SetPoint("LEFT", button, "LEFT", paddingM, 0)

        local function Gradient(texture, color, startAlpha, endAlpha)
            texture:SetColorTexture(1, 1, 1, 1)
            texture:SetGradient("HORIZONTAL", CreateColor(color[1], color[2], color[3], startAlpha),
                CreateColor(color[1], color[2], color[3], endAlpha))
        end

        function button:UpdateState()
            local isSelected = Settings.selectedPage == section.name
            Gradient(base, Q.Theme.Background.Tertiary, 0.8, 0.1)
            Gradient(hover, Q.Theme.Text.Primary, 0.1, 0)
            Gradient(selected, Q.Theme.Brand, 0.35, 0.05)
            hover:SetShown(not isSelected and self:IsMouseOver())
            selected:SetShown(isSelected)
            accent:SetShown(isSelected)
            accent:SetColorTexture(unpack(Q.Theme.Brand))
            label:SetTextColor(unpack(isSelected and Q.Theme.Text.Brand or Q.Theme.Text.Primary))
        end

        button:SetScript("OnEnter", button.UpdateState)
        button:SetScript("OnLeave", button.UpdateState)
        button:SetScript("OnClick", function() SelectPage(section.name) end)
        Q:RegisterThemed(button, button.UpdateState)

        self.navButtons[section.name] = button
    end

    local function CreatePage(name)
        local page = CreateFrame("Frame", nil, content)
        page:SetFrameStrata("DIALOG")
        page:SetAllPoints(content)
        page:Hide()
        self.pages[name] = page
        return page
    end

    --------------------------------------------------
    -- General Settings
    --------------------------------------------------
    local generalSettingsFrame = self:CreateSection(Sections.General.name, Sections.General.title,
        CreatePage(Sections.General.name))

    --------------------------------------------------
    -- Notification Settings
    --------------------------------------------------
    local notificationSettingsFrame = self:CreateSection(Sections.Notifications.name, Sections.Notifications.title,
        CreatePage(Sections.Notifications.name))

    --------------------------------------------------
    -- Quest Log Settings
    --------------------------------------------------
    local questLogSettingsFrame = self:CreateSection(Sections.QuestLog.name, Sections.QuestLog.title,
        CreatePage(Sections.QuestLog.name))

    -- Setting: Quest Colors
    local settingCount = #GetSectionSettings(Sections.QuestLog.name)
    local anchorFrame = _G["Setting_" .. GetSectionSettings(Sections.QuestLog.name)[settingCount].path] or nil

    local questColorContainer = Q:CreateBackdropFrame("QuestColorContainer", questLogSettingsFrame, CONTENT_WIDTH - (2 * paddingM), 128, "DIALOG", "Secondary", "Default", 0.6, 0.2)
    Q:SetPixelPerfectPoint(questColorContainer, "TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, -paddingM)

    local label = Q:CreateText(nil, questColorContainer, "Colors", Q.Theme.FontSize.M, "Primary")
    label:SetPoint("TOPLEFT", questColorContainer, "TOPLEFT", paddingS, -13)
    local description = Q:CreateText(nil, questColorContainer, "Customize the colors for different quest states.", Q.Theme.FontSize.S, "Secondary")
    description:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, -4)

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
        picker.text:SetTextColor(color.r, color.g, color.b)
        Q:SetPixelPerfectWidth(picker, 260)
        picker.frame:SetParent(questColorContainer)
        picker.frame:SetFrameStrata("DIALOG")
        picker.frame:ClearAllPoints()
        Q:SetPixelPerfectPoint(picker.frame, "TOPLEFT", questColorContainer, "TOPLEFT", setting.x, -setting.y)
        picker.frame:Show()
        picker:SetCallback("OnValueChanged", function(_, _, r, g, b)
            picker.text:SetTextColor(r, g, b)
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
    local resetColorsButton = Q:CreateButton(nil, questColorContainer, "Reset Colors", 120, 40, Q.Theme.FontSize.M, Q.Theme.Status.Error, resetColorHandlers)
    Q:SetPixelPerfectPoint(resetColorsButton, "BOTTOMRIGHT", questColorContainer, "BOTTOMRIGHT", -paddingS, paddingS)

    --------------------------------------------------
    -- Theme Selection
    --------------------------------------------------
    local themeSectionFrame = self:CreateSection(Sections.Theme.name, Sections.Theme.title,
        CreatePage(Sections.Theme.name))
    local themeContainer = Q:CreateBackdropFrame("ThemeContainer", themeSectionFrame, CONTENT_WIDTH - (2 * paddingM), 140,
        "DIALOG", "Secondary", "Default", 0.6, 0.2)
    Q:SetPixelPerfectPoint(themeContainer, "TOPLEFT", themeSectionFrame, "TOPLEFT", paddingM,
        -(paddingM + Q.Theme.FontSize.L + paddingM))

    local themeLabel = Q:CreateText(nil, themeContainer, "Select Theme", Q.Theme.FontSize.M, "Primary")
    themeLabel:SetPoint("TOPLEFT", themeContainer, "TOPLEFT", paddingS, -13)
    local themeDescription = Q:CreateText(nil, themeContainer,
        "Choose the color theme used by all Dungeon Buddy windows.", Q.Theme.FontSize.S, "Secondary")
    themeDescription:SetPoint("TOPLEFT", themeLabel, "BOTTOMLEFT", 0, -4)

    local themeButtons = {}
    local function UpdateThemeButtons()
        local current = Q:GetSetting("Theme")
        for name, button in pairs(themeButtons) do
            local palette = Q.Themes[name]
            button:SetColor(palette.Brand or Q.Themes.Plain.Brand)
            button:SetAlpha(name == current and 1 or 0.55)
        end
    end

    local THEME_BUTTON_WIDTH, THEME_BUTTON_HEIGHT, THEME_COLUMNS = 200, 32, 3
    for index, name in ipairs(Q.ThemeOrder) do
        local column = (index - 1) % THEME_COLUMNS
        local row = math.floor((index - 1) / THEME_COLUMNS)
        local button = Q:CreateButton(nil, themeContainer, name, THEME_BUTTON_WIDTH, THEME_BUTTON_HEIGHT,
            Q.Theme.FontSize.M, Q.Themes[name].Brand, {
                OnClick = function()
                    Q:SetTheme(name)
                    UpdateThemeButtons()
                end,
            })
        Q:SetPixelPerfectPoint(button, "TOPLEFT", themeContainer, "TOPLEFT",
            paddingS + column * (THEME_BUTTON_WIDTH + paddingS), -(52 + row * (THEME_BUTTON_HEIGHT + paddingS)))
        themeButtons[name] = button
    end
    UpdateThemeButtons()
    Q:RegisterThemed(Settings, UpdateThemeButtons)

    SelectPage(self.selectedPage or Sections.General.name)

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
