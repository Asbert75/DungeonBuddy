local _, Q = ...

local QuestLogFilter = {}
Q.QuestLogFilter = QuestLogFilter

local DROPDOWN_WIDTH = 176
local DROPDOWN_HEIGHT = 28
local ROW_HEIGHT = 22
local LABEL_HEIGHT = 20
local SECTION_GAP = 12
local RESET_EXTRA_GAP = 24

local function IsHidden(settingPath, key)
    local hidden = Q:GetSetting(settingPath)
    return hidden and hidden[key] and true or false
end

local function ToggleHidden(settingPath, key)
    local hidden = Q:GetSetting(settingPath) or {}
    hidden[key] = (not hidden[key]) or nil
    Q:SetSetting(settingPath, hidden)
end

local function CreateDropdown(parent, x, y, width, title, getText, options)
    local label = Q:CreateText(nil, parent, title, Q.Theme.FontSize.M, "Primary")
    label:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)

    local outline = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    Q:SetPixelPerfectSize(outline, width, DROPDOWN_HEIGHT)
    outline:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y - LABEL_HEIGHT)
    outline:SetBackdrop({ edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = Q:PixelPerfect(1) })
    local function ApplyOutline()
        outline:SetBackdropBorderColor(unpack(Q.Theme.Text.Secondary))
    end
    ApplyOutline()
    Q:RegisterThemed(outline, ApplyOutline)

    local inset = Q:PixelPerfect(3)
    local button = Q:CreateButton(nil, parent, "", width - 6, DROPDOWN_HEIGHT - 6, Q.Theme.FontSize.S,
        Q.Theme.Text.Brand)
    button:SetPoint("TOPLEFT", outline, "TOPLEFT", inset, -inset)

    local menuHeight = #options * (ROW_HEIGHT + 2) + 2
    local menu = Q:CreateBackdropFrame(nil, button, width, menuHeight, "DIALOG", "Primary", "Default", 1, 0.5)
    menu:SetPoint("TOPLEFT", outline, "BOTTOMLEFT", 0, 0)
    menu:EnableMouse(true)
    menu:Hide()

    local items = {}
    local function Refresh()
        button.label:SetText(getText())
        for _, item in ipairs(items) do
            item.button:SetColor(item.option.isSelected() and Q.Theme.Text.Brand or Q.Theme.Text.Secondary)
        end
    end

    for index, option in ipairs(options) do
        local item = Q:CreateButton(nil, menu, option.label, width - 4, ROW_HEIGHT, Q.Theme.FontSize.S,
            Q.Theme.Text.Secondary, {
                OnClick = function()
                    option.onSelect()
                    menu:Hide()
                end
            })
        item:SetPoint("TOPLEFT", menu, "TOPLEFT", 2, -2 - (index - 1) * (ROW_HEIGHT + 2))
        items[index] = { button = item, option = option }
    end

    -- Stays open while the mouse is over either the button or the list
    menu:SetScript("OnUpdate", function(self)
        if not (outline:IsMouseOver() or self:IsMouseOver()) then
            self:Hide()
        end
    end)
    menu:SetScript("OnShow", Refresh)
    button:HookScript("OnEnter", function()
        menu:Show()
    end)

    Refresh()
    Q:RegisterThemed(label, Refresh)

    return Refresh, LABEL_HEIGHT + DROPDOWN_HEIGHT, button
end

function QuestLogFilter:Create(questLogFrame, onChanged)
    local padding = Q.Theme.Padding.S
    local window = Q:CreateBackdropFrame("DungeonBuddy_QuestLogSortFrame", questLogFrame,
        padding * 2 + DROPDOWN_WIDTH, 100, "HIGH", "Primary", "Default", 0.9, 0.5)
    window:SetPoint("TOPRIGHT", questLogFrame, "TOPLEFT", -4, 0)
    window:EnableMouse(true)
    questLogFrame:HookScript("OnHide", function()
        window:Hide()
    end)

    local title = Q:CreateText(nil, window, "Filter / Sort", Q.Theme.FontSize.L, "Brand", 1)
    title:SetPoint("TOPLEFT", window, "TOPLEFT", padding, -padding)

    local headerHeight = padding * 2 + Q.Theme.FontSize.L
    local headerBorder = window:CreateTexture(nil, "OVERLAY")
    Q:SetThemedColorTexture(headerBorder, "Border", "Default", 0.25)
    headerBorder:SetHeight(Q:PixelPerfect(1))
    headerBorder:SetPoint("TOPLEFT", window, "TOPLEFT", 0, -headerHeight)
    headerBorder:SetPoint("TOPRIGHT", window, "TOPRIGHT", 0, -headerHeight)

    local refreshers = {}
    local function Changed()
        for _, refresh in ipairs(refreshers) do
            refresh()
        end
        onChanged()
    end

    local currentY = -(headerHeight + padding)
    local function AddDropdown(sectionTitle, getText, options, width)
        local refresh, height, button = CreateDropdown(window, padding, currentY, width or DROPDOWN_WIDTH,
            sectionTitle, getText, options)
        table.insert(refreshers, refresh)
        currentY = currentY - height - SECTION_GAP
        return button
    end

    local function AddSort(sectionTitle, settingPath, keys)
        local options = {}
        for _, key in ipairs(keys) do
            table.insert(options, {
                label = key,
                isSelected = function() return Q:GetSetting(settingPath .. ".Key") == key end,
                onSelect = function()
                    Q:SetSetting(settingPath .. ".Key", key)
                    Changed()
                end,
            })
        end

        local halfWidth = (DROPDOWN_WIDTH - 2) / 2
        local rowY = currentY - LABEL_HEIGHT - DROPDOWN_HEIGHT - 2
        AddDropdown(sectionTitle, function() return Q:GetSetting(settingPath .. ".Key") end, options)

        local directions = {}
        for index, direction in ipairs({ { label = "Asc", value = true }, { label = "Desc", value = false } }) do
            local button = Q:CreateButton(nil, window, direction.label, halfWidth, ROW_HEIGHT, Q.Theme.FontSize.S,
                Q.Theme.Text.Secondary, {
                    OnClick = function()
                        Q:SetSetting(settingPath .. ".Ascending", direction.value)
                        Changed()
                    end
                })
            button:SetPoint("TOPLEFT", window, "TOPLEFT", padding + (index - 1) * (halfWidth + 2), rowY)
            directions[index] = { button = button, value = direction.value }
        end
        currentY = currentY - ROW_HEIGHT - 2
        table.insert(refreshers, function()
            local ascending = Q:GetSetting(settingPath .. ".Ascending") and true or false
            for _, item in ipairs(directions) do
                item.button:SetColor(item.value == ascending and Q.Theme.Text.Brand or Q.Theme.Text.Secondary)
            end
        end)
        refreshers[#refreshers]()
    end

    AddSort("Sort Instances", "QuestLogSort.Instances", Q.API.InstanceSortKeys)
    AddSort("Sort Quests", "QuestLogSort.Quests", Q.API.QuestSortKeys)

    -- Always-visible toggle buttons for short option lists
    local function AddButtonList(sectionTitle, entries)
        local label = Q:CreateText(nil, window, sectionTitle, Q.Theme.FontSize.M, "Primary")
        label:SetPoint("TOPLEFT", window, "TOPLEFT", padding, currentY)

        local buttons = {}
        local top = currentY - LABEL_HEIGHT
        for _, entry in ipairs(entries) do
            local button = Q:CreateButton(nil, window, entry.label, DROPDOWN_WIDTH, ROW_HEIGHT, Q.Theme.FontSize.S,
                Q.Theme.Text.Secondary, { OnClick = entry.onSelect })
            button:SetPoint("TOPLEFT", window, "TOPLEFT", padding, top)
            buttons[#buttons + 1] = { button = button, isSelected = entry.isSelected }
            top = top - ROW_HEIGHT - 2
        end

        local function Refresh()
            for _, item in ipairs(buttons) do
                item.button:SetColor(item.isSelected() and Q.Theme.Text.Brand or Q.Theme.Text.Secondary)
            end
        end
        Refresh()
        table.insert(refreshers, Refresh)
        Q:RegisterThemed(label, Refresh)

        currentY = top - SECTION_GAP + 2
    end

    local groupEntries = {}
    for _, value in ipairs({ "None", "Continent", "Zone" }) do
        table.insert(groupEntries, {
            label = value,
            isSelected = function() return (Q:GetSetting("QuestLogGroupBy") or "None") == value end,
            onSelect = function()
                Q:SetSetting("QuestLogGroupBy", value)
                Changed()
            end,
        })
    end
    AddButtonList("Group Instances", groupEntries)

    local continentEntries = {}
    for _, continent in ipairs(Q.API:GetContinents()) do
        table.insert(continentEntries, {
            label = continent,
            isSelected = function() return not IsHidden("QuestLogFilter.HiddenContinents", continent) end,
            onSelect = function()
                ToggleHidden("QuestLogFilter.HiddenContinents", continent)
                Changed()
            end,
        })
    end
    AddButtonList("Show Continents", continentEntries)

    local resetButton = Q:CreateButton(nil, window, "Restore Defaults", DROPDOWN_WIDTH, ROW_HEIGHT,
        Q.Theme.FontSize.S, Q.Theme.Status.Error, {
            OnClick = function()
                for _, path in ipairs({ "QuestLogSort", "QuestLogGroupBy", "QuestLogFilter" }) do
                    Q:SetSetting(path, Q:GetDefaultSetting(path))
                end
                Changed()
            end
        })
    resetButton:SetPoint("TOPLEFT", window, "TOPLEFT", padding, currentY - RESET_EXTRA_GAP)

    Q:CreateCloseButton(window, "DungeonBuddy_QuestLogSortCloseButton")

    Q:SetPixelPerfectHeight(window, -currentY + RESET_EXTRA_GAP + ROW_HEIGHT + padding)
    window:Hide()
    return window
end
