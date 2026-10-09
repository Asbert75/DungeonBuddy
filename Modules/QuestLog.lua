local _, Q = ...
local QuestLog = Q.Addon:NewModule("QuestLog", "AceEvent-3.0", "AceConsole-3.0")
Q.QuestLog = QuestLog

local function IsRowCollapsed(row)
    if row.isDungeon then
        return Q:GetSetting("CollapsedDungeons")[row.id] or false
    else
        return Q:GetSetting("CollapsedQuests")[row.id] or false
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

function QuestLog:Create()
    if self.frame then
        return self.frame
    end

    local containerWidth = 450

    --------------------------------------------------
    -- Create QuestLog Frame
    --------------------------------------------------
    local frame = Q:CreateBackdropFrame('DungeonBuddy_QuestLogFrame', UIParent, containerWidth, 600, "MEDIUM", "Primary", "Default")
    self.frame = frame

    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")

    frame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        Q:ClampFrameToScreen(self)

        local x, y = self:GetCenter()
        local centerX, centerY = UIParent:GetCenter()
        Q:SetSetting("QuestLogFrame.X", x - centerX)
        Q:SetSetting("QuestLogFrame.Y", y - centerY)
    end)

    local savedX = Q:GetSetting("QuestLogFrame.X")
    local savedY = Q:GetSetting("QuestLogFrame.Y")
    frame:SetPoint("CENTER", UIParent, "CENTER", savedX or 0, savedY or 0)
    Q:ClampFrameToScreen(frame)

    -- Older versions saved the frame's absolute screen center as an offset.
    -- Clamp that restored position and persist the corrected relative offset.
    local x, y = frame:GetCenter()
    local centerX, centerY = UIParent:GetCenter()
    Q:SetSetting("QuestLogFrame.X", x - centerX)
    Q:SetSetting("QuestLogFrame.Y", y - centerY)

    Q:CreateCloseButton(frame)

    --------------------------------------------------
    -- QuestLog Header
    --------------------------------------------------
    local headerContainer = Q:CreateFrame("QuestLogHeader", frame, containerWidth, 50, "MEDIUM")
    self.header = headerContainer
    Q:SetPixelPerfectPoint(headerContainer, "TOP", frame, "TOP", 0, 0)
    Q:SetPixelPerfectPoint(headerContainer, "LEFT", frame, "LEFT", Q.Theme.Padding.S, 0)
    Q:SetPixelPerfectPoint(headerContainer, "RIGHT", frame, "RIGHT", -Q.Theme.Padding.L, 0)

    local border = headerContainer:CreateTexture(nil, "OVERLAY")
    border:SetColorTexture(unpack(Q.Theme.Border.Accent))
    border:SetHeight(Q:PixelPerfect(1))
    Q:SetPixelPerfectPoint(border, "BOTTOMLEFT", headerContainer, "BOTTOMLEFT", 0, 0)
    Q:SetPixelPerfectPoint(border, "BOTTOMRIGHT", headerContainer, "BOTTOMRIGHT", 0, 0)

    local headerText = Q:CreateText("QuestLogHeaderText", headerContainer, "Dungeon Buddy", Q.Theme.Font.XXL, "Accent", 1)
    headerText:SetJustifyH("LEFT")
    Q:SetPixelPerfectPoint(headerText, "LEFT", headerContainer, "LEFT", 0, 0)

    --------------------------------------------------
    -- QuestLog Content Container
    --------------------------------------------------
    local contentContainer = CreateFrame("ScrollFrame", "DungeonBuddy_QuestLogContentContainer", frame, "UIPanelScrollFrameTemplate")
    self.contentContainer = contentContainer
    Q:SetPixelPerfectPoint(contentContainer, "TOPLEFT", headerContainer, "BOTTOMLEFT", 0, -Q.Theme.Padding.S)
    Q:SetPixelPerfectPoint(contentContainer, "BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
    contentContainer:EnableMouseWheel(true)

    local scrollChild = CreateFrame("Frame", "DungeonBuddy_QuestLogContentContainerChild", contentContainer)
    Q:SetPixelPerfectSize(scrollChild, containerWidth, 1)
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

    QuestLog:RefreshAndPopulate()

    frame:Hide()
    return frame
end

function QuestLog:RefreshAndPopulate()
    self.rows = {}
    self._frames = self._frames or {}

    local fontM = Q.Theme.Font.M
    local fontXL = Q.Theme.Font.XL
    local fontL = Q.Theme.Font.L
    local rowHeight = Q.Theme.Font.XL + 6
    local paddingS = Q.Theme.Padding.S
    local paddingL = Q.Theme.Padding.L
    local totalOffset = 0

    local pixelPerfect = Q:PixelPerfect(1)
    local playerInfo = Q.API:GetPlayerInfo()

    if playerInfo.level < 9 then
        if not self.noQuestsFound then
            self.noQuestsFound = CreateFrame("Frame", "DungeonBuddy_NoQuestsFound", self.scrollChild)
            self.noQuestsFound:SetAllPoints()
            self.noQuestsFoundText = self.noQuestsFound:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            self.noQuestsFoundText:SetFont("Fonts\\FRIZQT__.TTF", fontM * pixelPerfect)
            self.noQuestsFoundText:SetTextColor(unpack(Q.Theme.Text.Primary))
            self.noQuestsFoundText:SetPoint("CENTER")
            Q:SetPixelPerfectPoint(self.noQuestsFoundText, "CENTER", self.scrollChild, "CENTER", -7.5, -30)
            self.noQuestsFoundText:SetText("No quests available.")
        end

        self.noQuestsFound:Show()
    elseif self.noQuestsFound then
        self.noQuestsFound:Hide()
    end

    local dungeons = Q.API:GetDungeons()

    -- First build the rows table with all dungeons, quests, and chain quests, only adding rows that are not hidden
    for _, dungeon in ipairs(dungeons) do
        if Q.API:HasAvailableQuestsForDungeon(dungeon.id, playerInfo) and playerInfo.level <= dungeon.maxLevel then
            local isCollapsed = Q:GetSetting("CollapsedDungeons")[dungeon.id] or false
            dungeon.isDungeon = true
            local quests = Q.API:GetQuestsForDungeon(dungeon.id, playerInfo)
            table.sort(quests, function(a, b) return a.id > b.id end)

            table.insert(self.rows, dungeon)
            
            if not isCollapsed then
                for _, quest in ipairs(quests) do
                    local questIsCollapsed = Q:GetSetting("CollapsedQuests")[quest.id] or false
                    
                    local chain = {}
                    local seenQuestIds = { [quest.id] = true }
                    local prevQuest = Q.API:GetQuestById(quest.previousQuestId)
                    while prevQuest and not seenQuestIds[prevQuest.id] do
                        seenQuestIds[prevQuest.id] = true
                        table.insert(chain, prevQuest)
                        prevQuest = Q.API:GetQuestById(prevQuest.previousQuestId)
                    end

                    local chainLength = #chain + 1
                    quest.isMainQuest = true
                    quest.chainStep = #chain > 0 and chainLength or nil
                    quest.chainLength = #chain > 0 and chainLength or nil
                    if not Q:GetSetting("HideCompletedQuests") or not Q.API:IsQuestCompleted(quest.id) then
                        table.insert(self.rows, quest)
                    end

                    for chainIndex = 1, #chain do
                        local chainQuest = chain[chainIndex]
                        chainQuest.isChainQuest = true
                        chainQuest.chainStep = chainLength - chainIndex
                        chainQuest.chainLength = chainLength
                        if (not Q:GetSetting("HideCompletedQuests") or not Q.API:IsQuestCompleted(chainQuest.id)) and not questIsCollapsed then
                            table.insert(self.rows, chainQuest)
                        end
                    end
                end
            end
        end
    end

    for index, row in ipairs(self.rows) do
        local frame = self._frames[index] -- Frames cannot be destroyed so we reuse frames by id and create a new if we have a longer list

        --------------------------------------------------
        -- Create Row Frame
        --------------------------------------------------
        if not frame then
            frame = CreateFrame("Frame", "DungeonBuddy_QuestLogRow"..index, self.scrollChild)
            self._frames[index] = frame
            frame:SetWidth(self.scrollChild:GetWidth())
            Q:SetPixelPerfectHeight(frame, rowHeight)
            Q:SetPixelPerfectPoint(frame, "TOPLEFT", self.scrollChild, "TOPLEFT", 0, 0)

            local leftBorder = frame:CreateTexture(nil, "OVERLAY")
            frame.leftBorder = leftBorder
            leftBorder:SetColorTexture(unpack(Q.Theme.Border.Accent))
            leftBorder:SetWidth(Q:PixelPerfect(3))
            leftBorder:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
            leftBorder:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)

            --------------------------------------------------
            -- Create Title
            --------------------------------------------------
            local titleFrame = CreateFrame("Frame", nil, frame)
            frame.titleFrame = titleFrame
            titleFrame:SetWidth(self.scrollChild:GetWidth())
            Q:SetPixelPerfectHeight(titleFrame, rowHeight)
            Q:SetPixelPerfectPoint(titleFrame, "TOPLEFT", frame, "TOPLEFT", 0, 0)

            local title = Q:CreateText(nil, titleFrame, row.name, row.isDungeon and fontXL or fontM)
            frame.titleFrame.title = title
            Q:SetPixelPerfectPoint(frame.titleFrame.title, "LEFT", titleFrame, "LEFT", paddingS, 0)
            frame.titleFrame.title:SetJustifyH("LEFT")

            local level = Q:CreateText(nil, titleFrame, "", fontL)
            frame.titleFrame.level = level
            Q:SetPixelPerfectPoint(level, "LEFT", title, "RIGHT", 2, 0)
            level:SetJustifyH("LEFT")

            local classIcon = titleFrame:CreateTexture(nil, "ARTWORK")
            frame.titleFrame.classIcon = classIcon
            Q:SetPixelPerfectPoint(classIcon, "LEFT", title, "RIGHT", paddingS, 0)
            Q:SetPixelPerfectSize(classIcon, 16, 16)
            classIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

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
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                    GameTooltip:SetText("Expand/Collapse Section", 1, 1, 1)
                    GameTooltip:AddLine("Click to expand/collapse this section.", 0.85, 0.85, 0.85, true)
                    GameTooltip:Show()
                end,
                OnMouseLeave = function()
                    GameTooltip:Hide()
                end
            }
            frame.collapseButton = Q:CreateButton(nil, frame, "+", rowHeight, rowHeight, Q.Theme.Font.M, collapseHandlers)
            frame.collapseButton:SetPoint("RIGHT", titleFrame, "RIGHT", -paddingL, 0)
            
            local waypointHandlers = {
                OnClick = function(self)
                    if self.isDisabled then
                        return
                    end
                    
                    if not frame.row then
                        return
                    end

                    self.isDisabled = true
                    Q.API:SetQuestWaypoint(frame.row)

                    C_Timer.After(2, function()
                        self.isDisabled = false
                    end)
                end,
                OnMouseEnter = function(self)
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                    GameTooltip:SetText("Get directions", 1, 1, 1)
                    local tomtom = rawget(_G, "TomTom")
                    if tomtom and tomtom.AddWaypoint then
                        GameTooltip:AddLine("Add a TomTom waypoint at this quest's source.", 0.85, 0.85, 0.85, true)
                    else
                        GameTooltip:AddLine("TomTom required for waypoint directions.", 0.85, 0.85, 0.85, true)
                    end
                    GameTooltip:Show()
                end,
                OnMouseLeave = function()
                    GameTooltip:Hide()
                end
            }
            frame.waypointButton = Q:CreateButton(nil, frame, "D", rowHeight, rowHeight, Q.Theme.Font.M, waypointHandlers)
            frame.waypointButton:SetPoint("RIGHT", titleFrame, "RIGHT", -paddingL * 2, 0)
        end

        --------------------------------------------------
        -- Update Row Frame
        --------------------------------------------------
        frame:Show()
        frame.row = row
        local classIcon = frame.titleFrame.classIcon
        local classIconTexture = not row.isDungeon and Q.API:GetClassIconTexture(row.class)
        if classIconTexture then
            classIcon:SetTexture(classIconTexture)
            classIcon:Show()
        else
            classIcon:Hide()
        end

        local title = row.name
        if row.chainStep then
            title = string.format("%s (%d/%d)", title, row.chainStep, row.chainLength)
        end
        frame.titleFrame.title:SetText(title)

        if row.isDungeon then
            frame.titleFrame.level:SetText(string.format("(%s-%s)", row.minLevel, row.maxLevel))

            local levelColor = Q.API:GetDifficultyColor(playerInfo.level, row.minLevel)
            frame.titleFrame.level:SetTextColor(levelColor.r, levelColor.g, levelColor.b, 1)
        else
            frame.titleFrame.level:SetText("")
        end

        -- Determine title color
        if row.isDungeon then
            Q:SetTextColor(frame.titleFrame.title, "Primary")
            frame.leftBorder:SetColorTexture(unpack(Q.Theme.Text.Primary))
        else
            if Q.API:IsQuestCompleted(row.id) then
                SetQuestStatusColor(frame.titleFrame.title, "QuestColorCompleted", "Disabled")
                SetBorderTextureColor(frame.leftBorder, "QuestColorCompleted")
            elseif Q.API:IsQuestInQuestLog(row.id) then
                SetQuestStatusColor(frame.titleFrame.title, "QuestColorInProgress", "Success")
                SetBorderTextureColor(frame.leftBorder, "QuestColorInProgress")
            elseif Q.API:IsQuestAvailable(row.id) then
                SetQuestStatusColor(frame.titleFrame.title, "QuestColorAvailable", "Accent")
                SetBorderTextureColor(frame.leftBorder, "QuestColorAvailable")
            else
                SetQuestStatusColor(frame.titleFrame.title, "QuestColorUnavailable", "Emphasized")
                SetBorderTextureColor(frame.leftBorder, "QuestColorUnavailable")
            end
        end

        if row.isDungeon then
            frame.collapseButton:Show()
            frame.waypointButton:Hide()
            frame.titleFrame.title:SetFont("Fonts\\FRIZQT__.TTF", pixelPerfect * fontXL)
            Q:SetPixelPerfectPoint(frame.titleFrame.title, "LEFT", frame.titleFrame, "LEFT", paddingS, 0)
        elseif row.isMainQuest then
            if row.previousQuestId then
                frame.collapseButton:Show()
            else
                frame.collapseButton:Hide()
            end
            frame.titleFrame.title:SetFont("Fonts\\FRIZQT__.TTF", pixelPerfect * fontM)
            Q:SetPixelPerfectPoint(frame.titleFrame.title, "LEFT", frame.titleFrame, "LEFT", 2 * paddingS, 0)
        else
            frame.collapseButton:Hide()
            frame.titleFrame.title:SetFont("Fonts\\FRIZQT__.TTF", pixelPerfect * fontM)
            Q:SetPixelPerfectPoint(frame.titleFrame.title, "LEFT", frame.titleFrame, "LEFT", 3 * paddingS, 0)
        end

        if not row.isDungeon and not row.previousQuestId then
            frame.waypointButton:Show()
        elseif not row.isDungeon then
            frame.waypointButton:Hide()
        end

        if IsRowCollapsed(row) then
            frame.collapseButton.label:SetText("+")
        else
            frame.collapseButton.label:SetText("-")
        end

        local rowOffset
        if index == 1 then
            rowOffset = paddingS
        elseif index ~= 1 then
            rowOffset = rowHeight + 2
            if row.isDungeon then
                rowOffset = rowOffset + 10
            end
        end
        Q:SetPixelPerfectPoint(frame, "TOPLEFT", self.scrollChild, "TOPLEFT", 0, -(rowOffset + totalOffset))
        totalOffset = totalOffset + rowOffset
    end

    for index = #self.rows + 1, #self._frames do
        self._frames[index]:Hide()
        self._frames[index].row = nil
    end

    Q:SetPixelPerfectHeight(self.scrollChild, math.max(1, totalOffset + rowHeight + 10))
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
