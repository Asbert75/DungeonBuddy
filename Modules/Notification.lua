local _, Q = ...
local Notification = Q.Addon:NewModule("Notification", "AceEvent-3.0", "AceConsole-3.0")
Notification.queue = {}
Notification.queueIndex = 1
Q.Notification = Notification

local function FormatDungeonRelationships(relationships)
    local groups = {}
    local groupOrder = {}

    for _, relationship in ipairs(relationships or {}) do
        local dungeon = relationship.dungeon
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
    local quests = Q.API:GetAllQuests()
    self.queue = {}
    self.queueIndex = 1

    for _, quest in ipairs(quests) do
        if (Q:GetSetting("ShowNotificationForAllQuests") or Q.API:IsDungeonQuestChainStart(quest.id)) and quest.requiredLevel == playerLevel and Q.API:IsQuestAvailable(quest.id) then
            local dungeonRelationships = Q.API:GetDungeonRelationshipsForQuest(quest.id)
            table.insert(self.queue, { quest = quest, dungeonRelationships = dungeonRelationships })

            if Q:GetSetting("AutoWaypoint") then
                Q.API:SetQuestWaypoint(quest)
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
    local frame = Q:CreateBackdropFrame('DungeonBuddy_NotificationFrame', UIParent, 450, 300, "MEDIUM", "Primary", "Accent")
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
        Q:SetSetting("NotificationFrame.X", x - centerX)
        Q:SetSetting("NotificationFrame.Y", y - centerY)
    end)

    local savedX = Q:GetSetting("NotificationFrame.X")
    local savedY = Q:GetSetting("NotificationFrame.Y")
    frame:SetPoint("CENTER", UIParent, "CENTER", savedX or 0, savedY or 0)
    Q:ClampFrameToScreen(frame)

    -- Older versions saved the frame's absolute screen center as an offset.
    -- Clamp that restored position and persist the corrected relative offset.
    local x, y = frame:GetCenter()
    local centerX, centerY = UIParent:GetCenter()
    Q:SetSetting("NotificationFrame.X", x - centerX)
    Q:SetSetting("NotificationFrame.Y", y - centerY)
    frame:SetAlpha(0)
    frame:Hide()

    local closeButton = Q:CreateCloseButton(frame)
    closeButton:SetScript("OnClick", function()
        self:Dismiss(true)
    end)

    --------------------------------------------------
    -- Fade In/Out Animation
    --------------------------------------------------
    frame.FadeIn = Q:AddFadeInAnimation(frame, 0.3)
    frame.FadeOut = Q:AddFadeOutAnimation(frame, 0.3)

    --------------------------------------------------
    -- Notification Window Title
    --------------------------------------------------
    local notificationIcon = Q:CreateTexture("NotificationIcon", frame, 40, 40, "UI-QuestPoiLegendary-QuestBang")
    self.notificationIcon = notificationIcon
    Q:SetPixelPerfectPoint(notificationIcon, "TOPLEFT", frame, "TOPLEFT", paddingM, -paddingS)

    local notificationTitle = Q:CreateText("notificationTitle", frame, "A NEW QUEST IS AVAILABLE", fontL, "Accent")
    self.notificationTitle = notificationTitle
    Q:SetPixelPerfectPoint(notificationTitle, "LEFT", notificationIcon, "RIGHT", paddingS, -2)

    local notificationProgress = Q:CreateText("NotificationProgress", frame, "", fontM, "Accent")
    self.notificationProgress = notificationProgress
    Q:SetPixelPerfectPoint(notificationProgress, "LEFT", notificationTitle, "RIGHT", 5, 0)

    --------------------------------------------------
    -- Dungeon Name
    --------------------------------------------------
    local dungeonName = Q:CreateText("DungeonName", frame, "DUNGEON NAME", fontS, "Accent")
    self.dungeonName = dungeonName
    Q:SetPixelPerfectPoint(dungeonName, "TOPLEFT", notificationIcon, "BOTTOMLEFT", 0, -paddingM)

    --------------------------------------------------
    -- Quest Name
    --------------------------------------------------
    local questName = Q:CreateText("QuestName", frame, "QUEST NAME", fontXL, "Primary")
    self.questName = questName
    Q:SetPixelPerfectPoint(questName, "TOPLEFT", dungeonName, "BOTTOMLEFT", 0, -paddingS)

    local questClassIcon = Q:CreateTexture("QuestClassIcon", frame, 20, 20)
    self.questClassIcon = questClassIcon
    questClassIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    Q:SetPixelPerfectPoint(questClassIcon, "TOPLEFT", dungeonName, "BOTTOMLEFT", 0, -paddingS)

    --------------------------------------------------
    -- Quest Source Label
    --------------------------------------------------
    local questSourceLabel = Q:CreateText("QuestSourceLabel", frame, "QUEST STARTED BY", fontS, "Accent")
    self.questSourceLabel = questSourceLabel
    Q:SetPixelPerfectPoint(questSourceLabel, "TOPLEFT", questClassIcon, "BOTTOMLEFT", 0, -paddingM)

    --------------------------------------------------
    -- Quest Source Information
    --------------------------------------------------
    local sourceIcon = Q:CreateTexture("SourceIcon", frame, 20, 20)
    self.sourceIcon = sourceIcon
    sourceIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    Q:SetPixelPerfectPoint(sourceIcon, "TOPLEFT", questSourceLabel, "BOTTOMLEFT", 0, -paddingS)
    
    local questSourceName = Q:CreateText("QuestSourceName", frame, "Name", fontM, "Primary")
    self.questSourceName = questSourceName
    Q:SetPixelPerfectPoint(questSourceName, "LEFT", sourceIcon, "RIGHT", paddingS, 0)
    questSourceName:SetTextColor(unpack(Q.Theme.Status.Success))

    local questSourceZoneName = Q:CreateText("QuestSourceZoneName", frame, "- Orgrimmar", fontM, "Primary")
    self.questSourceZoneName = questSourceZoneName
    Q:SetPixelPerfectPoint(questSourceZoneName, "LEFT", questSourceName, "RIGHT", 0, 0)

    local questSourceText = Q:CreateText("QuestSourceText", frame, "Additional information about the quest source.", fontM, "Secondary")
    self.questSourceText = questSourceText
    Q:SetPixelPerfectPoint(questSourceText, "TOPLEFT", questSourceName, "BOTTOMLEFT", 0, -paddingS)
    Q:SetPixelPerfectWidth(questSourceText, frame:GetWidth() - paddingM * 2)
    questSourceText:SetJustifyH("LEFT")
    questSourceText:SetWordWrap(true)

    --------------------------------------------------
    -- Set Waypoint Button
    --------------------------------------------------
    local trackButton = CreateFrame("Button", nil, frame, "BackdropTemplate")
    self.trackButton = trackButton
    trackButton:EnableMouse(true)
    trackButton:SetFrameLevel(frame:GetFrameLevel() + 1)
    Q:SetPixelPerfectSize(trackButton, 160, 40)
    Q:SetPixelPerfectPoint(trackButton, "BOTTOMLEFT", frame, "BOTTOMLEFT", paddingM, paddingM)
    trackButton:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = pixelPerfect,
        insets = { left = pixelPerfect, right = pixelPerfect, top = pixelPerfect, bottom = pixelPerfect, },
    })

    local trackText = trackButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    trackButton.text = trackText
    trackText:SetPoint("CENTER")
    trackText:SetText("Set Waypoint")
    trackText:SetTextColor(unpack(Q.Theme.Text.Accent))

    local function updateTrackButtonStyle(isHovered)
        local trackColor = Q.Theme.Text.Accent
        if self.trackWaypointSet then
            trackColor = Q.Theme.Status.Success
        end
        local r, g, b = unpack(trackColor)

        trackButton:SetBackdropColor(r, g, b, isHovered and Q.Theme.Alpha.ButtonBackgroundHover or Q.Theme.Alpha.ButtonBackground)
        trackButton:SetBackdropBorderColor(r, g, b, isHovered and Q.Theme.Alpha.ButtonBorderHover or Q.Theme.Alpha.ButtonBorder)
        if isHovered then
            trackButton.text:SetTextColor(unpack(Q.Theme.Text.Primary))
        else
            trackButton.text:SetTextColor(r, g, b)
        end
    end

    updateTrackButtonStyle(false)

    trackButton:SetScript("OnEnter", function()
        updateTrackButtonStyle(true)
    end)
    trackButton:SetScript("OnLeave", function()
        updateTrackButtonStyle(false)
    end)

    --------------------------------------------------------
    -- Dismiss button
    --------------------------------------------------------
    local dismissButton = CreateFrame("Button", nil, frame, "BackdropTemplate")
    self.dismissButton = dismissButton
    dismissButton:EnableMouse(true)
    dismissButton:SetFrameLevel(frame:GetFrameLevel() + 1)
    Q:SetPixelPerfectSize(dismissButton, 160, 40)
    Q:SetPixelPerfectPoint(dismissButton, "BOTTOMRIGHT", frame, "BOTTOMRIGHT", -paddingM, paddingM)

    dismissButton:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = pixelPerfect,
        insets = { left = pixelPerfect, right = pixelPerfect, top = pixelPerfect, bottom = pixelPerfect, },
    })
    local colorR, colorG, colorB = unpack(Q.Theme.Text.Secondary)

    local dismissText = dismissButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dismissButton.text = dismissText
    dismissText:SetPoint("CENTER")
    dismissText:SetText("Dismiss")
    dismissText:SetTextColor(colorR, colorG, colorB)

    local function updateDismissButtonStyle(isHovered)
        dismissButton:SetBackdropColor(colorR, colorG, colorB, isHovered and Q.Theme.Alpha.ButtonBackgroundHover or Q.Theme.Alpha.ButtonBackground)
        dismissButton:SetBackdropBorderColor(colorR, colorG, colorB, isHovered and Q.Theme.Alpha.ButtonBorderHover or Q.Theme.Alpha.ButtonBorder)

        if isHovered then
            dismissButton.text:SetTextColor(unpack(Q.Theme.Text.Primary))
        else
            dismissButton.text:SetTextColor(colorR, colorG, colorB)
        end
    end

    updateDismissButtonStyle(false)

    dismissButton:SetScript("OnEnter", function()
        updateDismissButtonStyle(true)
    end)
    dismissButton:SetScript("OnLeave", function()
        updateDismissButtonStyle(false)
    end)

    --------------------------------------------------------
    -- Button actions
    --------------------------------------------------------
    trackButton:SetScript("OnClick", function()
        if not self.quest then
            return
        end

        Q.API:SetQuestWaypoint(self.quest)

        self.trackWaypointSet = true
        self.trackButton.text:SetText("Waypoint Set")
        updateTrackButtonStyle(self.trackButton:IsMouseOver())
    end)

    dismissButton:SetScript("OnClick", function()
        updateDismissButtonStyle(false)
        updateTrackButtonStyle(false)
        self:Dismiss()
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
        local dungeonRelationships = Q.API:GetDungeonRelationshipsForQuest(quest.id)
        for index, existingQuest in ipairs(self.queue) do
            if existingQuest.quest.id == quest.id then
                table.remove(self.queue, index)
                break
            end
        end
        table.insert(self.queue, { quest = quest, dungeonRelationships = dungeonRelationships })

        if Q:GetSetting("AutoWaypoint") then
            Q.API:SetQuestWaypoint(quest)
        end
    end

    self.queueIndex = 1
    self:DisplayNextInQueue()
end

function Notification:DisplayNextInQueue()
    local queuedQuest = self.queue and self.queue[self.queueIndex]
    if queuedQuest then
        self:DisplayQuest(queuedQuest.quest, queuedQuest.dungeonRelationships)
    end
end

function Notification:DisplayQuest(quest, dungeonRelationships)
    local paddingS = Q.Theme.Padding.S
    self.quest = quest

    if not dungeonRelationships then
        dungeonRelationships = Q.API:GetDungeonRelationshipsForQuest(quest.id)
    end
    local dungeonsText = FormatDungeonRelationships(dungeonRelationships)
    self.dungeonNameValue = dungeonsText

    self.trackWaypointSet = false
    self.trackButton.text:SetText("Set Waypoint")
    local trackColorR, trackColorG, trackColorB = unpack(Q.Theme.Text.Accent)
    self.trackButton:SetBackdropColor(trackColorR, trackColorG, trackColorB, Q.Theme.Alpha.ButtonBackground)
    self.trackButton:SetBackdropBorderColor(trackColorR, trackColorG, trackColorB, Q.Theme.Alpha.ButtonBorder)
    self.trackButton.text:SetTextColor(trackColorR, trackColorG, trackColorB)

    if self.queueIndex ~= #self.queue then
        self.dismissButton.text:SetText("View Next")
    else
        self.dismissButton.text:SetText("Dismiss")
    end

    local colorR, colorG, colorB = unpack(Q.Theme.Text.Secondary)
    self.dismissButton:SetBackdropColor(colorR, colorG, colorB, Q.Theme.Alpha.ButtonBackground)
    self.dismissButton:SetBackdropBorderColor(colorR, colorG, colorB, Q.Theme.Alpha.ButtonBorder)
    self.dismissButton.text:SetTextColor(colorR, colorG, colorB)

    -- Update Dungeon Name
    self.dungeonName:SetText(dungeonsText)
    if #self.queue > 1 then
        self.notificationProgress:SetText(string.format("(%d/%d)", self.queueIndex, #self.queue))
    else
        self.notificationProgress:SetText("")
    end
    
    -- Update Quest Title
    local questTitle = quest.suggestedLevel and string.format("[%d] %s", quest.suggestedLevel, quest.name) or quest.name
    self.questName:SetText(questTitle)
    local color = Q.API:GetDifficultyColor(Q.API:GetPlayerLevel(), quest.suggestedLevel)
    if color then
        self.questName:SetTextColor(color.r, color.g, color.b)
    end

    local classIconTexture = Q.API:GetClassIconTexture(quest.class)
    if classIconTexture then
        self.questClassIcon:SetTexture(classIconTexture)
        self.questClassIcon:Show()
        Q:SetPixelPerfectPoint(self.questName, "TOPLEFT", self.questClassIcon, "TOPRIGHT", paddingS, 0)
    else
        self.questClassIcon:Hide()
        Q:SetPixelPerfectPoint(self.questName, "TOPLEFT", self.dungeonName, "BOTTOMLEFT", 0, -paddingS)
    end

    if quest.source then
        self.questSourceName:SetText(quest.source.name)
        self.questSourceZoneName:SetText(" - " .. quest.source.zone)
        self.questSourceText:SetText(quest.source.text)

        if quest.source.type == "npc" then
            if Q.API:GetPlayerFaction() == "Alliance" then
                self.sourceIcon:SetTexture("Interface\\Icons\\achievement_character_human_male")
            else
                self.sourceIcon:SetTexture("Interface\\Icons\\achievement_character_orc_male")
            end
        elseif quest.source.type == "item" then
            local itemIcon
            if quest.source.itemId then
                if C_Item and C_Item.GetItemIconByID then
                    itemIcon = C_Item.GetItemIconByID(quest.source.itemId)
                end
            end

            self.sourceIcon:SetTexture(itemIcon or "Interface\\Icons\\INV_Scroll_03")
        elseif quest.source.type == "object" then
            self.sourceIcon:SetTexture("Interface\\Icons\\inv_scroll_10")
        end
    end
    
    -- self.frame.FadeIn:Stop()
    -- self.frame.FadeOut:Stop()
    -- self.frame:SetAlpha(0)
    
    if self.queueIndex == 1 then
        self.frame:Show()
        self.frame.FadeIn:Play()
    end

    if Q:GetSetting("AutoWaypoint") then
        self.trackWaypointSet = true
        self.trackButton.text:SetText("Waypoint Set")

        local trackColor = Q.Theme.Text.Accent
        if self.trackWaypointSet then
            trackColor = Q.Theme.Status.Success
        end
        local r, g, b = unpack(trackColor)

        self.trackButton:SetBackdropColor(r, g, b, Q.Theme.Alpha.ButtonBackground)
        self.trackButton:SetBackdropBorderColor(r, g, b, Q.Theme.Alpha.ButtonBorder)
        self.trackButton.text:SetTextColor(r, g, b)
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
