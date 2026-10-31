local _, Q = ...
local QuestLog = Q.Addon:NewModule("QuestLog", "AceEvent-3.0", "AceConsole-3.0")
Q.QuestLog = QuestLog

local DB_ROW_HEIGHT = Q.Theme.FontSize.XL + 6
local INSTANCE_ROW_EXTRA_HEIGHT = 20
local CONTAINER_WIDTH = 500

function QuestLog:Create()
    if self.frame then
        return self.frame
    end

    --------------------------------------------------
    -- Create QuestLog Frame
    --------------------------------------------------
    self.frame = Q:CreateBackdropFrame('DungeonBuddy_QuestLogFrame', UIParent, CONTAINER_WIDTH, 600, "HIGH", "Primary", "Default", 0.9, 0.5)

    self.frame:SetMovable(true)
    self.frame:EnableMouse(true)
    self.frame:RegisterForDrag("LeftButton")

    self.frame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    self.frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        self:SetUserPlaced(false)
        Q:ClampFrameToScreen(self)

        local x, y = self:GetCenter()
        local centerX, centerY = UIParent:GetCenter()
        Q:SetSetting("QuestLogFrame.X", Q:PixelPerfect(x - centerX))
        Q:SetSetting("QuestLogFrame.Y", Q:PixelPerfect(y - centerY))

        Q:SetPixelPerfectCenterPoint(self, Q:GetSetting("QuestLogFrame.X") or 500, Q:GetSetting("QuestLogFrame.Y") or 0)
    end)

    Q:SetPixelPerfectCenterPoint(self.frame, Q:GetSetting("QuestLogFrame.X") or 500, Q:GetSetting("QuestLogFrame.Y") or 0)
    self.frame:SetUserPlaced(false)

    local closeButton = Q:CreateCloseButton(self.frame, "DungeonBuddy_QuestLogCloseButton")

    --------------------------------------------------
    -- QuestLog Header
    --------------------------------------------------
    self.header = Q:CreateFrame("QuestLogHeader", self.frame, CONTAINER_WIDTH, 33, "HIGH")
    Q:SetPixelPerfectPoint(self.header, "TOP", self.frame, "TOP", 0, 0)
    Q:SetPixelPerfectPoint(self.header, "LEFT", self.frame, "LEFT", 0, 0)
    Q:SetPixelPerfectPoint(self.header, "RIGHT", self.frame, "RIGHT", 0, 0)

    local border = self.header:CreateTexture(nil, "OVERLAY")
    local borderR, borderG, borderB = unpack(Q.Theme.Border.Default)
    border:SetColorTexture(borderR, borderG, borderB, 0.25)
    border:SetHeight(Q:PixelPerfect(1))
    Q:SetPixelPerfectPoint(border, "BOTTOMLEFT", self.header, "BOTTOMLEFT", 0, 0)
    Q:SetPixelPerfectPoint(border, "BOTTOMRIGHT", self.header, "BOTTOMRIGHT", 0, 0)

    self.header.text = Q:CreateText("QuestLogHeaderText", self.header, "DUNGEON|cffEFE8D3BUDDY", Q.Theme.FontSize.L, "Accent", 1)
    self.header.text:SetJustifyH("LEFT")
    self.header.text:SetPoint("LEFT", self.header, "LEFT", Q.Theme.Padding.S, 0)

    --------------------------------------------------
    -- Action Buttons
    --------------------------------------------------
    local actionHandlers = {
        OnClick = function(self)
            if next(Q:GetSetting("CollapsedQuests")) or next(Q:GetSetting("CollapsedInstances")) then
                Q:SetSetting("CollapsedQuests", {})
                Q:SetSetting("CollapsedInstances", {})
                Q.QuestLog:RefreshAndPopulate()

                self.label:SetText("-")
            else
                local quests = {}
                local instances = {}

                for _, row in ipairs(Q.QuestLog.rows) do
                    if row.isInstance then
                        instances[row.id] = true
                    elseif not row.isSharedSummary and #(row.prerequisites or {}) > 0 then
                        quests[row.collapseKey] = true
                    end
                end
                
                Q:SetSetting("CollapsedQuests", quests)
                Q:SetSetting("CollapsedInstances", instances)
                Q.QuestLog:RefreshAndPopulate()

                self.label:SetText("+")
            end
        end,
        OnMouseEnter = function(self)
            local tooltip = Q:GetTooltip()
            local accentR, accentG, accentB = unpack(Q.Theme.Text.Accent)
            local primaryR, primaryG, primaryB = unpack(Q.Theme.Text.Primary)

            tooltip:SetOwner(self, "ANCHOR_RIGHT")
            tooltip:SetText("Expand/Collapse All", accentR, accentG, accentB)
            tooltip:AddLine("Click to expand/collapse all rows.", primaryR, primaryG, primaryB, true)
            tooltip:Show()
        end,
        OnMouseLeave = function()
            local tooltip = Q:GetTooltip()
            tooltip:Hide()
        end
    }

    local initialText = (next(Q:GetSetting("CollapsedQuests")) or next(Q:GetSetting("CollapsedInstances"))) and "+" or "-"
    local collapseAndExpandButton = Q:CreateButton("DungeonBuddy_CollapseAndExpandButton", self.frame, initialText, 24, 24, Q.Theme.FontSize.M, Q.Theme.Text.Secondary, actionHandlers)
    collapseAndExpandButton:SetPoint("RIGHT", closeButton, "LEFT", -2, 0)
    
    --------------------------------------------------
    -- QuestLog Content Container
    --------------------------------------------------
    self.contentContainer = CreateFrame("ScrollFrame", "DungeonBuddy_QuestLogContentContainer", self.frame, "UIPanelScrollFrameTemplate")
    Q:SetPixelPerfectPoint(self.contentContainer, "TOPLEFT", self.header, "BOTTOMLEFT", 0, 0)
    Q:SetPixelPerfectPoint(self.contentContainer, "BOTTOMRIGHT", self.frame, "BOTTOMRIGHT", 0, 0)
    self.contentContainer:EnableMouseWheel(true)

    self.scrollChild = CreateFrame("Frame", "DungeonBuddy_QuestLogContentContainerChild", self.contentContainer)
    Q:SetPixelPerfectSize(self.scrollChild, CONTAINER_WIDTH, 1)
    self.contentContainer:SetScrollChild(self.scrollChild)
    self.contentContainer:SetScript("OnSizeChanged", function(self, width)
        QuestLog.scrollChild:SetWidth(width)
    end)

    local scrollBar = _G[self.contentContainer:GetName() .. "ScrollBar"]
    if scrollBar then
        scrollBar:ClearAllPoints()
        scrollBar:SetValueStep(Q:PixelPerfect(DB_ROW_HEIGHT / 4))
        scrollBar:SetObeyStepOnDrag(true)
        Q:SetPixelPerfectPoint(scrollBar, "TOPRIGHT", self.contentContainer, "TOPRIGHT", 4, -20)
        Q:SetPixelPerfectPoint(scrollBar, "BOTTOMRIGHT", self.contentContainer, "BOTTOMRIGHT", 4, 20)

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
            thumb:SetColorTexture(unpack(Q.Theme.Border.Accent))
            Q:SetPixelPerfectWidth(thumb, 3)
        end
    end

    self.contentContainer:SetScript("OnMouseWheel", function(self, delta)
        local step = 10
        local maxScroll = math.max(0, QuestLog.scrollChild:GetHeight() - self:GetHeight())
        self:SetVerticalScroll(math.max(0, math.min(maxScroll, self:GetVerticalScroll() - delta * step)))
    end)

    QuestLog:RefreshAndPopulate()

    self.frame:Hide()
    return self.frame
end

local function IsRowCollapsed(row)
    if row.isInstance then
        return Q:GetSetting("CollapsedInstances")[row.id] or false
    else
        local collapsedQuests = Q:GetSetting("CollapsedQuests")
        if collapsedQuests[row.collapseKey] ~= nil then
            return collapsedQuests[row.collapseKey]
        end

        -- Preserve an old quest-id collapse on the first matching row encountered.
        if collapsedQuests[row.id] then
            collapsedQuests[row.collapseKey] = true
            collapsedQuests[row.id] = nil
            return true
        end

        return false
    end
end

local function CopyRow(row)
    local copy = {}
    for key, value in pairs(row) do
        copy[key] = value
    end
    return copy
end

-- Counts the unique quests that lead up to the given quest, ignoring optional breadcrumbs.
local function CountLineage(quest, seen)
    for _, prerequisite in ipairs(quest.prerequisites or {}) do
        local prerequisiteQuest = Q.API:GetQuestById(prerequisite.id)
        if  prerequisiteQuest and
            prerequisite.type ~= Q.PrerequisiteType.BREADCRUMB and
            not seen[prerequisite.id]
        then
            seen[prerequisite.id] = true
            CountLineage(prerequisiteQuest, seen)
        end
    end
    return seen
end

local function CountRemainingLineage(quest)
    local count = 0
    for questId in pairs(CountLineage(quest, {})) do
        if not Q:GetSetting("HideCompletedQuests") or not Q.API:IsQuestCompleted(questId) then
            count = count + 1
        end
    end
    return count
end

local function HasLineage(quest)
    for _, prerequisite in ipairs(quest.prerequisites or {}) do
        if prerequisite.type ~= Q.PrerequisiteType.BREADCRUMB and Q.API:GetQuestById(prerequisite.id) then
            return true
        end
    end
    return false
end

-- "visited" holds every quest already listed under the current main quest, so a chain shared by
-- several alternatives is only expanded once and referenced with a summary row afterwards.
local function AppendRelatedRows(quest, depth, visited, parentCollapseKey)
    if not quest then
        return
    end

    depth = depth or 0
    visited = visited or { [quest.id] = true }

    local function AddDependency(questId, dependencyType)
        local dependency = Q.API:GetQuestById(questId)
        if dependency and not Q.API:PlayerHasProfession(dependency.profession) then
            return
        end

        local row = dependency and CopyRow(dependency) or {
            id = questId,
            name = "Missing QuestId [" .. tostring(questId) .. "]",
        }
        row.isChainQuest = dependencyType == "chain"
        row.isPrerequisite = dependencyType ~= "chain"
        row.prerequisiteType = dependencyType
        row.lineageDepth = depth + 1
        row.collapseKey = string.format("%s/quest:%s", parentCollapseKey or ("quest:" .. tostring(quest.id)), tostring(questId))

        local isHidden = Q:GetSetting("HideCompletedQuests") and Q.API:IsQuestCompleted(questId)
        if not isHidden then
            table.insert(QuestLog.rows, row)
        end

        if IsRowCollapsed(row) or not dependency then
            return
        end

        if not visited[questId] then
            visited[questId] = true
            AppendRelatedRows(dependency, depth + 1, visited, row.collapseKey)
        elseif HasLineage(dependency) and not isHidden then
            local count = CountRemainingLineage(dependency)
            if count > 0 then
                table.insert(QuestLog.rows, {
                    id = "shared:" .. questId .. ":" .. #QuestLog.rows,
                    name = string.format("Shared chain (%d %s, listed above)", count, count == 1 and "quest" or "quests"),
                    isSharedSummary = true,
                    lineageDepth = depth + 2,
                })
            end
        end
    end

    -- Breadcrumb quests stop being available once the quest they point to is completed.
    for _, prerequisite in ipairs(quest.prerequisites or {}) do
        local isHiddenBreadcrumb = Q.API:IsQuestCompleted(quest.id) and prerequisite.type == Q.PrerequisiteType.BREADCRUMB
        if not isHiddenBreadcrumb and Q.API:GetQuestById(prerequisite.id) then
            AddDependency(prerequisite.id, prerequisite.type)
        end
    end
end

local function SetQuestStatusColor(fontString, settingPath, fallbackKey)
    local color = Q:GetSetting(settingPath)
    if color and color.r and color.g and color.b then
        fontString:SetTextColor(color.r, color.g, color.b)
    else
        Q:SetTextColor(fontString, fallbackKey)
    end
end

local function SetBorderTextureColor(frame, settingPath)
    local color = Q:GetSetting(settingPath)
    if color and color.r and color.g and color.b then
        frame:SetColorTexture(color.r, color.g, color.b)
    end
end

local function SetGradientColor(frame, settingPath)
    local color = Q:GetSetting(settingPath)
    if color and color.r and color.g and color.b then
        frame:SetGradient("HORIZONTAL", CreateColor(color.r, color.g, color.b, 0.03), CreateColor(0, 0, 0, 0))
    end
end

local function UpdateClassIcon(frame)
    local classIcon = frame.titleFrame.classIcon
    local professionIcon = frame.titleFrame.professionIcon
    local classIconTexture = not frame.row.isInstance and Q.API:GetClassIconTexture(frame.row.class)
    local professionIconTexture = not frame.row.isInstance and Q.API:GetProfessionIconTexture(frame.row.profession)

    if classIconTexture then
        classIcon:SetTexture(classIconTexture)
        local classColor = RAID_CLASS_COLORS and RAID_CLASS_COLORS[frame.row.class]
        if classColor then
            Q:SetIconBorderColor(frame.titleFrame.classIconBorder, { classColor.r, classColor.g, classColor.b })
        end
        Q:SetIconBorderShown(frame.titleFrame.classIconBorder, true)
        classIcon:Show()
    else
        Q:SetIconBorderShown(frame.titleFrame.classIconBorder, false)
        classIcon:Hide()
    end

    if professionIconTexture then
        professionIcon:SetTexture(professionIconTexture)
        Q:SetIconBorderColor(frame.titleFrame.professionIconBorder, Q.Theme.Text.Primary)
        Q:SetIconBorderShown(frame.titleFrame.professionIconBorder, true)
        professionIcon:ClearAllPoints()
        if classIconTexture then
            Q:SetPixelPerfectPoint(professionIcon, "LEFT", classIcon, "RIGHT", 2, 0)
        else
            Q:SetPixelPerfectPoint(professionIcon, "LEFT", frame.titleFrame.title, "RIGHT", 2, 0)
        end
        professionIcon:Show()
    else
        Q:SetIconBorderShown(frame.titleFrame.professionIconBorder, false)
        professionIcon:Hide()
    end

    local trackedIcon = frame.titleFrame.trackedIcon
    trackedIcon:ClearAllPoints()
    if professionIcon:IsShown() then
        Q:SetPixelPerfectPoint(trackedIcon, "LEFT", professionIcon, "RIGHT", 2, 0)
    elseif classIcon:IsShown() then
        Q:SetPixelPerfectPoint(trackedIcon, "LEFT", classIcon, "RIGHT", 2, 0)
    else
        Q:SetPixelPerfectPoint(trackedIcon, "LEFT", frame.titleFrame.title, "RIGHT", 2, 0)
    end
end

local function UpdateRowAppearance(frame, playerInfo)
    Q:SetPixelPerfectHeight(frame, DB_ROW_HEIGHT)
    Q:SetPixelPerfectHeight(frame.titleFrame, DB_ROW_HEIGHT)

    if frame.row.isSharedSummary then
        Q:SetTextColor(frame.titleFrame.title, "Disabled")
        frame.leftBorder:SetColorTexture(unpack(Q.Theme.Border.Accent))
        frame.sideGradient:SetGradient("HORIZONTAL", CreateColor(Q.Theme.Border.Accent[1], Q.Theme.Border.Accent[2], Q.Theme.Border.Accent[3], 0.03), CreateColor(0, 0, 0, 0))
    elseif frame.row.isInstance then
        local levelColor = Q.API:GetDifficultyColor(playerInfo.level, frame.row.minLevel)
        frame.titleFrame.level:SetTextColor(levelColor.r, levelColor.g, levelColor.b, 1)

        Q:SetTextColor(frame.titleFrame.title, "Primary")
        frame.leftBorder:SetColorTexture(unpack(Q.Theme.Text.Primary))

        Q:SetPixelPerfectHeight(frame, DB_ROW_HEIGHT + INSTANCE_ROW_EXTRA_HEIGHT)
        Q:SetPixelPerfectHeight(frame.titleFrame, DB_ROW_HEIGHT + INSTANCE_ROW_EXTRA_HEIGHT)


        frame.gradient:SetGradient("VERTICAL", CreateColor(levelColor.r, levelColor.g, levelColor.b, 0.15), CreateColor(0, 0, 0, 0))
        frame.bottomBorder:SetColorTexture(levelColor.r, levelColor.g, levelColor.b, 1)
    elseif Q.API:IsQuestCompleted(frame.row.id) then
        SetQuestStatusColor(frame.titleFrame.title, "QuestColorCompleted", "Disabled")
        SetBorderTextureColor(frame.leftBorder, "QuestColorCompleted")
        SetGradientColor(frame.sideGradient, "QuestColorCompleted")
    elseif Q.API:IsQuestInQuestLog(frame.row.id) then
        SetQuestStatusColor(frame.titleFrame.title, "QuestColorInProgress", "Success")
        SetBorderTextureColor(frame.leftBorder, "QuestColorInProgress")
        SetGradientColor(frame.sideGradient, "QuestColorInProgress")
    elseif Q.API:IsQuestAvailable(frame.row.id) then
        if frame.row.prerequisiteType == Q.PrerequisiteType.BREADCRUMB or frame.row.prerequisiteType == Q.PrerequisiteType.ANY then
            local infoR, infoG, infoB = unpack(Q.Theme.Status.Info)
            frame.titleFrame.title:SetTextColor(infoR, infoG, infoB, 1)
            frame.leftBorder:SetColorTexture(infoR, infoG, infoB)
            frame.sideGradient:SetGradient("HORIZONTAL", CreateColor(infoR, infoG, infoB, 0.03), CreateColor(0, 0, 0, 0))
        else
            SetQuestStatusColor(frame.titleFrame.title, "QuestColorAvailable", "Accent")
            SetBorderTextureColor(frame.leftBorder, "QuestColorAvailable")
            SetGradientColor(frame.sideGradient, "QuestColorAvailable")
        end
    else
        SetQuestStatusColor(frame.titleFrame.title, "QuestColorUnavailable", "Emphasized")
        SetBorderTextureColor(frame.leftBorder, "QuestColorUnavailable")
        SetGradientColor(frame.sideGradient, "QuestColorUnavailable")
    end
end

local function UpdateCollapseButton(frame)
    local row = frame.row

    if row.isInstance or (not row.isSharedSummary and #(row.prerequisites or {}) > 0) then
        frame.collapseButton:Show()
    else
        frame.collapseButton:Hide()
    end

    if row.isSharedSummary then
        return
    end
    if IsRowCollapsed(row) then
        frame.collapseButton.label:SetText("+")
    else
        frame.collapseButton.label:SetText("-")
    end
end

local function UpdateWaypointButton(frame)
    if not frame.row.isSharedSummary and (frame.row.isInstance or Q.API:IsQuestAvailable(frame.row.id)) then
        frame.waypointButton:Show()
    else
        frame.waypointButton:Hide()
    end
end

local function RemoveLastUTF8Character(text)
    local index = #text
    while index > 1 do
        local byte = string.byte(text, index)
        if byte < 128 or byte >= 192 then
            break
        end
        index = index - 1
    end
    return string.sub(text, 1, index - 1)
end

local function UpdateRowText(frame)
    local row = frame.row
    local pixelPerfect = Q:PixelPerfect(1)
    local titleFontString = frame.titleFrame.title
    local leftInset

    if row.isInstance then
        frame.titleFrame.level:SetText(string.format(" %s-%s", row.minLevel, row.maxLevel))

        titleFontString:SetFont("Fonts\\FRIZQT__.TTF", pixelPerfect * Q.Theme.FontSize.XL)
        leftInset = Q.Theme.Padding.S
        titleFontString:SetPoint("LEFT", frame.titleFrame, "LEFT", leftInset, 0)
    else
        frame.titleFrame.level:SetText("")

        if row.isMainQuest then
            titleFontString:SetFont("Fonts\\FRIZQT__.TTF", pixelPerfect * Q.Theme.FontSize.M)
            leftInset = 2 * Q.Theme.Padding.S
            titleFontString:SetPoint("LEFT", frame.titleFrame, "LEFT", leftInset, 0)
        else
            titleFontString:SetFont("Fonts\\FRIZQT__.TTF", pixelPerfect * Q.Theme.FontSize.M)
            leftInset = (3 + (row.lineageDepth or 0)) * Q.Theme.Padding.S
            titleFontString:SetPoint("LEFT", frame.titleFrame, "LEFT", leftInset, 0)
        end
    end

    local title = not row.isInstance and not row.isSharedSummary and Q:GetSetting("ShowSuggestedQuestLevel") and string.format("[%d] %s", row.suggestedLevel or 0, row.name) or row.name
    if row.prerequisiteType and row.prerequisiteType == "any" then
        title = "*" .. title
    elseif row.prerequisiteType and row.prerequisiteType == "breadcrumb" then
        title = "B: " .. title
    end

    frame.titleFrame.trackedIcon:SetShown(not row.isInstance and not row.isSharedSummary and Q.API:IsQuestInQuestLog(row.id) and Q.API:IsQuestWatched(row.id))

    -- Keep the text and any icons after it clear of the right-aligned row buttons.
    local rightInset = frame.collapseButton:GetWidth() + frame.waypointButton:GetWidth() + (Q.Theme.Padding.L + 4)
    local suffixWidth = frame.titleFrame.level:GetStringWidth()
    for _, icon in ipairs({ frame.titleFrame.classIcon, frame.titleFrame.professionIcon, frame.titleFrame.trackedIcon }) do
        if icon:IsShown() then
            suffixWidth = suffixWidth + icon:GetWidth() + 2
        end
    end
    local availableWidth = frame.titleFrame:GetWidth() - leftInset - rightInset - suffixWidth

    titleFontString:SetText(title)
    local displayedTitle = title
    if titleFontString:GetStringWidth() > availableWidth then
        local ellipsis = "..."
        local truncatedTitle = title
        repeat
            truncatedTitle = RemoveLastUTF8Character(truncatedTitle)
            displayedTitle = truncatedTitle .. ellipsis
            titleFontString:SetText(displayedTitle)
        until truncatedTitle == "" or titleFontString:GetStringWidth() <= availableWidth
    end
    titleFontString.fullText = title
    titleFontString.isTruncated = displayedTitle ~= title

end

local function CreateOrUpdateNoQuestsFoundFrame(playerInfo)
    if playerInfo.level < 9 then
        if not QuestLog.noQuestsFound then
            QuestLog.noQuestsFound = CreateFrame("Frame", "DungeonBuddy_NoQuestsFound", QuestLog.scrollChild)
            QuestLog.noQuestsFound:SetAllPoints()
            QuestLog.noQuestsFoundText = QuestLog.noQuestsFound:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            QuestLog.noQuestsFoundText:            SetFont("Fonts\\FRIZQT__.TTF", Q.Theme.FontSize.M)
            QuestLog.noQuestsFoundText:SetTextColor(unpack(Q.Theme.Text.Primary))
            QuestLog.noQuestsFoundText:SetPoint("CENTER")
            QuestLog.noQuestsFoundText:SetPoint("CENTER", QuestLog.scrollChild, "CENTER", -7.5, -30)
            QuestLog.noQuestsFoundText:SetText("No quests available.")
        end

        QuestLog.noQuestsFound:Show()
    elseif QuestLog.noQuestsFound then
        QuestLog.noQuestsFound:Hide()
    end
end

local function CreateRowFrame(index, row)
    local frame = CreateFrame("Frame", "DungeonBuddy_QuestLogRow"..index, QuestLog.scrollChild)
    QuestLog._frames[index] = frame
    frame:SetWidth(QuestLog.scrollChild:GetWidth() - 2)
    Q:SetPixelPerfectHeight(frame, DB_ROW_HEIGHT)
    Q:SetPixelPerfectPoint(frame, "TOPLEFT", QuestLog.scrollChild, "TOPLEFT", 1, 0)

    frame.background = frame:CreateTexture(nil, "BACKGROUND")
    frame.background:SetAllPoints(frame)
    frame.background:SetColorTexture(unpack(Q.Theme.Background.Tertiary))
    frame.background:SetAlpha(0.2)

    frame.gradient = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
    frame.gradient:SetAllPoints(frame)
    frame.gradient:SetColorTexture(1, 1, 1, 1)
    local bottomR, bottomG, bottomB = unpack(Q.Theme.Text.Accent)
    frame.gradient:SetGradient("VERTICAL", CreateColor(bottomR, bottomG, bottomB, 0.15), CreateColor(0, 0, 0, 0))
    frame.gradient:Hide()

    frame.sideGradient = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
    frame.sideGradient:SetAllPoints(frame)
    frame.sideGradient:SetColorTexture(1, 1, 1, 1)
    frame.sideGradient:SetGradient("HORIZONTAL", CreateColor(0, 0, 0, 0.05), CreateColor(0, 0, 0, 0))
    frame.sideGradient:Hide()

    frame.bottomBorder = frame:CreateTexture(nil, "OVERLAY")
    frame.bottomBorder:SetColorTexture(unpack(Q.Theme.Text.Accent))
    frame.bottomBorder:SetHeight(Q:PixelPerfect(1))
    frame.bottomBorder:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
    frame.bottomBorder:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
    frame.bottomBorder:Hide()

    local leftBorder = frame:CreateTexture(nil, "OVERLAY")
    frame.leftBorder = leftBorder
    leftBorder:SetColorTexture(unpack(Q.Theme.Border.Accent))
    leftBorder:SetWidth(Q:PixelPerfect(3))
    leftBorder:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    leftBorder:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)

    --------------------------------------------------
    -- Create Title
    --------------------------------------------------
    frame.titleFrame = CreateFrame("Frame", nil, frame)
    frame.titleFrame:SetWidth(QuestLog.scrollChild:GetWidth())
    Q:SetPixelPerfectHeight(frame.titleFrame, DB_ROW_HEIGHT)
    Q:SetPixelPerfectPoint(frame.titleFrame, "TOPLEFT", frame, "TOPLEFT", 0, 0)

    frame.titleFrame.title = Q:CreateText(nil, frame.titleFrame, row.name, row.isInstance and Q.Theme.FontSize.XL or Q.Theme.FontSize.M)
    frame.titleFrame.title:SetPoint("LEFT", frame.titleFrame, "LEFT", Q.Theme.Padding.S, 0)
    frame.titleFrame.title:SetJustifyH("LEFT")

    frame.titleFrame.trackedIcon = frame.titleFrame:CreateTexture(nil, "ARTWORK")
    frame.titleFrame.trackedIcon:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
    Q:SetPixelPerfectSize(frame.titleFrame.trackedIcon, DB_ROW_HEIGHT - 2, DB_ROW_HEIGHT - 2)
    frame.titleFrame.trackedIcon:Hide()

    frame.titleFrame.level = Q:CreateText(nil, frame.titleFrame, "", Q.Theme.FontSize.L)
    frame.titleFrame.level:SetPoint("LEFT", frame.titleFrame.title, "RIGHT", 2, 0)
    frame.titleFrame.level:SetJustifyH("LEFT")

    frame.titleFrame.classIcon = frame.titleFrame:CreateTexture(nil, "ARTWORK")
    Q:SetPixelPerfectPoint(frame.titleFrame.classIcon, "LEFT", frame.titleFrame.title, "RIGHT", Q.Theme.Padding.S, 0)
    Q:SetPixelPerfectSize(frame.titleFrame.classIcon, DB_ROW_HEIGHT - 2, DB_ROW_HEIGHT - 2)
    frame.titleFrame.classIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    frame.titleFrame.classIconBorder = Q:CreateIconBorder(frame.titleFrame, frame.titleFrame.classIcon)

    frame.titleFrame.professionIcon = frame.titleFrame:CreateTexture(nil, "ARTWORK")
    Q:SetPixelPerfectSize(frame.titleFrame.professionIcon, DB_ROW_HEIGHT - 2, DB_ROW_HEIGHT - 2)
    frame.titleFrame.professionIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    frame.titleFrame.professionIconBorder = Q:CreateIconBorder(frame.titleFrame, frame.titleFrame.professionIcon)

    --------------------------------------------------
    -- Create Action Buttons
    --------------------------------------------------
    local collapseHandlers = {
        OnClick = function()
            local clickedRow = frame.row
            if not clickedRow then
                return
            end

            local settingPath = clickedRow.isInstance and "CollapsedInstances" or "CollapsedQuests"
            local collapsedRows = clickedRow.isInstance and Q:GetSetting("CollapsedInstances") or Q:GetSetting("CollapsedQuests")
            local collapseKey = clickedRow.isInstance and clickedRow.id or clickedRow.collapseKey
            if collapsedRows[collapseKey] then
                collapsedRows[collapseKey] = nil
            else
                collapsedRows[collapseKey] = true
            end
            Q:SetSetting(settingPath, collapsedRows)
            QuestLog:RefreshAndPopulate()
        end,
        OnMouseEnter = function(self)
            local tooltip = Q:GetTooltip()
            local accentR, accentG, accentB = unpack(Q.Theme.Text.Accent)
            local primaryR, primaryG, primaryB = unpack(Q.Theme.Text.Primary)

            tooltip:SetOwner(self, "ANCHOR_TOPLEFT", 5, 5)
            tooltip:SetText("Expand/Collapse Section", accentR, accentG, accentB)
            tooltip:AddLine("Click to expand/collapse this section.", primaryR, primaryG, primaryB, true)
            tooltip:Show()
        end,
        OnMouseLeave = function()
            local tooltip = Q:GetTooltip()
            tooltip:Hide()
        end
    }
    frame.collapseButton = Q:CreateButton(nil, frame, "+", DB_ROW_HEIGHT, DB_ROW_HEIGHT, Q.Theme.FontSize.M, Q.Theme.Text.Secondary, collapseHandlers)
    frame.collapseButton:SetPoint("RIGHT", frame.titleFrame, "RIGHT", -Q.Theme.Padding.L, 0)
    
    local waypointHandlers = {
        OnClick = function(self)
            if self.isDisabled then
                return
            end
            
            if not frame.row then
                return
            end

            self.isDisabled = true
            self:SetAlpha(0.5)
            Q.API:SetWaypoint(frame.row, frame.row.isInstance)

            C_Timer.After(2, function()
                self.isDisabled = false
                self:SetAlpha(1)
            end)
        end,
        OnMouseEnter = function(self)
            local tooltip = Q:GetTooltip()
            local r, g, b = unpack(Q.Theme.Text.Primary)
            local hasMultipleSources = frame.row.sources and #frame.row.sources > 1

            tooltip:SetOwner(self, "ANCHOR_TOPLEFT", 5, 5)
            tooltip:SetText(frame.row.isInstance and "Find Entrance" or "Find Source", unpack(Q.Theme.Text.Accent))
            tooltip:AddLine(string.format("Add a waypoint to %s.", frame.row.isInstance and "the instance entrance" or (hasMultipleSources and "all of this quests sources" or "this quest's source")), r, g, b, true)
            tooltip:Show()
        end,
        OnMouseLeave = function()
            local tooltip = Q:GetTooltip()
            tooltip:Hide()
        end
    }
    frame.waypointButton = Q:CreateButton(nil, frame, "", DB_ROW_HEIGHT, DB_ROW_HEIGHT, Q.Theme.FontSize.M, Q.Theme.Background.Accent, waypointHandlers)
    frame.waypointButton.icon = frame.waypointButton:CreateTexture(nil, "ARTWORK")
    frame.waypointButton.icon:SetTexture("Interface\\AddOns\\DungeonBuddy\\Media\\Waypoint.png")
    Q:SetPixelPerfectSize(frame.waypointButton.icon, DB_ROW_HEIGHT * 0.7, DB_ROW_HEIGHT * 0.7)
    frame.waypointButton.icon:SetPoint("CENTER")
    frame.waypointButton:SetPoint("RIGHT", frame.collapseButton, "LEFT", -2, 0)

    frame.titleHover = CreateFrame("Frame", nil, frame)
    frame.titleHover:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    -- End the hoverable area before the action buttons so they remain clickable.
    frame.titleHover:SetPoint("BOTTOMRIGHT", frame.waypointButton, "BOTTOMLEFT", -2, 0)
    frame.titleHover:EnableMouse(true)
    frame.titleHover:SetScript("OnMouseUp", function(_, button)
        local clickedRow = frame.row
        if button ~= "LeftButton" or not clickedRow or clickedRow.isSharedSummary then
            return
        end

        -- Left click -> Collapse/Expand row
        if not IsShiftKeyDown() then
            if frame.collapseButton:IsShown() then
                collapseHandlers.OnClick()
            end
            return
        end

        if clickedRow.isInstance then
            return
        end

        if not Q.API:IsQuestInQuestLog(clickedRow.id) then
            return
        end

        -- Shift-click -> Toggle quest tracking
        if Q.API:IsQuestWatched(clickedRow.id) then
            C_QuestLog.RemoveQuestWatch(clickedRow.id)
        else
            C_QuestLog.AddQuestWatch(clickedRow.id)
        end
        QuestLog:RefreshAndPopulate()
    end)

    frame.hoverHighlight = frame:CreateTexture(nil, "BACKGROUND", nil, 2)
    frame.hoverHighlight:SetAllPoints(frame)
    frame.hoverHighlight:SetColorTexture(unpack(Q.Theme.Text.Primary))
    frame.hoverHighlight:SetAlpha(0.03)
    frame.hoverHighlight:Hide()
    frame.titleHover:SetScript("OnEnter", function()
        if frame.row.isInstance or frame.row.isSharedSummary then
            return
        end

        frame.hoverHighlight:Show()
        local hoveredRow = frame.row
        if not hoveredRow then
            return
        end

        local tooltip = Q:GetTooltip()
        tooltip:SetOwner(frame.titleFrame, "ANCHOR_LEFT", -5, 5)

        local colorInProgress = Q:GetSetting("QuestColorInProgress")
        local colorUnavailable = Q:GetSetting("QuestColorUnavailable")
        local colorAvailable = Q:GetSetting("QuestColorAvailable")
        local tooltipStatus
        local tooltipStatusColor
        local isQuestInLog = Q.API:IsQuestInQuestLog(hoveredRow.id)
        local meetsPrerequisites = Q.API:IsQuestAvailableToLevel(hoveredRow.id) and Q.API:IsPrerequisiteSatisfied(hoveredRow.id)
        local isQuestAvailable = Q.API:IsQuestAvailable(hoveredRow.id)
        
        if isQuestInLog then
            tooltipStatus = "Track Quest"
            tooltipStatusColor = colorInProgress
        elseif not meetsPrerequisites then
            tooltipStatus = "Prerequisite Not Met"
            tooltipStatusColor = colorUnavailable
        elseif isQuestAvailable then
            tooltipStatus = "Available"
            tooltipStatusColor = colorAvailable
        else
            tooltipStatus = "Unavailable"
            tooltipStatusColor = colorUnavailable
        end

        tooltip:SetText(hoveredRow.name, Q.Theme.Text.Accent[1], Q.Theme.Text.Accent[2], Q.Theme.Text.Accent[3])
        tooltip:AddLine(tooltipStatus, tooltipStatusColor.r, tooltipStatusColor.g, tooltipStatusColor.b)

        --------------------------------------------------
        -- Determine tooltip content
        --------------------------------------------------

        -- Player has the quest in their quest log
        if isQuestInLog then
            tooltip:AddLine("Shift-click to toggle tracking this quest", Q.Theme.Text.Primary[1], Q.Theme.Text.Primary[2], Q.Theme.Text.Primary[3], true)
        -- Player does not meet the quest prerequisites (Too low level, prequests not completed, wrong class etc)
        elseif not meetsPrerequisites then
            
            if not Q.API:IsQuestAvailableToLevel(hoveredRow.id) then
                tooltip:AddLine("Requires level " .. hoveredRow.requiredLevel, Q.Theme.Text.Disabled[1], Q.Theme.Text.Disabled[2], Q.Theme.Text.Disabled[3])
            end

            if not Q.API:IsPrerequisiteSatisfied(hoveredRow.id) then
                local missingRequired = {}
                local incompleteChoices = {}
                local hasCompletedChoice = false
                local quest = Q.API:GetQuestById(hoveredRow.id)

                -- Because changing color of text without using multiple font strings requires hex codes, we need to convert colors
                local function GetQuestColorCode(questId)
                    local settingPath, fallbackKey
                    if Q.API:IsQuestCompleted(questId) then
                        settingPath, fallbackKey = "QuestColorCompleted", "Disabled"
                    elseif Q.API:IsQuestInQuestLog(questId) then
                        settingPath, fallbackKey = "QuestColorInProgress", "Success"
                    elseif Q.API:IsQuestAvailable(questId) then
                        settingPath, fallbackKey = "QuestColorAvailable", "Accent"
                    else
                        settingPath, fallbackKey = "QuestColorUnavailable", "Emphasized"
                    end

                    local color = Q:GetSetting(settingPath)
                    local fallback = Q.Theme.Text[fallbackKey]
                    local r = color and color.r or fallback[1]
                    local g = color and color.g or fallback[2]
                    local b = color and color.b or fallback[3]
                    return Q:ColorToHex({ r = r, g = g, b = b })
                end

                for _, prerequisite in ipairs(quest and quest.prerequisites or {}) do
                    local prerequisiteQuest = Q.API:GetQuestById(prerequisite.id)
                    if prerequisiteQuest then
                        if prerequisite.type == Q.PrerequisiteType.CHAIN or prerequisite.type == Q.PrerequisiteType.REQUIRED then
                            if not Q.API:IsQuestCompleted(prerequisite.id) then
                                table.insert(missingRequired, { id = prerequisite.id, name = prerequisiteQuest.name })
                            end
                        elseif prerequisite.type == Q.PrerequisiteType.ANY then
                            if Q.API:IsQuestCompleted(prerequisite.id) then
                                hasCompletedChoice = true
                            else
                                table.insert(incompleteChoices, { id = prerequisite.id, name = prerequisiteQuest.name })
                            end
                        end
                    end
                end

                if #missingRequired > 1 then
                    tooltip:AddLine("You must complete the following quests first:", Q.Theme.Text.Primary[1], Q.Theme.Text.Primary[2], Q.Theme.Text.Primary[3], true)
                    for _, prerequisiteQuest in ipairs(missingRequired) do
                        local coloredName = GetQuestColorCode(prerequisiteQuest.id) .. prerequisiteQuest.name .. "|r"
                        tooltip:AddLine(coloredName, Q.Theme.Text.Primary[1], Q.Theme.Text.Primary[2], Q.Theme.Text.Primary[3], true)
                    end
                elseif #missingRequired == 1 then
                    local prerequisiteQuest = missingRequired[1]
                    local coloredName = GetQuestColorCode(prerequisiteQuest.id) .. prerequisiteQuest.name .. "|r"
                    tooltip:AddLine("You must complete the quest " .. coloredName .. " first.", Q.Theme.Text.Primary[1], Q.Theme.Text.Primary[2], Q.Theme.Text.Primary[3], true)
                end
                if not hasCompletedChoice and #incompleteChoices > 0 then
                    tooltip:AddLine("You must complete one of the following quests first:", Q.Theme.Text.Primary[1], Q.Theme.Text.Primary[2], Q.Theme.Text.Primary[3], true)
                    for _, prerequisiteQuest in ipairs(incompleteChoices) do
                        local coloredName = GetQuestColorCode(prerequisiteQuest.id) .. prerequisiteQuest.name .. "|r"
                        tooltip:AddLine(coloredName, Q.Theme.Text.Primary[1], Q.Theme.Text.Primary[2], Q.Theme.Text.Primary[3], true)
                    end
                end
                if #missingRequired == 0 and (hasCompletedChoice or #incompleteChoices == 0) then
                    tooltip:AddLine("You must complete the prerequisite quests before this quest becomes available.", Q.Theme.Text.Primary[1], Q.Theme.Text.Primary[2], Q.Theme.Text.Primary[3], true)
                end
            end
        -- Player meets all prerequisites and the quest is available
        elseif isQuestAvailable then
            local quest = Q.API:GetQuestById(hoveredRow.id)
            local playerFaction = Q.API:GetPlayerFaction()
            local sources = {}
            local successColor = Q.Theme.Status.Success
            local successColorCode = Q:ColorToHex(successColor)
            if quest then
                if quest.source then
                    if not quest.source.faction or quest.source.faction == playerFaction then
                        table.insert(sources, quest.source)
                    end
                else
                    for _, source in ipairs(quest.sources or {}) do
                        if not source.faction or source.faction == playerFaction then
                            table.insert(sources, source)
                        end
                    end
                end
            end

            if #sources == 1 then
                local source = sources[1]
                local location = source.zone and (" in " .. source.zone) or ""
                tooltip:AddLine("Started by " .. successColorCode .. source.name .. "|r" .. location .. ".", Q.Theme.Text.Primary[1], Q.Theme.Text.Primary[2], Q.Theme.Text.Primary[3], true)
                if source.text then
                    tooltip:AddLine(source.text, Q.Theme.Status.Info[1], Q.Theme.Status.Info[2], Q.Theme.Status.Info[3], true)
                end
            elseif #sources > 1 then
                tooltip:AddLine("Started by:", Q.Theme.Text.Primary[1], Q.Theme.Text.Primary[2], Q.Theme.Text.Primary[3], true)
                for _, source in ipairs(sources) do
                    local location = source.zone and (" in " .. source.zone) or ""
                    tooltip:AddLine(successColorCode .. source.name .. "|r" .. location, Q.Theme.Text.Primary[1], Q.Theme.Text.Primary[2], Q.Theme.Text.Primary[3], true)
                    if source.text then
                        tooltip:AddLine(source.text, Q.Theme.Status.Info[1], Q.Theme.Status.Info[2], Q.Theme.Status.Info[3], true)
                    end
                end
            end
        end

        -- If the quest being hovered is a breadcrumb quest or an optional choice, add the appropriate tooltip message to the already added texts.
        if hoveredRow.prerequisiteType == Q.PrerequisiteType.ANY then
            tooltip:AddLine(" ")
            tooltip:AddLine("Optional Choice", Q.Theme.Status.Info[1], Q.Theme.Status.Info[2], Q.Theme.Status.Info[3], true)
            tooltip:AddLine("You only need to complete one of the quests marked with * to unlock the next quest.", Q.Theme.Text.Primary[1], Q.Theme.Text.Primary[2], Q.Theme.Text.Primary[3], true)
        elseif hoveredRow.prerequisiteType == Q.PrerequisiteType.BREADCRUMB then
            tooltip:AddLine(" ")
            tooltip:AddLine("Breadcrumb", Q.Theme.Status.Info[1], Q.Theme.Status.Info[2], Q.Theme.Status.Info[3], true)
            tooltip:AddLine("Not required to unlock the next quest. Breadcrumb quests are only meant to guide players to a quest giver.", Q.Theme.Text.Primary[1], Q.Theme.Text.Primary[2], Q.Theme.Text.Primary[3], true)
        end

        tooltip:Show()
    end)
    frame.titleHover:SetScript("OnLeave", function()
        frame.hoverHighlight:Hide()
        Q:GetTooltip():Hide()
    end)

    return frame
end

function QuestLog:RefreshAndPopulate()
    self.rows = {}
    self._frames = self._frames or {}

    local totalOffset = 0
    local playerInfo = Q.API:GetPlayerInfo()

    CreateOrUpdateNoQuestsFoundFrame(playerInfo)

    local instances = Q.API:GetInstances()

    -- First build the rows table with all instances, quests, and chain quests, only adding rows that are not hidden
    for _, instance in pairs(instances) do
        if Q.API:InstanceHasAvailableQuests(instance.id, playerInfo) and playerInfo.level <= instance.maxLevel then
            local isCollapsed = Q:GetSetting("CollapsedInstances")[instance.id] or false
            local quests
            if Q:GetSetting("ShowAllQuestsForAvailableInstance") then
                quests = {}
                for _, quest in ipairs(Q.API:GetQuestsByInstanceId(instance.id)) do
                    if Q.API:PlayerHasProfession(quest.profession) then
                        table.insert(quests, quest)
                    end
                end
            else
                quests = Q.API:GetAvailableQuestsByInstanceId(instance.id, playerInfo)
            end
            table.sort(quests, function(a, b) return a.name < b.name end)
            instance.isInstance = true

            table.insert(self.rows, instance)
            
            if not isCollapsed then
                for _, quest in ipairs(quests) do
                    local questRow = CopyRow(quest)
                    questRow.isMainQuest = true
                    questRow.collapseKey = string.format("instance:%s/quest:%s", tostring(instance.id), tostring(quest.id))
                    local questIsCollapsed = IsRowCollapsed(questRow)
                    if not Q:GetSetting("HideCompletedQuests") or not Q.API:IsQuestCompleted(quest.id) then
                        table.insert(self.rows, questRow)
                    end

                    if not questIsCollapsed and (not Q:GetSetting("HideCompletedQuests") or not Q.API:IsQuestCompleted(quest.id)) then
                        AppendRelatedRows(quest, 0, nil, questRow.collapseKey)
                    end
                end
            end
        end
    end

    local prevRowHeight = DB_ROW_HEIGHT
    for index, row in ipairs(self.rows) do
        local frame = self._frames[index] -- Frames cannot be destroyed so we reuse frames by id and create a new if we have a longer list

        if not frame then
            frame = CreateRowFrame(index, row)
        end

        --------------------------------------------------
        -- Update Row Frame
        --------------------------------------------------
        frame:Show()
        frame.row = row

        frame.titleHover:ClearAllPoints()
        frame.titleHover:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
        frame.titleHover:SetPoint(
            "BOTTOMRIGHT",
            frame.waypointButton,
            "BOTTOMLEFT",
            -2,
            row.isInstance and -(INSTANCE_ROW_EXTRA_HEIGHT / 2) or 0
        )
        
        UpdateClassIcon(frame)
        UpdateRowText(frame)
        UpdateRowAppearance(frame, playerInfo)
        UpdateCollapseButton(frame)
        UpdateWaypointButton(frame)
        
        frame.sideGradient:SetShown(not row.isInstance and true or false)
        frame.gradient:SetShown(row.isInstance and true or false)
        frame.bottomBorder:SetShown(row.isInstance and true or false)
        if row.isInstance then
            frame.background:SetAlpha(0)
            frame.leftBorder:SetAlpha(0)
        else
            frame.background:SetAlpha(0.2)
            frame.leftBorder:SetAlpha(1)
        end

        local rowOffset
        if index == 1 then
            rowOffset = 0
        else
            rowOffset = prevRowHeight + 2
        end
        prevRowHeight = row.isInstance and (DB_ROW_HEIGHT + INSTANCE_ROW_EXTRA_HEIGHT) or DB_ROW_HEIGHT

        Q:SetPixelPerfectPoint(frame, "TOPLEFT", self.scrollChild, "TOPLEFT", 1, -(rowOffset + totalOffset))
        totalOffset = totalOffset + rowOffset
    end

    for index = #self.rows + 1, #self._frames do
        self._frames[index]:Hide()
        self._frames[index].row = nil
    end

    Q:SetPixelPerfectHeight(self.scrollChild, math.max(1, totalOffset + DB_ROW_HEIGHT + Q:PixelPerfect(50)))
end

function QuestLog:Toggle()
    if not self.frame then
        self:Create()
        return
    end

    if self.frame and self.frame:IsShown() then
        self.frame:Hide()
    else
        self:RefreshAndPopulate()
        self.frame:Show()
    end
end

function QuestLog:Reload()
    if not self.frame then
        self:Create()
        return
    end

    self:RefreshAndPopulate()
    self.frame:Show()
end

function QuestLog:OnDisable()
    self:UnregisterEvent("QUEST_LOG_UPDATE")
    self:UnregisterEvent("QUEST_WATCH_LIST_CHANGED")
    self:UnregisterEvent("QUEST_TURNED_IN")
    self:UnregisterEvent("QUEST_ACCEPTED")
    self:UnregisterEvent("PLAYER_LEVEL_UP")

    if self.frame then
        self.frame:Hide()
    end
end

function QuestLog:OnEnable()
    self:RegisterEvent("QUEST_LOG_UPDATE", "OnQuestStateChanged")
    self:RegisterEvent("QUEST_WATCH_LIST_CHANGED", "OnQuestStateChanged")
    self:RegisterEvent("QUEST_TURNED_IN", "OnQuestStateChanged")
    self:RegisterEvent("QUEST_ACCEPTED", "OnQuestStateChanged")
    self:RegisterEvent("PLAYER_LEVEL_UP", "OnQuestStateChanged")
end

-- QUEST_LOG_UPDATE fires in bursts, so refreshes are coalesced and skipped while the log is hidden
-- (Toggle and Reload both refresh before showing it).
function QuestLog:OnQuestStateChanged()
    if not self.frame or not self.frame:IsShown() or self.refreshPending then
        return
    end

    self.refreshPending = true
    C_Timer.After(0.2, function()
        self.refreshPending = false
        if self.frame and self.frame:IsShown() then
            self:RefreshAndPopulate()
        end
    end)
end
