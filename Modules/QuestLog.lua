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
    self.frame = Q:CreateBackdropFrame('DungeonBuddy_QuestLogFrame', UIParent, containerWidth, 600, "MEDIUM", "Primary", "Default")

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
        Q:SetSetting("QuestLogFrame.X", x - centerX)
        Q:SetSetting("QuestLogFrame.Y", y - centerY)
    end)

    self.frame:SetPoint("CENTER", UIParent, "CENTER", Q:GetSetting("QuestLogFrame.X") or 0, Q:GetSetting("QuestLogFrame.Y") or 0)
    Q:ClampFrameToScreen(self.frame)

    local x, y = self.frame:GetCenter()
    local centerX, centerY = UIParent:GetCenter()
    Q:SetSetting("QuestLogFrame.X", x - centerX)
    Q:SetSetting("QuestLogFrame.Y", y - centerY)

    Q:CreateCloseButton(self.frame)

    --------------------------------------------------
    -- QuestLog Header
    --------------------------------------------------
    self.header = Q:CreateFrame("QuestLogHeader", self.frame, containerWidth, 50, "MEDIUM")
    Q:SetPixelPerfectPoint(self.header, "TOP", self.frame, "TOP", 0, 0)
    Q:SetPixelPerfectPoint(self.header, "LEFT", self.frame, "LEFT", Q.Theme.Padding.S, 0)
    Q:SetPixelPerfectPoint(self.header, "RIGHT", self.frame, "RIGHT", -Q.Theme.Padding.L, 0)

    local border = self.header:CreateTexture(nil, "OVERLAY")
    border:SetColorTexture(unpack(Q.Theme.Border.Accent))
    border:SetHeight(Q:PixelPerfect(1))
    Q:SetPixelPerfectPoint(border, "BOTTOMLEFT", self.header, "BOTTOMLEFT", 0, 0)
    Q:SetPixelPerfectPoint(border, "BOTTOMRIGHT", self.header, "BOTTOMRIGHT", 0, 0)

    self.header.text = Q:CreateText("QuestLogHeaderText", self.header, "Dungeon Buddy", Q.Theme.Font.XXL, "Accent", 1)
    self.header.text:SetJustifyH("LEFT")
    Q:SetPixelPerfectPoint(self.header.text, "LEFT", self.header, "LEFT", 0, 0)

    --------------------------------------------------
    -- QuestLog Content Container
    --------------------------------------------------
    self.contentContainer = CreateFrame("ScrollFrame", "DungeonBuddy_QuestLogContentContainer", self.frame, "UIPanelScrollFrameTemplate")
    Q:SetPixelPerfectPoint(self.contentContainer, "TOPLEFT", self.header, "BOTTOMLEFT", 0, -Q.Theme.Padding.S)
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
        Q:SetPixelPerfectPoint(scrollBar, "TOPRIGHT", self.contentContainer, "TOPRIGHT", -1, -20)
        Q:SetPixelPerfectPoint(scrollBar, "BOTTOMRIGHT", self.contentContainer, "BOTTOMRIGHT", -1, 20)

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

local function UpdateClassIcon(frame, row)
    local classIcon = frame.titleFrame.classIcon
    local classIconTexture = not row.isDungeon and Q.API:GetClassIconTexture(row.class)
    if classIconTexture then
        classIcon:SetTexture(classIconTexture)
        classIcon:Show()
    else
        classIcon:Hide()
    end
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
        if Q.API:DungeonHasAvailableQuests(dungeon.id, playerInfo) and playerInfo.level <= dungeon.maxLevel then
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
            frame.titleFrame = CreateFrame("Frame", nil, frame)
            frame.titleFrame:SetWidth(self.scrollChild:GetWidth())
            Q:SetPixelPerfectHeight(frame.titleFrame, rowHeight)
            Q:SetPixelPerfectPoint(frame.titleFrame, "TOPLEFT", frame, "TOPLEFT", 0, 0)

            frame.titleFrame.title = Q:CreateText(nil, frame.titleFrame, row.name, row.isDungeon and fontXL or fontM)
            Q:SetPixelPerfectPoint(frame.titleFrame.title, "LEFT", frame.titleFrame, "LEFT", paddingS, 0)
            frame.titleFrame.title:SetJustifyH("LEFT")

            frame.titleFrame.level = Q:CreateText(nil, frame.titleFrame, "", fontL)
            Q:SetPixelPerfectPoint(frame.titleFrame.level, "LEFT", frame.titleFrame.title, "RIGHT", 2, 0)
            frame.titleFrame.level:SetJustifyH("LEFT")

            frame.titleFrame.classIcon = frame.titleFrame:CreateTexture(nil, "ARTWORK")
            Q:SetPixelPerfectPoint(frame.titleFrame.classIcon, "LEFT", frame.titleFrame.title, "RIGHT", paddingS, 0)
            Q:SetPixelPerfectSize(frame.titleFrame.classIcon, 16, 16)
            frame.titleFrame.classIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

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
            frame.collapseButton:SetPoint("RIGHT", frame.titleFrame, "RIGHT", -paddingL, 0)
            
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
            frame.waypointButton:SetPoint("RIGHT", frame.titleFrame, "RIGHT", -paddingL * 2, 0)
        end

        --------------------------------------------------
        -- Update Row Frame
        --------------------------------------------------
        frame:Show()
        frame.row = row
        
        UpdateClassIcon(frame, row)

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
