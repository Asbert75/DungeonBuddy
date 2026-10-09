local _, Q = ...

Q.API = {}

-- Working mainly in SQL server professionaly these days I've gotten used to being able to JOIN tables together to build complex relationships between data,
-- and seeing how LUA does not seem to expose JS-like higher-order functions such as .map(), .find() etc I've decided this is as close as it'll get
function Q.API:BuildLookupTables()
    for _, quest in ipairs(Q.Quests) do
        Q.QuestById[quest.id] = quest
    end

    local relationshipIndex = {}

    local function addRelationship(questId, dungeon, relation)
        local relationships = Q.DungeonRelationshipsByQuestId[questId]
        if not relationships then
            relationships = {}
            Q.DungeonRelationshipsByQuestId[questId] = relationships
            relationshipIndex[questId] = {}
        end

        local indexByDungeonId = relationshipIndex[questId]
        local existingIndex = indexByDungeonId[dungeon.id]
        if existingIndex then
            if relation == "direct" then
                relationships[existingIndex].relation = "direct"
            end
            return
        end

        table.insert(relationships, { dungeon = dungeon, relation = relation })
        indexByDungeonId[dungeon.id] = #relationships
    end

    for _, dungeon in ipairs(Q.Dungeons) do
        Q.DungeonById[dungeon.id] = dungeon

        for _, questId in ipairs(dungeon.questIds) do
            local dungeons = Q.DungeonsByQuestId[questId] 
            if not dungeons then
                dungeons = {}
                Q.DungeonsByQuestId[questId] = dungeons
            end
            table.insert(dungeons, dungeon)
            addRelationship(questId, dungeon, "direct")
        end
    end

    local function addPrerequisiteRelationships(questId, dungeon, visited)
        if visited[questId] then
            return
        end
        visited[questId] = true

        local quest = Q.QuestById[questId]
        if not quest then
            return
        end

        if quest.previousQuestId then
            local prerequisiteQuest = Q.QuestById[quest.previousQuestId]
            if prerequisiteQuest then
                addRelationship(quest.previousQuestId, dungeon, "leadsTo")
                addPrerequisiteRelationships(quest.previousQuestId, dungeon, visited)
            end
        end
    end

    for _, dungeon in ipairs(Q.Dungeons) do
        for _, questId in ipairs(dungeon.questIds) do
            addPrerequisiteRelationships(questId, dungeon, {})
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

function Q.API:GetQuestWaypointText(questId)
    local quest = self:GetQuestById(questId)
    if not quest then
        return "Unknown"
    end

    local sourceName = quest.source and quest.source.name

    local title = quest.name
    if sourceName then
        return string.format("%s (%s)", sourceName, title)
    end
    return title
end

function Q.API:GetAllQuests()
    return Q.Quests
end

function Q.API:GetQuestById(questId)
    return Q.QuestById[questId]
end

function Q.API:GetDungeons()
    return Q.Dungeons
end

function Q.API:GetDungeonRelationshipsForQuest(questId)
    return Q.DungeonRelationshipsByQuestId[questId] or {}
end

function Q.API:IsDungeonQuestChainStart(questId)
    return not self:GetQuestById(questId).previousQuestId
end

function Q.API:GetRelevantQuestsForZone()
    local quests = {}
    local mapID = C_Map.GetBestMapForUnit("player")
    local zone = C_Map.GetMapInfo(mapID).name
    local playerInfo = Q.API:GetPlayerInfo()

    for _, quest in ipairs(Q.Quests) do
        if  not self:IsQuestInQuestLog(quest.id) and 
            not self:IsQuestCompleted(quest.id) and 
            self:IsQuestAvailableToLevel(quest.id, playerInfo) and 
            self:IsQuestAvailableToFaction(quest.id, playerInfo) and 
            self:IsQuestAvailableToClass(quest.id, playerInfo) and quest.source.zone == zone
        then
            table.insert(quests, quest)
        end
    end
    return quests
end

function Q.API:GetQuestsForDungeon(dungeonId, playerInfo)
    local dungeon = Q.DungeonById[dungeonId]
    if not dungeon then
        return {}
    end

    local quests = {}
    for _, questId in ipairs(dungeon.questIds or {}) do
        local quest = Q.QuestById[questId]
        if quest and self:IsQuestAvailableToFaction(questId, playerInfo) and self:IsQuestAvailableToClass(questId, playerInfo) and self:IsQuestAvailableToLevel(questId, playerInfo) then
            table.insert(quests, quest)
        end
    end
    return quests
end

function Q.API:DungeonHasAvailableQuests(dungeonId, playerInfo)
    for questId, relationships in pairs(Q.DungeonRelationshipsByQuestId) do
        for _, relationship in ipairs(relationships) do
            if relationship.dungeon.id == dungeonId and 
                self:IsQuestAvailableToFaction(questId, playerInfo) and 
                self:IsQuestAvailableToClass(questId, playerInfo) and 
                self:IsQuestAvailableToLevel(questId, playerInfo) and 
                (Q:GetSetting("HideCompletedQuests") == false or not self:IsQuestCompleted(questId))
            then
                return true
            end
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

-- Returns true if the player has turned in the quest
function Q.API:IsQuestCompleted(questId)
    return C_QuestLog.IsQuestFlaggedCompleted(questId)
end

-- Returns true if the quest is currently active in the player's quest log
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
    for _, quest in ipairs(Q.Quests) do
        if self:IsDungeonQuestChainStart(quest.id) then
            table.insert(chainStartQuests, quest)
        end
    end

    if #chainStartQuests == 0 then
        return nil, {}
    end

    local quest = chainStartQuests[math.random(#chainStartQuests)]
    local dungeonRelationships = self:GetDungeonRelationshipsForQuest(quest.id)

    return quest, dungeonRelationships
end

function Q.API:SetQuestWaypoint(quest)
    local mapId = quest.source.location.mapId
    local x = quest.source.location.x
    local y = quest.source.location.y
    if not (mapId and x and y) then
        Q:PrettyPrint("No waypoint location is available for this quest.")
        return
    end
    
    local title = self:GetQuestWaypointText(quest.id)
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
