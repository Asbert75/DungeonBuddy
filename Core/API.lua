local _, Q = ...

Q.API = {}

function Q.API:BuildLookupTables()
    for _, quest in ipairs(Q.Quests) do
        Q.QuestById[quest.id] = quest
        for _, dungeon in ipairs(quest.dungeons or {}) do
            local quests = Q.QuestsByDungeonId[dungeon.id]
            if not quests then
                quests = {}
                Q.QuestsByDungeonId[dungeon.id] = quests
            end
            table.insert(quests, quest)
        end
    end

    for _, dungeon in pairs(Q.Dungeons) do
        Q.DungeonById[dungeon.id] = dungeon
    end

    local function addQuestDungeon(questId, dungeon)
        local dungeons = Q.DungeonByQuestId[questId]
        if not dungeons then
            dungeons = {}
            Q.DungeonByQuestId[questId] = dungeons
        end

        for _, existingDungeon in ipairs(dungeons) do
            if existingDungeon.id == dungeon.id then
                return
            end
        end
        table.insert(dungeons, dungeon)
    end

    -- A dungeon quest makes its preceding chain quests relevant to that dungeon too.
    for _, quest in ipairs(Q.Quests) do
        for _, dungeon in ipairs(quest.dungeons or {}) do
            local previousQuestId = quest.previousQuestId
            local visited = { [quest.id] = true }

            while previousQuestId and not visited[previousQuestId] do
                visited[previousQuestId] = true
                local previousQuest = Q.QuestById[previousQuestId]
                if not previousQuest then
                    break
                end

                addQuestDungeon(previousQuest.id, dungeon)
                previousQuestId = previousQuest.previousQuestId
            end
        end
    end

    -- Include direct dungeon membership as well as inherited chain membership.
    for _, quest in ipairs(Q.Quests) do
        for _, dungeon in ipairs(quest.dungeons or {}) do
            addQuestDungeon(quest.id, dungeon)
        end
    end
end

function Q.API:GetPlayerLevel()
    return Q.Debug.Enabled and Q.Debug.Level or UnitLevel("player")
end

function Q.API:GetPlayerFaction()
    return Q.Debug.Enabled and Q.Debug.Faction or UnitFactionGroup("player")
end

function Q.API:GetPlayerClass()
    return Q.Debug.Enabled and Q.Debug.Class or select(2, UnitClass("player"))
end

function Q.API:GetPlayerInfo()
    return {
        level = self:GetPlayerLevel(),
        faction = self:GetPlayerFaction(),
        class = self:GetPlayerClass(),
    }
end

function Q.API:GetClassIconTexture(class)
    if not class then
        return nil
    end

    local className = class:lower():gsub("^%l", string.upper)
    return "Interface\\Addons\\DungeonBuddy\\Media\\Icons\\ClassIcon_" .. className
end

function Q.API:GetDifficultyColor(playerLevel, comparisonLevel)
    if type(playerLevel) ~= "number" or type(comparisonLevel) ~= "number" then
        return nil
    end

    local grayLevel
    if playerLevel <= 5 then
        grayLevel = 0
    elseif playerLevel <= 39 then
        grayLevel = playerLevel - math.floor(playerLevel / 10) - 5
    elseif playerLevel <= 59 then
        grayLevel = playerLevel - math.floor(playerLevel / 5) - 1
    else
        grayLevel = playerLevel - 9
    end

    local levelDifference = comparisonLevel - playerLevel
    if levelDifference >= 5 then
        return Q.Theme.DifficultyColors.Red
    elseif levelDifference >= 3 then
        return Q.Theme.DifficultyColors.Orange
    elseif levelDifference >= -2 then
        return Q.Theme.DifficultyColors.Yellow
    elseif comparisonLevel <= grayLevel then
        return Q.Theme.DifficultyColors.Gray
    else
        return Q.Theme.DifficultyColors.Green
    end
end

function Q.API:GetWaypointText(entityId, isDungeon)
    if isDungeon then
        local dungeon = self:GetDungeonById(entityId)
        return dungeon.name .." (Entrance)"
    end

    local quest = self:GetQuestById(entityId)
    local sourceName = quest.source and quest.source.name

    local title = quest.name
    if sourceName then
        return string.format("%s (%s)", sourceName, title)
    end
    return title
end

function Q.API:GetQuests()
    return Q.Quests
end

function Q.API:GetQuestById(questId)
    return Q.QuestById[questId]
end

function Q.API:GetDungeonById(dungeonId)
    return Q.DungeonById[dungeonId]
end

function Q.API:GetDungeons()
    local dungeons = {}
    for _, dungeon in pairs(Q.Dungeons) do
        table.insert(dungeons, dungeon)
    end

    table.sort(dungeons, function(a, b) return a.minLevel < b.minLevel or (a.minLevel == b.minLevel and a.maxLevel < b.maxLevel) end)
    return dungeons
end

function Q.API:IsDungeonQuestChainStart(questId)
    return not self:GetQuestById(questId).previousQuestId
end

function Q.API:GetRelevantQuestsForZone()
    local quests = {}
    local mapID = C_Map.GetBestMapForUnit("player")
    local zone = C_Map.GetMapInfo(mapID).name
    local playerInfo = Q.API:GetPlayerInfo()

    for _, quest in ipairs(self:GetQuests()) do
        if  self:IsQuestAvailable(quest.id) and
            not self:IsQuestInQuestLog(quest.id) and
            quest.source.zone == zone and
            playerInfo.level <= quest.suggestedLevel + 3 -- Allow a buffer of 3 levels above the suggested level before it doesn't count as "relevant" anymore
        then
            table.insert(quests, quest)
        end
    end
    return quests
end

function Q.API:GetQuestsByDungeonId(dungeonId)
    return Q.QuestsByDungeonId[dungeonId] or {}
end

function Q.API:GetDungeonsForQuest(questId)
    return Q.DungeonByQuestId[questId] or {}
end

function Q.API:IsQuestRelatedToDungeon(questId, dungeonId)
    if not questId or not dungeonId then
        return false
    end

    local quests = Q.QuestsByDungeonId[dungeonId] or {}
    for _, quest in ipairs(quests) do
        if quest.id == questId then
            return true
        end
    end
    return false
end

function Q.API:GetAvailableQuestsByDungeonId(dungeonId, playerInfo)
    local quests = {}
    for _, quest in ipairs(self:GetQuestsByDungeonId(dungeonId) or {}) do
        if  self:IsQuestAvailableToFaction(quest.id, playerInfo) and 
            self:IsQuestAvailableToClass(quest.id, playerInfo) and 
            self:IsQuestAvailableToLevel(quest.id, playerInfo) 
        then
            table.insert(quests, quest)
        end
    end
    return quests
end

function Q.API:DungeonHasAvailableQuests(dungeonId, playerInfo)
    for _, quest in ipairs(self:GetQuests() or {}) do
        if  self:IsQuestRelatedToDungeon(quest.id, dungeonId) and 
            self:IsQuestAvailableToFaction(quest.id, playerInfo) and 
            self:IsQuestAvailableToClass(quest.id, playerInfo) and 
            self:IsQuestAvailableToLevel(quest.id, playerInfo) and 
            (Q:GetSetting("HideCompletedQuests") == false or not self:IsQuestCompleted(quest.id))
        then
            return true
        end
    end

    return false
end

function Q.API:IsPrerequisiteSatisfied(questId)
    local quest = self:GetQuestById(questId)
    if not quest then
        return false
    end
    
    if quest.previousQuestId and not self:IsQuestCompleted(quest.previousQuestId) then
        return false
    end

    return true
end

function Q.API:IsQuestCompleted(questId)
    return C_QuestLog.IsQuestFlaggedCompleted(questId)
end

function Q.API:IsQuestInQuestLog(questId)
    return C_QuestLog.IsOnQuest(questId)
end

function Q.API:IsQuestAvailableToLevel(questId, playerInfo)
    local quest = self:GetQuestById(questId)
    local playerLevel = playerInfo and playerInfo.level or Q.API:GetPlayerLevel()
    if quest.requiredLevel and playerLevel < quest.requiredLevel then
        return false
    end
    return true
end

function Q.API:IsQuestAvailableToFaction(questId, playerInfo)
    local quest = self:GetQuestById(questId)
    if not quest.faction then
        return true
    end

    local playerFaction = playerInfo and playerInfo.faction or Q.API:GetPlayerFaction()
    return quest.faction == playerFaction
end

function Q.API:IsQuestAvailableToClass(questId, playerInfo)
    local quest = self:GetQuestById(questId)
    if not quest.class then
        return true
    end

    local playerClass = playerInfo and playerInfo.class or Q.API:GetPlayerClass()
    return quest.class == playerClass
end

function Q.API:IsQuestAvailable(questId)
    if not self:GetQuestById(questId) then
        return false
    end

    local playerInfo = Q.API:GetPlayerInfo()

    return
        not self:IsQuestCompleted(questId)
        and self:IsQuestAvailableToLevel(questId, playerInfo)
        and self:IsQuestAvailableToFaction(questId, playerInfo)
        and self:IsQuestAvailableToClass(questId, playerInfo)
        and self:IsPrerequisiteSatisfied(questId)
end

function Q.API:GetRandomQuest()
    local chainStartQuests = {}
    for _, quest in ipairs(self:GetQuests()) do
        if self:IsDungeonQuestChainStart(quest.id) then
            table.insert(chainStartQuests, quest)
        end
    end

    if #chainStartQuests == 0 then
        return nil, {}
    end

    local quest = chainStartQuests[math.random(#chainStartQuests)]

    return quest
end

function Q.API:SetWaypoint(entity, isDungeon)
    local mapId, x, y
    if isDungeon then
        mapId = entity.location.mapId
        x = entity.location.x
        y = entity.location.y
    else
        mapId = entity.source.location.mapId
        x = entity.source.location.x
        y = entity.source.location.y
        if not (mapId and x and y) then
            Q:PrettyPrint("No waypoint location is available for this quest.")
            return
        end
    end
    local title = self:GetWaypointText(entity.id, isDungeon)
    local tomtom = rawget(_G, "TomTom")
    if tomtom and tomtom.AddWaypoint then
        tomtom:AddWaypoint(tonumber(mapId), tonumber(x), tonumber(y), {
            title = title,
            from = "Dungeon Buddy",
            persistent = true,
        })
        return
    end

    Q:PrettyPrint("Waypoints requires the TomTom addon to be enabled.")
end
