local _, Q = ...
local QuestLog = Q.Addon:NewModule("QuestLog", "AceEvent-3.0", "AceConsole-3.0")
Q.QuestLog = QuestLog

local DB_ROW_HEIGHT = Q.Theme.Font.XL + 6
local DUNGEON_ROW_EXTRA_HEIGHT = 20

function QuestLog:Create()
    if self.frame then
        return self.frame
    end

    local containerWidth = 500

    --------------------------------------------------
    -- Create QuestLog Frame
    --------------------------------------------------
    self.frame = Q:CreateBackdropFrame('DungeonBuddy_QuestLogFrame', UIParent, containerWidth, 600, "HIGH", "Primary", "Default", 0.9, 0.25)

    self.frame:SetMovable(true)
    self.frame:EnableMouse(true)
    self.frame:RegisterForDrag("LeftButton")

    self.frame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    self.frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        Q:ClampFrameToScreen(self)

        local x, y = self:GetCenter()
        local centerX, centerY = UIParent:GetCenter()
        Q:SetSetting("QuestLogFrame.X", Q:PixelPerfect(x - centerX))
        Q:SetSetting("QuestLogFrame.Y", Q:PixelPerfect(y - centerY))
    end)

    self.frame:SetPoint("CENTER", UIParent, "CENTER", Q:GetSetting("QuestLogFrame.X") or 500, Q:GetSetting("QuestLogFrame.Y") or 0)
    Q:ClampFrameToScreen(self.frame)

    local closeButton = Q:CreateCloseButton(self.frame, "DungeonBuddy_QuestLogCloseButton")

    --------------------------------------------------
    -- QuestLog Header
    --------------------------------------------------
    self.header = Q:CreateFrame("QuestLogHeader", self.frame, containerWidth, 50, "HIGH")
    Q:SetPixelPerfectPoint(self.header, "TOP", self.frame, "TOP", 0, 0)
    Q:SetPixelPerfectPoint(self.header, "LEFT", self.frame, "LEFT", 0, 0)
    Q:SetPixelPerfectPoint(self.header, "RIGHT", self.frame, "RIGHT", 0, 0)

    local border = self.header:CreateTexture(nil, "OVERLAY")
    local borderR, borderG, borderB = unpack(Q.Theme.Border.Default)
    border:SetColorTexture(borderR, borderG, borderB, 0.25)
    border:SetHeight(Q:PixelPerfect(1))
    Q:SetPixelPerfectPoint(border, "BOTTOMLEFT", self.header, "BOTTOMLEFT", 0, 0)
    Q:SetPixelPerfectPoint(border, "BOTTOMRIGHT", self.header, "BOTTOMRIGHT", 0, 0)

    self.header.text = Q:CreateText("QuestLogHeaderText", self.header, "Dungeon Buddy", Q.Theme.Font.XXL, "Accent", 1)
    self.header.text:SetJustifyH("LEFT")
    Q:SetPixelPerfectPoint(self.header.text, "LEFT", self.header, "LEFT", Q.Theme.Padding.S, 0)

    --------------------------------------------------
    -- Action Buttons
    --------------------------------------------------
    local actionHandlers = {
        OnClick = function(self)
            if #Q:GetSetting("CollapsedQuests") > 0 or #Q:GetSetting("CollapsedDungeons") > 0 then
                Q:SetSetting("CollapsedQuests", {})
                Q:SetSetting("CollapsedDungeons", {})
                Q.QuestLog:RefreshAndPopulate()

                self.label:SetText("-")
            else
                local quests = {}
                local dungeons = {}

                for _, row in ipairs(Q.API:GetQuests()) do
                    table.insert(quests, row.id)
                end

                for _, row in ipairs(Q.API:GetDungeons()) do
                    table.insert(dungeons, row.id)
                end
                
                Q:SetSetting("CollapsedQuests", quests)
                Q:SetSetting("CollapsedDungeons", dungeons)
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

    local initialText = (#Q:GetSetting("CollapsedQuests") > 0 or #Q:GetSetting("CollapsedDungeons") > 0) and "+" or "-"
    local collapseAndExpandButton = Q:CreateTransparentButton("DungeonBuddy_CollapseAndExpandButton", self.frame, initialText, 24, 24, Q.Theme.Font.M, Q.Theme.Text.Secondary, actionHandlers)
    collapseAndExpandButton:SetPoint("RIGHT", closeButton, "LEFT", -2, 0)
    
    --------------------------------------------------
    -- QuestLog Content Container
    --------------------------------------------------
    self.contentContainer = CreateFrame("ScrollFrame", "DungeonBuddy_QuestLogContentContainer", self.frame, "UIPanelScrollFrameTemplate")
    Q:SetPixelPerfectPoint(self.contentContainer, "TOPLEFT", self.header, "BOTTOMLEFT", 0, 0)
    Q:SetPixelPerfectPoint(self.contentContainer, "BOTTOMRIGHT", self.frame, "BOTTOMRIGHT", 0, 0)
    self.contentContainer:EnableMouseWheel(true)

    self.scrollChild = CreateFrame("Frame", "DungeonBuddy_QuestLogContentContainerChild", self.contentContainer)
    Q:SetPixelPerfectSize(self.scrollChild, containerWidth, 1)
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
            thumb:SetColorTexture(unpack(Q.Theme.Border.Default))
            Q:SetPixelPerfectWidth(thumb, 4)
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
    if row.isDungeon then
        return Q:GetSetting("CollapsedDungeons")[row.id] or false
    else
        return Q:GetSetting("CollapsedQuests")[row.id] or false
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

-- Adds a chain-style info row below a quest the player is too low level for. It reuses the
-- isSharedSummary row type, which has no buttons, a disabled colour and no quest-specific text.
local function InsertLevelRequirementRow(row, depth)
    if row.isDungeon or not row.requiredLevel or not Q:GetSetting("ShowAllQuestsForAvailableDungeon") then
        return
    end

    if row.requiredLevel > Q.API:GetPlayerLevel() then
        table.insert(QuestLog.rows, {
            id = "level:" .. tostring(row.id) .. ":" .. #QuestLog.rows,
            name = string.format("Requires Level %d", row.requiredLevel),
            isSharedSummary = true,
            lineageDepth = depth,
        })
    end
end

-- "visited" holds every quest already listed under the current main quest, so a chain shared by
-- several alternatives is only expanded once and referenced with a summary row afterwards.
local function AppendRelatedRows(quest, depth, visited)
    if not quest then
        return
    end

    depth = depth or 0
    visited = visited or { [quest.id] = true }

    local function AddDependency(questId, dependencyType)
        local dependency = Q.API:GetQuestById(questId)
        local row = dependency and CopyRow(dependency) or {
            id = questId,
            name = "Missing QuestId [" .. tostring(questId) .. "]",
        }
        row.isChainQuest = dependencyType == "chain"
        row.isPrerequisite = dependencyType ~= "chain"
        row.prerequisiteType = dependencyType
        row.lineageDepth = depth + 1

        local isHidden = Q:GetSetting("HideCompletedQuests") and Q.API:IsQuestCompleted(questId)
        if not isHidden then
            table.insert(QuestLog.rows, row)
            InsertLevelRequirementRow(row, depth + 2)
        end

        if IsRowCollapsed(row) or not dependency then
            return
        end

        if not visited[questId] then
            visited[questId] = true
            AppendRelatedRows(dependency, depth + 1, visited)
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

    -- A breadcrumb only points toward this quest, so it is pointless once this quest is hidden as completed.
    local hideBreadcrumbs = Q:GetSetting("HideCompletedQuests") and Q.API:IsQuestCompleted(quest.id)

    for _, prerequisite in ipairs(quest.prerequisites or {}) do
        local isHiddenBreadcrumb = hideBreadcrumbs and prerequisite.type == Q.PrerequisiteType.BREADCRUMB
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

local function UpdateClassIcon(frame)
    local classIcon = frame.titleFrame.classIcon
    local professionIcon = frame.titleFrame.professionIcon
    local classIconTexture = not frame.row.isDungeon and Q.API:GetClassIconTexture(frame.row.class)
    local professionIconTexture = not frame.row.isDungeon and Q.API:GetProfessionIconTexture(frame.row.profession)

    if classIconTexture then
        classIcon:SetTexture(classIconTexture)
        classIcon:Show()
    else
        classIcon:Hide()
    end

    if professionIconTexture then
        professionIcon:SetTexture(professionIconTexture)
        professionIcon:ClearAllPoints()
        if classIconTexture then
            Q:SetPixelPerfectPoint(professionIcon, "LEFT", classIcon, "RIGHT", Q.Theme.Padding.S, 0)
        else
            Q:SetPixelPerfectPoint(professionIcon, "LEFT", frame.titleFrame.title, "RIGHT", Q.Theme.Padding.S, 0)
        end
        professionIcon:Show()
    else
        professionIcon:Hide()
    end
end

local function UpdateRowAppearance(frame, playerInfo)
    Q:SetPixelPerfectHeight(frame, DB_ROW_HEIGHT)
    Q:SetPixelPerfectHeight(frame.titleFrame, DB_ROW_HEIGHT)

    if frame.row.isSharedSummary then
        Q:SetTextColor(frame.titleFrame.title, "Disabled")
        frame.leftBorder:SetColorTexture(unpack(Q.Theme.Border.Accent))
    elseif frame.row.isDungeon then
        local levelColor = Q.API:GetDifficultyColor(playerInfo.level, frame.row.minLevel)
        frame.titleFrame.level:SetTextColor(levelColor.r, levelColor.g, levelColor.b, 1)

        Q:SetTextColor(frame.titleFrame.title, "Primary")
        frame.leftBorder:SetColorTexture(unpack(Q.Theme.Text.Primary))

        Q:SetPixelPerfectHeight(frame, DB_ROW_HEIGHT + DUNGEON_ROW_EXTRA_HEIGHT)
        Q:SetPixelPerfectHeight(frame.titleFrame, DB_ROW_HEIGHT + DUNGEON_ROW_EXTRA_HEIGHT)


        frame.gradient:SetGradient("VERTICAL", CreateColor(levelColor.r, levelColor.g, levelColor.b, 0.15), CreateColor(0, 0, 0, 0))
        frame.bottomBorder:SetColorTexture(levelColor.r, levelColor.g, levelColor.b, 1)
    elseif Q.API:IsQuestCompleted(frame.row.id) then
        SetQuestStatusColor(frame.titleFrame.title, "QuestColorCompleted", "Disabled")
        SetBorderTextureColor(frame.leftBorder, "QuestColorCompleted")
    elseif Q.API:IsQuestInQuestLog(frame.row.id) then
        SetQuestStatusColor(frame.titleFrame.title, "QuestColorInProgress", "Success")
        SetBorderTextureColor(frame.leftBorder, "QuestColorInProgress")
    elseif Q.API:IsQuestAvailable(frame.row.id) then
        SetQuestStatusColor(frame.titleFrame.title, "QuestColorAvailable", "Accent")
        SetBorderTextureColor(frame.leftBorder, "QuestColorAvailable")
    else
        SetQuestStatusColor(frame.titleFrame.title, "QuestColorUnavailable", "Emphasized")
        SetBorderTextureColor(frame.leftBorder, "QuestColorUnavailable")
    end
end

local function UpdateCollapseButton(frame)
    local row = frame.row

    if row.isDungeon or (not row.isSharedSummary and #(row.prerequisites or {}) > 0) then
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
    if not frame.row.isSharedSummary and (frame.row.isDungeon or Q.API:IsQuestAvailable(frame.row.id)) then
        frame.waypointButton:Show()
    else
        frame.waypointButton:Hide()
    end
end

local function UpdateRowText(frame)
    local row = frame.row
    local pixelPerfect = Q:PixelPerfect(1)

    if row.isDungeon then
        frame.titleFrame.level:SetText(string.format(" %s-%s", row.minLevel, row.maxLevel))

        frame.titleFrame.title:SetFont("Fonts\\FRIZQT__.TTF", pixelPerfect * Q.Theme.Font.XL)
        Q:SetPixelPerfectPoint(frame.titleFrame.title, "LEFT", frame.titleFrame, "LEFT", Q.Theme.Padding.S, 0)
    else
        frame.titleFrame.level:SetText("")

        if row.isMainQuest then
            frame.titleFrame.title:SetFont("Fonts\\FRIZQT__.TTF", pixelPerfect * Q.Theme.Font.M)
            Q:SetPixelPerfectPoint(frame.titleFrame.title, "LEFT", frame.titleFrame, "LEFT", 2 * Q.Theme.Padding.S, 0)
        else
            frame.titleFrame.title:SetFont("Fonts\\FRIZQT__.TTF", pixelPerfect * Q.Theme.Font.M)
            Q:SetPixelPerfectPoint(frame.titleFrame.title, "LEFT", frame.titleFrame, "LEFT", (3 + (row.lineageDepth or 0)) * Q.Theme.Padding.S, 0)
        end
    end

    local title = not row.isDungeon and not row.isSharedSummary and Q:GetSetting("ShowSuggestedQuestLevel") and string.format("[%d] %s", row.suggestedLevel or 0, row.name) or row.name
    if row.prerequisiteType and row.prerequisiteType == "any" then
        title = "*" .. title
    elseif row.prerequisiteType and row.prerequisiteType == "breadcrumb" then
        title = "B: " .. title
    end

    frame.titleFrame.title:SetText(title)
end

local function CreateOrUpdateNoQuestsFoundFrame(playerInfo)
    if playerInfo.level < 9 then
        if not QuestLog.noQuestsFound then
            QuestLog.noQuestsFound = CreateFrame("Frame", "DungeonBuddy_NoQuestsFound", QuestLog.scrollChild)
            QuestLog.noQuestsFound:SetAllPoints()
            QuestLog.noQuestsFoundText = QuestLog.noQuestsFound:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            QuestLog.noQuestsFoundText:SetFont("Fonts\\FRIZQT__.TTF", Q:PixelPerfect(Q.Theme.Font.M))
            QuestLog.noQuestsFoundText:SetTextColor(unpack(Q.Theme.Text.Primary))
            QuestLog.noQuestsFoundText:SetPoint("CENTER")
            Q:SetPixelPerfectPoint(QuestLog.noQuestsFoundText, "CENTER", QuestLog.scrollChild, "CENTER", -7.5, -30)
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

    frame.titleFrame.title = Q:CreateText(nil, frame.titleFrame, row.name, row.isDungeon and Q.Theme.Font.XL or Q.Theme.Font.M)
    Q:SetPixelPerfectPoint(frame.titleFrame.title, "LEFT", frame.titleFrame, "LEFT", Q.Theme.Padding.S, 0)
    frame.titleFrame.title:SetJustifyH("LEFT")

    frame.titleFrame.title:EnableMouse(true)
    frame.titleFrame.title:SetScript("OnEnter", function(self)
        local hoveredRow = frame.row
        local tooltip = Q:GetTooltip()
        if hoveredRow and hoveredRow.prerequisiteType == Q.PrerequisiteType.ANY then
            tooltip:SetOwner(self, "ANCHOR_RIGHT")
            tooltip:SetText("Optional Choice", Q.Theme.Text.Accent[1], Q.Theme.Text.Accent[2], Q.Theme.Text.Accent[3])
            tooltip:AddLine("You only need to complete one of the quests marked with * to unlock the next quest.", Q.Theme.Text.Primary[1], Q.Theme.Text.Primary[2], Q.Theme.Text.Primary[3], true)
            tooltip:Show()
        elseif hoveredRow and hoveredRow.prerequisiteType == Q.PrerequisiteType.BREADCRUMB then
            tooltip:SetOwner(self, "ANCHOR_RIGHT")
            tooltip:SetText("Breadcrumb", Q.Theme.Text.Accent[1], Q.Theme.Text.Accent[2], Q.Theme.Text.Accent[3])
            tooltip:AddLine("Not required to unlock the next quest. Breadcrumb quests are only meant to help players find a quest.", Q.Theme.Text.Primary[1], Q.Theme.Text.Primary[2], Q.Theme.Text.Primary[3], true)
            tooltip:Show()
        end
    end)
    frame.titleFrame.title:SetScript("OnLeave", function()
        local tooltip = Q:GetTooltip()
        tooltip:Hide()
    end)

    frame.titleFrame.level = Q:CreateText(nil, frame.titleFrame, "", Q.Theme.Font.L)
    Q:SetPixelPerfectPoint(frame.titleFrame.level, "LEFT", frame.titleFrame.title, "RIGHT", 2, 0)
    frame.titleFrame.level:SetJustifyH("LEFT")

    frame.titleFrame.classIcon = frame.titleFrame:CreateTexture(nil, "ARTWORK")
    Q:SetPixelPerfectPoint(frame.titleFrame.classIcon, "LEFT", frame.titleFrame.title, "RIGHT", Q.Theme.Padding.S, 0)
    Q:SetPixelPerfectSize(frame.titleFrame.classIcon, 16, 16)
    frame.titleFrame.classIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

    frame.titleFrame.professionIcon = frame.titleFrame:CreateTexture(nil, "ARTWORK")
    Q:SetPixelPerfectSize(frame.titleFrame.professionIcon, 16, 16)
    frame.titleFrame.professionIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

    --------------------------------------------------
    -- Create Action Buttons
    --------------------------------------------------
    local collapseHandlers = {
        OnClick = function()
            local clickedRow = frame.row
            if not clickedRow then
                return
            end

            local settingPath = clickedRow.isDungeon and "CollapsedDungeons" or "CollapsedQuests"
            local collapsedRows = clickedRow.isDungeon and Q:GetSetting("CollapsedDungeons") or Q:GetSetting("CollapsedQuests")
            if collapsedRows[clickedRow.id] then
                collapsedRows[clickedRow.id] = nil
            else
                collapsedRows[clickedRow.id] = true
            end
            Q:SetSetting(settingPath, collapsedRows)
            QuestLog:RefreshAndPopulate()
        end,
        OnMouseEnter = function(self)
            local tooltip = Q:GetTooltip()
            local accentR, accentG, accentB = unpack(Q.Theme.Text.Accent)
            local primaryR, primaryG, primaryB = unpack(Q.Theme.Text.Primary)

            tooltip:SetOwner(self, "ANCHOR_RIGHT")
            tooltip:SetText("Expand/Collapse Section", accentR, accentG, accentB)
            tooltip:AddLine("Click to expand/collapse this section.", primaryR, primaryG, primaryB, true)
            tooltip:Show()
        end,
        OnMouseLeave = function()
            local tooltip = Q:GetTooltip()
            tooltip:Hide()
        end
    }
    frame.collapseButton = Q:CreateTransparentButton(nil, frame, "+", DB_ROW_HEIGHT, DB_ROW_HEIGHT, Q.Theme.Font.M, Q.Theme.Text.Secondary, collapseHandlers)
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
            Q.API:SetWaypoint(frame.row, frame.row.isDungeon)

            C_Timer.After(2, function()
                self.isDisabled = false
                self:SetAlpha(1)
            end)
        end,
        OnMouseEnter = function(self)
            local tooltip = Q:GetTooltip()
            local tomtom = rawget(_G, "TomTom")
            local r, g, b = unpack(Q.Theme.Text.Primary)

            tooltip:SetOwner(self, "ANCHOR_RIGHT")
            if tomtom and tomtom.AddWaypoint then
                tooltip:SetText(frame.row.isDungeon and "Find Entrance" or "Find Source", unpack(Q.Theme.Text.Accent))
                tooltip:AddLine(string.format("Add a waypoint at %s.", frame.row.isDungeon and "the dungeon entrance" or "this quests source(s)"), r, g, b, true)
                if frame.row.source and frame.row.source.text then
                    tooltip:AddLine("-", r, g, b, true)
                    tooltip:AddLine("Info: "..frame.row.source.text, r, g, b, true)
                end
            else
                tooltip:AddLine("TomTom required for waypoint directions.", r, g, b, true)
            end
            tooltip:Show()
        end,
        OnMouseLeave = function()
            local tooltip = Q:GetTooltip()
            tooltip:Hide()
        end
    }
    frame.waypointButton = Q:CreateTransparentButton(nil, frame, "", DB_ROW_HEIGHT, DB_ROW_HEIGHT, Q.Theme.Font.M, Q.Theme.Background.Accent, waypointHandlers)
    frame.waypointButton.icon = frame.waypointButton:CreateTexture(nil, "ARTWORK")
    frame.waypointButton.icon:SetAtlas("waypoint-mappin-minimap-untracked")
    frame.waypointButton.icon:SetSize(DB_ROW_HEIGHT * 0.9, DB_ROW_HEIGHT * 0.9)
    frame.waypointButton.icon:SetPoint("CENTER")
    frame.waypointButton:SetPoint("RIGHT", frame.titleFrame, "RIGHT", -Q.Theme.Padding.L * 1.8, 0)

    return frame
end

function QuestLog:RefreshAndPopulate()
    self.rows = {}
    self._frames = self._frames or {}

    local totalOffset = 0
    local playerInfo = Q.API:GetPlayerInfo()

    CreateOrUpdateNoQuestsFoundFrame(playerInfo)

    local dungeons = Q.API:GetDungeons()

    -- First build the rows table with all dungeons, quests, and chain quests, only adding rows that are not hidden
    for _, dungeon in pairs(dungeons) do
        if Q.API:DungeonHasAvailableQuests(dungeon.id, playerInfo) and playerInfo.level <= dungeon.maxLevel then
            local isCollapsed = Q:GetSetting("CollapsedDungeons")[dungeon.id] or false
            local quests = (Q:GetSetting("ShowAllQuestsForAvailableDungeon") and Q.API:GetQuestsByDungeonId(dungeon.id)) or Q.API:GetAvailableQuestsByDungeonId(dungeon.id, playerInfo)
            table.sort(quests, function(a, b) return a.name < b.name end)
            dungeon.isDungeon = true

            table.insert(self.rows, dungeon)
            
            if not isCollapsed then
                for _, quest in ipairs(quests) do
                    local questIsCollapsed = Q:GetSetting("CollapsedQuests")[quest.id] or false
                    
                    local questRow = CopyRow(quest)
                    questRow.isMainQuest = true
                    if not Q:GetSetting("HideCompletedQuests") or not Q.API:IsQuestCompleted(quest.id) then
                        table.insert(self.rows, questRow)
                        InsertLevelRequirementRow(questRow, 1)
                    end

                    if not questIsCollapsed and (not Q:GetSetting("HideCompletedQuests") or not Q.API:IsQuestCompleted(quest.id)) then
                        AppendRelatedRows(quest, 0)
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
        
        UpdateClassIcon(frame)
        UpdateRowAppearance(frame, playerInfo)
        UpdateCollapseButton(frame)
        UpdateWaypointButton(frame)
        UpdateRowText(frame)
        
        frame.gradient:SetShown(row.isDungeon and true or false)
        frame.bottomBorder:SetShown(row.isDungeon and true or false)
        if row.isDungeon then
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
            if row.isDungeon then
                rowOffset = rowOffset + 10
            end
        end
        prevRowHeight = row.isDungeon and (DB_ROW_HEIGHT + DUNGEON_ROW_EXTRA_HEIGHT) or DB_ROW_HEIGHT

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
    self:UnregisterEvent("QUEST_TURNED_IN")
    self:UnregisterEvent("QUEST_ACCEPTED")
    self:UnregisterEvent("PLAYER_LEVEL_UP")

    if self.frame then
        self.frame:Hide()
    end
end

function QuestLog:OnEnable()
    self:RegisterEvent("QUEST_LOG_UPDATE", "OnQuestStateChanged")
    self:RegisterEvent("QUEST_TURNED_IN", "OnQuestStateChanged")
    self:RegisterEvent("QUEST_ACCEPTED", "OnQuestStateChanged")
    self:RegisterEvent("PLAYER_LEVEL_UP", "OnQuestStateChanged")

    if not self.frame then
        self:Create()
    elseif self.frame then
        self.frame:Show()
    end
end

function QuestLog:OnQuestStateChanged()
    self:RefreshAndPopulate()
end
