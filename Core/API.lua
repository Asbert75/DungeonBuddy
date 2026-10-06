local _, Q = ...

Q.API = {}

--#region Helpers
local function GetPrerequisiteQuestIds(quest)
    local prerequisiteQuestIds = {}
    local seen = {}

    local function add(questId)
        if questId and not seen[questId] then
            seen[questId] = true
            table.insert(prerequisiteQuestIds, questId)
        end
    end

    add(quest.previousQuestId)
    add(quest.prerequisiteId)

    for _, questId in ipairs(quest.prerequisiteQuestIds or {}) do
        add(questId)
    end
    for _, questId in ipairs(quest.prerequisiteIds or {}) do
        add(questId)
    end

    return prerequisiteQuestIds
end

function Q.API:BuildLookupTables()
    Q.DungeonById = {}
    Q.QuestById = {}
    Q.DungeonsByQuestId = {}
    Q.DungeonRelationshipsByQuestId = {}
    Q.DungeonQuestChainStartsByQuestId = {}

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
            -- Direct membership takes precedence if a quest is also an ancestor
            -- of another quest assigned to the same dungeon.
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

        for _, questId in ipairs(dungeon.questIds or {}) do
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

        for _, prerequisiteQuestId in ipairs(GetPrerequisiteQuestIds(quest)) do
            local prerequisiteQuest = Q.QuestById[prerequisiteQuestId]
            if prerequisiteQuest then
                addRelationship(prerequisiteQuestId, dungeon, "leadsTo")
                if #GetPrerequisiteQuestIds(prerequisiteQuest) == 0 then
                    Q.DungeonQuestChainStartsByQuestId[prerequisiteQuestId] = true
                end
                addPrerequisiteRelationships(prerequisiteQuestId, dungeon, visited)
            end
        end
    end

    for _, dungeon in ipairs(Q.Dungeons) do
        for _, questId in ipairs(dungeon.questIds or {}) do
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
--#endregion

--#region Getters
function Q.API:GetAllQuests()
    return Q.Quests
end

function Q.API:GetQuestById(questId)
    return Q.QuestById[questId]
end

function Q.API:GetDungeons()
    return Q.Dungeons
end

function Q.API:GetDungeonsForQuest(questId)
    return Q.DungeonsByQuestId[questId] or {}
end

function Q.API:GetDungeonRelationshipsForQuest(questId)
    return Q.DungeonRelationshipsByQuestId[questId] or {}
end

function Q.API:IsDungeonQuestChainStart(questId)
    return Q.DungeonQuestChainStartsByQuestId[questId] == true
end

function Q.API:GetDungeon(questIdToFind)
    for _, entry in pairs(Q.Dungeons) do
        for _, questId in ipairs(entry.questIds) do
            if questId == questIdToFind then
                return entry
            end
        end
    end
    return nil
end

function Q.API:GetRelevantQuestsForZone()
    local quests = {}
    local mapID = C_Map.GetBestMapForUnit("player")
    local zone = C_Map.GetMapInfo(mapID).name

    for _, quest in ipairs(Q.Quests) do
        if  not self:IsQuestInQuestLog(quest.id) and 
            not self:IsQuestCompleted(quest.id) and 
            self:IsQuestAvailableToLevel(quest.id) and 
            self:IsQuestAvailableToFaction(quest.id) and 
            self:IsQuestAvailableToClass(quest.id) and quest.source.zone == zone 
        then
            table.insert(quests, quest)
        end
    end
    return quests
end

function Q.API:GetQuestsForDungeon(dungeonId)
    local dungeon = Q.DungeonById[dungeonId]
    if not dungeon then
        return {}
    end

    local quests = {}
    for _, questId in ipairs(dungeon.questIds or {}) do
        local quest = Q.QuestById[questId]
        if quest and self:IsQuestAvailableToFaction(questId) and self:IsQuestAvailableToClass(questId) and self:IsQuestAvailableToLevel(questId) then
            table.insert(quests, quest)
        end
    end
    return quests
end

function Q.API:HasAvailableQuestsForDungeon(dungeonId)
    for questId, relationships in pairs(Q.DungeonRelationshipsByQuestId) do
        for _, relationship in ipairs(relationships) do
            if relationship.dungeon.id == dungeonId and self:IsQuestAvailableToFaction(questId) and self:IsQuestAvailableToClass(questId) and self:IsQuestAvailableToLevel(questId) then
                return true
            end
        end
    end

    return false
end

--#endregion

--#region Quest Statuses
function Q.API:IsPrerequisiteSatisfied(questId)
    local quest = self:GetQuestById(questId)
    if not quest then
        return false
    end

    for _, prerequisiteQuestId in ipairs(GetPrerequisiteQuestIds(quest)) do
        if not self:IsQuestCompleted(prerequisiteQuestId) then
            return false
        end
    end

    return true
end

-- Returns true if the player has turned in the quest
function Q.API:IsQuestCompleted(questId)
    return C_QuestLog.IsQuestFlaggedCompleted(questId)
end

-- Returns true only if the quest is completed and in the players quest log
function Q.API:IsQuestObjectivesCompleted(questId)
    return C_QuestLog.IsComplete(questId)
end

-- Returns true if the quest is currently active in the player's quest log
function Q.API:IsQuestInQuestLog(questId)
    return C_QuestLog.IsOnQuest(questId)
end

function Q.API:IsQuestAvailableToLevel(questId)
    local quest = self:GetQuestById(questId)
    local playerLevel = Q.API:GetPlayerLevel()
    if quest.requiredLevel and playerLevel < quest.requiredLevel then
        return false
    end
    return true
end

function Q.API:IsQuestAvailableToFaction(questId)
    local quest = self:GetQuestById(questId)
    if not quest.faction then
        return true
    end

    local playerFaction = Q.API:GetPlayerFaction()
    return quest.faction == playerFaction
end

function Q.API:IsQuestAvailableToClass(questId)
    local quest = self:GetQuestById(questId)
    if not quest.class then
        return true
    end

    local _, playerClass = UnitClass("player")
    return quest.class == playerClass
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

function Q.API:IsQuestAvailable(questId)
    if not self:GetQuestById(questId) then
        return false
    end

    return
        not self:IsQuestCompleted(questId)
        and self:IsQuestAvailableToLevel(questId)
        and self:IsQuestAvailableToFaction(questId)
        and self:IsQuestAvailableToClass(questId)
        and self:IsPrerequisiteSatisfied(questId)
end
--#endregion

function Q.API:GetQuestSourceWaypoint(questId)
    local quest = self:GetQuestById(questId)
    if not quest or not quest.source or not quest.source.location then
        return nil, nil, nil
    end

    local mapID = quest.source.location.mapId
    local x = quest.source.location.x
    local y = quest.source.location.y
    return mapID, x, y
end

function Q.API:GetQuestWaypointText(questId)
    local quest = self:GetQuestById(questId)
    if not quest then
        return "Quest waypoint"
    end

    local sourceName = quest.source and quest.source.name
    local dungeonNames = {}
    for _, relationship in ipairs(self:GetDungeonRelationshipsForQuest(questId)) do
        local dungeonName = relationship.dungeon and relationship.dungeon.name
        if dungeonName then
            table.insert(dungeonNames, dungeonName)
        end
    end

    local title = quest.name or "Quest"
    if #dungeonNames > 0 then
        title = string.format("%s (%s)", title, table.concat(dungeonNames, ", "))
    end
    if sourceName then
        return string.format("%s (%s)", sourceName, title)
    end
    return title
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
    local mapId, x, y = self:GetQuestSourceWaypoint(quest.id)
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
