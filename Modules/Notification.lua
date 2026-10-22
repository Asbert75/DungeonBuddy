local _, Q = ...
local Notification = Q.Addon:NewModule("Notification", "AceEvent-3.0", "AceConsole-3.0")
Notification.queue = {}
Notification.queueIndex = 1
Q.Notification = Notification

local function FormatInstanceRelationships(quest)
    local groups = {}
    local groupOrder = {}

    for _, instance in ipairs(Q.API:GetInstancesForQuest(quest.id)) do
        if instance then
            local entity, wing = instance.name:match("^(.+):%s*(.+)$")
            local groupName = entity or instance.name
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
    local playerLevel = Q.API:GetPlayerLevel() + 1
    local quests = Q.API:GetQuests()
    self.queue = {}
    self.queueIndex = 1

    for _, quest in ipairs(quests) do
        if ((Q:GetSetting("ShowNotificationForAllQuests") and quest.instances and #quest.instances > 0) or Q.API:IsInstanceQuestLineageStart(quest.id)) and quest.requiredLevel == playerLevel and Q.API:IsQuestAvailable(quest.id) then
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

    local fontS, fontM, fontL, fontXL = Q.Theme.Font.S, Q.Theme.Font.M, Q.Theme.Font.L, Q.Theme.Font.XL
    local paddingS, paddingM = Q.Theme.Padding.S, Q.Theme.Padding.M

    --------------------------------------------------
    -- Create Notification Frame
    --------------------------------------------------
    self.frame = Q:CreateBackdropFrame('DungeonBuddy_NotificationFrame', UIParent, 500, 300, "HIGH", "Primary", "Accent", 0.9, 0.9)

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

    self.frame:SetPoint("CENTER", UIParent, "CENTER", Q:GetSetting("NotificationFrame.x") or 0, Q:GetSetting("NotificationFrame.y") or 250)
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
    -- Instance Name
    --------------------------------------------------
    self.instanceName = Q:CreateText("InstanceName", self.frame, "INSTANCE NAME", fontS, "Accent")
    Q:SetPixelPerfectPoint(self.instanceName, "TOPLEFT", self.notificationIcon, "BOTTOMLEFT", 0, -paddingM)

    --------------------------------------------------
    -- Quest Name
    --------------------------------------------------
    self.questName = Q:CreateText("QuestName", self.frame, "QUEST NAME", fontXL, "Primary")
    Q:SetPixelPerfectPoint(self.questName, "TOPLEFT", self.instanceName, "BOTTOMLEFT", 0, -paddingS)

    self.questClassIcon = Q:CreateTexture("QuestClassIcon", self.frame, 20, 20)
    self.questClassIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    Q:SetPixelPerfectPoint(self.questClassIcon, "TOPLEFT", self.instanceName, "BOTTOMLEFT", 0, -paddingS)

    self.questProfessionIcon = Q:CreateTexture("QuestProfessionIcon", self.frame, 20, 20)
    self.questProfessionIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

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
    local waypointHandlers = {
        ["OnMouseEnter"] = function()
            local tooltip = Q:GetTooltip()
            local r, g, b = unpack(Q.Theme.Text.Primary)

            tooltip:SetOwner(self.waypointButton, "ANCHOR_RIGHT")
            tooltip:SetText("Find Source", unpack(Q.Theme.Text.Accent))
            tooltip:AddLine("Add a waypoint at this quests source(s)", r, g, b, true)

            tooltip:Show()
        end,
        ["OnMouseLeave"] = function()
            Q:GetTooltip():Hide()
        end,
        ["OnClick"] = function()
            if not self.quest then
                return
            end

            Q.API:SetWaypoint(self.quest)

            self.trackWaypointSet = true
            self.waypointButton.label:SetText("Waypoint Set")
            self.waypointButton:SetColor(Q.Theme.Status.Success)
        end
    }
    self.waypointButton = Q:CreateButton(nil, self.frame, "Find Source", 140, 40, fontM, Q.Theme.Text.Accent, waypointHandlers)
    self.waypointButton:SetFrameLevel(self.frame:GetFrameLevel() + 1)
    Q:SetPixelPerfectPoint(self.waypointButton, "BOTTOMLEFT", self.frame, "BOTTOMLEFT", paddingM, paddingM)

    --------------------------------------------------------
    -- Dismiss / View Next button
    --------------------------------------------------------
    local dismissHandlers = {
        ["OnClick"] = function()
            self:Dismiss()
        end
    }
    self.dismissButton = Q:CreateButton(nil, self.frame, "Dismiss", 120, 40, fontM, Q.Theme.Text.Secondary, dismissHandlers)
    self.dismissButton:SetFrameLevel(self.frame:GetFrameLevel() + 1)
    Q:SetPixelPerfectPoint(self.dismissButton, "BOTTOMRIGHT", self.frame, "BOTTOMRIGHT", -paddingM, paddingM)

    --------------------------------------------------
    -- View Previous Button
    --------------------------------------------------
    local previousHandlers = {
        ["OnClick"] = function()
            Notification:DisplayPreviousInQueue()
        end
    }
    self.previousQuestButton = Q:CreateButton(nil, self.frame, "< Previous", 120, 40, fontM, Q.Theme.Text.Secondary, previousHandlers)
    self.previousQuestButton:SetFrameLevel(self.frame:GetFrameLevel() + 1)
    Q:SetPixelPerfectPoint(self.previousQuestButton, "RIGHT", self.dismissButton, "LEFT", -paddingS, 0)
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

    local hasMultipleSources = false
    local zoneText = " - "
    if quest.sources and #quest.sources > 1 then
        hasMultipleSources = true

        for index, source in ipairs(quest.sources) do
            if source.faction == playerFaction then
                zoneText = (index ~= 1 and zoneText .. '/' or zoneText) .. source.zone
            end
        end
    end

    Notification.questSourceName:SetText(hasMultipleSources and "Multiple Sources" or quest.source.name)
    Notification.questSourceZoneName:SetText(hasMultipleSources and zoneText or " - " .. quest.source.zone)
    Notification.questSourceText:SetText(hasMultipleSources and "" or quest.source.text)

    if hasMultipleSources or quest.source.type == "npc" then
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

local function UpdateClassIcon(questClass, questProfession)
    local classIconTexture = Q.API:GetClassIconTexture(questClass)
    local professionIconTexture = Q.API:GetProfessionIconTexture(questProfession)
    local previous = Notification.instanceName
    local previousPoint, offsetX, offsetY = "BOTTOMLEFT", 0, -Q.Theme.Padding.S
    local paddingS = Q.Theme.Padding.S

    if classIconTexture then
        Notification.questClassIcon:SetTexture(classIconTexture)
        Notification.questClassIcon:Show()
        previous, previousPoint, offsetX, offsetY = Notification.questClassIcon, "TOPRIGHT", paddingS, 0
    else
        Notification.questClassIcon:Hide()
    end

    if professionIconTexture then
        local icon = Notification.questProfessionIcon
        icon:SetTexture(professionIconTexture)
        icon:ClearAllPoints()
        Q:SetPixelPerfectPoint(icon, "TOPLEFT", previous, previousPoint, offsetX, offsetY)
        icon:Show()
        previous, previousPoint, offsetX, offsetY = icon, "TOPRIGHT", paddingS, 0
    else
        Notification.questProfessionIcon:Hide()
    end

    Q:SetPixelPerfectPoint(Notification.questName, "TOPLEFT", previous, previousPoint, offsetX, offsetY)
end

local function UpdateActionButtons()
    Notification.trackWaypointSet = false
    Notification.waypointButton.label:SetText("Set Waypoint")
    Notification.waypointButton:SetColor(Q.Theme.Text.Accent)

    if Notification.queueIndex ~= #Notification.queue then
        Notification.dismissButton.label:SetText("Next >")
    else
        Notification.dismissButton.label:SetText("Dismiss")
    end

    if Notification.queueIndex == 1 then
        Notification.previousQuestButton:Hide()
    else
        Notification.previousQuestButton:Show()
    end

    if Q:GetSetting("AutoWaypoint") then
        Notification.trackWaypointSet = true
        Notification.waypointButton.label:SetText("Waypoint Set")
        Notification.waypointButton:SetColor(Q.Theme.Status.Success)
    end
end

function Notification:DisplayQuest(quest, isPrevious)
    self.quest = quest

    local playerInfo = Q.API:GetPlayerInfo()

    -- Update window title
    self.notificationTitle:SetText("A NEW QUEST CHAIN IS AVAILABLE")
    if (not quest.prerequisites or #quest.prerequisites == 0) and (quest.instances and #quest.instances > 0) then
        self.notificationTitle:SetText("A NEW INSTANCE QUEST IS AVAILABLE")
    end

    -- Update Instance Name Text
    self.instanceName:SetText(FormatInstanceRelationships(quest))
    
    -- Update Quest Title
    local questTitle = (Q:GetSetting("ShowSuggestedQuestLevel") and quest.suggestedLevel and string.format("[%d] %s", quest.suggestedLevel, quest.name)) or quest.name
    self.questName:SetText(questTitle)
    local color = Q.API:GetDifficultyColor(playerInfo.level, quest.suggestedLevel)
    self.questName:SetTextColor(color.r, color.g, color.b)

    UpdateClassIcon(quest.class, quest.profession)
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
    self:UnregisterEvent("PLAYER_LEVEL_UP")
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

-- The module itself stays enabled so other modules (zone reminders) can still queue notifications;
-- the level-up setting only controls whether the level-up event is listened to.
function Notification:UpdateLevelUpRegistration()
    if Q:GetSetting("ShowNotificationOnLevelUp") then
        self:RegisterEvent("PLAYER_LEVEL_UP", "LevelUpEventHandler")
    else
        self:UnregisterEvent("PLAYER_LEVEL_UP")
    end
end

function Notification:OnEnable()
    self:UpdateLevelUpRegistration()

    if not self.frame then
        self:Create()
    end
end
