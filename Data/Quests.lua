local _, Q = ...

--[[
    The "dungeons" property on a quest only tells the addon which dungeons that this particular quest
    should be displayed as a "main" quest, that is; which dungeon in the quest tracker it is displayed
    on the "main" level.
]]
Q.Quests = {
    --#region Hall of Thanes
    {
        id = 96403,
        faction = "Alliance",
        name = "Important Heirlooms",
        suggestedLevel = 15,
        requiredLevel = 10,
        source = { 
            type = "npc", 
            name = "Thom Filch", 
            zone = "Ironforge", 
            location = { mapId = 1455, x = 0.326, y = 0.446 } 
        },
        dungeons = { Q.Dungeons["Hall of Thanes"] }
    },
    {
        id = 96394,
        faction = "Alliance",
        name = "The Restless Dead",
        suggestedLevel = 15,
        requiredLevel = 10,
        source = { 
            type = "npc", 
            name = "Afadra Dunwall", 
            zone = "Ironforge", 
            location = { mapId = 1455, x = 0.340, y = 0.488 } 
        },
        dungeons = { Q.Dungeons["Hall of Thanes"] }
    },
        {
        id = 96395,
        faction = nil,
        name = "An Ancient Grudge",
        suggestedLevel = 15,
        requiredLevel = 10,
        source = { 
            type = "npc", 
            name = "Ghostly Attendant", 
            zone = "Hall of Thanes", 
            location = { mapId = 1455, x = 0.614, y = 0.892 }
        },
        dungeons = { Q.Dungeons["Hall of Thanes"] }
    },
    {
        id = 96393,
        faction = "Alliance",
        name = "Old Ironforge Incursion",
        suggestedLevel = 16,
        requiredLevel = 9,
        previousQuestId = 96391,
        source = { 
            type = "npc", 
            name = "Earthseer Farsen", 
            zone = "Dun Morogh", 
            location = { mapId = 1426, x = 0.648, y = 0.584 } 
        },
        dungeons = { Q.Dungeons["Hall of Thanes"] }
    },
    {
        id = 96391,
        faction = "Alliance",
        name = "Underground Map",
        suggestedLevel = 15,
        requiredLevel = 9,
        source = { 
            type = "item", 
            name = "Dark Iron Map", 
            itemId = 274268, 
            zone = "Dun Morogh", 
            location = { mapId = 1426, x = 0.65, y = 0.58 }, 
            text = "Dropped by Captain Beld and Dark Iron spies" 
        },
        dungeons = { Q.Dungeons["Hall of Thanes"] }
    },
    {
        id = 98423,
        faction = "Alliance",
        name = "The Treaty of Understanding",
        suggestedLevel = 16,
        requiredLevel = 9,
        source = {
            type = "item",
            name = "Treaty of Understanding",
            itemId = 281030,
            zone = "Hall of Thanes",
            location = { mapId = 1455, x = 0.614, y = 0.892 },
            text = "Found inside the vault in the Reliquary of Kings"
        },
        dungeons = { Q.Dungeons["Hall of Thanes"] }
    },
    --#endregion

    --#region Ragefire Chasm
    {
        id = 5726,
        faction = "Horde",
        name = "Hidden Enemies",
        suggestedLevel = 12,
        requiredLevel = 9,
        source = {
            type = "npc",
            name = "Thrall",
            zone = "Orgrimmar",
            location = { mapId = 1454, x = 0.31, y = 0.37 },
        },
    },
    {
        id = 5727,
        faction = "Horde",
        name = "Hidden Enemies",
        suggestedLevel = 12,
        requiredLevel = 9,
        previousQuestId = 5726,
        source = {
            type = "npc",
            name = "Thrall",
            zone = "Orgrimmar",
            location = { mapId = 1454, x = 0.31, y = 0.37 },
        },
    },
    {
        id = 5728,
        faction = "Horde",
        name = "Hidden Enemies",
        suggestedLevel = 16,
        requiredLevel = 9,
        previousQuestId = 5727,
        source = {
            type = "npc",
            name = "Thrall",
            zone = "Orgrimmar",
            location = { mapId = 1454, x = 0.31, y = 0.37 },
        },
        dungeons = { Q.Dungeons["Ragefire Chasm"] }
    },
    {
        id = 5761,
        faction = "Horde",
        name = "Slaying the Beast",
        suggestedLevel = 16,
        requiredLevel = 9,
        source = {
            type = "npc",
            name = "Neeru Fireblade",
            zone = "Orgrimmar",
            location = { mapId = 1454, x = 0.49, y = 0.50 },
        },
        dungeons = { Q.Dungeons["Ragefire Chasm"] }
    },
    {
        id = 5725,
        faction = "Horde",
        name = "The Power to Destroy...",
        suggestedLevel = 16,
        requiredLevel = 9,
        source = {
            type = "npc",
            name = "Varimathras",
            zone = "Undercity",
            location = { mapId = 1458, x = 0.56, y = 0.92 },
        },
        dungeons = { Q.Dungeons["Ragefire Chasm"] }
    },
    {
        id = 5723,
        faction = "Horde",
        name = "Testing an Enemy's Strength",
        suggestedLevel = 15,
        requiredLevel = 9,
        source = {
            type = "npc",
            name = "Rahauro",
            zone = "Thunder Bluff",
            location = { mapId = 1456, x = 0.70, y = 0.30 },
        },
        dungeons = { Q.Dungeons["Ragefire Chasm"] }
    },
    {
        id = 5724,
        faction = "Horde",
        name = "Returning the Lost Satchel",
        suggestedLevel = 16,
        previousQuestId = 5722,
        requiredLevel = 9,
        source = {
            type = "npc",
            name = "Maur Grimtotem",
            zone = "Ragefire Chasm",
            location = { mapId = 1454, x = 0.53, y = 0.50 },
        },
        dungeons = { Q.Dungeons["Ragefire Chasm"] }
    },
    {
        id = 5722,
        faction = "Horde",
        name = "Searching for the Lost Satchel",
        suggestedLevel = 16,
        requiredLevel = 9,
        source = {
            type = "npc",
            name = "Rahauro",
            zone = "Thunder Bluff",
            location = { mapId = 1456, x = 0.70, y = 0.30 },
        }
    },
    --#endregion

    --#region Ruins of Lordaeron
    {
        id = 92401,
        faction = "Horde",
        name = "A Frightened Request",
        suggestedLevel = 22,
        requiredLevel = 15,
        source = { 
            type = "npc", 
            name = "Tabitha Heartweaver", 
            zone = "Silverpine Forest", 
            location = { mapId = 1421, x = 0.446, y = 0.429 } 
        },
        dungeons = { Q.Dungeons["Ruins of Lordaeron"] }
    },
    {
        id = 95204,
        faction = "Horde",
        name = "Crest of Lordaeron",
        suggestedLevel = 22,
        requiredLevel = 16,
        source = { 
            type = "item", 
            name = "Crest of Lordaeron", 
            itemId = 275521, 
            zone = "Ruins of Lordaeron", 
            location = { mapId = 1420, x = 0.61, y = 0.60 },
            text = "Search the ruins; the crest can appear in several locations" 
        },
        dungeons = { Q.Dungeons["Ruins of Lordaeron"] }
    },
    {
        id = 95189,
        faction = "Alliance",
        name = "Crest of Lordaeron",
        suggestedLevel = 22,
        requiredLevel = 16,
        source = { 
            type = "item", 
            name = "Crest of Lordaeron", 
            itemId = 268579, 
            zone = "Ruins of Lordaeron", 
            location = { mapId = 1420, x = 0.61, y = 0.60 },
            text = "Search the ruins; the crest can appear in several locations" 
        },
        dungeons = { Q.Dungeons["Ruins of Lordaeron"] }
    },
    {
        id = 92421,
        faction = "Horde",
        name = "Light's Justice",
        suggestedLevel = 22,
        requiredLevel = 15,
        source = { 
            type = "npc", 
            name = "Morbin Lightbane", 
            zone = "Undercity", 
            location = { mapId = 1458, x = 0.578, y = 0.897 }
        },
        dungeons = { Q.Dungeons["Ruins of Lordaeron"] }
    },
    {
        id = 95216,
        faction = "Horde",
        name = "The New Plague",
        suggestedLevel = 22,
        requiredLevel = 16,
        source = { 
            type = "npc", 
            name = "Theodore Griffs", 
            zone = "Undercity", 
            location = { mapId = 1458, x = 0.467, y = 0.719 }
        },
        dungeons = { Q.Dungeons["Ruins of Lordaeron"] }
    },
    {
        id = 92422,
        faction = "Horde",
        name = "The Wrath of Rath'mael",
        suggestedLevel = 22,
        requiredLevel = 15,
        source = { 
            type = "npc", 
            name = "Deathguard Kristof", 
            zone = "Tirisfal Glades", 
            location = { mapId = 1420, x = 0.652, y = 0.602 } 
        },
        dungeons = { Q.Dungeons["Ruins of Lordaeron"] }
    },
    {
        id = 97288,
        faction = "Horde",
        name = "Unending Torment",
        suggestedLevel = 21,
        requiredLevel = 16,
        source = { 
            type = "item", 
            name = "Abominable Head", 
            itemId = 280438, 
            zone = "Ruins of Lordaeron", 
            location = { mapId = 1420, x = 0.61, y = 0.60 },
            text = "Dropped by The Baron inside the dungeon" 
        },
        dungeons = { Q.Dungeons["Ruins of Lordaeron"] }
    },
    {
        id = 95250,
        faction = "Alliance",
        name = "Abominable Creatures",
        suggestedLevel = 21,
        requiredLevel = 16,
        source = { 
            type = "npc", 
            name = "Captain Truman", 
            zone = "Ruins of Lordaeron", 
            location = { mapId = 1420, x = 0.61, y = 0.60 },
            text = "Found inside the dungeon at the entrance"
        },
        dungeons = { Q.Dungeons["Ruins of Lordaeron"] }
    },
    {
        id = 92415,
        faction = "Alliance",
        name = "Remember That I Love You",
        suggestedLevel = 22,
        requiredLevel = 15,
        source = { 
            type = "item", 
            name = "Blood-Stained Letter", 
            itemId = 251522, 
            zone = "Ruins of Lordaeron", 
            location = { mapId = 1420, x = 0.61, y = 0.60 },
            text = "Found in the dungeon near Rath'mael" 
        },
        dungeons = { Q.Dungeons["Ruins of Lordaeron"] }
    },
    {
        id = 95195,
        faction = "Alliance",
        name = "Bloodied Insignia",
        suggestedLevel = 22,
        requiredLevel = 16,
        source = { 
            type = "item", 
            name = "Bloodied Insignia", 
            itemId = 268535, 
            zone = "Ruins of Lordaeron", 
            location = { mapId = 1420, x = 0.61, y = 0.60 },
            text = "Dropped by undead mobs in the ruins" 
        },
        dungeons = { Q.Dungeons["Ruins of Lordaeron"] }
    },
    --#endregion
    
    --#region The Deadmines
    {
        id = 65,
        faction = "Alliance",
        name = "The Defias Brotherhood",
        suggestedLevel = 18,
        requiredLevel = 14,
        source = { 
            type = "npc", 
            name = "Gryan Stoutmantle", 
            zone = "Westfall", 
            location = { mapId = 1436, x = 0.56, y = 0.47 } },
    },
    {
        id = 155,
        faction = "Alliance",
        name = "The Defias Brotherhood",
        suggestedLevel = 18,
        requiredLevel = 14,
        previousQuestId = 65,
        source = { 
            type = "npc", 
            name = "Gryan Stoutmantle", 
            zone = "Westfall", 
            location = { mapId = 1436, x = 0.56, y = 0.47 } },
    },
    {
        id = 132,
        faction = "Alliance",
        name = "The Defias Brotherhood",
        suggestedLevel = 18,
        requiredLevel = 14,
        previousQuestId = 155,
        source = { 
            type = "npc", 
            name = "Wiley the Black", 
            zone = "Redridge Mountains", 
            location = { mapId = 1433, x = 0.89, y = 0.70 } },
    },
    {
        id = 135,
        faction = "Alliance",
        name = "The Defias Brotherhood",
        suggestedLevel = 18,
        requiredLevel = 14,
        previousQuestId = 132,
        source = { 
            type = "npc", 
            name = "Gryan Stoutmantle", 
            zone = "Westfall", 
            location = { mapId = 1436, x = 0.56, y = 0.47 } },
    },
    {
        id = 141,
        faction = "Alliance",
        name = "The Defias Brotherhood",
        suggestedLevel = 18,
        requiredLevel = 14,
        previousQuestId = 135,
        source = { 
            type = "npc", 
            name = "Master Mathias Shaw", 
            zone = "Stormwind City", 
            location = { mapId = 1453, x = 0.75, y = 0.60 } },
    },
    {
        id = 142,
        faction = "Alliance",
        name = "The Defias Brotherhood",
        suggestedLevel = 18,
        requiredLevel = 14,
        previousQuestId = 141,
        source = { 
            type = "npc", 
            name = "Gryan Stoutmantle", 
            zone = "Westfall", 
            location = { mapId = 1436, x = 0.56, y = 0.47 } },
    },
    {
        id = 168,
        faction = "Alliance",
        name = "Collecting Memories",
        suggestedLevel = 18,
        requiredLevel = 14,
        source = {
            type = "npc",
            name = "Wilder Thistlenettle",
            zone = "Stormwind City",
            location = { mapId = 1453, x = 0.65, y = 0.21 }
        },
        dungeons = { Q.Dungeons["The Deadmines"] },
    },
    {
        id = 167,
        faction = "Alliance",
        name = "Oh Brother...",
        suggestedLevel = 20,
        requiredLevel = 15,
        source = {
            type = "npc",
            name = "Wilder Thistlenettle",
            zone = "Stormwind City",
            location = { mapId = 1453, x = 0.65, y = 0.21 }
        },
        dungeons = { Q.Dungeons["The Deadmines"] },
    },
    {
        id = 2040,
        faction = "Alliance",
        name = "Underground Assault",
        suggestedLevel = 20,
        requiredLevel = 15,
        source = {
            type = "npc",
            name = "Shoni the Shilent",
            zone = "Stormwind City",
            location = { mapId = 1453, x = 0.55, y = 0.13 }
        },
        dungeons = { Q.Dungeons["The Deadmines"] },
    },
    {
        id = 214,
        faction = "Alliance",
        name = "Red Silk Bandanas",
        suggestedLevel = 14,
        requiredLevel = 14,
        previousQuestId = 142,
        source = {
            type = "npc",
            name = "Scout Riell",
            zone = "Westfall",
            location = { mapId = 1436, x = 0.56, y = 0.47 }
        },
        dungeons = { Q.Dungeons["The Deadmines"] },
    },
    {
        id = 373,
        faction = "Alliance",
        name = "The Unsent Letter",
        suggestedLevel = 16,
        requiredLevel = 16,
        source = {
            type = "item",
            name = "An Unsent Letter",
            itemId = 2874,
            zone = "The Deadmines",
            location = { mapId = 1436, x = 0.42, y = 0.71 },
            text = "Drops from the last boss, Edwin VanCleef",
        },
        dungeons = { Q.Dungeons["The Deadmines"] },
    },
    {
        id = 166,
        faction = "Alliance",
        name = "The Defias Brotherhood",
        suggestedLevel = 18,
        requiredLevel = 14,
        previousQuestId = 142,
        source = {
            type = "npc",
            name = "Gryan Stoutmantle",
            zone = "Westfall",
            location = { mapId = 1436, x = 0.56, y = 0.47 },
        },
        dungeons = { Q.Dungeons["The Deadmines"] },
    },
    --#endregion

    --#region Wailing Caverns
    {
        id = 870,
        faction = "Horde",
        name = "The Forgotten Pools",
        suggestedLevel = 13,
        requiredLevel = 10,
        source = {
            type = "npc",
            name = "Tonga Runetotem",
            zone = "The Crossroads",
            location = { mapId = 1413, x = 0.52, y = 0.31 },
        },
    },
    {
        id = 877,
        faction = "Horde",
        name = "The Stagnant Oasis",
        suggestedLevel = 13,
        requiredLevel = 10,
        previousQuestId = 870,
        source = {
            type = "npc",
            name = "Tonga Runetotem",
            zone = "The Crossroads",
            location = { mapId = 1413, x = 0.52, y = 0.31 },
        },
    },
    {
        id = 880,
        faction = "Horde",
        name = "Altered Beings",
        suggestedLevel = 16,
        requiredLevel = 10,
        previousQuestId = 877,
        source = {
            type = "npc",
            name = "Tonga Runetotem",
            zone = "The Crossroads",
            location = { mapId = 1413, x = 0.52, y = 0.31 },
        },
    },
    {
        id = 1489,
        faction = "Horde",
        name = "Hamuul Runetotem",
        suggestedLevel = 16,
        requiredLevel = 10,
        previousQuestId = 880,
        source = {
            type = "npc",
            name = "Tonga Runetotem",
            zone = "The Crossroads",
            location = { mapId = 1413, x = 0.52, y = 0.31 },
        },
    },
    {
        id = 1490,
        faction = "Horde",
        name = "Nara Wildmane",
        suggestedLevel = 16,
        requiredLevel = 10,
        previousQuestId = 1489,
        source = {
            type = "npc",
            name = "Hamuul Runetotem",
            zone = "Thunder Bluff",
            location = { mapId = 1456, x = 0.45, y = 0.23 },
        },
    },
    {
        id = 1486,
        faction = nil,
        name = "Deviate Hides",
        suggestedLevel = 17,
        requiredLevel = 13,
        source = {
            type = "npc",
            name = "Nalpak",
            zone = "The Barrens",
            location = { mapId = 1413, x = 0.46, y = 0.35 }
        },
        dungeons = { Q.Dungeons["Wailing Caverns"] },
    },
    {
        id = 1487,
        faction = nil,
        name = "Deviate Eradication",
        suggestedLevel = 21,
        requiredLevel = 15,
        source = {
            type = "npc",
            name = "Ebru",
            zone = "The Barrens",
            location = { mapId = 1413, x = 0.46, y = 0.35 }
        },
        dungeons = { Q.Dungeons["Wailing Caverns"] },
    },
    {
        id = 959,
        faction = nil,
        name = "Trouble at the Docks",
        suggestedLevel = 18,
        requiredLevel = 14,
        source = {
            type = "npc",
            name = "Crane Operator Bigglefuzz",
            zone = "Ratchet",
            location = { mapId = 1413, x = 0.63, y = 0.37 }
        },
        dungeons = { Q.Dungeons["Wailing Caverns"] },
    },
    {
        id = 1491,
        faction = nil,
        name = "Smart Drinks",
        suggestedLevel = 18,
        requiredLevel = 13,
        previousQuestId = 865,
        source = {
            type = "npc",
            name = "Mebok Mizzyrix",
            zone = "Ratchet",
            location = { mapId = 1413, x = 0.62, y = 0.37 }
        },
        dungeons = { Q.Dungeons["Wailing Caverns"] },
    },
    {
        id = 865,
        faction = nil,
        name = "Raptor Horns",
        suggestedLevel = 18,
        requiredLevel = 13,

        source = {
            type = "npc",
            name = "Mebok Mizzyrix",
            zone = "Ratchet",
            location = { mapId = 1413, x = 0.62, y = 0.37 },
        },
    },
    {
        id = 962,
        faction = "Horde",
        name = "Serpentbloom",
        suggestedLevel = 21,
        requiredLevel = 14,
        source = {
            type = "npc",
            name = "Apothecary Zamah",
            zone = "Thunder Bluff",
            location = { mapId = 1456, x = 0.34, y = 0.21 }
        },
        dungeons = { Q.Dungeons["Wailing Caverns"] },
    },
    {
        id = 914,
        faction = "Horde",
        name = "Leaders of the Fang",
        suggestedLevel = 22,
        requiredLevel = 15,
        previousQuestId = 1490,
        source = {
            type = "npc",
            name = "Nara Wildmane",
            zone = "Thunder Bluff",
            location = { mapId = 1456, x = 0.45, y = 0.23 }
        },
        dungeons = { Q.Dungeons["Wailing Caverns"] },
    },
    {
        id = 6981,
        faction = nil,
        name = "The Glowing Shard",
        suggestedLevel = 25,
        requiredLevel = 15,
        source = {
            type = "item",
            name = "Glowing Shard",
            itemId = 10441,
            zone = "Wailing Caverns",
            location = { mapId = 1413, x = 0.458, y = 0.344 },
            text = "Dropped by Mutanus the Devourer at the end of the dungeon",
        },
        dungeons = { Q.Dungeons["Wailing Caverns"] },
    },
    --#endregion
       
    --#region Blackfathom Deeps
    {
        id = 971,
        faction = "Alliance",
        name = "Knowledge in the Deeps",
        suggestedLevel = 23,
        requiredLevel = 10,
        source = { 
            type = "npc", 
            name = "Gerrig Bonegrip", 
            zone = "Ironforge", 
            location = { mapId = 1455, x = 0.50, y = 0.08 } 
        },
        dungeons = { Q.Dungeons["Blackfathom Deeps"] },
    },
    {
        id = 1275,
        faction = "Alliance",
        name = "Researching the Corruption",
        suggestedLevel = 24,
        requiredLevel = 18,
        previousQuestId = 376,
        source = { 
            type = "npc", 
            name = "Gershala Nightwhisper", 
            zone = "Darkshore", 
            location = { mapId = 1439, x = 0.37, y = 0.44 } 
        },
        dungeons = { Q.Dungeons["Blackfathom Deeps"] },
    },
    {
        id = 376,
        faction = "Alliance",
        name = "The Corruption Abroad",
        suggestedLevel = 24,
        requiredLevel = 18,
        source = { 
            type = "npc", 
            name = "Argos Nightwhisper", 
            zone = "Stormwind City", 
            location = { mapId = 1453, x = 0.21, y = 0.56 } 
        },
        dungeons = { Q.Dungeons["Blackfathom Deeps"] },
    },
    {
        id = 1199,
        faction = "Alliance",
        name = "Twilight Falls",
        suggestedLevel = 25,
        requiredLevel = 20,
        source = { 
            type = "npc", 
            name = "Argent Guard Manados", 
            zone = "Darnassus", 
            location = { mapId = 1457, x = 0.55, y = 0.23 } 
        },
        dungeons = { Q.Dungeons["Blackfathom Deeps"] },
    },
    {
        id = 6565,
        faction = "Horde",
        name = "Allegiance to the Old Gods",
        suggestedLevel = 22,
        requiredLevel = 17,
        source = { 
            type = "item", 
            name = "Damp Note", 
            itemId = 16790, 
            zone = "Ashenvale", 
            location = { mapId = 1440, x = 0.13, y = 0.12 }, 
            text = "Dropped by Blackfathom Tide Priestesses outside the instance" 
        },
        dungeons = { Q.Dungeons["Blackfathom Deeps"] },
    },
    {
        id = 6921,
        faction = "Horde",
        name = "Amongst the Ruins",
        suggestedLevel = 24,
        requiredLevel = 21,
        source = { 
            type = "npc", 
            name = "Je'neu Sancrea", 
            zone = "Ashenvale", 
            location = { mapId = 1440, x = 0.12, y = 0.34 } 
        },
        dungeons = { Q.Dungeons["Blackfathom Deeps"] },
    },
    {
        id = 6563,
        faction = "Horde",
        name = "The Essence of Aku'Mai",
        suggestedLevel = 22,
        requiredLevel = 17,
        source = { 
            type = "npc", 
            name = "Je'neu Sancrea", 
            zone = "Ashenvale", 
            location = { mapId = 1440, x = 0.12, y = 0.34 } 
        },
        dungeons = { Q.Dungeons["Blackfathom Deeps"] },
    },
    {
        id = 1200,
        faction = "Alliance",
        name = "Blackfathom Villainy",
        suggestedLevel = 27,
        requiredLevel = 18,
        previousQuestId = 1198,
        source = { 
            type = "npc", 
            name = "Argent Guard Thaelrid", 
            zone = "Blackfathom Deeps", 
            location = { mapId = 1440, x = 0.14, y = 0.15 }
        },
        dungeons = { Q.Dungeons["Blackfathom Deeps"] },
    },
    {
        id = 1198,
        faction = "Alliance",
        name = "In Search of Thaelrid",
        suggestedLevel = 24,
        requiredLevel = 18,
        source = { 
            type = "npc", 
            name = "Dawnwatcher Shaedlass", 
            zone = "Darnassus", 
            location = { mapId = 1457, x = 0.55, y = 0.24 } 
        },
        dungeons = { Q.Dungeons["Blackfathom Deeps"] },
    },
    {
        id = 6561,
        faction = "Horde",
        name = "Blackfathom Villainy",
        suggestedLevel = 27,
        requiredLevel = 18,
        source = { 
            type = "npc", 
            name = "Argent Guard Thaelrid", 
            zone = "Blackfathom Deeps", 
            location = { mapId = 1440, x = 0.14, y = 0.15 }
        },
        dungeons = { Q.Dungeons["Blackfathom Deeps"] },
    },
    {
        id = 6922,
        faction = "Horde",
        name = "Baron Aquanis",
        suggestedLevel = 27,
        requiredLevel = 21,
        source = { 
            type = "item", 
            name = "Strange Water Globe", 
            itemId = 16782, 
            zone = "Blackfathom Deeps", 
            location = { mapId = 1440, x = 0.14, y = 0.15 },
            text = "Dropped by Baron Aquanis inside the dungeon" 
        },
        dungeons = { Q.Dungeons["Blackfathom Deeps"] },
    },
    --#endregion
    
    --#region Razorfen Kraul
    {
        id = 1100,
        faction = "Alliance",
        name = "Lonebrow's Journal",
        suggestedLevel = 27,
        requiredLevel = 25,
        source = {
            type = "item",
            name = "Lonebrow's Journal",
            itemId = 5791,
            zone = "Thousand Needles",
            location = { mapId = 1441, x = 0.30, y = 0.24 },
            text = "Found on the floor by the corpse",
        },
    },
    {
        id = 1101,
        faction = "Alliance",
        name = "The Crone of the Kraul",
        suggestedLevel = 34,
        previousQuestId = 1100,
        requiredLevel = 29,
        source = {
            type = "npc",
            name = "Falfindel Waywarder",
            zone = "Feralas",
            location = { mapId = 1448, x = 0.89, y = 0.46 },
        },
        dungeons = { Q.Dungeons["Razorfen Kraul"] },
    },
    {
        id = 1102,
        faction = "Horde",
        name = "A Vengeful Fate",
        suggestedLevel = 34,
        requiredLevel = 29,
        source = {
            type = "npc",
            name = "Auld Stonespire",
            zone = "Thunder Bluff",
            location = { mapId = 1456, x = 0.37, y = 0.29 }
        },
        dungeons = { Q.Dungeons["Razorfen Kraul"] },
    },
    {
        id = 1221,
        faction = nil,
        name = "Blueleaf Tubers",
        suggestedLevel = 26,
        requiredLevel = 20,
        source = {
            type = "npc",
            name = "Mebok Mizzyrix",
            zone = "Ratchet",
            location = { mapId = 1413, x = 0.62, y = 0.38 },
            text = "Don't forget to pick up the items next to him"
        },
        dungeons = { Q.Dungeons["Razorfen Kraul"] },
    },
    {
        id = 1142,
        faction = "Alliance",
        name = "Mortality Wanes",
        suggestedLevel = 30,
        requiredLevel = 25,
        source = {
            type = "npc",
            name = "Heralath Fallowbrook",
            zone = "Razorfen Kraul",
            location = { mapId = 1413, x = 0.43, y = 0.90 }
        },
        dungeons = { Q.Dungeons["Razorfen Kraul"] },
    },
    {
        id = 1144,
        faction = nil,
        name = "Willix the Importer",
        suggestedLevel = 30,
        requiredLevel = 22,
        source = {
            type = "npc",
            name = "Willix the Importer",
            zone = "Razorfen Kraul",
            location = { mapId = 1413, x = 0.43, y = 0.90 },
            text = "Near the final boss, inside the dungeon"
        },
        dungeons = { Q.Dungeons["Razorfen Kraul"] },
    },
    {
        id = 1109,
        faction = "Horde",
        name = "Going, Going, Guano!",
        suggestedLevel = 33,
        requiredLevel = 30,
        source = {
            type = "npc",
            name = "Master Apothecary Faranell",
            zone = "Undercity",
            location = { mapId = 1458, x = 0.49, y = 0.69 },
        },
        dungeons = { Q.Dungeons["Razorfen Kraul"] },
    },
    {
        id = 6522,
        faction = "Horde",
        name = "An Unholy Alliance",
        suggestedLevel = 36,
        requiredLevel = 28,
        source = {
            type = "item",
            name = "Small Scroll",
            itemId = 17008,
            zone = "Razorfen Kraul",
            location = { mapId = 1413, x = 0.43, y = 0.90 },
            text = "Dropped by Charlga Razorflank inside the dungeon",
        },
        dungeons = { Q.Dungeons["Razorfen Kraul"] },
    },
    --#endregion

    --#region Shadowfang Keep
    {
        id = 1013,
        faction = "Horde",
        name = "The Book of Ur",
        suggestedLevel = 20,
        requiredLevel = 16,
        source = {
            type = "npc",
            name = "Keeper Bel'dugur",
            zone = "Undercity",
            location = { mapId = 1458, x = 0.53, y = 0.54 }
        },
        dungeons = { Q.Dungeons["Shadowfang Keep"] },
    },
    {
        id = 1098,
        faction = "Horde",
        name = "Deathstalkers in Shadowfang",
        suggestedLevel = 25,
        requiredLevel = 18,
        source = {
            type = "npc",
            name = "High Executor Hadrec",
            zone = "Silverpine Forest",
            location = { mapId = 1421, x = 0.43, y = 0.41 }
        },
        dungeons = { Q.Dungeons["Shadowfang Keep"] },
    },
    {
        id = 1014,
        faction = "Horde",
        name = "Arugal Must Die",
        suggestedLevel = 24,
        requiredLevel = 18,
        source = {
            type = "npc",
            name = "Dalar Dawnweaver",
            zone = "Silverpine Forest",
            location = { mapId = 1421, x = 0.44, y = 0.39 }
        },
        dungeons = { Q.Dungeons["Shadowfang Keep"] },
    },
    --#endregion

    --#region Excavation Site: Wetlands
    {
        id = 95663,
        faction = "Horde",
        name = "Dragonmaw Rumors",
        suggestedLevel = 31,
        requiredLevel = 24,
        source = { 
            type = "npc", 
            name = "Zaruk", 
            zone = "Arathi Highlands",
            location = { mapId = 1417, x = 0.744, y = 0.356 }
        },
    },
    {
        id = 95697,
        faction = "Horde",
        name = "Changing Tastes",
        suggestedLevel = 31,
        requiredLevel = 24,
        source = { 
            type = "npc", 
            name = "Borstan", 
            zone = "Orgrimmar", 
            location = { mapId = 1454, x = 0.576, y = 0.534 }
        },
        dungeons = { Q.Dungeons["Excavation Site: Wetlands"] },
    },
    {
        id = 95664,
        faction = "Horde",
        name = "Elder Knowledge",
        suggestedLevel = 31,
        requiredLevel = 24,
        source = { 
            type = "item", 
            name = "Titan Relic", 
            itemId = 270866, 
            zone = "Excavation Site: Wetlands", 
            text = "Dropped by the Relic Guardian boss" 
        },
        dungeons = { Q.Dungeons["Excavation Site: Wetlands"] },
    },
    {
        id = 95682,
        faction = "Horde",
        name = "Open the Maw",
        suggestedLevel = 31,
        previousQuestId = 95663,
        requiredLevel = 24,
        source = { 
            type = "npc", 
            name = "Deathstalker Agent", 
            zone = "Wetlands",
            location = { mapId = 1437, x = 0.514, y = 0.592 }
        },
        dungeons = { Q.Dungeons["Excavation Site: Wetlands"] },
    },
    {
        id = 98815,
        faction = "Alliance",
        name = "Highland Hides",
        suggestedLevel = 28,
        requiredLevel = 24,
        source = { 
            type = "npc", 
            name = "James Halloran", 
            zone = "Wetlands", 
            location = { mapId = 1437, x = 0.08, y = 0.55 } 
        },
        dungeons = { Q.Dungeons["Excavation Site: Wetlands"] },
    },
    {
        id = 95772,
        faction = "Alliance",
        name = "Songblade Search",
        suggestedLevel = 31,
        requiredLevel = 24,
        source = { 
            type = "npc", 
            name = "Dorin Songblade", 
            zone = "Redridge Mountains", 
            location = { mapId = 1433, x = 0.308, y = 0.466 } 
        },
        dungeons = { Q.Dungeons["Excavation Site: Wetlands"] },
    },
    {
        id = 95646,
        faction = "Alliance",
        name = "Horrors in the Highland",
        suggestedLevel = 24,
        requiredLevel = 24,
        source = { 
            type = "npc", 
            name = "Rethiel the Greenwarden", 
            zone = "Wetlands", 
            location = { mapId = 1437, x = 0.562, y = 0.406 } 
        },
        dungeons = { Q.Dungeons["Excavation Site: Wetlands"] },
    },
    {
        id = 95647,
        faction = "Alliance",
        name = "Lost in the Thicket Things",
        suggestedLevel = 31,
        requiredLevel = 24,
        source = { 
            type = "npc", 
            name = "Caitlin Grassman", 
            zone = "Wetlands", 
            location = { mapId = 1437, x = 0.118, y = 0.586 } 
        },
        dungeons = { Q.Dungeons["Excavation Site: Wetlands"] },
    },
    {
        id = 95810,
        faction = "Alliance",
        name = "Lost Relic Carry",
        suggestedLevel = 31,
        requiredLevel = 24,
        source = { 
            type = "item", 
            name = "Titan Relic", 
            itemId = 270865, 
            zone = "Excavation Site: Wetlands", 
            text = "Dropped by the boss Relic Guardian in the dungeon" 
        },
        dungeons = { Q.Dungeons["Excavation Site: Wetlands"] },
    },
    --#endregion

    --#region The Stockade
    {
        id = 303,
        faction = "Alliance",
        name = "The Dark Iron War",
        suggestedLevel = 30,
        requiredLevel = 25,
        source = { 
            type = "npc", 
            name = "Motley Garmason", 
            zone = "Wetlands", 
            location = { mapId = 1437, x = 0.49, y = 0.18 } 
        },
        dungeons = { Q.Dungeons["The Stockade"] },
    },
    {
        id = 389,
        faction = "Alliance",
        name = "Bazil Thredd",
        suggestedLevel = 22,
        requiredLevel = 16,
        previousQuestId = 373,
        source = { 
            type = "npc", 
            name = "Baros Alexston", 
            zone = "Stormwind City", 
            location = { mapId = 1453, x = 0.49, y = 0.30 } 
        },
    },
    {
        id = 386,
        faction = "Alliance",
        name = "What Comes Around...",
        suggestedLevel = 25,
        requiredLevel = 22,
        source = { 
            type = "npc", 
            name = "Guard Berton", 
            zone = "Redridge Mountains", 
            location = { mapId = 1433, x = 0.26, y = 0.46 } 
        },
        dungeons = { Q.Dungeons["The Stockade"] },
    },
    {
        id = 377,
        faction = "Alliance",
        name = "Crime and Punishment",
        suggestedLevel = 26,
        requiredLevel = 22,
        source = { 
            type = "npc", 
            name = "Councilman Millstipe", 
            zone = "Duskwood", 
            location = { mapId = 1431, x = 0.71, y = 0.47 } 
        },
        dungeons = { Q.Dungeons["The Stockade"] },
    },
    {
        id = 387,
        faction = "Alliance",
        name = "Quell The Uprising",
        suggestedLevel = 26,
        requiredLevel = 22,
        source = { 
            type = "npc", 
            name = "Warden Thelwater", 
            zone = "Stormwind City", 
            location = { mapId = 1453, x = 0.518, y = 0.693 } 
        },
        dungeons = { Q.Dungeons["The Stockade"] },
    },
    {
        id = 388,
        faction = "Alliance",
        name = "The Color of Blood",
        suggestedLevel = 26,
        requiredLevel = 22,
        source = { 
            type = "npc", 
            name = "Nikova Raskol", 
            zone = "Stormwind City", 
            location = { mapId = 1453, x = 0.73, y = 0.50 } 
        },
        dungeons = { Q.Dungeons["The Stockade"] },
    },
    {
        id = 378,
        faction = "Alliance",
        name = "The Fury Runs Deep",
        suggestedLevel = 27,
        requiredLevel = 25,
        previousQuestId = 303,
        source = { 
            type = "npc", 
            name = "Motley Garmason", 
            zone = "Wetlands", 
            location = { mapId = 1437, x = 0.49, y = 0.18 } 
        },
        dungeons = { Q.Dungeons["The Stockade"] },
    },
    {
        id = 391,
        faction = "Alliance",
        name = "The Stockade Riots",
        suggestedLevel = 29,
        requiredLevel = 16,
        previousQuestId = 389,
        source = { 
            type = "npc", 
            name = "Warden Thelwater", 
            zone = "Stormwind City", 
            location = { mapId = 1453, x = 0.518, y = 0.693 } 
        },
        dungeons = { Q.Dungeons["The Stockade"] },
    },
    --#endregion

    --#region Gnomeregan
    {
        id = 2927,
        faction = "Alliance",
        name = "The Day After",
        suggestedLevel = 27,
        requiredLevel = 20,
        source = { 
            type = "npc", 
            name = "Gnoarn", 
            zone = "Ironforge", 
            location = { mapId = 1455, x = 0.69, y = 0.50 } 
        },
        dungeons = { Q.Dungeons["Gnomeregan"] },
    },
    {
        id = 2931,
        faction = "Alliance",
        name = "Castpipe's Task",
        suggestedLevel = 30,
        requiredLevel = 25,
        source = { 
            type = "npc", 
            name = "Gaxim Rustfizzle", 
            zone = "Stonetalon Mountains", 
            location = { mapId = 1442, x = 0.596, y = 0.670 } 
        },
    },
    {
        id = 2841,
        faction = "Horde",
        name = "Rig Wars",
        suggestedLevel = 35,
        requiredLevel = 25,
        source = { 
            type = "npc", 
            name = "Nogg", 
            zone = "Orgrimmar", 
            location = { mapId = 1454, x = 0.76, y = 0.25 } 
        },
        dungeons = { Q.Dungeons["Gnomeregan"] },
    },
    {
        id = 2842,
        faction = "Horde",
        name = "Chief Engineer Scooty",
        suggestedLevel = 35,
        requiredLevel = 20,
        source = { 
            type = "npc", 
            name = "Sovik", 
            zone = "Orgrimmar", 
            location = { mapId = 1454, x = 0.76, y = 0.25 },
            text = "You must pick up the quest 'Rig Wars' right beside Sovik first."
        }
    },
    {
        id = 2924,
        faction = "Alliance",
        name = "Essential Artificials",
        suggestedLevel = 30,
        requiredLevel = 20,
        source = { 
            type = "npc", 
            name = "Klockmort Spannerspan", 
            zone = "Ironforge", 
            location = { mapId = 1455, x = 0.682, y = 0.462 }
        },
        dungeons = { Q.Dungeons["Gnomeregan"] },
    },
    {
        id = 2930,
        faction = "Alliance",
        name = "Data Rescue",
        suggestedLevel = 30,
        requiredLevel = 25,
        previousQuestId = 2931,
        source = { 
            type = "npc", 
            name = "Master Mechanic Castpipe", 
            zone = "Ironforge", 
            location = { mapId = 1455, x = 0.700, y = 0.474 } 
        },
        dungeons = { Q.Dungeons["Gnomeregan"] },
    },
    {
        id = 2962,
        faction = "Alliance",
        name = "The Only Cure is More Green Glow",
        suggestedLevel = 30,
        requiredLevel = 20,
        previousQuestId = 2926,
        source = { 
            type = "npc", 
            name = "Ozzie Togglevolt", 
            zone = "Dun Morogh", 
            location = { mapId = 1426, x = 0.45, y = 0.49 } 
        },
        dungeons = { Q.Dungeons["Gnomeregan"] },
    },
    {
        id = 2945,
        faction = nil,
        name = "Grime-Encrusted Ring",
        suggestedLevel = 34,
        requiredLevel = 28,
        previousQuestId = 2926,
        source = { 
            type = "item", 
            name = "Grime-Encrusted Ring", 
            itemId = 9326,
            zone = "Gnomeregan", 
            text = "Dropped by Dark Iron Agents inside the dungeon"
        },
        dungeons = { Q.Dungeons["Gnomeregan"] },
    },
    {
        id = 2926,
        faction = "Alliance",
        name = "Gnogaine",
        suggestedLevel = 27,
        requiredLevel = 20,
        previousQuestId = 2927,
        source = { 
            type = "npc", 
            name = "Ozzie Togglevolt", 
            zone = "Dun Morogh", 
            location = { mapId = 1426, x = 0.458, y = 0.492 }
        },
        dungeons = { Q.Dungeons["Gnomeregan"] },
    },
    {
        id = 2922,
        faction = "Alliance",
        name = "Save Techbot's Brain!",
        suggestedLevel = 26,
        requiredLevel = 20,
        source = { 
            type = "npc", 
            name = "Tinkmaster Overspark", 
            zone = "Ironforge", 
            location = { mapId = 1455, x = 0.69, y = 0.50 } 
        },
        dungeons = { Q.Dungeons["Gnomeregan"] },
    },
    {
        id = 2929,
        faction = "Alliance",
        name = "The Grand Betrayal",
        suggestedLevel = 35,
        requiredLevel = 25,
        source = { 
            type = "npc", 
            name = "High Tinker Mekkatorque", 
            zone = "Ironforge", 
            location = { mapId = 1455, x = 0.68, y = 0.49 } 
        },
        dungeons = { Q.Dungeons["Gnomeregan"] },
    },
    {
        id = 2928,
        faction = "Alliance",
        name = "Gyrodrillmatic Excavationators",
        suggestedLevel = 30,
        requiredLevel = 20,
        source = { 
            type = "npc", 
            name = "Shoni the Shilent", 
            zone = "Stormwind City", 
            location = { mapId = 1453, x = 0.55, y = 0.12 } 
        },
        dungeons = { Q.Dungeons["Gnomeregan"] },
    },
    {
        id = 2843,
        faction = "Horde",
        name = "Gnomer-gooooone!",
        suggestedLevel = 35,
        requiredLevel = 20,
        previousQuestId = 2842,
        source = { 
            type = "npc", 
            name = "Scooty", 
            zone = "The Cape of Stranglethorn", 
            location = { mapId = 1434, x = 0.27, y = 0.77 } 
        },
        dungeons = { Q.Dungeons["Gnomeregan"] },
    },
    {
        id = 2904,
        faction = nil,
        name = "A Fine Mess",
        suggestedLevel = 30,
        requiredLevel = 20,
        source = { 
            type = "npc", 
            name = "Kernobee", 
            zone = "Gnomeregan", 
            text = "Found inside the dungeon in the room right of the Clean Room."
        },
        dungeons = { Q.Dungeons["Gnomeregan"] },
    },
    --#endregion

    --#region City of Dalaran
    {
        id = 96986,
        faction = "Horde",
        name = "The Grave Knight",
        suggestedLevel = 33,
        requiredLevel = 24,
        source = { 
            type = "npc", 
            name = "Melisara", 
            zone = "Hillsbrad Foothills", 
            location = { mapId = 1424, x = 0.626, y = 0.206 }
        },
        dungeons = { Q.Dungeons["City of Dalaran"] },
    },
    {
        id = 96987,
        faction = "Horde",
        name = "Opportunistic Education",
        suggestedLevel = 33,
        requiredLevel = 24,
        source = { 
            type = "npc", 
            name = "Rexxie Copperclutch",
            zone = "City of Dalaran", 
            location = { mapId = 1421, x = 0.686, y = 0.452 }
        },
        dungeons = { Q.Dungeons["City of Dalaran"] },
    },
    {
        id = 96984,
        faction = "Horde",
        name = "Heart of Disruption",
        suggestedLevel = 33,
        requiredLevel = 24,
        previousQuestId = 92434,
        source = { 
            type = "npc", 
            name = "Image of Archmage Modera", 
            zone = "City of Dalaran", 
            location = { mapId = 1421, x = 0.686, y = 0.452 }
        }
    },
    {
        id = 92457,
        faction = "Alliance",
        name = "Starving Arcane",
        suggestedLevel = 33,
        requiredLevel = 24,
        source = { 
            type = "npc", 
            name = "Image of Archmage Modera", 
            zone = "City of Dalaran", 
            location = { mapId = 1421, x = 0.686, y = 0.452 }
        },
        dungeons = { Q.Dungeons["City of Dalaran"] },
    },
    {
        id = 92489,
        faction = "Alliance",
        name = "Power Overwhelming",
        suggestedLevel = 33,
        requiredLevel = 24,
        source = { 
            type = "npc", 
            name = "High Sorcerer Andromath", 
            zone = "Stormwind City", 
            location = { mapId = 1453, x = 0.376, y = 0.816 }
        },
        dungeons = { Q.Dungeons["City of Dalaran"] },
    },
    {
        id = 92458,
        faction = "Alliance",
        name = "Heart of Disruption",
        suggestedLevel = 33,
        requiredLevel = 24,
        previousQuestId = 92432,
        source = { 
            type = "npc", 
            name = "Image of Archmage Modera", 
            zone = "City of Dalaran", 
            location = { mapId = 1421, x = 0.686, y = 0.452 }
        },
        dungeons = { Q.Dungeons["City of Dalaran"] },
    },
    {
        id = 96988,
        faction = "Horde",
        name = "Source of Power",
        suggestedLevel = 33,
        requiredLevel = 24,
        source = { 
            type = "npc", 
            name = "Doctor Martin Felben", 
            zone = "Undercity", 
            location = { mapId = 1458, x = 0.466, y = 0.746 }
        },
        dungeons = { Q.Dungeons["City of Dalaran"] },
    },
    {
        id = 97287,
        faction = "Horde",
        name = "Shrewd Negotiations",
        suggestedLevel = 33,
        requiredLevel = 24,
        previousQuestId = 96984,
        source = { 
            type = "npc", 
            name = "Magus Wordeen Voidglare", 
            zone = "Hillsbrad Foothills", 
            location = { mapId = 1424, x = 0.616, y = 0.208 }
        },
        dungeons = { Q.Dungeons["City of Dalaran"] },
    },
    {
        id = 92434,
        faction = "Horde",
        name = "Blood in the Streets", -- TODO: wowhead comment says you need to complete all of Magus Wordeens quests to pick this up, verify in-game.
        suggestedLevel = 33,
        requiredLevel = 24, -- TODO: Wowhead says 30, but next 2 quests say 24? Finish leveling shaman to figure out...
        source = { 
            type = "npc", 
            name = "Magus Wordeen Voidglare", 
            zone = "Hillsbrad Foothills", 
            location = { mapId = 1424, x = 0.616, y = 0.208 }
        }
    },
    {
        id = 92456,
        faction = "Alliance",
        name = "A Green Sample",
        suggestedLevel = 33,
        requiredLevel = 24,
        source = { 
            type = "npc", 
            name = "Shylamiir", 
            zone = "Stormwind City", 
            location = { mapId = 1453, x = 0.313, y = 0.629 }
        },
        dungeons = { Q.Dungeons["City of Dalaran"] },
    },
    {
        id = 92432,
        faction = "Alliance",
        name = "An Alarming Request",
        suggestedLevel = 33,
        requiredLevel = 24,
        source = { 
            type = "npc", 
            name = "Emissary Jacques", 
            zone = "Hillsbrad Foothills", 
            location = { mapId = 1424, x = 0.483, y = 0.601 }
        }
    },
    --#endregion

    --#region Scarlet Monastery: Shared
    {
        id = 261,
        faction = "Alliance",
        name = "Down the Scarlet Path",
        suggestedLevel = 38,
        requiredLevel = 34,
        source = { 
            type = "npc", 
            name = "Brother Anton", 
            zone = "Desolace", 
            location = { mapId = 405, x = 0.66, y = 0.09 } 
        },
    },
    {
        id = 1052,
        faction = "Alliance",
        name = "Down the Scarlet Path",
        suggestedLevel = 38,
        requiredLevel = 34,
        previousQuestId = 261,
        source = { 
            type = "npc", 
            name = "Brother Anton", 
            zone = "Desolace", 
            location = { mapId = 405, x = 0.66, y = 0.09 } 
        },
    },
    {
        id = 1048,
        faction = "Horde",
        name = "Into The Scarlet Monastery",
        suggestedLevel = 42,
        requiredLevel = 33,
        source = { 
            type = "npc", 
            name = "Varimathras", 
            zone = "Undercity", 
            location = { mapId = 1458, x = 0.56, y = 0.92 } 
        },
        dungeons = { Q.Dungeons["SM: Library"], Q.Dungeons["SM: Armory"], Q.Dungeons["SM: Cathedral"] },
    },
        {
        id = 1113,
        faction = "Horde",
        name = "Hearts of Zeal",
        suggestedLevel = 35,
        requiredLevel = 30,
        previousQuestId = 1109,
        source = { 
            type = "npc", 
            name = "Master Apothecary Faranell", 
            zone = "Undercity", 
            location = { mapId = 1458, x = 0.48, y = 0.69 } 
        },
        dungeons = { Q.Dungeons["SM: Library"], Q.Dungeons["SM: Armory"], Q.Dungeons["SM: Cathedral"] },
    },
    {
        id = 1053,
        faction = "Alliance",
        name = "In the Name of the Light",
        suggestedLevel = 40,
        requiredLevel = 34,
        previousQuestId = 1052,
        source = { 
            type = "npc", 
            name = "Raleigh the Devout", 
            zone = "Hillsbrad Foothills", 
            location = { mapId = 1424, x = 0.51, y = 0.58 } 
        },
        dungeons = { Q.Dungeons["SM: Library"], Q.Dungeons["SM: Armory"], Q.Dungeons["SM: Cathedral"] },
    },
    --#endregion

    --#region SM: Graveyard
    {
        id = 1051,
        faction = nil,
        name = "Vorrel's Revenge",
        suggestedLevel = 30,
        requiredLevel = 25,
        source = { 
            type = "npc", 
            name = "Vorrel Sengutz", 
            zone = "Scarlet Monastery", 
            location = { mapId = 1420, x = 0.84, y = 0.32 }
        },
        dungeons = { Q.Dungeons["SM: Graveyard"] },
    },
    --#endregion

    --#region SM: Library
    {
        id = 1049,
        faction = "Horde",
        name = "Compendium of the Fallen",
        suggestedLevel = 38,
        requiredLevel = 28,
        source = { 
            type = "npc", 
            name = "Sage Truthseeker", 
            zone = "Thunder Bluff", 
            location = { mapId = 1456, x = 0.36, y = 0.26 },
        },
        dungeons = { Q.Dungeons["SM: Library"] },
    },
    {
        id = 1149,
        faction = "Horde",
        name = "Test of Faith",
        suggestedLevel = 26,
        requiredLevel = 25,
        source = { 
            type = "npc", 
            name = "Dorn Plainstalker", 
            zone = "Thousand Needles", 
            location = { mapId = 1441, x = 0.53, y = 0.41 } 
        },
    },
    {
        id = 1150,
        faction = "Horde",
        name = "Test of Endurance",
        suggestedLevel = 29,
        requiredLevel = 25,
        previousQuestId = 1149,
        source = { 
            type = "npc", 
            name = "Dorn Plainstalker", 
            zone = "Thousand Needles", 
            location = { mapId = 1441, x = 0.53, y = 0.41 } 
        },
    },
    {
        id = 1151,
        faction = "Horde",
        name = "Test of Strength",
        suggestedLevel = 30,
        requiredLevel = 25,
        previousQuestId = 1150,
        source = { 
            type = "npc", 
            name = "Dorn Plainstalker", 
            zone = "Thousand Needles", 
            location = { mapId = 1441, x = 0.53, y = 0.41 } 
        },
    },
    {
        id = 1152,
        faction = "Horde",
        name = "Test of Lore",
        suggestedLevel = 30,
        requiredLevel = 25,
        previousQuestId = 1151,
        source = { 
            type = "npc", 
            name = "Dorn Plainstalker", 
            zone = "Thousand Needles", 
            location = { mapId = 1441, x = 0.53, y = 0.41 } 
        },
    },
    {
        id = 1154,
        faction = "Horde",
        name = "Test of Lore",
        suggestedLevel = 30,
        requiredLevel = 25,
        previousQuestId = 1152,
        source = { 
            type = "npc", 
            name = "Braug Dimspirit", 
            zone = "Stonetalon Mountains", 
            location = { mapId = 1442, x = 0.79, y = 0.46 } 
        },
    },
    {
        id = 6627,
        faction = "Horde",
        name = "Test of Lore",
        suggestedLevel = 30,
        requiredLevel = 25,
        previousQuestId = 1154,
        source = { 
            type = "npc", 
            name = "Braug Dimspirit", 
            zone = "Stonetalon Mountains", 
            location = { mapId = 1442, x = 0.79, y = 0.46 } 
        },
    },
    {
        id = 1159,
        faction = "Horde",
        name = "Test of Lore",
        suggestedLevel = 30,
        requiredLevel = 25,
        previousQuestId = 6627,
        source = { 
            type = "npc", 
            name = "Braug Dimspirit", 
            zone = "Stonetalon Mountains", 
            location = { mapId = 1442, x = 0.79, y = 0.46 } 
        },
    },
    {
        id = 1160,
        faction = "Horde",
        name = "Test of Lore",
        suggestedLevel = 35,
        requiredLevel = 25,
        previousQuestId = 1159,
        source = { 
            type = "npc", 
            name = "Parqual Fintallas", 
            zone = "Undercity", 
            location = { mapId = 1458, x = 0.57, y = 0.65 } 
        },
        dungeons = { Q.Dungeons["SM: Library"] },
    },
    {
        id = 1050,
        faction = "Alliance",
        name = "Mythology of the Titans",
        suggestedLevel = 38,
        requiredLevel = 28,
        source = { 
            type = "npc", 
            name = "Librarian Mae Paledust", 
            zone = "Ironforge", 
            location = { mapId = 1455, x = 0.75, y = 0.12 } 
        },
        dungeons = { Q.Dungeons["SM: Library"] },
    },
    --#endregion

    --#region Razorfen Downs
        {
        id = 3341,
        faction = "Horde",
        name = "Bring the End",
        suggestedLevel = 42,
        requiredLevel = 37,
        source = { 
            type = "npc", 
            name = "Andrew Brownell", 
            zone = "Undercity", 
            location = { mapId = 1458, x = 0.74, y = 0.33 } 
        },
        dungeons = { Q.Dungeons["Razorfen Downs"] },
    },
    {
        id = 6521,
        faction = "Horde",
        name = "An Unholy Alliance",
        suggestedLevel = 36,
        requiredLevel = 28,
        previousQuestId = 6522,
        source = { 
            type = "npc", 
            name = "Varimathras", 
            zone = "Undercity", 
            location = { mapId = 1458, x = 0.56, y = 0.92 } 
        },
        dungeons = { Q.Dungeons["Razorfen Downs"] },
    },
    {
        id = 3636,
        faction = "Alliance",
        name = "Bring the Light",
        suggestedLevel = 42,
        requiredLevel = 39,
        source = { 
            type = "npc", 
            name = "Archbishop Benedictus", 
            zone = "Stormwind City", 
            location = { mapId = 1453, x = 0.39, y = 0.27 } 
        },
        dungeons = { Q.Dungeons["Razorfen Downs"] },
    },
    {
        id = 6626,
        faction = nil,
        name = "A Host of Evil",
        suggestedLevel = 35,
        requiredLevel = 28,
        source = { 
            type = "npc", 
            name = "Myriam Moonsinger", 
            zone = "The Barrens", 
            location = { mapId = 1413, x = 0.49, y = 0.95 } 
        },
        dungeons = { Q.Dungeons["Razorfen Downs"] },
    },
    {
        id = 3525,
        faction = nil,
        name = "Extinguishing the Idol",
        suggestedLevel = 37,
        requiredLevel = 32,
        previousQuestId = 3523,
        source = { 
            type = "npc", 
            name = "Belnistrasz", 
            zone = "Razorfen Downs", 
            location = { mapId = 1413, x = 0.49, y = 0.92 }
        },
        dungeons = { Q.Dungeons["Razorfen Downs"] },
    },
    {
        id = 3523,
        faction = nil,
        name = "Scourge of the Downs",
        suggestedLevel = 37,
        requiredLevel = 32,
        source = { 
            type = "npc", 
            name = "Belnistrasz", 
            zone = "Razorfen Downs", 
            location = { mapId = 1413, x = 0.49, y = 0.92 },
            text = "Located inside the dungeon"
        }
    },
    --#endregion

    --#region Uldaman
    {
        id = 2342,
        faction = "Horde",
        name = "Reclaimed Treasures",
        suggestedLevel = 38,
        requiredLevel = 33,
        source = { 
            type = "npc", 
            name = "Patrick Garrett", 
            zone = "Undercity", 
            location = { mapId = 1458, x = 0.626, y = 0.486 } 
        },
        dungeons = { Q.Dungeons["Uldaman"] },
    },
    {
        id = 1360,
        faction = "Alliance",
        name = "Reclaimed Treasures",
        suggestedLevel = 38,
        requiredLevel = 33,
        source = { 
            type = "npc", 
            name = "Krom Stoutarm", 
            zone = "Ironforge", 
            location = { mapId = 1455, x = 0.746, y = 0.10 } 
        },
        dungeons = { Q.Dungeons["Uldaman"] },
    },
    {
        id = 17,
        faction = "Alliance",
        name = "Uldaman Reagent Run",
        suggestedLevel = 42,
        requiredLevel = 38,
        previousQuestId = 2500,
        source = { 
            type = "npc", 
            name = "Ghak Healtouch", 
            zone = "Loch Modan", 
            location = { mapId = 1432, x = 0.37, y = 0.492 } 
        },
        dungeons = { Q.Dungeons["Uldaman"] },
    },
    {
        id = 2339,
        faction = "Horde",
        name = "Find the Gems and Power Source",
        suggestedLevel = 44,
        requiredLevel = 37,
        previousQuestId = 2338,
        source = { 
            type = "npc", 
            name = "Jarkal Mossmeld", 
            zone = "Badlands", 
            location = { mapId = 1418, x = 0.024, y = 0.460 }  
        },
        dungeons = { Q.Dungeons["Uldaman"] },
    },
    {
        id = 2240,
        faction = "Alliance",
        name = "The Hidden Chamber",
        suggestedLevel = 40,
        requiredLevel = 35,
        previousQuestId = 2398,
        source = { 
            type = "npc", 
            name = "Baelog", 
            zone = "Uldaman", 
            location = { mapId = 1418, x = 0.426, y = 0.122 },
            text = "Found inside the dungeon"
        },
        dungeons = { Q.Dungeons["Uldaman"] },
    },
    {
        id = 2418,
        faction = nil,
        name = "Power Stones",
        suggestedLevel = 36,
        requiredLevel = 30,
        source = { 
            type = "npc", 
            name = "Rigglefuzz", 
            zone = "Badlands", 
            location = { mapId = 1418, x = 0.424, y = 0.528 } 
        },
        dungeons = { Q.Dungeons["Uldaman"] },
    },
    {
        id = 720,
        faction = "Alliance",
        name = "A Sign of Hope",
        suggestedLevel = 35,
        requiredLevel = 35,
        source = { 
            type = "item", 
            name = "Crumpled Map", 
            zone = "Badlands", 
            location = { mapId = 1418, x = 0.53, y = 0.341 } 
        }
    },
    {
        id = 721,
        faction = "Alliance",
        name = "A Sign of Hope",
        suggestedLevel = 40,
        requiredLevel = 35,
        previousQuestId = 720,
        source = { 
            type = "npc", 
            name = "Prospector Ryedol", 
            zone = "Badlands", 
            location = { mapId = 1418, x = 0.534, y = 0.432 } 
        }
    },
    {
        id = 722,
        faction = "Alliance",
        name = "Amulet of Secrets",
        suggestedLevel = 40,
        requiredLevel = 35,
        previousQuestId = 721,
        source = { 
            type = "npc", 
            name = "Hammertoe Grez", 
            zone = "Uldaman", 
            location = { mapId = 1418, x = 0.426, y = 0.122 },
            text = "Found inside the dungeon"
        },
        dungeons = { Q.Dungeons["Uldaman"] },
    },
    {
        id = 723,
        faction = "Alliance",
        name = "Prospect of Faith",
        suggestedLevel = 40,
        requiredLevel = 35,
        previousQuestId = 722,
        source = { 
            type = "npc", 
            name = "Hammertoe Grez", 
            zone = "Uldaman", 
            location = { mapId = 1418, x = 0.426, y = 0.122 },
            text = "Found inside the dungeon"
        }
    },
    {
        id = 724,
        faction = "Alliance",
        name = "Prospect of Faith",
        suggestedLevel = 40,
        requiredLevel = 35,
        previousQuestId = 722,
        source = { 
            type = "npc", 
            name = "Prospector Ryedol", 
            zone = "Badlands", 
            location = { mapId = 1418, x = 0.534, y = 0.432 } 
        }
    },
    {
        id = 725,
        faction = "Alliance",
        name = "Passing Word of a Threat",
        suggestedLevel = 40,
        requiredLevel = 35,
        previousQuestId = 724,
        source = { 
            type = "npc", 
            name = "Historian Karnik", 
            zone = "Ironforge", 
            location = { mapId = 1455, x = 0.764, y = 0.12 } 
        }
    },
    {
        id = 726,
        faction = "Alliance",
        name = "Passing Word of a Threat",
        suggestedLevel = 40,
        requiredLevel = 35,
        previousQuestId = 725,
        source = { 
            type = "npc", 
            name = "Advisor Belgrum", 
            zone = "Ironforge", 
            location = { mapId = 1455, x = 0.764, y = 0.12 } 
        }
    },
    {
        id = 762,
        faction = "Alliance",
        name = "An Ambassador of Evil",
        suggestedLevel = 44,
        requiredLevel = 35,
        previousQuestId = 726,
        source = { 
            type = "npc", 
            name = "Historian Karnik", 
            zone = "Ironforge", 
            location = { mapId = 1455, x = 0.764, y = 0.12 } 
        }
    },
    {
        id = 1139,
        faction = "Alliance",
        name = "The Lost Tablets of Will",
        suggestedLevel = 45,
        requiredLevel = 35,
        previousQuestId = 762,
        source = { 
            type = "npc", 
            name = "Advisor Belgrum", 
            zone = "Ironforge", 
            location = { mapId = 1455, x = 0.764, y = 0.12 } 
        },
        dungeons = { Q.Dungeons["Uldaman"] },
    },
    {
        id = 2198,
        faction = "Alliance",
        name = "The Shattered Necklace",
        suggestedLevel = 41,
        requiredLevel = 37,
        source = { 
            type = "item", 
            itemId = 7666,
            name = "Shattered Necklace", 
            zone = "Uldaman", 
            location = { mapId = 1418, x = 0.426, y = 0.122 },
            text = "Drops from Stonevault troggs and Shadowforge Ruffian/Diggers around/inside the dungeon"
        },
        dungeons = { Q.Dungeons["Uldaman"] },
    },
    {
        id = 2199,
        faction = "Alliance",
        name = "Lore for a Price",
        suggestedLevel = 41,
        requiredLevel = 37,
        previousQuestId = 2198,
        source = { 
            type = "npc", 
            name = "Talvash del Kissel", 
            zone = "Ironforge", 
            location = { mapId = 1455, x = 0.360, y = 0.04 } 
        }
    },
    {
        id = 2200,
        faction = "Alliance",
        name = "Back to Uldaman",
        suggestedLevel = 41,
        requiredLevel = 37,
        previousQuestId = 2199,
        source = { 
            type = "npc", 
            name = "Talvash del Kissel", 
            zone = "Ironforge", 
            location = { mapId = 1455, x = 0.360, y = 0.04 } 
        }
    },
    {
        id = 2201,
        faction = "Alliance",
        name = "Find the Gems",
        suggestedLevel = 43,
        requiredLevel = 37,
        previousQuestId = 2200,
        source = { 
            type = "object", 
            name = "Remains of a Paladin", 
            zone = "Uldaman", 
            location = { mapId = 1418, x = 0.426, y = 0.122, },
            text = "Found on the floor to the right when moving from Revelosh to Ironaya"
        }
    },
    {
        id = 2204,
        faction = "Alliance",
        name = "Restoring the Necklace",
        suggestedLevel = 44,
        requiredLevel = 37,
        previousQuestId = 2201,
        source = { 
            type = "object", 
            name = "Talvash's Scrying Bowl", 
            zone = "Uldaman", 
            location = { mapId = 1418, x = 0.426, y = 0.122, },
            text = "Summoned by using Talvah's Phial of Scrying from your bags."
        },
        dungeons = { Q.Dungeons["Uldaman"] },
    },
    {
        id = 2398,
        faction = "Alliance",
        name = "The Lost Dwarves",
        suggestedLevel = 40,
        requiredLevel = 35,
        source = { 
            type = "npc", 
            name = "Prospector Stormpike", 
            zone = "Ironforge", 
            location = { mapId = 1455, x = 0.75, y = 0.12 } 
        },
    },
    {
        id = 2500,
        faction = "Alliance",
        name = "Badlands Reagent Run",
        suggestedLevel = 39,
        requiredLevel = 36,
        source = { 
            type = "npc", 
            name = "Ghak Healtouch", 
            zone = "Loch Modan", 
            location = { mapId = 1432, x = 0.37, y = 0.492 } 
        },
    },
    {
        id = 2202,
        faction = "Horde",
        name = "Uldaman Reagent Run",
        suggestedLevel = 42,
        requiredLevel = 38,
        previousQuestId = 2258,
        source = { 
            type = "npc", 
            name = "Jarkal Mossmeld", 
            zone = "Badlands", 
            location = { mapId = 1418, x = 0.024, y = 0.460 } 
        },
        dungeons = { Q.Dungeons["Uldaman"] },
    },
    {
        id = 2258,
        faction = "Horde",
        name = "Badlands Reagent Run",
        suggestedLevel = 39,
        requiredLevel = 36,
        source = { 
            type = "npc", 
            name = "Jarkal Mossmeld", 
            zone = "Badlands", 
            location = { mapId = 1418, x = 0.024, y = 0.460 } 
        },
    },
    {
        id = 2278,
        faction = nil,
        name = "The Platinum Discs",
        suggestedLevel = 42,
        requiredLevel = 40,
        source = { 
            type = "object", 
            name = "The Platinum Discs", 
            zone = "Uldaman", 
            location = { mapId = 1418, x = 0.426, y = 0.122 },
            text = "Started in the vault after the final boss"
        },
        dungeons = { Q.Dungeons["Uldaman"] },
    },
    {
        id = 704,
        faction = "Alliance",
        name = "Agmond's Fate",
        suggestedLevel = 38,
        requiredLevel = 30,
        previousQuestId = 739,
        source = { 
            type = "npc", 
            name = "Prospector Ironband", 
            zone = "Loch Modan", 
            location = { mapId = 1432, x = 0.658, y = 0.656 }
        },
        dungeons = { Q.Dungeons["Uldaman"] },
    },
    {
        id = 739,
        faction = "Alliance",
        name = "Murdaloc",
        suggestedLevel = 42,
        requiredLevel = 30,
        previousQuestId = 738,
        source = { 
            type = "npc", 
            name = "Battered Dwarven Skeleton", 
            zone = "Badlands", 
            location = { mapId = 15, x = 0.51, y = 0.625 }
        }
    },
    {
        id = 738,
        faction = "Alliance",
        name = "Find Agmond",
        suggestedLevel = 38,
        requiredLevel = 30,
        previousQuestId = 707,
        source = { 
            type = "npc", 
            name = "Prospector Stormpike", 
            zone = "Ironforge", 
            location = { mapId = 1455, x = 0.738, y = 0.13 }
        }
    },
    {
        id = 2283,
        faction = "Horde",
        name = "Necklace Recovery",
        suggestedLevel = 41,
        requiredLevel = 37,
        source = { 
            type = "item", 
            itemId = 7666,
            name = "Shattered Necklace", 
            zone = "Uldaman", 
            location = { mapId = 1418, x = 0.426, y = 0.122 },
            text = "Drops from Stonevault troggs and Shadowforge Ruffian/Diggers around/inside the dungeon"
        }
    },
    {
        id = 2284,
        faction = "Horde",
        name = "Necklace Recovery, Take 2",
        suggestedLevel = 41,
        requiredLevel = 37,
        previousQuestId = 2283,
        source = { 
            type = "npc", 
            name = "Dran Droffers", 
            zone = "Orgrimmar", 
            location = { mapId = 1454, x = 0.594, y = 0.368 }
        }
    },
    {
        id = 2318,
        faction = "Horde",
        name = "Translating the Journal",
        suggestedLevel = 42,
        requiredLevel = 37,
        previousQuestId = 2284,
        source = { 
            type = "object", 
            name = "Remains of a Paladin", 
            zone = "Uldaman", 
            location = { mapId = 1418, x = 0.426, y = 0.122, },
            text = "Found on the floor to the right when moving from Revelosh to Ironaya"
        }
    },
    {
        id = 2338,
        faction = "Horde",
        name = "Translating the Journal",
        suggestedLevel = 42,
        requiredLevel = 37,
        previousQuestId = 2284,
        source = { 
            type = "npc", 
            name = "Jarkal Mossmeld", 
            zone = "Badlands", 
            location = { mapId = 1418, x = 0.024, y = 0.460 } 
        }
    },
    {
        id = 709,
        faction = nil,
        name = "Solution to Doom",
        suggestedLevel = 40,
        requiredLevel = 30,
        source = { 
            type = "npc", 
            name = "Theldurin the Lost", 
            zone = "Badlands", 
            location = { mapId = 1418, x = 0.514, y = 0.768 } 
        },
        dungeons = { Q.Dungeons["Uldaman"] },
    },
    --#endregion

    --#region Zul'Farrak
    {
        id = 2933,
        faction = "Horde",
        name = "Venom Bottles",
        suggestedLevel = 45,
        requiredLevel = 40,
        source = { 
            type = "item", 
            name = "Venom Bottle", 
            zone = "The Hinterlands", 
            location = { mapId = 1425, x = 0.236, y = 0.587 },
            text = "Can spawn in multiple locations throughout the zone" 
        }
    },
    {
        id = 2934,
        faction = "Horde",
        name = "Undamaged Venom Sac",
        suggestedLevel = 45,
        requiredLevel = 40,
        previousQuestId = 2933,
        source = { 
            type = "npc", 
            name = "Apotechary Lydon", 
            zone = "Hillsbrad Foothills", 
            location = { mapId = 1424, x = 0.614, y = 0.192 } 
        }
    },
    {
        id = 2935,
        faction = "Horde",
        name = "Consult Master Gadrin",
        suggestedLevel = 44,
        requiredLevel = 40,
        previousQuestId = 2934,
        source = { 
            type = "npc", 
            name = "Apotechary Lydon", 
            zone = "Hillsbrad Foothills", 
            location = { mapId = 1424, x = 0.614, y = 0.192 } 
        }
    },
    {
        id = 2936,
        faction = "Horde",
        name = "The Spider God",
        suggestedLevel = 44,
        requiredLevel = 40,
        previousQuestId = 2935,
        source = { 
            type = "npc", 
            name = "Master Gadrin", 
            zone = "Durotar", 
            location = { mapId = 1411, x = 0.56, y = 0.74 } 
        },
        dungeons = { Q.Dungeons["Zul'Farrak"] },
    },
    {
        id = 3042,
        faction = nil,
        name = "Troll Temper",
        suggestedLevel = 45,
        requiredLevel = 40,
        source = { 
            type = "npc", 
            name = "Trenton Lighthammer", 
            zone = "Tanaris", 
            location = { mapId = 440, x = 0.51, y = 0.28 } 
        },
        dungeons = { Q.Dungeons["Zul'Farrak"] },
    },
    {
        id = 2768,
        faction = nil,
        name = "Divino-matic Rod",
        suggestedLevel = 45,
        requiredLevel = 40,
        source = { 
            type = "npc", 
            name = "Chief Engineer Bilgewhizzle", 
            zone = "Tanaris", 
            location = { mapId = 440, x = 0.52, y = 0.28 } 
        },
        dungeons = { Q.Dungeons["Zul'Farrak"] },
    },
    {
        id = 2865,
        faction = nil,
        name = "Tiara of the Deep",
        suggestedLevel = 45,
        requiredLevel = 40,
        source = { 
            type = "npc", 
            name = "Tabetha", 
            zone = "Dustwallow Marsh", 
            location = { mapId = 1445, x = 0.46, y = 0.57 } 
        },
        dungeons = { Q.Dungeons["Zul'Farrak"] },
    },
    {
        id = 2770,
        faction = nil,
        name = "Gahz'rilla",
        suggestedLevel = 50,
        requiredLevel = 40,
        source = { 
            type = "npc", 
            name = "Wizzle Brassbolts", 
            zone = "Thousand Needles", 
            location = { mapId = 1441, x = 0.78, y = 0.77 } 
        },
        dungeons = { Q.Dungeons["Zul'Farrak"] },
    },

    {
        id = 2988,
        faction = "Alliance",
        name = "Witherbark Cages",
        suggestedLevel = 45,
        requiredLevel = 40,
        source = { 
            type = "npc", 
            name = "Gryphon Master Talonaxe", 
            zone = "The Hinterlands", 
            location = { mapId = 1425, x = 0.098, y = 0.444 } 
        }
    },
    {
        id = 2989,
        faction = nil,
        name = "The Altar of Zul",
        suggestedLevel = 48,
        requiredLevel = 40,
        previousQuestId = 2988,
        source = { 
            type = "npc", 
            name = "Gryphon Master Talonaxe", 
            zone = "The Hinterlands", 
            location = { mapId = 1425, x = 0.098, y = 0.444 } 
        }
    },
    {
        id = 2990,
        faction = nil,
        name = "Thadius Grimshade",
        suggestedLevel = 47,
        requiredLevel = 40,
        source = { 
            type = "npc", 
            name = "Gryphon Master Talonaxe", 
            zone = "The Hinterlands", 
            location = { mapId = 1425, x = 0.098, y = 0.444 } 
        }
    },
    {
        id = 2991,
        faction = nil,
        name = "Nekrum's Medallion",
        suggestedLevel = 47,
        requiredLevel = 40,
        source = { 
            type = "npc", 
            name = "Thadius Grimshade", 
            zone = "Blasted Lands", 
            location = { mapId = 1419, x = 0.87, y = 0.194 } 
        },
        dungeons = { Q.Dungeons["Zul'Farrak"] },
    },
    {
        id = 3520,
        faction = nil,
        name = "Screecher Spirits",
        suggestedLevel = 42,
        requiredLevel = 40,
        source = { 
            type = "npc", 
            name = "Yeh'kinya", 
            zone = "Tanaris", 
            location = { mapId = 440, x = 0.67, y = 0.22 } 
        },
    },
    {
        id = 3527,
        faction = nil,
        name = "The Prophecy of Mosh'aru",
        suggestedLevel = 47,
        requiredLevel = 40,
        previousQuestId = 3520,
        source = { 
            type = "npc", 
            name = "Yeh'kinya", 
            zone = "Tanaris", 
            location = { mapId = 440, x = 0.67, y = 0.22 } 
        },
        dungeons = { Q.Dungeons["Zul'Farrak"] },
    },
    --#endregion

    --#region Maraudon
    {
        id = 7070,
        faction = "Alliance",
        name = "Shadowshard Fragments",
        suggestedLevel = 41,
        requiredLevel = 39,
        source = { 
            type = "npc", 
            name = "Archmage Tervosh", 
            zone = "Dustwallow Marsh", 
            location = { mapId = 1445, x = 0.66, y = 0.49 } 
        },
        dungeons = { Q.Dungeons["Maraudon"] },
    },
    {
        id = 7068,
        faction = "Horde",
        name = "Shadowshard Fragments",
        suggestedLevel = 41,
        requiredLevel = 39,
        source = { 
            type = "npc", 
            name = "Uthel'nay", 
            zone = "Orgrimmar", 
            location = { mapId = 1454, x = 0.39, y = 0.86 } 
        },
        dungeons = { Q.Dungeons["Maraudon"] },
    },
    {
        id = 7028,
        faction = nil,
        name = "Twisted Evils",
        suggestedLevel = 45,
        requiredLevel = 41,
        source = { 
            type = "npc", 
            name = "Willow", 
            zone = "Desolace", 
            location = { mapId = 1443, x = 0.62, y = 0.39 } 
        },
        dungeons = { Q.Dungeons["Maraudon"] },
    },
    {
        id = 7044,
        faction = nil,
        name = "Legends of Maraudon",
        suggestedLevel = 49,
        requiredLevel = 41,
        source = { 
            type = "npc", 
            name = "Cavindra", 
            zone = "Maraudon", 
            location = { mapId = 1443, x = 0.29, y = 0.62 }
        },
        dungeons = { Q.Dungeons["Maraudon"] },
    },
    {
        id = 7029,
        faction = "Horde",
        name = "Vyletongue Corruption",
        suggestedLevel = 47,
        requiredLevel = 41,
        source = { 
            type = "npc", 
            name = "Vark Battlescar", 
            zone = "Desolace", 
            location = { mapId = 1443, x = 0.232, y = 0.702 } 
        },
        dungeons = { Q.Dungeons["Maraudon"] },
    },
    {
        id = 7041,
        faction = "Alliance",
        name = "Vyletongue Corruption",
        suggestedLevel = 47,
        requiredLevel = 41,
        source = { 
            type = "npc", 
            name = "Talendria", 
            zone = "Desolace", 
            location = { mapId = 1443, x = 0.684, y = 0.088 } 
        },
        dungeons = { Q.Dungeons["Maraudon"] },
    },
    {
        id = 7069,
        faction = "Alliance",
        name = "Corruption of Earth and Seed",
        suggestedLevel = 51,
        requiredLevel = 45,
        source = { 
            type = "npc", 
            name = "Keeper Marandis", 
            zone = "Desolace", 
            location = { mapId = 1443, x = 0.63, y = 0.10 } 
        },
        dungeons = { Q.Dungeons["Maraudon"] },
    },
    {
        id = 7046,
        faction = nil,
        name = "The Scepter of Celebras",
        suggestedLevel = 49,
        requiredLevel = 41,
        source = { 
            type = "npc", 
            name = "Celebras the Redeemed", 
            zone = "Desolace", 
            location = { mapId = 1443, x = 0.38, y = 0.58 },
            text = "Inside the dungeons, spawns after killing Celebras the Cursed"
        },
        dungeons = { Q.Dungeons["Maraudon"] },
    },
    {
        id = 7066,
        faction = nil,
        name = "Seed of Life",
        suggestedLevel = 51,
        requiredLevel = 39,
        source = { 
            type = "npc", 
            name = "Zaetar's Spirit", 
            zone = "Desolace", 
            location = { mapId = 1443, x = 0.38, y = 0.58 },
            text = "Inside the dungeons, spawns after killing Princess Theradras"
        },
        dungeons = { Q.Dungeons["Maraudon"] },
    },
    {
        id = 7067,
        faction = nil,
        name = "The Pariah's Instructions",
        suggestedLevel = 48,
        requiredLevel = 39,
        source = { 
            type = "npc", 
            name = "Centaur Pariah", 
            zone = "Desolace", 
            location = { mapId = 1443, x = 0.462, y = 0.866 },
            text = "Patrols the area"
        },
        dungeons = { Q.Dungeons["Maraudon"] },
    },
    --#endregion

    --#region Temple of Atal'Hakkar
    {
        id = 1424,
        faction = "Horde",
        name = "Pool of Tears",
        suggestedLevel = 43,
        requiredLevel = 38,
        source = { 
            type = "npc", 
            name = "Fel'zerul", 
            zone = "Swamp of Sorrows", 
            location = { mapId = 1435, x = 0.47, y = 0.54 } 
        }
    },
    {
        id = 1429,
        faction = "Horde",
        name = "The Atal'ai Exile",
        suggestedLevel = 44,
        requiredLevel = 38,
        previousQuestId = 1424,
        source = { 
            type = "npc", 
            name = "Fel'zerul", 
            zone = "Swamp of Sorrows", 
            location = { mapId = 1435, x = 0.47, y = 0.54 } 
        }
    },
    {
        id = 1444,
        faction = "Horde",
        name = "Return to Fel'Zerul",
        suggestedLevel = 44,
        requiredLevel = 38,
        previousQuestId = 1429,
        source = { 
            type = "npc", 
            name = "Atal'ai Exile", 
            zone = "The Hinterlands", 
            location = { mapId = 1425, x = 0.336, y = 0.752 } 
        }
    },
    {
        id = 1445,
        faction = "Horde",
        name = "The Temple of Atal'Hakkar",
        suggestedLevel = 50,
        requiredLevel = 38,
        previousQuestId = 1444,
        source = { 
            type = "npc", 
            name = "Fel'zerul", 
            zone = "Swamp of Sorrows", 
            location = { mapId = 1435, x = 0.47, y = 0.54 } 
        }
    },
    {
        id = 4143,
        faction = "Alliance",
        name = "Haze of Evil",
        suggestedLevel = 52,
        requiredLevel = 47,
        previousQuestId = 4142,
        source = { 
            type = "npc", 
            name = "Gregan Brewspewer", 
            zone = "Feralas", 
            location = { mapId = 1444, x = 0.45, y = 0.256 } 
        },
        dungeons = { Q.Dungeons["Temple of Atal'Hakkar"] },
    },
    {
        id = 1448,
        faction = "Alliance",
        name = "In Search of The Temple",
        suggestedLevel = 43,
        requiredLevel = 38,
        source = { 
            type = "npc", 
            name = "Brohann Caskbelly", 
            zone = "Stormwind City", 
            location = { mapId = 1453, x = 0.64, y = 0.21 } 
        }
    },
    {
        id = 4145,
        faction = "Horde",
        name = "Larion And Muigin",
        suggestedLevel = 52,
        requiredLevel = 47,
        source = { 
            type = "npc", 
            name = "Larion", 
            zone = "Un'Goro Crater", 
            location = { mapId = 1449, x = 0.43, y = 0.096 } 
        }
    },
    {
        id = 4147,
        faction = "Horde",
        name = "Marvon's Workshop",
        suggestedLevel = 52,
        requiredLevel = 47,
        previousQuestId = 4145,
        source = { 
            type = "npc", 
            name = "Larion", 
            zone = "Un'Goro Crater", 
            location = { mapId = 1449, x = 0.43, y = 0.096 } 
        }
    },
    {
        id = 4146,
        faction = "Horde",
        name = "Zapper Fuel",
        suggestedLevel = 52,
        requiredLevel = 47,
        previousQuestId = 4147,
        source = { 
            type = "npc", 
            name = "Liv Rizzlefix", 
            zone = "Feralas", 
            location = { mapId = 1413, x = 0.624, y = 0.386 } 
        },
        dungeons = { Q.Dungeons["Temple of Atal'Hakkar"] },
    },
    {
        id = 4141,
        faction = "Alliance",
        name = "Muigin and Larion",
        suggestedLevel = 52,
        requiredLevel = 47,
        source = { 
            type = "npc", 
            name = "Muigin", 
            zone = "Un'Goro Crater", 
            location = { mapId = 1449, x = 0.43, y = 0.096 } 
        }
    },
    {
        id = 4142,
        faction = "Alliance",
        name = "A Visist to Gregan",
        suggestedLevel = 52,
        requiredLevel = 47,
        previousQuestId = 4141,
        source = { 
            type = "npc", 
            name = "Muigin", 
            zone = "Un'Goro Crater", 
            location = { mapId = 1449, x = 0.43, y = 0.096 } 
        }
    },
    {
        id = 1449,
        faction = "Alliance",
        name = "To The Hinterlands",
        suggestedLevel = 43,
        requiredLevel = 38,
        previousQuestId = 1448,
        source = { 
            type = "npc", 
            name = "Brohann Caskbelly", 
            zone = "Stormwind City", 
            location = { mapId = 1453, x = 0.64, y = 0.21 } 
        }
    },
    {
        id = 1450,
        faction = "Alliance",
        name = "Gryphon Master Talonaxe",
        suggestedLevel = 43,
        requiredLevel = 38,
        previousQuestId = 1449,
        source = { 
            type = "npc", 
            name = "Falstad Wildhammer", 
            zone = "The Hinterlands", 
            location = { mapId = 1425, x = 0.118, y = 0.468 } 
        }
    },
    {
        id = 1451,
        faction = "Alliance",
        name = "Rhapsody Shindigger",
        suggestedLevel = 43,
        requiredLevel = 38,
        previousQuestId = 1450,
        source = { 
            type = "npc", 
            name = "Gryphon Master Talonaxe", 
            zone = "The Hinterlands", 
            location = { mapId = 1425, x = 0.098, y = 0.444 } 
        }
    },
    {
        id = 1452,
        faction = "Alliance",
        name = "Rhapsody's Kalimdor Kocktail",
        suggestedLevel = 43,
        requiredLevel = 38,
        previousQuestId = 1451,
        source = { 
            type = "npc", 
            name = "Rhapsody Shindigger", 
            zone = "The Hinterlands", 
            location = { mapId = 1425, x = 0.268, y = 0.486 } 
        }
    },
    {
        id = 1469,
        faction = "Alliance",
        name = "Rhapsody's Tale",
        suggestedLevel = 43,
        requiredLevel = 38,
        previousQuestId = 1452,
        source = { 
            type = "npc", 
            name = "Rhapsody Shindigger", 
            zone = "The Hinterlands", 
            location = { mapId = 1425, x = 0.268, y = 0.486 } 
        }
    },
    {
        id = 1475,
        faction = "Alliance",
        name = "Into The Temple of Atal'Hakkar",
        suggestedLevel = 50,
        requiredLevel = 38,
        previousQuestId = 1452,
        source = { 
            type = "npc", 
            name = "Brohann Caskbelly", 
            zone = "Stormwind City", 
            location = { mapId = 1453, x = 0.64, y = 0.21 } 
        },
        dungeons = { Q.Dungeons["Temple of Atal'Hakkar"] },
    },
    {
        id = 3446,
        faction = nil,
        name = "The Essence of Eranikus",
        suggestedLevel = 52,
        requiredLevel = 48,
        source = { 
            type = "item", 
            name = "Essence of Eranikus", 
            itemId = 10454, 
            zone = "Temple of Atal'Hakkar", 
            location = { mapId = 1435, x = 0.43, y = 0.53 },
            text = "Dropped by Shade of Eranikus inside the dungeon" 
        },
        dungeons = { Q.Dungeons["Temple of Atal'Hakkar"] },
    },
    {
        id = 4787,
        faction = nil,
        name = "The God Hakkar",
        suggestedLevel = 50,
        requiredLevel = 40,
        previousQuestId = 4786,
        source = { 
            type = "npc", 
            name = "Yeh'kinya", 
            zone = "Tanaris", 
            location = { mapId = 440, x = 0.67, y = 0.22 } 
        },
        dungeons = { Q.Dungeons["Temple of Atal'Hakkar"] },
    },
    {
        id = 4786,
        faction = nil,
        name = "The Ancient Egg",
        suggestedLevel = 50,
        requiredLevel = 40,
        previousQuestId = 3527,
        source = { 
            type = "npc", 
            name = "Yeh'kinya", 
            zone = "Tanaris", 
            location = { mapId = 440, x = 0.67, y = 0.22 } 
        },
    },
    {
        id = 1446,
        faction = nil,
        name = "Jammal'an the Prophet",
        suggestedLevel = 53,
        requiredLevel = 38,
        source = { 
            type = "npc", 
            name = "Atal'ai Exile", 
            zone = "The Hinterlands", 
            location = { mapId = 1425, x = 0.336, y = 0.752 } 
        },
        dungeons = { Q.Dungeons["Temple of Atal'Hakkar"] },
    },
    {
        id = 3380,
        faction = "Horde",
        name = "The Sunken Temple",
        suggestedLevel = 51,
        requiredLevel = 46,
        source = { 
            type = "npc", 
            name = "Witch Doctor Uzer'i", 
            zone = "Feralas", 
            location = { mapId = 1444, x = 0.744, y = 0.434 } 
        },
        dungeons = { Q.Dungeons["Temple of Atal'Hakkar"] },
    },
    {
        id = 3445,
        faction = "Alliance",
        name = "The Sunken Temple",
        suggestedLevel = 51,
        requiredLevel = 46,
        source = { 
            type = "npc", 
            name = "Angelas Moonbreeze", 
            zone = "Feralas", 
            location = { mapId = 1444, x = 0.318, y = 0.456 } 
        }
    },
    {
        id = 3444,
        faction = "Alliance",
        name = "The Stone Circle",
        suggestedLevel = 51,
        requiredLevel = 46,
        previousQuestId = 3445,
        source = { 
            type = "npc", 
            name = "Marvon Rivetseeker", 
            zone = "Tanaris", 
            location = { mapId = 1446, x = 0.526, y = 0.458 } 
        }
    },
    {
        id = 3444,
        faction = "Horde",
        name = "The Stone Circle",
        suggestedLevel = 51,
        requiredLevel = 46,
        previousQuestId = 3380,
        source = { 
            type = "npc", 
            name = "Marvon Rivetseeker", 
            zone = "Tanaris", 
            location = { mapId = 1446, x = 0.526, y = 0.458 } 
        }
    },
    {
        id = 3446,
        faction = "Alliance",
        name = "Into the Depths",
        suggestedLevel = 51,
        requiredLevel = 46,
        previousQuestId = 3444,
        source = { 
            type = "npc", 
            name = "Marvon Rivetseeker", 
            zone = "Tanaris", 
            location = { mapId = 1446, x = 0.526, y = 0.458 } 
        },
        dungeons = { Q.Dungeons["Temple of Atal'Hakkar"] },
    },
    {
        id = 3446,
        faction = "Horde",
        name = "Into the Depths",
        suggestedLevel = 51,
        requiredLevel = 46,
        previousQuestId = 3444,
        source = { 
            type = "npc", 
            name = "Marvon Rivetseeker", 
            zone = "Tanaris", 
            location = { mapId = 1446, x = 0.526, y = 0.458 } 
        },
        dungeons = { Q.Dungeons["Temple of Atal'Hakkar"] },
    },
    {
        id = 3447,
        faction = "Alliance",
        name = "Secret of the Circle",
        suggestedLevel = 51,
        requiredLevel = 46,
        previousQuestId = 3445,
        source = { 
            type = "npc", 
            name = "Marvon Rivetseeker", 
            zone = "Tanaris", 
            location = { mapId = 1446, x = 0.526, y = 0.458 } 
        },
        dungeons = { Q.Dungeons["Temple of Atal'Hakkar"] },
    },
    {
        id = 3447,
        faction = "Horde",
        name = "Secret of the Circle",
        suggestedLevel = 51,
        requiredLevel = 46,
        previousQuestId = 3380,
        source = { 
            type = "npc", 
            name = "Marvon Rivetseeker", 
            zone = "Tanaris", 
            location = { mapId = 1446, x = 0.526, y = 0.458 } 
        },
        dungeons = { Q.Dungeons["Temple of Atal'Hakkar"] },
    },
    --#endregion

    --#region Blackrock Depths
    {
        id = 4081,
        faction = "Horde",
        name = "KILL ON SIGHT: Dark Iron Dwarves",
        suggestedLevel = 52,
        requiredLevel = 48,
        source = { 
            type = "object", 
            name = "WANTED", 
            zone = "Badlands", 
            location = { mapId = 1418, x = 0.039, y = 0.474 },
            text = "Found in Kargath"
        },
        dungeons = { Q.Dungeons["Blackrock Depths"] }
    },
    {
        id = 4082,
        faction = "Horde",
        name = "KILL ON SIGHT: High Ranking Dark Iron Officials",
        suggestedLevel = 54,
        requiredLevel = 50,
        previousQuestId = 4081,
        source = { 
            type = "object", 
            name = "WANTED", 
            zone = "Badlands",
            location = { mapId = 1418, x = 0.04, y = 0.468 },
            text = "Found in Kargath"
        },
        dungeons = { Q.Dungeons["Blackrock Depths"] }
    },
    {
        id = 3906,
        faction = "Horde",
        name = "Disharmony of Flame",
        suggestedLevel = 52,
        requiredLevel = 48,
        source = { 
            type = "npc", 
            name = "Thunderheart", 
            zone = "Badlands", 
            location = { mapId = 1418, x = 0.036, y = 0.48 }
        },
        dungeons = { Q.Dungeons["Blackrock Depths"] }
    },
    {
        id = 3906,
        faction = "Horde",
        name = "Disharmony of Fire",
        suggestedLevel = 56,
        requiredLevel = 48,
        previousQuestId = 3906,
        source = { 
            type = "npc", 
            name = "Thunderheart", 
            zone = "Badlands", 
            location = { mapId = 1418, x = 0.036, y = 0.48 }
        },
        dungeons = { Q.Dungeons["Blackrock Depths"] }
    },
    {
        id = 7201,
        faction = "Horde",
        name = "The Last Element",
        suggestedLevel = 54,
        requiredLevel = 48,
        previousQuestId = 3906,
        source = { 
            type = "npc", 
            name = "Shadowmage Vivian Lagrave", 
            zone = "Badlands", 
            location = { mapId = 1418, x = 0.03, y = 0.476 }
        },
        dungeons = { Q.Dungeons["Blackrock Depths"] }
    },
    {
        id = 4134,
        faction = "Horde",
        name = "Lost Thunderbrew Recipe",
        suggestedLevel = 55,
        requiredLevel = 50,
        source = { 
            type = "npc", 
            name = "Shadowmage Vivian Lagrave", 
            zone = "Badlands", 
            location = { mapId = 1418, x = 0.03, y = 0.476 }
        },
        dungeons = { Q.Dungeons["Blackrock Depths"] }
    },
    {
        id = 4123,
        faction = nil,
        name = "The Heart of the Mountain",
        suggestedLevel = 55,
        requiredLevel = 50,
        source = { 
            type = "npc", 
            name = "Maxwort Uberglint", 
            zone = "Burning Steppes", 
            location = { mapId = 1428, x = 0.652, y = 0.238 } 
        },
        dungeons = { Q.Dungeons["Blackrock Depths"] }
    },
    {
        id = 7848,
        faction = nil,
        name = "Attunement to the Core",
        suggestedLevel = 55,
        requiredLevel = 55,
        source = { 
            type = "npc", 
            name = "Lothos Riftwaker", 
            zone = "Blackrock Mountain", 
            location = { mapId = 1428, x = 0.49, y = 0.63 },
            text = "Found at the bottom of the chain inside the mountain on the way to the dungeon"
        },
        dungeons = { Q.Dungeons["Blackrock Depths"] }
    },
    {
        id = 4324,
        faction = nil,
        name = "Yuka Screwspigot",
        suggestedLevel = 48,
        requiredLevel = 53,
        source = { 
            type = "npc", 
            name = "Yorba Screwspigot", 
            zone = "Tanaris", 
            location = { mapId = 1446, x = 0.670, y = 0.24 } 
        },
        dungeons = { Q.Dungeons["Blackrock Depths"] }
    },
    {
        id = 4136,
        faction = nil,
        name = "Ribbly Screwspigot",
        suggestedLevel = 48,
        requiredLevel = 53,
        previousQuestId = 4324,
        source = { 
            type = "npc", 
            name = "Yuka Screwspigot", 
            zone = "Burning Steppes", 
            location = { mapId = 1428, x = 0.66, y = 0.22 } 
        },
        dungeons = { Q.Dungeons["Blackrock Depths"] }
    },
    {
        id = 4286,
        faction = "Alliance",
        name = "The Good Stuff",
        suggestedLevel = 56,
        requiredLevel = 50,
        source = { 
            type = "npc", 
            name = "Oralius", 
            zone = "Burning Steppes", 
            location = { mapId = 1428, x = 0.846, y = 0.686 } 
        },
        dungeons = { Q.Dungeons["Blackrock Depths"] }
    },
    {
        id = 4126,
        faction = "Alliance",
        name = "Hurley Blackbreath",
        suggestedLevel = 55,
        requiredLevel = 50,
        source = { 
            type = "npc", 
            name = "Ragnar Thunderbrew", 
            zone = "Dun Morogh", 
            location = { mapId = 1426, x = 0.468, y = 0.524 } 
        },
        dungeons = { Q.Dungeons["Blackrock Depths"] }
    },
    {
        id = 3801,
        faction = nil,
        name = "Dark Iron Legacy",
        suggestedLevel = 52,
        requiredLevel = 48,
        source = { 
            type = "npc", 
            name = "Franclorn Forgewright", 
            zone = "Blackrock Mountain", 
            location = { mapId = 1428, x = 0.48, y = 0.66 },
            text = "You must be dead to speak to him, he's located in the middle of Blackrock Mountains inside the building"
        },
        dungeons = { Q.Dungeons["Blackrock Depths"] }
    },
    {
        id = 3802,
        faction = nil,
        name = "Dark Iron Legacy",
        suggestedLevel = 52,
        requiredLevel = 48,
        previousQuestId = 3801,
        source = { 
            type = "npc", 
            name = "Franclorn Forgewright", 
            zone = "Blackrock Mountain", 
            location = { mapId = 1428, x = 0.48, y = 0.66 },
            text = "You must be dead to speak to him, he's located in the middle of Blackrock Mountains inside the building"
        },
        dungeons = { Q.Dungeons["Blackrock Depths"] }
    },
    {
        id = 5125,
        faction = nil,
        name = "The Love Potion",
        suggestedLevel = 54,
        requiredLevel = 50,
        source = { 
            type = "npc", 
            name = "Mistress Nagmara", 
            zone = "Blackrock Depths", 
            location = { mapId = 1428, x = 0.48, y = 0.62 },
            text = "Found in the bar inside the dungeon"
        },
        dungeons = { Q.Dungeons["Blackrock Depths"] }
    },
    --#endregion

    --#region Dire Maul: East
    {
        id = 7488,
        faction = "Alliance",
        name = "Lethtendris's Web",
        suggestedLevel = 56,
        requiredLevel = 54,
        source = { 
            type = "npc", 
            name = "Latronicus Moonspear", 
            zone = "Feralas", 
            location = { mapId = 1444, x = 0.304, y = 0.46 } 
        },
        dungeons = { Q.Dungeons["Dire Maul: East"] }
    },
    {
        id = 7489,
        faction = "Horde",
        name = "Lethtendris's Web",
        suggestedLevel = 56,
        requiredLevel = 54,
        source = { 
            type = "npc", 
            name = "Talo Thornhoof", 
            zone = "Feralas", 
            location = { mapId = 1444, x = 0.76, y = 0.43 } 
        },
        dungeons = { Q.Dungeons["Dire Maul: East"] }
    },
    {
        id = 7461,
        faction = nil,
        name = "The Madness Within",
        suggestedLevel = 58,
        requiredLevel = 56,
        source = { 
            type = "npc", 
            name = "Shen'dralar Ancient", 
            zone = "Dire Maul", 
            location = { mapId = 1448, x = 0.59, y = 0.45 }
        },
        dungeons = { Q.Dungeons["Dire Maul: East"] }
    },
    {
        id = 7441,
        faction = nil,
        name = "Pusillin and the Elder Azj'Tordin",
        suggestedLevel = 56,
        requiredLevel = 54,
        source = { 
            type = "npc", 
            name = "Azj'Tordin", 
            zone = "Feralas", 
            location = { mapId = 1444, x = 0.76, y = 0.37 } 
        },
        dungeons = { Q.Dungeons["Dire Maul: East"] }
    },
    --#endregion

    --#region Dire Maul: North
    {
        id = 5527,
        faction = nil,
        name = "Free Knot!",
        suggestedLevel = 60,
        requiredLevel = 56,
        source = { 
            type = "npc", 
            name = "Knot Thimblejack", 
            zone = "Dire Maul", 
            location = { mapId = 1448, x = 0.59, y = 0.45 },
            text = "Located inside the dungeon"
        },
        dungeons = { Q.Dungeons["Dire Maul: North"] }
    },
    {
        id = 7481,
        faction = "Horde",
        name = "Elven Legends",
        suggestedLevel = 56,
        requiredLevel = 54,
        source = { 
            type = "npc", 
            name = "Sage Korolusk", 
            zone = "Feralas", 
            location = { mapId = 1444, x = 0.74, y = 0.43 } 
        },
        dungeons = { Q.Dungeons["Dire Maul: North"] }
    },
    {
        id = 7482,
        faction = "Alliance",
        name = "Elven Legends",
        suggestedLevel = 56,
        requiredLevel = 54,
        source = { 
            type = "npc", 
            name = "Sage Korolusk", 
            zone = "Feralas", 
            location = { mapId = 1444, x = 0.318, y = 0.444 } 
        },
        dungeons = { Q.Dungeons["Dire Maul: North"] }
    },
    --#endregion

    --#region Lower Blackrock Spire
    {
        id = 4724,
        faction = "Horde",
        name = "The Pack Mistress",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = { 
            type = "npc", 
            name = "Galamav the Marksman", 
            zone = "Badlands", 
            location = { mapId = 1418, x = 0.06, y = 0.47 } 
        },
        dungeons = { Q.Dungeons["Lower Blackrock Spire"] }
    },
    {
        id = 4701,
        faction = "Alliance",
        name = "Put Her Down",
        suggestedLevel = 59,
        requiredLevel = 55,
        source = { 
            type = "npc", 
            name = "Helendis Riverhorn", 
            zone = "Badlands", 
            location = { mapId = 1428, x = 0.856, y = 0.69 } 
        },
        dungeons = { Q.Dungeons["Lower Blackrock Spire"] }
    },
    {
        id = 4981,
        faction = "Horde",
        name = "Operative Bijou",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = { 
            type = "npc", 
            name = "Lexlort", 
            zone = "Badlands", 
            location = { mapId = 1418, x = 0.05, y = 0.47 } 
        },
        dungeons = { Q.Dungeons["Lower Blackrock Spire"] }
    },
    {
        id = 4702,
        faction = "Horde",
        name = "Warlord's Command",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = { 
            type = "npc", 
            name = "Warlord Goretooth", 
            zone = "Badlands", 
            location = { mapId = 1418, x = 0.05, y = 0.47 } 
        },
        dungeons = { Q.Dungeons["Lower Blackrock Spire"] }
    },
    {
        id = 4729,
        faction = nil,
        name = "Kibler's Exotic Pets",
        suggestedLevel = 59,
        requiredLevel = 55,
        source = { 
            type = "npc", 
            name = "Kibler", 
            zone = "Burning Steppes", 
            location = { mapId = 1428, x = 0.658, y = 0.22 } 
        },
        dungeons = { Q.Dungeons["Lower Blackrock Spire"] }
    },
    {
        id = 4742,
        faction = nil,
        name = "Seal of Ascension",
        suggestedLevel = 60,
        requiredLevel = 57,
        source = { 
            type = "item", 
            name = "Unadorned Seal of Ascension", 
            itemId = 12219, 
            zone = "Blackrock Spire", 
            location = { mapId = 1428, x = 0.48, y = 0.62 },
            text = "A random drop from mobs in Lower Blackrock Spire" 
        },
        dungeons = { Q.Dungeons["Lower Blackrock Spire"] }
    },
    {
        id = 4981,
        faction = nil,
        name = "Urok Doomhowl",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = { 
            type = "npc", 
            name = "Warosh", 
            zone = "Blackrock Spire", 
            location = { mapId = 1428, x = 0.48, y = 0.62 }
        },
        dungeons = { Q.Dungeons["Lower Blackrock Spire"] }
    },
    --#endregion

    --#region Scholomance
    {
        id = 5341,
        faction = "Horde",
        name = "Barov Family Fortune",
        suggestedLevel = 60,
        requiredLevel = 52,
        source = { 
            type = "npc", 
            name = "Alexi Barov", 
            zone = "Western Plaguelands", 
            location = { mapId = 1422, x = 0.83, y = 0.71 } 
        },
        dungeons = { Q.Dungeons["Scholomance"] }
    },
    {
        id = 5382,
        faction = "Alliance",
        name = "Barov Family Fortune",
        suggestedLevel = 60,
        requiredLevel = 52,
        source = { 
            type = "npc", 
            name = "Weldon Barov", 
            zone = "Western Plaguelands", 
            location = { mapId = 1422, x = 0.43, y = 0.83 } 
        },
        dungeons = { Q.Dungeons["Scholomance"] }
    },
    {
        id = 5533,
        faction = nil,
        name = "Doctor Theolen Krastinov, the Butcher",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = { 
            type = "npc", 
            name = "Eva Sarkhoff", 
            zone = "Western Plaguelands", 
            location = { mapId = 1422, x = 0.70, y = 0.73 } 
        },
        dungeons = { Q.Dungeons["Scholomance"] }
    },
    {
        id = 5537,
        faction = nil,
        name = "Kirtonos the Herald",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = { 
            type = "npc", 
            name = "Eva Sarkhoff", 
            zone = "Western Plaguelands", 
            location = { mapId = 1422, x = 0.70, y = 0.73 } 
        },
        dungeons = { Q.Dungeons["Scholomance"] }
    },
    {
        id = 5529,
        faction = nil,
        name = "Plagued Hatchlings",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = { 
            type = "npc", 
            name = "Betina Bigglezink", 
            zone = "Eastern Plaguelands", 
            location = { mapId = 1423, x = 0.81, y = 0.59 } 
        },
        dungeons = { Q.Dungeons["Scholomance"] }
    },
    {
        id = 5384,
        faction = nil,
        name = "The Lich, Ras Frostwhisper",
        suggestedLevel = 60,
        requiredLevel = 57,
        source = { 
            type = "npc", 
            name = "Magistrate Marduke", 
            zone = "Western Plaguelands", 
            location = { mapId = 1422, x = 0.70, y = 0.74 } 
        },
        dungeons = { Q.Dungeons["Scholomance"] }
    },
    {
        id = 5214,
        faction = nil,
        name = "The Great Ezra Grimm",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = { 
            type = "npc", 
            name = "Smokey LaRue", 
            zone = "Eastern Plaguelands", 
            location = { mapId = 1423, x = 0.80, y = 0.58 } 
        },
        dungeons = { Q.Dungeons["Scholomance"] }
    },
    --#endregion

    --#region Stratholme
    {
        id = 5251,
        faction = nil,
        name = "The Archivist",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = { 
            type = "npc", 
            name = "Duke Nicholas Zverenhoff", 
            zone = "Eastern Plaguelands", 
            location = { mapId = 1423, x = 0.81, y = 0.59 } 
        },
    },
    {
        id = 5282,
        faction = nil,
        name = "The Restless Souls",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = { 
            type = "npc", 
            name = "Egan", 
            zone = "Eastern Plaguelands", 
            location = { mapId = 1423, x = 0.14, y = 0.33 } 
        },
        dungeons = { Q.Dungeons["Stratholme"] }
    },
    {
        id = 5122,
        faction = nil,
        name = "The Medallion of Faith",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = { 
            type = "npc", 
            name = "Aurius", 
            zone = "Stratholme", 
            location = { mapId = 1423, x = 0.30, y = 0.27 }
        },
        dungeons = { Q.Dungeons["Stratholme"] }
    },
    {
        id = 5243,
        faction = nil,
        name = "Houses of the Holy",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = { 
            type = "npc", 
            name = "Leonid Barthalomew the Revered", 
            zone = "Eastern Plaguelands", 
            location = { mapId = 1423, x = 0.81, y = 0.57 } 
        },
        dungeons = { Q.Dungeons["Stratholme"] }
    },
    {
        id = 5127,
        faction = nil,
        name = "The Truth Comes Crashing Down",
        suggestedLevel = 60,
        requiredLevel = 55,
        previousQuestId = 5251,
        source = { 
            type = "item", 
            name = "Head of Balnazzar", 
            itemId = 13250, 
            zone = "Stratholme", 
            location = { mapId = 1423, x = 0.30, y = 0.27 },
            text = "Dropped by Balnazzar in Stratholme" 
        },
        dungeons = { Q.Dungeons["Stratholme"] }
    },
    --#endregion

    --#region Paladin Quests
    {
        id = 1442,
        faction = "Alliance",
        class = "PALADIN",
        name = "Seeking the Kor Gem",
        suggestedLevel = 22,
        requiredLevel = 20,
        source = { 
            type = "npc", 
            name = "Thundris Windweaver", 
            zone = "Darkshore", 
            location = { mapId = 1439, x = 0.37, y = 0.44 } 
        }
    },
    {
        id = 95034,
        faction = "Horde",
        class = "PALADIN",
        name = "The Debt",
        suggestedLevel = 25,
        requiredLevel = 18,
        source = {
            type = "npc",
            name = "Lumina Windsinger",
            zone = "The Sepulcher",
            location = { mapId = 1421, x = 0.432, y = 0.41 },
        },
    },
    {
        id = 95036,
        faction = "Horde",
        class = "PALADIN",
        name = "A Moon-Kissed Blade",
        suggestedLevel = 25,
        requiredLevel = 20,
        previousQuestId = 95034,
        source = {
            type = "npc",
            name = "Lumina Windsinger",
            zone = "The Sepulcher",
            location = { mapId = 1421, x = 0.432, y = 0.41 },
        },
        dungeons = { Q.Dungeons["Shadowfang Keep"], Q.Dungeons["The Deadmines"], Q.Dungeons["Blackfathom Deeps"] },
    },
    {
        id = 1654,
        faction = "Alliance",
        class = "PALADIN",
        name = "The Test of Righteousness",
        suggestedLevel = 20,
        requiredLevel = 20,
        previousQuestId = 1653,
        source = {
            type = "npc",
            name = "Jordan Stilwell",
            zone = "Ironforge",
            location = { mapId = 1455, x = 0.52, y = 0.36 }
        },
        dungeons = { Q.Dungeons["Shadowfang Keep"], Q.Dungeons["The Deadmines"], Q.Dungeons["Blackfathom Deeps"] },
    },
    {
        id = 1649,
        faction = "Alliance",
        class = "PALADIN",
        name = "The Tome of Valor",
        suggestedLevel = 20,
        requiredLevel = 20,
        source = { 
            type = "npc", 
            name = "Duthorian Rall", 
            zone = "Stormwind City", 
            location = { mapId = 1453, x = 0.40, y = 0.29 } },
    },
    {
        id = 1650,
        faction = "Alliance",
        class = "PALADIN",
        name = "The Tome of Valor",
        suggestedLevel = 23,
        requiredLevel = 20,
        previousQuestId = 1649,
        source = { 
            type = "npc", 
            name = "Daphne Stilwell", 
            zone = "Westfall", 
            location = { mapId = 1436, x = 0.42, y = 0.88 } 
        },
    },
    {
        id = 1651,
        faction = "Alliance",
        class = "PALADIN",
        name = "The Tome of Valor",
        suggestedLevel = 25,
        requiredLevel = 20,
        previousQuestId = 1650,
        source = { 
            type = "npc", 
            name = "Daphne Stilwell", 
            zone = "Westfall", 
            location = { mapId = 1436, x = 0.42, y = 0.88 } 
        },
    },
    {
        id = 1652,
        faction = "Alliance",
        class = "PALADIN",
        name = "The Tome of Valor",
        suggestedLevel = 25,
        requiredLevel = 20,
        previousQuestId = 1651,
        source = { 
            type = "npc", 
            name = "Duthorian Rall", 
            zone = "Stormwind City", 
            location = { mapId = 1453, x = 0.40, y = 0.29 } 
        },
    },
    {
        id = 1653,
        faction = "Alliance",
        class = "PALADIN",
        name = "The Test of Righteousness",
        suggestedLevel = 25,
        requiredLevel = 20,
        previousQuestId = 1652,
        source = { 
            type = "npc", 
            name = "Duthorian Rall", 
            zone = "Stormwind City", 
            location = { mapId = 1453, x = 0.40, y = 0.29 } 
        },
    },
    --#endregion
    
    --#region Warlock Quests
    {
        id = 1740,
        faction = nil,
        class = "WARLOCK",
        name = "The Orb of Soran'ruk",
        suggestedLevel = 25,
        requiredLevel = 20,
        source = { 
            type = "npc", 
            name = "Doan Karhan", 
            zone = "The Barrens", 
            location = { mapId = 1413, x = 0.49, y = 0.57 } 
        },
        dungeons = { Q.Dungeons["Shadowfang Keep"], Q.Dungeons["Blackfathom Deeps"] }
    },
    --#endregion
    
    --#region Warrior Quests
    {
        id = 1701,
        faction = "Alliance",
        class = "WARRIOR",
        name = "Fire Hardened Mail",
        suggestedLevel = 28,
        requiredLevel = 20,
        previousQuestId = 1702,
        source = {
            type = "npc",
            name = "Furen Longbeard",
            zone = "Stormwind City",
            location = { mapId = 1453, x = 0.63, y = 0.33 }
        },
        dungeons = { Q.Dungeons["Razorfen Kraul"]}
    },
    {
        id = 1699,
        faction = "Alliance",
        class = "WARRIOR",
        name = "The Rethban Gauntlet",
        suggestedLevel = 22,
        requiredLevel = 20,
        source = { 
            type = "npc", 
            name = "Yorus Barleybrew", 
            zone = "Redridge Mountains", 
            location = { mapId = 1433, x = 0.27, y = 0.45 } 
        },
    },
    {
        id = 1702,
        faction = "Alliance",
        class = "WARRIOR",
        name = "The Shieldsmith",
        suggestedLevel = 22,
        requiredLevel = 20,
        previousQuestId = 1699,
        source = { 
            type = "npc", 
            name = "Furen Longbeard", 
            zone = "Stormwind City", 
            location = { mapId = 1453, x = 0.63, y = 0.33 } 
        },
    },
    {
        id = 1838,
        faction = "Horde",
        class = "WARRIOR",
        name = "Brutal Armor",
        suggestedLevel = 30,
        requiredLevel = 20,
        previousQuestId = 1825,
        source = {
            type = "npc",
            name = "Thun'grim Firegaze",
            zone = "The Barrens",
            location = { mapId = 1413, x = 0.57, y = 0.30 }
        },
        dungeons = { Q.Dungeons["Razorfen Kraul"] }
    },
    {
        id = 1823,
        faction = "Horde",
        class = "WARRIOR",
        name = "Speak with Ruga",
        suggestedLevel = 20,
        requiredLevel = 20,
        sources = {
            { 
                type = "npc", 
                name = "Sorek", 
                zone = "Orgrimmar", 
                location = { mapId = 1454, x = 0.804, y = 0.314 } 
            },
            { 
                type = "npc", 
                name = "Torm Ragetotem", 
                zone = "Thunder Bluff", 
                location = { mapId = 1456, x = 0.576, y = 0.876 } 
            },
            { 
                type = "npc", 
                name = "Baltus Fowler", 
                zone = "Undercity", 
                location = { mapId = 1458, x = 0.476, y = 0.168 } 
            }
        },
    },
    {
        id = 1824,
        faction = "Horde",
        class = "WARRIOR",
        name = "Trial at the Field of Giants",
        suggestedLevel = 20,
        requiredLevel = 20,
        previousQuestId = 1823,
        source = { 
            type = "npc", 
            name = "Ruga Ragetotem", 
            zone = "The Barrens", 
            location = { mapId = 1413, x = 0.45, y = 0.59 } 
        },
    },
    {
        id = 1825,
        faction = "Horde",
        class = "WARRIOR",
        name = "Speak with Thun'grim",
        suggestedLevel = 20,
        requiredLevel = 20,
        previousQuestId = 1824,
        source = { 
            type = "npc", 
            name = "Thun'grim Firegaze", 
            zone = "The Barrens", 
            location = { mapId = 1413, x = 0.57, y = 0.30 } 
        },
    },
    --#endregion

    --#region Mage Quests
    {
        id = 1947,
        class = "MAGE",
        name = "Journey to the Marsh",
        suggestedLevel = 38,
        requiredLevel = 30,
        sources = {
            { 
                type = "npc",
                faction = "Horde",
                name = "Ursyn Ghull",
                zone = "Thunder Bluff",
                location = { mapId = 1456, x = 0.256, y = 0.156 }
            },
            { 
                type = "npc",
                faction = "Horde",
                name = "Anastasia Hartwell",
                zone = "Undercity",
                location = { mapId = 1458, x = 0.85, y = 0.102 }
            },
            { 
                type = "npc",
                faction = "Horde",
                name = "Deino",
                zone = "Orgrimmar",
                location = { mapId = 1454, x = 0.386, y = 0.852 }
            },
            { 
                type = "npc",
                faction = "Alliance",
                name = "Jennea Cannon",
                zone = "Stormwind City",
                location = { mapId = 1453, x = 0.386, y = 0.796 }
            }
            ,
            { 
                type = "npc",
                faction = "Alliance",
                name = "Bink",
                zone = "Ironforge",
                location = { mapId = 1455, x = 0.27, y = 0.082 }
            }
        }
    },
    {
        id = 1948,
        class = "MAGE",
        name = "Items of Power",
        suggestedLevel = 40,
        requiredLevel = 30,
        source = {
            type = "npc",
            name = "Tabetha",
            zone = "Dustwallow Marsh",
            location = { mapId = 1445, x = 0.460, y = 0.570 }
        },
    },
    {
        id = 1949,
        class = "MAGE",
        name = "Hidden Secrets",
        suggestedLevel = 38,
        requiredLevel = 30,
        previousQuestId = 1947,
        source = {
            type = "npc",
            name = "Tabetha",
            zone = "Dustwallow Marsh",
            location = { mapId = 1445, x = 0.460, y = 0.570 }
        },
    },
    {
        id = 1950,
        class = "MAGE",
        name = "Get the Scoop",
        suggestedLevel = 30,
        requiredLevel = 30,
        previousQuestId = 1949,
        source = {
            type = "npc",
            name = "Magus Tirth",
            zone = "Thousand Needles",
            location = { mapId = 1441, x = 0.784, y = 0.754 }
        },
    },
    {
        id = 1953,
        class = "MAGE",
        name = "Return to the Marsh",
        suggestedLevel = 40,
        requiredLevel = 35,
        sources = {
            { 
                type = "npc",
                faction = "Horde",
                name = "Ursyn Ghull",
                zone = "Thunder Bluff",
                location = { mapId = 1456, x = 0.256, y = 0.156 }
            },
            { 
                type = "npc",
                faction = "Horde",
                name = "Anastasia Hartwell",
                zone = "Undercity",
                location = { mapId = 1458, x = 0.85, y = 0.102 }
            },
            { 
                type = "npc",
                faction = "Horde",
                name = "Deino",
                zone = "Orgrimmar",
                location = { mapId = 1454, x = 0.386, y = 0.852 }
            },
            { 
                type = "npc",
                faction = "Alliance",
                name = "Jennea Cannon",
                zone = "Stormwind City",
                location = { mapId = 1453, x = 0.386, y = 0.796 }
            }
            ,
            { 
                type = "npc",
                faction = "Alliance",
                name = "Bink",
                zone = "Ironforge",
                location = { mapId = 1455, x = 0.27, y = 0.082 }
            }
        }
    },
    {
        id = 1954,
        class = "MAGE",
        name = "The Infernal Orb",
        suggestedLevel = 40,
        requiredLevel = 35,
        previousQuestId = 1953,
        source = {
            type = "npc",
            name = "Tabetha",
            zone = "Dustwallow Marsh",
            location = { mapId = 1445, x = 0.460, y = 0.570 }
        },
    },
    {
        id = 1955,
        class = "MAGE",
        name = "The Exorcism",
        suggestedLevel = 40,
        requiredLevel = 35,
        previousQuestId = 1954,
        source = {
            type = "npc",
            name = "Tabetha",
            zone = "Dustwallow Marsh",
            location = { mapId = 1445, x = 0.460, y = 0.570 }
        },
    },
    {
        id = 1956,
        class = "MAGE",
        name = "Power in Uldaman",
        suggestedLevel = 40,
        requiredLevel = 35,
        previousQuestId = 1955,
        source = {
            type = "npc",
            name = "Tabetha",
            zone = "Dustwallow Marsh",
            location = { mapId = 1445, x = 0.460, y = 0.570 }
        },
        dungeons = { Q.Dungeons["Uldaman"] },
    },
    {
        id = 1951,
        class = "MAGE",
        name = "Rituals of Power",
        suggestedLevel = 40,
        requiredLevel = 30,
        previousQuestId = 1950,
        source = {
            type = "npc",
            name = "Magus Tirth",
            zone = "Thousand Needles",
            location = { mapId = 1441, x = 0.784, y = 0.754 }
        },
        dungeons = { Q.Dungeons["SM: Library"] },
    },
    --#endregion
}
