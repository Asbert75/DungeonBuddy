local _, Q = ...
local Notification = Q.Addon:NewModule("Notification", "AceEvent-3.0", "AceConsole-3.0")
Notification.queue = {}
Notification.queueIndex = 1
Q.Notification = Notification

local function FormatDungeonRelationships(quest)
    local groups = {}
    local groupOrder = {}

    for _, dungeon in ipairs(Q.API:GetDungeonsForQuest(quest.id)) do
        if dungeon then
            local instance, wing = dungeon.name:match("^(.+):%s*(.+)$")
            local groupName = instance or dungeon.name
            local group = groups[groupName]

            if not group then
                group = { name = groupName, wings = {} }
                groups[groupName] = group
                table.insert(groupOrder, group)
            end

            if wing then
                table.insert(group.wings, wing)
            end
        end
    end

    local labels = {}
    for _, group in ipairs(groupOrder) do
        local name = group.name
        if #group.wings == 1 then
            name = name .. ": " .. group.wings[1]
        elseif #group.wings > 1 then
            name = string.format("%s (%d wings)", name, #group.wings)
        end

        table.insert(labels, string.upper(name))
    end

    return table.concat(labels, " | ")
end

function Notification:LevelUpEventHandler()
    local playerLevel = Q.API:GetPlayerLevel()
    local quests = Q.API:GetQuests()
    self.queue = {}
    self.queueIndex = 1

    for _, quest in ipairs(quests) do
        if (Q:GetSetting("ShowNotificationForAllQuests") or Q.API:IsDungeonQuestChainStart(quest.id)) and quest.requiredLevel == playerLevel and Q.API:IsQuestAvailable(quest.id) then
            table.insert(self.queue, quest)

            if Q:GetSetting("AutoWaypoint") then
                Q.API:SetWaypoint(quest)
            end
        end
    end

    self:DisplayNextInQueue()
end

function Notification:Create()
    if self.frame then
        return self.frame
    end

    local pixelPerfect = Q:PixelPerfect(1)
    local fontS, fontM, fontL, fontXL = Q.Theme.Font.S, Q.Theme.Font.M, Q.Theme.Font.L, Q.Theme.Font.XL
    local paddingS, paddingM = Q.Theme.Padding.S, Q.Theme.Padding.M

    --------------------------------------------------
    -- Create Notification Frame
    --------------------------------------------------
    self.frame = Q:CreateBackdropFrame('DungeonBuddy_NotificationFrame', UIParent, 480, 300, "MEDIUM", "Primary", "Accent")

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
        Q:SetSetting("NotificationFrame.x", x - centerX)
        Q:SetSetting("NotificationFrame.y", y - centerY)
    end)

    self.frame:SetPoint("CENTER", UIParent, "CENTER", Q:GetSetting("NotificationFrame.x") or 0, Q:GetSetting("NotificationFrame.y") or 0)
    Q:ClampFrameToScreen(self.frame)

    local x, y = self.frame:GetCenter()
    local centerX, centerY = UIParent:GetCenter()
    Q:SetSetting("NotificationFrame.x", x - centerX)
    Q:SetSetting("NotificationFrame.y", y - centerY)
    self.frame:SetAlpha(0)
    self.frame:Hide()

    local closeButton = Q:CreateCloseButton(self.frame)
    closeButton:SetScript("OnClick", function()
        self:Dismiss(true)
    end)

    --------------------------------------------------
    -- Fade In/Out Animation
    --------------------------------------------------
    self.frame.FadeIn = Q:AddFadeInAnimation(self.frame, 0.3)
    self.frame.FadeOut = Q:AddFadeOutAnimation(self.frame, 0.3)

    --------------------------------------------------
    -- Notification Window Title
    --------------------------------------------------
    self.notificationIcon = Q:CreateTexture("NotificationIcon", self.frame, 40, 40, "UI-QuestPoiLegendary-QuestBang")
    Q:SetPixelPerfectPoint(self.notificationIcon, "TOPLEFT", self.frame, "TOPLEFT", paddingM, -paddingS)

    self.notificationTitle = Q:CreateText("notificationTitle", self.frame, "A NEW QUEST IS AVAILABLE", fontL, "Accent")
    Q:SetPixelPerfectPoint(self.notificationTitle, "LEFT", self.notificationIcon, "RIGHT", paddingS, -2)

    self.notificationProgress = Q:CreateText("NotificationProgress", self.frame, "", fontM, "Accent")
    Q:SetPixelPerfectPoint(self.notificationProgress, "LEFT", self.notificationTitle, "RIGHT", 5, 0)

    --------------------------------------------------
    -- Dungeon Name
    --------------------------------------------------
    self.dungeonName = Q:CreateText("DungeonName", self.frame, "DUNGEON NAME", fontS, "Accent")
    Q:SetPixelPerfectPoint(self.dungeonName, "TOPLEFT", self.notificationIcon, "BOTTOMLEFT", 0, -paddingM)

    --------------------------------------------------
    -- Quest Name
    --------------------------------------------------
    self.questName = Q:CreateText("QuestName", self.frame, "QUEST NAME", fontXL, "Primary")
    Q:SetPixelPerfectPoint(self.questName, "TOPLEFT", self.dungeonName, "BOTTOMLEFT", 0, -paddingS)

    self.questClassIcon = Q:CreateTexture("QuestClassIcon", self.frame, 20, 20)
    self.questClassIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    Q:SetPixelPerfectPoint(self.questClassIcon, "TOPLEFT", self.dungeonName, "BOTTOMLEFT", 0, -paddingS)

    --------------------------------------------------
    -- Quest Source Label
    --------------------------------------------------
    self.questSourceLabel = Q:CreateText("QuestSourceLabel", self.frame, "QUEST STARTED BY", fontS, "Accent")
    Q:SetPixelPerfectPoint(self.questSourceLabel, "TOPLEFT", self.questClassIcon, "BOTTOMLEFT", 0, -paddingM)

    --------------------------------------------------
    -- Quest Source Information
    --------------------------------------------------
    self.sourceIcon = Q:CreateTexture("SourceIcon", self.frame, 20, 20)
    self.sourceIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    Q:SetPixelPerfectPoint(self.sourceIcon, "TOPLEFT", self.questSourceLabel, "BOTTOMLEFT", 0, -paddingS)
    
    self.questSourceName = Q:CreateText("QuestSourceName", self.frame, "Name", fontM, "Primary")
    Q:SetPixelPerfectPoint(self.questSourceName, "LEFT", self.sourceIcon, "RIGHT", paddingS, 0)
    self.questSourceName:SetTextColor(unpack(Q.Theme.Status.Success))

    self.questSourceZoneName = Q:CreateText("QuestSourceZoneName", self.frame, "- Orgrimmar", fontM, "Primary")
    Q:SetPixelPerfectPoint(self.questSourceZoneName, "LEFT", self.questSourceName, "RIGHT", 0, 0)

    self.questSourceText = Q:CreateText("QuestSourceText", self.frame, "Additional information about the quest source.", fontM, "Secondary")
    Q:SetPixelPerfectPoint(self.questSourceText, "TOPLEFT", self.questSourceName, "BOTTOMLEFT", 0, -paddingS)
    Q:SetPixelPerfectWidth(self.questSourceText, self.frame:GetWidth() - paddingM * 2)
    self.questSourceText:SetJustifyH("LEFT")
    self.questSourceText:SetWordWrap(true)

    --------------------------------------------------
    -- Create Waypoint/Directions Button
    --------------------------------------------------
    self.waypointButton = CreateFrame("Button", nil, self.frame, "BackdropTemplate")
    self.waypointButton:EnableMouse(true)
    self.waypointButton:SetFrameLevel(self.frame:GetFrameLevel() + 1)
    Q:SetPixelPerfectSize(self.waypointButton, 140, 40)
    Q:SetPixelPerfectPoint(self.waypointButton, "BOTTOMLEFT", self.frame, "BOTTOMLEFT", paddingM, paddingM)
    self.waypointButton:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = pixelPerfect,
        insets = { left = pixelPerfect, right = pixelPerfect, top = pixelPerfect, bottom = pixelPerfect, },
    })

    self.waypointButton.text = self.waypointButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.waypointButton.text:SetPoint("CENTER")
    self.waypointButton.text:SetText("Set Waypoint")
    self.waypointButton.text:SetTextColor(unpack(Q.Theme.Text.Accent))

    local function updateWaypointButtonStyle(isHovered)
        local trackColor = self.trackWaypointSet and Q.Theme.Status.Success or Q.Theme.Text.Accent
        local r, g, b = unpack(trackColor)

        self.waypointButton:SetBackdropColor(r, g, b, isHovered and Q.Theme.Alpha.ButtonBackgroundHover or Q.Theme.Alpha.ButtonBackground)
        self.waypointButton:SetBackdropBorderColor(r, g, b, isHovered and Q.Theme.Alpha.ButtonBorderHover or Q.Theme.Alpha.ButtonBorder)
        if isHovered then
            self.waypointButton.text:SetTextColor(unpack(Q.Theme.Text.Primary))
        else
            self.waypointButton.text:SetTextColor(r, g, b)
        end
    end

    updateWaypointButtonStyle(false)

    self.waypointButton:SetScript("OnEnter", function()
        updateWaypointButtonStyle(true)
    end)
    self.waypointButton:SetScript("OnLeave", function()
        updateWaypointButtonStyle(false)
    end)
    self.waypointButton:SetScript("OnClick", function()
        if not self.quest then
            return
        end

        Q.API:SetWaypoint(self.quest)

        self.trackWaypointSet = true
        self.waypointButton.text:SetText("Waypoint Set")
        updateWaypointButtonStyle(self.waypointButton:IsMouseOver())
    end)

    --------------------------------------------------------
    -- Dismiss / View Next button
    --------------------------------------------------------
    self.dismissButton = CreateFrame("Button", nil, self.frame, "BackdropTemplate")
    self.dismissButton:EnableMouse(true)
    self.dismissButton:SetFrameLevel(self.frame:GetFrameLevel() + 1)
    Q:SetPixelPerfectSize(self.dismissButton, 120, 40)
    Q:SetPixelPerfectPoint(self.dismissButton, "BOTTOMRIGHT", self.frame, "BOTTOMRIGHT", -paddingM, paddingM)

    self.dismissButton:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = pixelPerfect,
        insets = { left = pixelPerfect, right = pixelPerfect, top = pixelPerfect, bottom = pixelPerfect, },
    })
    local colorR, colorG, colorB = unpack(Q.Theme.Text.Secondary)

    self.dismissButton.text = self.dismissButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.dismissButton.text:SetPoint("CENTER")
    self.dismissButton.text:SetText("Dismiss")
    self.dismissButton.text:SetTextColor(colorR, colorG, colorB)

    local function updateDismissButtonStyle(isHovered)
        self.dismissButton:SetBackdropColor(colorR, colorG, colorB, isHovered and Q.Theme.Alpha.ButtonBackgroundHover or Q.Theme.Alpha.ButtonBackground)
        self.dismissButton:SetBackdropBorderColor(colorR, colorG, colorB, isHovered and Q.Theme.Alpha.ButtonBorderHover or Q.Theme.Alpha.ButtonBorder)

        if isHovered then
            self.dismissButton.text:SetTextColor(unpack(Q.Theme.Text.Primary))
        else
            self.dismissButton.text:SetTextColor(colorR, colorG, colorB)
        end
    end

    updateDismissButtonStyle(false)

    self.dismissButton:SetScript("OnEnter", function()
        updateDismissButtonStyle(true)
    end)
    self.dismissButton:SetScript("OnLeave", function()
        updateDismissButtonStyle(false)
    end)
    self.dismissButton:SetScript("OnClick", function()
        updateDismissButtonStyle(false)
        updateWaypointButtonStyle(false)
        self:Dismiss()
    end)

    --------------------------------------------------
    -- View Previous Button
    --------------------------------------------------
    self.previousQuestButton = CreateFrame("Button", nil, self.frame, "BackdropTemplate")
    self.previousQuestButton:EnableMouse(true)
    self.previousQuestButton:SetFrameLevel(self.frame:GetFrameLevel() + 1)
    Q:SetPixelPerfectSize(self.previousQuestButton, 120, 40)
    Q:SetPixelPerfectPoint(self.previousQuestButton, "RIGHT", self.dismissButton, "LEFT", -paddingS, 0)

    self.previousQuestButton:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = pixelPerfect,
        insets = { left = pixelPerfect, right = pixelPerfect, top = pixelPerfect, bottom = pixelPerfect, },
    })
    local colorR, colorG, colorB = unpack(Q.Theme.Text.Secondary)

    self.previousQuestButton.text = self.previousQuestButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.previousQuestButton.text:SetPoint("CENTER")
    self.previousQuestButton.text:SetText("< Previous")
    self.previousQuestButton.text:SetTextColor(colorR, colorG, colorB)

    local function updatePreviousQuestButtonStyle(isHovered)
        self.previousQuestButton:SetBackdropColor(colorR, colorG, colorB, isHovered and Q.Theme.Alpha.ButtonBackgroundHover or Q.Theme.Alpha.ButtonBackground)
        self.previousQuestButton:SetBackdropBorderColor(colorR, colorG, colorB, isHovered and Q.Theme.Alpha.ButtonBorderHover or Q.Theme.Alpha.ButtonBorder)

        if isHovered then
            self.previousQuestButton.text:SetTextColor(unpack(Q.Theme.Text.Primary))
        else
            self.previousQuestButton.text:SetTextColor(colorR, colorG, colorB)
        end
    end

    updatePreviousQuestButtonStyle(false)

    self.previousQuestButton:SetScript("OnEnter", function()
        updatePreviousQuestButtonStyle(true)
    end)
    self.previousQuestButton:SetScript("OnLeave", function()
        updatePreviousQuestButtonStyle(false)
    end)
    self.previousQuestButton:SetScript("OnClick", function()
        updatePreviousQuestButtonStyle(false)
        updateWaypointButtonStyle(false)
        Notification:DisplayPreviousInQueue()
    end)
end

function Notification:Dismiss(dismissAll)
    if self.frame then
        if dismissAll or self.queueIndex == #self.queue then
            self.queue = {}
            self.queueIndex = 1
            self.frame.FadeOut:Play()
        elseif self.queueIndex < #self.queue then
            self.queueIndex = self.queueIndex + 1
            self:DisplayNextInQueue()
        end
    end
end

function Notification:AddToQueue(quests)
    if not quests or #quests == 0 then return end

    for _, quest in ipairs(quests) do
        for index, existingQuest in ipairs(self.queue) do
            if existingQuest.id == quest.id then
                table.remove(self.queue, index)
                break
            end
        end
        table.insert(self.queue, quest)

        if Q:GetSetting("AutoWaypoint") then
            Q.API:SetWaypoint(quest)
        end
    end

    self.queueIndex = 1
    self:DisplayNextInQueue()
end

function Notification:DisplayPreviousInQueue()
    if self.queueIndex > 1 then
        self.queueIndex = self.queueIndex - 1
        local queuedQuest = self.queue and self.queue[self.queueIndex]
        self:DisplayQuest(queuedQuest, true)
    end
end

function Notification:DisplayNextInQueue()
    local queuedQuest = self.queue and self.queue[self.queueIndex]
    if queuedQuest then
        self:DisplayQuest(queuedQuest)
    end
end

local function UpdateSourceData(playerFaction)
    local quest = Notification.quest
    if not quest.source then
        return
    end

    Notification.questSourceName:SetText(quest.source.name)
    Notification.questSourceZoneName:SetText(" - " .. quest.source.zone)
    Notification.questSourceText:SetText(quest.source.text)

    if quest.source.type == "npc" then
        if playerFaction == "Alliance" then
            Notification.sourceIcon:SetTexture("Interface\\Icons\\achievement_character_human_male")
        else
            Notification.sourceIcon:SetTexture("Interface\\Icons\\achievement_character_orc_male")
        end
    elseif quest.source.type == "item" then
        local itemIcon
        if quest.source.itemId then
            if C_Item and C_Item.GetItemIconByID then
                itemIcon = C_Item.GetItemIconByID(quest.source.itemId)
            end
        end

        Notification.sourceIcon:SetTexture(itemIcon or "Interface\\Icons\\INV_Scroll_03")
    elseif quest.source.type == "object" then
        Notification.sourceIcon:SetTexture("Interface\\Icons\\inv_scroll_10")
    end
end

local function UpdateClassIcon(questClass)
    local classIconTexture = Q.API:GetClassIconTexture(questClass)
    if classIconTexture then
        Notification.questClassIcon:SetTexture(classIconTexture)
        Notification.questClassIcon:Show()
        Q:SetPixelPerfectPoint(Notification.questName, "TOPLEFT", Notification.questClassIcon, "TOPRIGHT", Q.Theme.Padding.S, 0)
    else
        Notification.questClassIcon:Hide()
        Q:SetPixelPerfectPoint(Notification.questName, "TOPLEFT", Notification.dungeonName, "BOTTOMLEFT", 0, -Q.Theme.Padding.S)
    end
end

local function UpdateActionButtons()
    Notification.trackWaypointSet = false
    Notification.waypointButton.text:SetText("Set Waypoint")
    local trackColorR, trackColorG, trackColorB = unpack(Q.Theme.Text.Accent)
    Notification.waypointButton:SetBackdropColor(trackColorR, trackColorG, trackColorB, Q.Theme.Alpha.ButtonBackground)
    Notification.waypointButton:SetBackdropBorderColor(trackColorR, trackColorG, trackColorB, Q.Theme.Alpha.ButtonBorder)
    Notification.waypointButton.text:SetTextColor(trackColorR, trackColorG, trackColorB)

    if Notification.queueIndex ~= #Notification.queue then
        Notification.dismissButton.text:SetText("Next >")
    else
        Notification.dismissButton.text:SetText("Dismiss")
    end

    if Notification.queueIndex == 1 then
        Notification.previousQuestButton:Hide()
    else
        Notification.previousQuestButton:Show()
    end

    local colorR, colorG, colorB = unpack(Q.Theme.Text.Secondary)
    Notification.dismissButton:SetBackdropColor(colorR, colorG, colorB, Q.Theme.Alpha.ButtonBackground)
    Notification.dismissButton:SetBackdropBorderColor(colorR, colorG, colorB, Q.Theme.Alpha.ButtonBorder)
    Notification.dismissButton.text:SetTextColor(colorR, colorG, colorB)

    if Q:GetSetting("AutoWaypoint") then
        Notification.trackWaypointSet = true
        Notification.waypointButton.text:SetText("Waypoint Set")

        local trackColor = Q.Theme.Text.Accent
        if Notification.trackWaypointSet then
            trackColor = Q.Theme.Status.Success
        end
        local r, g, b = unpack(trackColor)

        Notification.waypointButton:SetBackdropColor(r, g, b, Q.Theme.Alpha.ButtonBackground)
        Notification.waypointButton:SetBackdropBorderColor(r, g, b, Q.Theme.Alpha.ButtonBorder)
        Notification.waypointButton.text:SetTextColor(r, g, b)
    end
end

function Notification:DisplayQuest(quest, isPrevious)
    self.quest = quest

    local playerInfo = Q.API:GetPlayerInfo()

    -- Update Dungeon Name Text
    self.dungeonName:SetText(FormatDungeonRelationships(quest))
    
    -- Update Quest Title
    local questTitle = quest.suggestedLevel and string.format("[%d] %s", quest.suggestedLevel, quest.name) or quest.name
    self.questName:SetText(questTitle)
    local color = Q.API:GetDifficultyColor(playerInfo.level, quest.suggestedLevel)
    self.questName:SetTextColor(color.r, color.g, color.b)

    UpdateClassIcon(quest.class)
    UpdateSourceData(playerInfo.faction)
    UpdateActionButtons()
    
    -- Update Queue State / Text
    if #self.queue > 1 then
        self.notificationProgress:SetText(string.format("(%d/%d)", self.queueIndex, #self.queue))
    else
        self.notificationProgress:SetText("")
    end

    if not isPrevious and self.queueIndex == 1 then
        self.frame:Show()
        self.frame.FadeIn:Play()
    end
end

function Notification:OnDisable()
    self:UnregisterEvent("PLAYER_LEVEL_UP", "LevelUpEventHandler")
    self.queue = {}
    self.queueIndex = 1

    if self.frame then
        self.frame.FadeIn:Stop()
        self.frame.FadeOut:Stop()
        self.frame:Hide()
        self.frame:SetParent(nil)
        self.frame = nil
    end
end

function Notification:OnEnable()
    if not Q:GetSetting("ShowNotificationOnLevelUp") then
        return
    end
    self:RegisterEvent("PLAYER_LEVEL_UP", "LevelUpEventHandler")

    if not self.frame then
        self:Create()
    elseif self.frame then
        self.frame:Show()
    end
end
