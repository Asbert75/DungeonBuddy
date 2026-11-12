local _, Q = ...

Q.PrerequisiteType = {
    BREADCRUMB = "breadcrumb",
    CHAIN = "chain",
    REQUIRED = "required",
    ANY = "any"
}

--[[
    The "instances" property on a quest only tells the addon which instances that this particular quest
    should be displayed as a "main" quest, that is; which instance in the quest tracker it is displayed
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
        source = Q.Sources[225], -- Thom Filch
        instances = { Q.Instances["Hall of Thanes"] }
    },
    {
        id = 96394,
        faction = "Alliance",
        name = "The Restless Dead",
        suggestedLevel = 15,
        requiredLevel = 10,
        source = Q.Sources[3], -- Afadra Dunwall
        instances = { Q.Instances["Hall of Thanes"] }
    },
    {
        id = 96395,
        faction = nil,
        name = "An Ancient Grudge",
        suggestedLevel = 15,
        requiredLevel = 10,
        source = Q.Sources[91], -- Ghostly Attendant
        instances = { Q.Instances["Hall of Thanes"] }
    },
    {
        id = 96393,
        faction = "Alliance",
        name = "Old Ironforge Incursion",
        suggestedLevel = 16,
        requiredLevel = 9,
        prerequisites = {
            { id = 96391, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[74], -- Earthseer Farsen
        instances = { Q.Instances["Hall of Thanes"] }
    },
    {
        id = 96391,
        faction = "Alliance",
        name = "Underground Map",
        suggestedLevel = 15,
        requiredLevel = 9,
        source = Q.Sources[59], -- Dark Iron Map
    },
    {
        id = 98423,
        faction = "Alliance",
        name = "The Treaty of Understanding",
        suggestedLevel = 16,
        requiredLevel = 9,
        source = Q.Sources[236], -- Treaty of Understanding
        instances = { Q.Instances["Hall of Thanes"] }
    },
    --#endregion

    --#region Ragefire Chasm
    {
        id = 5726,
        faction = "Horde",
        name = "Hidden Enemies (1/3)",
        suggestedLevel = 12,
        requiredLevel = 9,
        source = Q.Sources[226], -- Thrall
    },
    {
        id = 5727,
        faction = "Horde",
        name = "Hidden Enemies (2/3)",
        suggestedLevel = 12,
        requiredLevel = 9,
        prerequisites = {
            { id = 5726, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[226], -- Thrall
    },
    {
        id = 5728,
        faction = "Horde",
        name = "Hidden Enemies (3/3)",
        suggestedLevel = 16,
        requiredLevel = 9,
        prerequisites = {
            { id = 5727, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[226], -- Thrall
        instances = { Q.Instances["Ragefire Chasm"] }
    },
    {
        id = 5761,
        faction = "Horde",
        name = "Slaying the Beast",
        suggestedLevel = 16,
        requiredLevel = 9,
        source = Q.Sources[173], -- Neeru Fireblade
        instances = { Q.Instances["Ragefire Chasm"] }
    },
    {
        id = 5725,
        faction = "Horde",
        name = "The Power to Destroy...",
        suggestedLevel = 16,
        requiredLevel = 9,
        source = Q.Sources[242], -- Varimathras
        instances = { Q.Instances["Ragefire Chasm"] }
    },
    {
        id = 5723,
        faction = "Horde",
        name = "Testing an Enemy's Strength",
        suggestedLevel = 15,
        requiredLevel = 9,
        source = Q.Sources[189], -- Rahauro
        instances = { Q.Instances["Ragefire Chasm"] }
    },
    {
        id = 5724,
        faction = "Horde",
        name = "Returning the Lost Satchel",
        suggestedLevel = 16,
        prerequisites = {
            { id = 5722, type = Q.PrerequisiteType.CHAIN }
        },
        requiredLevel = 9,
        source = Q.Sources[157], -- Maur Grimtotem
        instances = { Q.Instances["Ragefire Chasm"] }
    },
    {
        id = 5722,
        faction = "Horde",
        name = "Searching for the Lost Satchel",
        suggestedLevel = 16,
        requiredLevel = 9,
        source = Q.Sources[189], -- Rahauro
    },
    --#endregion

    --#region Ruins of Lordaeron
    {
        id = 92401,
        faction = "Horde",
        name = "A Frightened Request",
        suggestedLevel = 22,
        requiredLevel = 15,
        source = Q.Sources[215], -- Tabitha Heartweaver
        instances = { Q.Instances["Ruins of Lordaeron"] }
    },
    {
        id = 95204,
        faction = "Horde",
        name = "Crest of Lordaeron",
        suggestedLevel = 22,
        requiredLevel = 15,
        source = Q.Sources[51], -- Crest of Lordaeron
        instances = { Q.Instances["Ruins of Lordaeron"] }
    },
    {
        id = 95189,
        faction = "Alliance",
        name = "Crest of Lordaeron",
        suggestedLevel = 22,
        requiredLevel = 15,
        source = Q.Sources[52], -- Crest of Lordaeron
        instances = { Q.Instances["Ruins of Lordaeron"] }
    },
    {
        id = 92421,
        faction = "Horde",
        name = "Light's Justice",
        suggestedLevel = 22,
        requiredLevel = 15,
        source = Q.Sources[166], -- Morbin Lightbane
        instances = { Q.Instances["Ruins of Lordaeron"] }
    },

    {
        id = 447,
        faction = "Horde",
        name = "A Recipe For Death (1/3)",
        suggestedLevel = 22,
        requiredLevel = 15,
        source = Q.Sources[283], -- Apothecary Renferrel
    },
    {
        id = 450,
        faction = "Horde",
        name = "A Recipe For Death (2/3)",
        prerequisites = {
            { id = 447, type = Q.PrerequisiteType.CHAIN }
        },
        suggestedLevel = 22,
        requiredLevel = 15,
        source = Q.Sources[153], -- Master Apothecary Faranell
    },
    {
        id = 451,
        faction = "Horde",
        name = "A Recipe For Death (3/3)",
        prerequisites = {
            { id = 450, type = Q.PrerequisiteType.CHAIN }
        },
        suggestedLevel = 22,
        requiredLevel = 15,
        source = Q.Sources[283], -- Apothecary Renferrel
    },

    {
        id = 95216,
        faction = "Horde",
        name = "The New Plague",
        prerequisites = {
            { id = 451, type = Q.PrerequisiteType.CHAIN }
        },
        suggestedLevel = 22,
        requiredLevel = 15,
        source = Q.Sources[224], -- Theodore Griffs
        instances = { Q.Instances["Ruins of Lordaeron"] }
    },
    {
        id = 356,
        faction = "Horde",
        name = "Rear Guard Patrol",
        suggestedLevel = 11,
        requiredLevel = 6,
        source = Q.Sources[282], -- Deathguard Linnea
    },
    {
        id = 99156,
        faction = "Horde",
        name = "Rear Guard Patrol",
        prerequisites = {
            { id = 356, type = Q.PrerequisiteType.CHAIN }
        },
        suggestedLevel = 13,
        requiredLevel = 6,
        source = Q.Sources[282], -- Deathguard Linnea
    },
    {
        id = 92422,
        faction = "Horde",
        name = "The Wrath of Rath'mael",
        prerequisites = {
            { id = 99156, type = Q.PrerequisiteType.CHAIN }
        },
        suggestedLevel = 22,
        requiredLevel = 15,
        source = Q.Sources[64], -- Deathguard Kristof
        instances = { Q.Instances["Ruins of Lordaeron"] }
    },
    {
        id = 97288,
        faction = "Horde",
        name = "Unending Torment",
        suggestedLevel = 21,
        requiredLevel = 15,
        source = Q.Sources[1], -- Abominable Head
        instances = { Q.Instances["Ruins of Lordaeron"] }
    },
    {
        id = 95250,
        faction = "Alliance",
        name = "Abominable Creatures",
        suggestedLevel = 21,
        requiredLevel = 15,
        source = Q.Sources[40], -- Captain Truman
        instances = { Q.Instances["Ruins of Lordaeron"] }
    },
    {
        id = 92415,
        faction = "Alliance",
        name = "Remember That I Love You",
        suggestedLevel = 22,
        requiredLevel = 15,
        source = Q.Sources[31], -- Blood-Stained Letter
        instances = { Q.Instances["Ruins of Lordaeron"] }
    },
    {
        id = 95195,
        faction = "Alliance",
        name = "Bloodied Insignia",
        suggestedLevel = 22,
        requiredLevel = 15,
        source = Q.Sources[32], -- Bloodied Insignia
        instances = { Q.Instances["Ruins of Lordaeron"] }
    },
    --#endregion

    --#region The Deadmines
    {
        id = 65,
        faction = "Alliance",
        name = "The Defias Brotherhood (1/7)",
        suggestedLevel = 18,
        requiredLevel = 14,
        source = Q.Sources[99], -- Gryan Stoutmantle
    },
    {
        id = 132,
        faction = "Alliance",
        name = "The Defias Brotherhood (2/7)",
        suggestedLevel = 18,
        requiredLevel = 14,
        prerequisites = {
            { id = 65, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[252], -- Wiley the Black
    },
    {
        id = 135,
        faction = "Alliance",
        name = "The Defias Brotherhood (3/7)",
        suggestedLevel = 18,
        requiredLevel = 14,
        prerequisites = {
            { id = 132, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[99], -- Gryan Stoutmantle
    },
    {
        id = 141,
        faction = "Alliance",
        name = "The Defias Brotherhood (4/7)",
        suggestedLevel = 18,
        requiredLevel = 14,
        prerequisites = {
            { id = 135, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[155], -- Master Mathias Shaw
    },
    {
        id = 142,
        faction = "Alliance",
        name = "The Defias Brotherhood (5/7)",
        suggestedLevel = 18,
        requiredLevel = 14,
        prerequisites = {
            { id = 141, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[99], -- Gryan Stoutmantle
    },
    {
        id = 155,
        faction = "Alliance",
        name = "The Defias Brotherhood (6/7)",
        suggestedLevel = 18,
        requiredLevel = 14,
        prerequisites = {
            { id = 142, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[280], -- The Defias Traitor
    },
    {
        id = 166,
        faction = "Alliance",
        name = "The Defias Brotherhood (7/7)",
        suggestedLevel = 18,
        requiredLevel = 14,
        prerequisites = {
            { id = 155, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[99], -- Gryan Stoutmantle
        instances = { Q.Instances["The Deadmines"] },
    },
    {
        id = 168,
        faction = "Alliance",
        name = "Collecting Memories",
        suggestedLevel = 18,
        requiredLevel = 14,
        source = Q.Sources[251], -- Wilder Thistlenettle
        instances = { Q.Instances["The Deadmines"] },
    },
    {
        id = 167,
        faction = "Alliance",
        name = "Oh Brother...",
        suggestedLevel = 20,
        requiredLevel = 15,
        source = Q.Sources[251], -- Wilder Thistlenettle
        instances = { Q.Instances["The Deadmines"] },
    },
    {
        id = 2040,
        faction = "Alliance",
        name = "Underground Assault",
        suggestedLevel = 20,
        requiredLevel = 15,
        source = Q.Sources[207], -- Shoni the Shilent
        instances = { Q.Instances["The Deadmines"] },
    },
    {
        id = 214,
        faction = "Alliance",
        name = "Red Silk Bandanas",
        suggestedLevel = 14,
        requiredLevel = 14,
        prerequisites = {
            { id = 155, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[202], -- Scout Riell
        instances = { Q.Instances["The Deadmines"] },
    },
    {
        id = 373,
        faction = "Alliance",
        name = "The Unsent Letter",
        suggestedLevel = 16,
        requiredLevel = 16,
        source = Q.Sources[5], -- An Unsent Letter
        instances = { Q.Instances["The Deadmines"] },
    },
    -- Toxic Soil questline (WoW Forever)
    {
        id = 92742,
        faction = "Alliance",
        name = "Testing the Wells",
        suggestedLevel = 12,
        requiredLevel = 9,
        source = Q.Sources[285], -- Alba Fairmoon
    },
    {
        id = 92744,
        faction = "Alliance",
        name = "Murloc Gills",
        suggestedLevel = 13,
        requiredLevel = 9,
        prerequisites = { { id = 92742, type = Q.PrerequisiteType.CHAIN } },
        source = Q.Sources[285], -- Alba Fairmoon
    },
    {
        id = 92745,
        faction = "Alliance",
        name = "The State of the Mines",
        suggestedLevel = 15,
        requiredLevel = 9,
        prerequisites = { { id = 92744, type = Q.PrerequisiteType.CHAIN } },
        source = Q.Sources[285], -- Alba Fairmoon
    },
    {
        id = 92747,
        faction = "Alliance",
        name = "Moonbrook Espionage",
        suggestedLevel = 16,
        requiredLevel = 9,
        prerequisites = { { id = 92745, type = Q.PrerequisiteType.CHAIN } },
        source = Q.Sources[285], -- Alba Fairmoon
    },
    {
        id = 92748,
        faction = "Alliance",
        name = "Explosive Consultation",
        suggestedLevel = 16,
        requiredLevel = 9,
        prerequisites = { { id = 92747, type = Q.PrerequisiteType.CHAIN } },
        source = Q.Sources[285], -- Alba Fairmoon
    },
    {
        id = 92749,
        faction = "Alliance",
        name = "A Dynamite Plan",
        suggestedLevel = 16,
        requiredLevel = 9,
        prerequisites = { { id = 92748, type = Q.PrerequisiteType.CHAIN } },
        source = Q.Sources[286], -- Sprite Jumpsprocket
    },
    {
        id = 92750,
        faction = "Alliance",
        name = "Detonation at a Distance (1/2)",
        suggestedLevel = 17,
        requiredLevel = 9,
        prerequisites = { { id = 92749, type = Q.PrerequisiteType.CHAIN } },
        source = Q.Sources[286], -- Sprite Jumpsprocket
    },
    {
        id = 92751,
        faction = "Alliance",
        name = "Detonation at a Distance (2/2)",
        suggestedLevel = 17,
        requiredLevel = 9,
        prerequisites = { { id = 92750, type = Q.PrerequisiteType.CHAIN } },
        source = Q.Sources[287], -- Jasper Fel
    },
    {
        id = 92752,
        faction = "Alliance",
        name = "Explosive Consultation (2/2)",
        suggestedLevel = 17,
        requiredLevel = 9,
        prerequisites = { { id = 92751, type = Q.PrerequisiteType.CHAIN } },
        source = Q.Sources[286], -- Sprite Jumpsprocket
    },
    {
        id = 92753,
        faction = "Alliance",
        name = "Destruction in Deadmines (1/2)",
        suggestedLevel = 18,
        requiredLevel = 9,
        prerequisites = { { id = 92752, type = Q.PrerequisiteType.CHAIN } },
        source = Q.Sources[285], -- Alba Fairmoon
    },
    {
        id = 92819,
        faction = "Alliance",
        name = "Destruction in Deadmines (2/2)",
        suggestedLevel = 18,
        requiredLevel = 9,
        prerequisites = { { id = 92753, type = Q.PrerequisiteType.CHAIN } },
        source = Q.Sources[285], -- Alba Fairmoon
        instances = { Q.Instances["The Deadmines"] },
    },
    --#endregion

    --#region Wailing Caverns
    {
        id = 886,
        faction = "Horde",
        name = "The Barrens Oases",
        suggestedLevel = 10,
        requiredLevel = 10,
        source = Q.Sources[12], -- Arch Druid Hamuul Runetotem
    },
    {
        id = 870,
        faction = "Horde",
        name = "The Forgotten Pools",
        suggestedLevel = 13,
        requiredLevel = 10,
        prerequisites = {
            { id = 886, type = Q.PrerequisiteType.BREADCRUMB }
        },
        source = Q.Sources[234], -- Tonga Runetotem
    },
    {
        id = 877,
        faction = "Horde",
        name = "The Stagnant Oasis",
        suggestedLevel = 13,
        requiredLevel = 10,
        prerequisites = {
            { id = 870, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[234], -- Tonga Runetotem
    },
    {
        id = 880,
        faction = "Horde",
        name = "Altered Beings",
        suggestedLevel = 16,
        requiredLevel = 10,
        prerequisites = {
            { id = 877, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[234], -- Tonga Runetotem
    },
    {
        id = 1489,
        faction = "Horde",
        name = "Hamuul Runetotem",
        suggestedLevel = 16,
        requiredLevel = 10,
        prerequisites = {
            { id = 880, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[234], -- Tonga Runetotem
    },
    {
        id = 1490,
        faction = "Horde",
        name = "Nara Wildmane",
        suggestedLevel = 16,
        requiredLevel = 10,
        prerequisites = {
            { id = 1489, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[103], -- Hamuul Runetotem
    },
    {
        id = 1486,
        faction = nil,
        name = "Deviate Hides",
        suggestedLevel = 17,
        requiredLevel = 13,
        source = Q.Sources[170], -- Nalpak
        instances = { Q.Instances["Wailing Caverns"] },
    },
    {
        id = 1487,
        faction = nil,
        name = "Deviate Eradication",
        suggestedLevel = 21,
        requiredLevel = 15,
        source = Q.Sources[75], -- Ebru
        instances = { Q.Instances["Wailing Caverns"] },
    },
    {
        id = 959,
        faction = nil,
        name = "Trouble at the Docks",
        suggestedLevel = 18,
        requiredLevel = 14,
        source = Q.Sources[50], -- Crane Operator Bigglefuzz
        instances = { Q.Instances["Wailing Caverns"] },
    },
    {
        id = 1491,
        faction = nil,
        name = "Smart Drinks",
        suggestedLevel = 18,
        requiredLevel = 13,
        prerequisites = {
            { id = 865, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[161], -- Mebok Mizzyrix
        instances = { Q.Instances["Wailing Caverns"] },
    },
    {
        id = 865,
        faction = nil,
        name = "Raptor Horns",
        suggestedLevel = 18,
        requiredLevel = 13,

        source = Q.Sources[161], -- Mebok Mizzyrix
    },
    {
        id = 962,
        faction = "Horde",
        name = "Serpentbloom",
        suggestedLevel = 21,
        requiredLevel = 14,
        source = Q.Sources[10], -- Apothecary Zamah
        instances = { Q.Instances["Wailing Caverns"] },
    },
    {
        id = 914,
        faction = "Horde",
        name = "Leaders of the Fang",
        suggestedLevel = 22,
        requiredLevel = 15,
        prerequisites = {
            { id = 1490, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[171], -- Nara Wildmane
        instances = { Q.Instances["Wailing Caverns"] },
    },
    {
        id = 6981,
        faction = nil,
        name = "The Glowing Shard",
        suggestedLevel = 25,
        requiredLevel = 15,
        source = Q.Sources[92], -- Glowing Shard
        instances = { Q.Instances["Wailing Caverns"] },
    },
    --#endregion

    --#region Blackfathom Deeps
    {
        id = 971,
        faction = "Alliance",
        name = "Knowledge in the Deeps",
        suggestedLevel = 23,
        requiredLevel = 18,
        source = Q.Sources[88], -- Gerrig Bonegrip
        instances = { Q.Instances["Blackfathom Deeps"] },
    },
    {
        id = 1275,
        faction = "Alliance",
        name = "Researching the Corruption",
        suggestedLevel = 24,
        requiredLevel = 18,
        prerequisites = {
            { id = 3765, type = Q.PrerequisiteType.BREADCRUMB }
        },
        source = Q.Sources[89], -- Gershala Nightwhisper
        instances = { Q.Instances["Blackfathom Deeps"] },
    },
    {
        id = 3765,
        faction = "Alliance",
        name = "The Corruption Abroad",
        suggestedLevel = 24,
        requiredLevel = 18,
        source = Q.Sources[17], -- Argos Nightwhisper
    },
    {
        id = 1199,
        faction = "Alliance",
        name = "Twilight Falls",
        suggestedLevel = 25,
        requiredLevel = 20,
        source = Q.Sources[15], -- Argent Guard Manados
        instances = { Q.Instances["Blackfathom Deeps"] },
    },
    {
        id = 6564,
        faction = "Horde",
        name = "Allegiance to the Old Gods (1/2)",
        suggestedLevel = 22,
        requiredLevel = 17,
        source = Q.Sources[56], -- Damp Note
    },
    {
        id = 6565,
        faction = "Horde",
        name = "Allegiance to the Old Gods (2/2)",
        suggestedLevel = 26,
        requiredLevel = 17,
        prerequisites = {
            { id = 6564, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[119], -- Je'neu Sancrea
        instances = { Q.Instances["Blackfathom Deeps"] },
    },
    {
        id = 6921,
        faction = "Horde",
        name = "Amongst the Ruins",
        suggestedLevel = 24,
        requiredLevel = 21,
        source = Q.Sources[119], -- Je'neu Sancrea
        instances = { Q.Instances["Blackfathom Deeps"] },
    },
    {
        id = 6563,
        faction = "Horde",
        name = "The Essence of Aku'Mai",
        suggestedLevel = 22,
        requiredLevel = 17,
        source = Q.Sources[119], -- Je'neu Sancrea
        instances = { Q.Instances["Blackfathom Deeps"] },
    },
    {
        id = 1200,
        faction = "Alliance",
        name = "Blackfathom Villainy",
        suggestedLevel = 27,
        requiredLevel = 18,
        prerequisites = {
            { id = 1198, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[16], -- Argent Guard Thaelrid
        instances = { Q.Instances["Blackfathom Deeps"] },
    },
    {
        id = 1198,
        faction = "Alliance",
        name = "In Search of Thaelrid",
        suggestedLevel = 24,
        requiredLevel = 18,
        source = Q.Sources[60], -- Dawnwatcher Shaedlass
    },
    {
        id = 6561,
        faction = "Horde",
        name = "Blackfathom Villainy",
        suggestedLevel = 27,
        requiredLevel = 18,
        source = Q.Sources[16], -- Argent Guard Thaelrid
        instances = { Q.Instances["Blackfathom Deeps"] },
    },
    {
        id = 6922,
        faction = "Horde",
        name = "Baron Aquanis",
        suggestedLevel = 27,
        requiredLevel = 21,
        source = Q.Sources[213], -- Strange Water Globe
        instances = { Q.Instances["Blackfathom Deeps"] },
    },
    --#endregion

    --#region Razorfen Kraul
    {
        id = 1100,
        faction = "Alliance",
        name = "Lonebrow's Journal",
        suggestedLevel = 27,
        requiredLevel = 25,
        source = Q.Sources[138], -- Lonebrow's Journal
    },
    {
        id = 1101,
        faction = "Alliance",
        name = "The Crone of the Kraul",
        suggestedLevel = 34,
        prerequisites = {
            { id = 1100, type = Q.PrerequisiteType.CHAIN }
        },
        requiredLevel = 29,
        source = Q.Sources[80], -- Falfindel Waywarder
        instances = { Q.Instances["Razorfen Kraul"] },
    },
    {
        id = 1102,
        faction = "Horde",
        name = "A Vengeful Fate",
        suggestedLevel = 34,
        requiredLevel = 29,
        source = Q.Sources[20], -- Auld Stonespire
        instances = { Q.Instances["Razorfen Kraul"] },
    },
    {
        id = 1221,
        faction = nil,
        name = "Blueleaf Tubers",
        suggestedLevel = 26,
        requiredLevel = 20,
        source = Q.Sources[161], -- Mebok Mizzyrix
        instances = { Q.Instances["Razorfen Kraul"] },
    },
    {
        id = 1142,
        faction = "Alliance",
        name = "Mortality Wanes",
        suggestedLevel = 30,
        requiredLevel = 25,
        source = Q.Sources[107], -- Heralath Fallowbrook
        instances = { Q.Instances["Razorfen Kraul"] },
    },
    {
        id = 1144,
        faction = nil,
        name = "Willix the Importer",
        suggestedLevel = 30,
        requiredLevel = 22,
        source = Q.Sources[253], -- Willix the Importer
        instances = { Q.Instances["Razorfen Kraul"] },
    },
    {
        id = 1109,
        faction = "Horde",
        name = "Going, Going, Guano!",
        suggestedLevel = 33,
        requiredLevel = 30,
        source = Q.Sources[153], -- Master Apothecary Faranell
        instances = { Q.Instances["Razorfen Kraul"] },
    },
    {
        id = 6522,
        faction = "Horde",
        name = "An Unholy Alliance (1/2)",
        suggestedLevel = 36,
        requiredLevel = 28,
        source = Q.Sources[209], -- Small Scroll
        instances = { Q.Instances["Razorfen Kraul"] },
    },
    --#endregion

    --#region Shadowfang Keep
    {
        id = 1013,
        faction = "Horde",
        name = "The Book of Ur",
        suggestedLevel = 20,
        requiredLevel = 16,
        source = Q.Sources[121], -- Keeper Bel'dugur
        instances = { Q.Instances["Shadowfang Keep"] },
    },
    {
        id = 1098,
        faction = "Horde",
        name = "Deathstalkers in Shadowfang",
        suggestedLevel = 25,
        requiredLevel = 18,
        source = Q.Sources[109], -- High Executor Hadrec
        instances = { Q.Instances["Shadowfang Keep"] },
    },
    {
        id = 1014,
        faction = "Horde",
        name = "Arugal Must Die",
        suggestedLevel = 24,
        requiredLevel = 18,
        source = Q.Sources[55], -- Dalar Dawnweaver
        instances = { Q.Instances["Shadowfang Keep"] },
    },
    --#endregion

    --#region Excavation Site: Wetlands
    {
        id = 95663,
        faction = "Horde",
        name = "Dragonmaw Rumors",
        suggestedLevel = 31,
        requiredLevel = 24,
        source = Q.Sources[262], -- Zaruk
    },
    {
        id = 95697,
        faction = "Horde",
        name = "Changing Tastes",
        suggestedLevel = 31,
        requiredLevel = 24,
        source = Q.Sources[33], -- Borstan
        instances = { Q.Instances["Excavation Site: Wetlands"] },
    },
    {
        id = 95664,
        faction = "Horde",
        name = "Elder Knowledge",
        suggestedLevel = 31,
        requiredLevel = 24,
        source = Q.Sources[231], -- Titan Relic
        instances = { Q.Instances["Excavation Site: Wetlands"] },
    },
    {
        id = 95682,
        faction = "Horde",
        name = "Open the Maw",
        suggestedLevel = 31,
        prerequisites = {
            { id = 95663, type = Q.PrerequisiteType.CHAIN }
        },
        requiredLevel = 24,
        source = Q.Sources[65], -- Deathstalker Agent
        instances = { Q.Instances["Excavation Site: Wetlands"] },
    },
    {
        id = 484,
        faction = "Alliance",
        name = "Young Crocolisk Skins",
        suggestedLevel = 22,
        requiredLevel = 18,
        source = Q.Sources[117], -- James Halloran
    },
    {
        id = 98815,
        faction = "Alliance",
        name = "Highland Hides",
        prerequisites = {
            { id = 484, type = Q.PrerequisiteType.CHAIN }
        },
        suggestedLevel = 28,
        requiredLevel = 24,
        source = Q.Sources[117], -- James Halloran
        instances = { Q.Instances["Excavation Site: Wetlands"] },
    },
    {
        id = 276,
        faction = "Alliance",
        name = "Tramping Paws",
        suggestedLevel = 21,
        requiredLevel = 20,
        source = Q.Sources[192], -- Rethiel the Greenwarden
    },
    {
        id = 277,
        faction = "Alliance",
        name = "Fire Taboo",
        suggestedLevel = 23,
        requiredLevel = 20,
        prerequisites = {
            { id = 276, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[192], -- Rethiel the Greenwarden
    },
    {
        id = 275,
        faction = "Alliance",
        name = "Blisters on the Land",
        suggestedLevel = 26,
        requiredLevel = 20,
        prerequisites = {
            { id = 277, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[192], -- Rethiel the Greenwarden
    },
    {
        id = 95772,
        faction = "Alliance",
        name = "Songblade Search",
        suggestedLevel = 31,
        requiredLevel = 24,
        source = Q.Sources[68], -- Dorin Songblade
        instances = { Q.Instances["Excavation Site: Wetlands"] },
    },
    {
        id = 95646,
        faction = "Alliance",
        name = "Horrors in the Highland",
        suggestedLevel = 24,
        requiredLevel = 24,
        prerequisites = {
            { id = 275, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[192], -- Rethiel the Greenwarden
        instances = { Q.Instances["Excavation Site: Wetlands"] },
    },
    {
        id = 95737,
        faction = "Alliance",
        name = "Seeking Caitlin",
        suggestedLevel = 31,
        requiredLevel = 24,
        source = Q.Sources[281], -- Llana
    },
    {
        id = 95647,
        faction = "Alliance",
        name = "Lost in the Thicket Things",
        suggestedLevel = 31,
        requiredLevel = 24,
        prerequisites = {
            { id = 95737, type = Q.PrerequisiteType.BREADCRUMB }
        },
        source = Q.Sources[38], -- Caitlin Grassman
        instances = { Q.Instances["Excavation Site: Wetlands"] },
    },
    {
        id = 95810,
        faction = "Alliance",
        name = "Lost Relic Carry",
        suggestedLevel = 31,
        requiredLevel = 24,
        source = Q.Sources[232], -- Titan Relic
        instances = { Q.Instances["Excavation Site: Wetlands"] },
    },
    --#endregion

    --#region The Stockade
    {
        id = 303,
        faction = "Alliance",
        name = "The Dark Iron War",
        suggestedLevel = 30,
        requiredLevel = 25,
        source = Q.Sources[167], -- Motley Garmason
    },
    {
        id = 389,
        faction = "Alliance",
        name = "Bazil Thredd",
        suggestedLevel = 22,
        requiredLevel = 16,
        prerequisites = {
            { id = 373, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[25], -- Baros Alexston
    },
    {
        id = 386,
        faction = "Alliance",
        name = "What Comes Around...",
        suggestedLevel = 25,
        requiredLevel = 22,
        source = Q.Sources[101], -- Guard Berton
        instances = { Q.Instances["The Stockade"] },
    },
    {
        id = 377,
        faction = "Alliance",
        name = "Crime and Punishment",
        suggestedLevel = 26,
        requiredLevel = 22,
        source = Q.Sources[48], -- Councilman Millstipe
        instances = { Q.Instances["The Stockade"] },
    },
    {
        id = 387,
        faction = "Alliance",
        name = "Quell The Uprising",
        suggestedLevel = 26,
        requiredLevel = 22,
        source = Q.Sources[248], -- Warden Thelwater
        instances = { Q.Instances["The Stockade"] },
    },
    {
        id = 388,
        faction = "Alliance",
        name = "The Color of Blood",
        suggestedLevel = 26,
        requiredLevel = 22,
        source = Q.Sources[174], -- Nikova Raskol
        instances = { Q.Instances["The Stockade"] },
    },
    {
        id = 378,
        faction = "Alliance",
        name = "The Fury Runs Deep",
        suggestedLevel = 27,
        requiredLevel = 25,
        prerequisites = {
            { id = 303, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[167], -- Motley Garmason
        instances = { Q.Instances["The Stockade"] },
    },
    {
        id = 391,
        faction = "Alliance",
        name = "The Stockade Riots",
        suggestedLevel = 29,
        requiredLevel = 16,
        prerequisites = {
            { id = 389, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[248], -- Warden Thelwater
        instances = { Q.Instances["The Stockade"] },
    },
    --#endregion

    --#region Gnomeregan
    {
        id = 2951,
        faction = nil,
        name = "The Sparklematic 5200!",
        suggestedLevel = 30,
        requiredLevel = 25,
        source = Q.Sources[222], -- The Sparklematic 5200
        instances = { Q.Instances["Gnomeregan"] },
    },
    {
        id = 2927,
        faction = "Alliance",
        name = "The Day After",
        suggestedLevel = 27,
        requiredLevel = 20,
        source = Q.Sources[93], -- Gnoarn
    },
    {
        id = 2931,
        faction = "Alliance",
        name = "Castpipe's Task",
        suggestedLevel = 30,
        requiredLevel = 25,
        source = Q.Sources[86], -- Gaxim Rustfizzle
    },
    {
        id = 2841,
        faction = "Horde",
        name = "Rig Wars",
        suggestedLevel = 35,
        requiredLevel = 25,
        source = Q.Sources[175], -- Nogg
        instances = { Q.Instances["Gnomeregan"] },
    },
    {
        id = 2842,
        faction = "Horde",
        name = "Chief Engineer Scooty",
        suggestedLevel = 35,
        requiredLevel = 20,
        source = Q.Sources[211], -- Sovik
    },
    {
        id = 2924,
        faction = "Alliance",
        name = "Essential Artificials",
        suggestedLevel = 30,
        requiredLevel = 20,
        source = Q.Sources[128], -- Klockmort Spannerspan
        instances = { Q.Instances["Gnomeregan"] },
    },
    {
        id = 2930,
        faction = "Alliance",
        name = "Data Rescue",
        suggestedLevel = 30,
        requiredLevel = 25,
        prerequisites = {
            { id = 2931, type = Q.PrerequisiteType.BREADCRUMB }
        },
        source = Q.Sources[156], -- Master Mechanic Castpipe
        instances = { Q.Instances["Gnomeregan"] },
    },
    {
        id = 2962,
        faction = "Alliance",
        name = "The Only Cure is More Green Glow",
        suggestedLevel = 30,
        requiredLevel = 20,
        prerequisites = {
            { id = 2926, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[178], -- Ozzie Togglevolt
        instances = { Q.Instances["Gnomeregan"] },
    },
    {
        id = 2945,
        faction = nil,
        name = "Grime-Encrusted Ring",
        suggestedLevel = 34,
        requiredLevel = 28,
        source = Q.Sources[98], -- Grime-Encrusted Ring
        instances = { Q.Instances["Gnomeregan"] },
    },
    {
        id = 2926,
        faction = "Alliance",
        name = "Gnogaine",
        suggestedLevel = 27,
        requiredLevel = 20,
        prerequisites = {
            { id = 2927, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[178], -- Ozzie Togglevolt
    },
    {
        id = 2922,
        faction = "Alliance",
        name = "Save Techbot's Brain!",
        suggestedLevel = 26,
        requiredLevel = 20,
        source = Q.Sources[229], -- Tinkmaster Overspark
        instances = { Q.Instances["Gnomeregan"] },
    },
    {
        id = 2929,
        faction = "Alliance",
        name = "The Grand Betrayal",
        suggestedLevel = 35,
        requiredLevel = 25,
        source = Q.Sources[112], -- High Tinker Mekkatorque
        instances = { Q.Instances["Gnomeregan"] },
    },
    {
        id = 2928,
        faction = "Alliance",
        name = "Gyrodrillmatic Excavationators",
        suggestedLevel = 30,
        requiredLevel = 20,
        source = Q.Sources[207], -- Shoni the Shilent
        instances = { Q.Instances["Gnomeregan"] },
    },
    {
        id = 2843,
        faction = "Horde",
        name = "Gnomer-gooooone!",
        suggestedLevel = 35,
        requiredLevel = 20,
        prerequisites = {
            { id = 2842, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[201], -- Scooty
        instances = { Q.Instances["Gnomeregan"] },
    },
    {
        id = 2904,
        faction = nil,
        name = "A Fine Mess",
        suggestedLevel = 30,
        requiredLevel = 20,
        source = Q.Sources[124], -- Kernobee
        instances = { Q.Instances["Gnomeregan"] },
    },
    --#endregion

    --#region City of Dalaran
    {
        id = 96986,
        faction = "Horde",
        name = "The Grave Knight",
        suggestedLevel = 33,
        requiredLevel = 24,
        source = Q.Sources[162], -- Melisara
        instances = { Q.Instances["City of Dalaran"] },
    },
    {
        id = 96987,
        faction = "Horde",
        name = "Opportunistic Education",
        suggestedLevel = 33,
        requiredLevel = 30,
        source = Q.Sources[193], -- Rexxie Copperclutch
        instances = { Q.Instances["City of Dalaran"] },
    },
    {
        id = 96984,
        faction = "Horde",
        name = "Heart of Disruption",
        suggestedLevel = 33,
        requiredLevel = 30,
        prerequisites = {
            { id = 92434, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[115], -- Image of Archmage Modera
    },
    {
        id = 92457,
        faction = "Alliance",
        name = "Starving Arcane",
        suggestedLevel = 33,
        requiredLevel = 30,
        source = Q.Sources[115], -- Image of Archmage Modera
        instances = { Q.Instances["City of Dalaran"] },
    },
    {
        id = 92489,
        faction = "Alliance",
        name = "Power Overwhelming",
        suggestedLevel = 33,
        requiredLevel = 30,
        source = Q.Sources[111], -- High Sorcerer Andromath
        instances = { Q.Instances["City of Dalaran"] },
    },
    {
        id = 92458,
        faction = "Alliance",
        name = "Heart of Disruption",
        suggestedLevel = 33,
        requiredLevel = 30,
        prerequisites = {
            { id = 92432, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[115], -- Image of Archmage Modera
        instances = { Q.Instances["City of Dalaran"] },
    },
    {
        id = 96988,
        faction = "Horde",
        name = "Source of Power",
        suggestedLevel = 33,
        requiredLevel = 24,
        source = Q.Sources[67], -- Doctor Martin Felben
        instances = { Q.Instances["City of Dalaran"] },
    },
    {
        id = 97287,
        faction = "Horde",
        name = "Shrewd Negotiations",
        suggestedLevel = 33,
        requiredLevel = 30,
        prerequisites = {
            { id = 96984, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[149], -- Magus Wordeen Voidglare
        instances = { Q.Instances["City of Dalaran"] },
    },

    {
        id = 93680,
        faction = "Horde",
        name = "Key to the City",
        suggestedLevel = 33,
        requiredLevel = 30,
        source = Q.Sources[149], -- Magus Wordeen Voidglare
    },
    {
        id = 556,
        faction = "Horde",
        name = "Stone Tokens",
        suggestedLevel = 33,
        requiredLevel = 30,
        source = Q.Sources[122], -- Keeper Bel'varil
    },
    {
        id = 544,
        faction = "Horde",
        name = "Prison Break In",
        suggestedLevel = 33,
        requiredLevel = 30,
        source = Q.Sources[149], -- Magus Wordeen Voidglare
    },
    {
        id = 545,
        faction = "Horde",
        name = "Dalaran Patrols",
        suggestedLevel = 33,
        requiredLevel = 30,
        prerequisites = {
            { id = 544, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[149], -- Magus Wordeen Voidglare
    },
    {
        id = 557,
        faction = "Horde",
        name = "Bracers of Binding",
        suggestedLevel = 33,
        requiredLevel = 30,
        prerequisites = {
            { id = 556, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[122], -- Keeper Bel'varil
    },
    {
        id = 92434,
        faction = "Horde",
        name = "Blood in the Streets",
        suggestedLevel = 33,
        requiredLevel = 30,
        prerequisites = {
            { id = 93680, type = Q.PrerequisiteType.REQUIRED },
            { id = 545,   type = Q.PrerequisiteType.REQUIRED },
            { id = 557,   type = Q.PrerequisiteType.REQUIRED }
        },
        source = Q.Sources[149], -- Magus Wordeen Voidglare
    },
    {
        id = 92456,
        faction = "Alliance",
        name = "A Green Sample",
        suggestedLevel = 33,
        requiredLevel = 30,
        source = Q.Sources[208], -- Shylamiir
        instances = { Q.Instances["City of Dalaran"] },
    },
    {
        id = 92432,
        faction = "Alliance",
        name = "An Alarming Request",
        suggestedLevel = 33,
        requiredLevel = 30,
        source = Q.Sources[77], -- Emissary Jacques
    },
    --#endregion

    --#region Scarlet Monastery: Shared
    {
        id = 6141,
        faction = "Alliance",
        name = "Brother Anton",
        suggestedLevel = 39,
        requiredLevel = 34,
        source = Q.Sources[37], -- Brother Crowley
    },
    {
        id = 261,
        faction = "Alliance",
        name = "Down the Scarlet Path (1/2)",
        suggestedLevel = 39,
        requiredLevel = 34,
        prerequisites = {
            { id = 6141, type = Q.PrerequisiteType.BREADCRUMB }
        },
        source = Q.Sources[36], -- Brother Anton
    },
    {
        id = 1052,
        faction = "Alliance",
        name = "Down the Scarlet Path (2/2)",
        suggestedLevel = 40,
        requiredLevel = 34,
        prerequisites = {
            { id = 261, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[36], -- Brother Anton
    },
    {
        id = 1048,
        faction = "Horde",
        name = "Into The Scarlet Monastery",
        suggestedLevel = 42,
        requiredLevel = 33,
        source = Q.Sources[242], -- Varimathras
        instances = { Q.Instances["Scarlet Monastery: Library"], Q.Instances["Scarlet Monastery: Armory"], Q.Instances["Scarlet Monastery: Cathedral"] },
    },
    {
        id = 1113,
        faction = "Horde",
        name = "Hearts of Zeal",
        suggestedLevel = 35,
        requiredLevel = 30,
        prerequisites = {
            { id = 1109, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[153], -- Master Apothecary Faranell
        instances = { Q.Instances["Scarlet Monastery: Library"], Q.Instances["Scarlet Monastery: Armory"], Q.Instances["Scarlet Monastery: Cathedral"] },
    },
    {
        id = 1053,
        faction = "Alliance",
        name = "In the Name of the Light",
        suggestedLevel = 40,
        requiredLevel = 34,
        prerequisites = {
            { id = 1052, type = Q.PrerequisiteType.REQUIRED }
        },
        source = Q.Sources[190], -- Raleigh the Devout
        instances = { Q.Instances["Scarlet Monastery: Library"], Q.Instances["Scarlet Monastery: Armory"], Q.Instances["Scarlet Monastery: Cathedral"] },
    },
    --#endregion

    --#region SM: Graveyard
    {
        id = 1051,
        faction = "Horde",
        name = "Vorrel's Revenge",
        suggestedLevel = 30,
        requiredLevel = 25,
        source = Q.Sources[246], -- Vorrel Sengutz
        instances = { Q.Instances["Scarlet Monastery: Graveyard"] },
    },
    --#endregion

    --#region SM: Library
    {
        id = 96800,
        faction = "Alliance",
        name = "Past Due",
        suggestedLevel = 38,
        requiredLevel = 30,
        source = Q.Sources[147], -- Magus Olvek
        instances = { Q.Instances["Scarlet Monastery: Library"] },
    },
    {
        id = 1049,
        faction = "Horde",
        name = "Compendium of the Fallen",
        suggestedLevel = 38,
        requiredLevel = 28,
        source = Q.Sources[199], -- Sage Truthseeker
        instances = { Q.Instances["Scarlet Monastery: Library"] },
    },
    {
        id = 1149,
        faction = "Horde",
        name = "Test of Faith",
        suggestedLevel = 26,
        requiredLevel = 25,
        source = Q.Sources[69], -- Dorn Plainstalker
    },
    {
        id = 1150,
        faction = "Horde",
        name = "Test of Endurance",
        suggestedLevel = 29,
        requiredLevel = 25,
        prerequisites = {
            { id = 1149, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[69], -- Dorn Plainstalker
    },
    {
        id = 1151,
        faction = "Horde",
        name = "Test of Strength",
        suggestedLevel = 30,
        requiredLevel = 25,
        prerequisites = {
            { id = 1150, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[69], -- Dorn Plainstalker
    },
    {
        id = 1152,
        faction = "Horde",
        name = "Test of Lore (1/5)",
        suggestedLevel = 30,
        requiredLevel = 25,
        prerequisites = {
            { id = 1151, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[69], -- Dorn Plainstalker
    },
    {
        id = 1154,
        faction = "Horde",
        name = "Test of Lore (2/5)",
        suggestedLevel = 30,
        requiredLevel = 25,
        prerequisites = {
            { id = 1152, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[34], -- Braug Dimspirit
    },
    {
        id = 6627,
        faction = "Horde",
        name = "Test of Lore (3/5)",
        suggestedLevel = 30,
        requiredLevel = 25,
        prerequisites = {
            { id = 1154, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[34], -- Braug Dimspirit
    },
    {
        id = 1159,
        faction = "Horde",
        name = "Test of Lore (4/5)",
        suggestedLevel = 30,
        requiredLevel = 25,
        prerequisites = {
            { id = 6627, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[34], -- Braug Dimspirit
    },
    {
        id = 1160,
        faction = "Horde",
        name = "Test of Lore (5/5)",
        suggestedLevel = 35,
        requiredLevel = 25,
        prerequisites = {
            { id = 1159, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[179], -- Parqual Fintallas
        instances = { Q.Instances["Scarlet Monastery: Library"] },
    },
    {
        id = 1050,
        faction = "Alliance",
        name = "Mythology of the Titans",
        suggestedLevel = 38,
        requiredLevel = 28,
        source = Q.Sources[136], -- Librarian Mae Paledust
        instances = { Q.Instances["Scarlet Monastery: Library"] },
    },
    --#endregion

    --#region Razorfen Downs
    {
        id = 97196,
        faction = "Horde",
        name = "The Coldbringer's Eye",
        suggestedLevel = 41,
        requiredLevel = 34,
        source = Q.Sources[240], -- Unknown
        instances = { Q.Instances["Razorfen Downs"] },
    },
    {
        id = 96773,
        faction = "Alliance",
        name = "The Coldbringer's Eye",
        suggestedLevel = 41,
        requiredLevel = 34,
        source = Q.Sources[289], -- Archmage Lan'dalock
        instances = { Q.Instances["Razorfen Downs"] },
    },
    {
        id = 3341,
        faction = "Horde",
        name = "Bring the End",
        suggestedLevel = 42,
        requiredLevel = 37,
        source = Q.Sources[7], -- Andrew Brownell
        instances = { Q.Instances["Razorfen Downs"] },
    },
    {
        id = 6521,
        faction = "Horde",
        name = "An Unholy Alliance (2/2)",
        suggestedLevel = 36,
        requiredLevel = 28,
        prerequisites = {
            { id = 6522, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[242], -- Varimathras
        instances = { Q.Instances["Razorfen Downs"] },
    },
    {
        id = 3636,
        faction = "Alliance",
        name = "Bring the Light",
        suggestedLevel = 42,
        requiredLevel = 39,
        source = Q.Sources[13], -- Archbishop Benedictus
        instances = { Q.Instances["Razorfen Downs"] },
    },
    {
        id = 6626,
        faction = nil,
        name = "A Host of Evil",
        suggestedLevel = 35,
        requiredLevel = 28,
        source = Q.Sources[169], -- Myriam Moonsinger
        instances = { Q.Instances["Razorfen Downs"] },
    },
    {
        id = 3525,
        faction = nil,
        name = "Extinguishing the Idol",
        suggestedLevel = 37,
        requiredLevel = 32,
        prerequisites = {
            { id = 3523, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[27], -- Belnistrasz
        instances = { Q.Instances["Razorfen Downs"] },
    },
    {
        id = 3523,
        faction = nil,
        name = "Scourge of the Downs",
        suggestedLevel = 37,
        requiredLevel = 32,
        source = Q.Sources[27], -- Belnistrasz
    },
    --#endregion

    --#region Uldaman
    {
        id = 2342,
        faction = "Horde",
        name = "Reclaimed Treasures",
        suggestedLevel = 38,
        requiredLevel = 33,
        source = Q.Sources[180], -- Patrick Garrett
        instances = { Q.Instances["Uldaman"] },
    },
    {
        id = 1360,
        faction = "Alliance",
        name = "Reclaimed Treasures",
        suggestedLevel = 38,
        requiredLevel = 33,
        source = Q.Sources[131], -- Krom Stoutarm
        instances = { Q.Instances["Uldaman"] },
    },
    {
        id = 17,
        faction = "Alliance",
        name = "Uldaman Reagent Run",
        suggestedLevel = 42,
        requiredLevel = 38,
        prerequisites = {
            { id = 2500, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[90], -- Ghak Healtouch
        instances = { Q.Instances["Uldaman"] },
    },
    {
        id = 2339,
        faction = "Horde",
        name = "Find the Gems and Power Source",
        suggestedLevel = 44,
        requiredLevel = 37,
        prerequisites = {
            { id = 2338, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[118], -- Jarkal Mossmeld
        instances = { Q.Instances["Uldaman"] },
    },
    {
        id = 2240,
        faction = "Alliance",
        name = "The Hidden Chamber",
        suggestedLevel = 40,
        requiredLevel = 35,
        prerequisites = {
            { id = 2398, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[24], -- Baelog
        instances = { Q.Instances["Uldaman"] },
    },
    {
        id = 2418,
        faction = nil,
        name = "Power Stones",
        suggestedLevel = 36,
        requiredLevel = 30,
        source = Q.Sources[195], -- Rigglefuzz
        instances = { Q.Instances["Uldaman"] },
    },
    {
        id = 720,
        faction = "Alliance",
        name = "A Sign of Hope (1/2)",
        suggestedLevel = 35,
        requiredLevel = 35,
        source = Q.Sources[53], -- Crumpled Map
    },
    {
        id = 721,
        faction = "Alliance",
        name = "A Sign of Hope (2/2)",
        suggestedLevel = 40,
        requiredLevel = 35,
        prerequisites = {
            { id = 720, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[185], -- Prospector Ryedol
    },
    {
        id = 722,
        faction = "Alliance",
        name = "Amulet of Secrets",
        suggestedLevel = 40,
        requiredLevel = 35,
        prerequisites = {
            { id = 721, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[102], -- Hammertoe Grez
    },
    {
        id = 723,
        faction = "Alliance",
        name = "Prospect of Faith (1/2)",
        suggestedLevel = 40,
        requiredLevel = 35,
        prerequisites = {
            { id = 722, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[102], -- Hammertoe Grez
    },
    {
        id = 724,
        faction = "Alliance",
        name = "Prospect of Faith (2/2)",
        suggestedLevel = 40,
        requiredLevel = 35,
        prerequisites = {
            { id = 723, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[185], -- Prospector Ryedol
    },
    {
        id = 725,
        faction = "Alliance",
        name = "Passing Word of a Threat (1/2)",
        suggestedLevel = 40,
        requiredLevel = 35,
        prerequisites = {
            { id = 724, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[113], -- Historian Karnik
    },
    {
        id = 726,
        faction = "Alliance",
        name = "Passing Word of a Threat (2/2)",
        suggestedLevel = 40,
        requiredLevel = 35,
        prerequisites = {
            { id = 725, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[2], -- Advisor Belgrum
    },
    {
        id = 762,
        faction = "Alliance",
        name = "An Ambassador of Evil",
        suggestedLevel = 44,
        requiredLevel = 35,
        prerequisites = {
            { id = 726, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[113], -- Historian Karnik
    },
    {
        id = 1139,
        faction = "Alliance",
        name = "The Lost Tablets of Will",
        suggestedLevel = 45,
        requiredLevel = 35,
        prerequisites = {
            { id = 762, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[2], -- Advisor Belgrum
        instances = { Q.Instances["Uldaman"] },
    },
    {
        id = 2198,
        faction = "Alliance",
        name = "The Shattered Necklace",
        suggestedLevel = 41,
        requiredLevel = 37,
        source = Q.Sources[205], -- Shattered Necklace
        instances = { Q.Instances["Uldaman"] },
    },
    {
        id = 2199,
        faction = "Alliance",
        name = "Lore for a Price",
        suggestedLevel = 41,
        requiredLevel = 37,
        prerequisites = {
            { id = 2198, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[218], -- Talvash del Kissel
    },
    {
        id = 2200,
        faction = "Alliance",
        name = "Back to Uldaman",
        suggestedLevel = 41,
        requiredLevel = 37,
        prerequisites = {
            { id = 2199, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[218], -- Talvash del Kissel
    },
    {
        id = 2201,
        faction = "Alliance",
        name = "Find the Gems",
        suggestedLevel = 43,
        requiredLevel = 37,
        prerequisites = {
            { id = 2200, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[191], -- Remains of a Paladin
    },
    {
        id = 2204,
        faction = "Alliance",
        name = "Restoring the Necklace",
        suggestedLevel = 44,
        requiredLevel = 37,
        prerequisites = {
            { id = 2201, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[219], -- Talvash's Scrying Bowl
        instances = { Q.Instances["Uldaman"] },
    },
    {
        id = 2398,
        faction = "Alliance",
        name = "The Lost Dwarves",
        suggestedLevel = 40,
        requiredLevel = 35,
        source = Q.Sources[186], -- Prospector Stormpike
    },
    {
        id = 2500,
        faction = "Alliance",
        name = "Badlands Reagent Run",
        suggestedLevel = 39,
        requiredLevel = 36,
        source = Q.Sources[90], -- Ghak Healtouch
    },
    {
        id = 2202,
        faction = "Horde",
        name = "Uldaman Reagent Run",
        suggestedLevel = 42,
        requiredLevel = 38,
        prerequisites = {
            { id = 2258, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[118], -- Jarkal Mossmeld
        instances = { Q.Instances["Uldaman"] },
    },
    {
        id = 2258,
        faction = "Horde",
        name = "Badlands Reagent Run",
        suggestedLevel = 39,
        requiredLevel = 36,
        source = Q.Sources[118], -- Jarkal Mossmeld
    },
    {
        id = 2278,
        faction = nil,
        name = "The Platinum Discs",
        suggestedLevel = 42,
        requiredLevel = 40,
        source = Q.Sources[221], -- The Platinum Discs
        instances = { Q.Instances["Uldaman"] },
    },
    {
        id = 707,
        faction = "Alliance",
        name = "Ironband Wants You!",
        suggestedLevel = 37,
        requiredLevel = 30,
        source = Q.Sources[183], -- Prospector Ironband
    },
    {
        id = 704,
        faction = "Alliance",
        name = "Agmond's Fate",
        suggestedLevel = 38,
        requiredLevel = 30,
        prerequisites = {
            { id = 739, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[183], -- Prospector Ironband
        instances = { Q.Instances["Uldaman"] },
    },
    {
        id = 739,
        faction = "Alliance",
        name = "Murdaloc",
        suggestedLevel = 42,
        requiredLevel = 30,
        prerequisites = {
            { id = 738, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[26], -- Battered Dwarven Skeleton
    },
    {
        id = 738,
        faction = "Alliance",
        name = "Find Agmond",
        suggestedLevel = 38,
        requiredLevel = 30,
        prerequisites = {
            { id = 707, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[186], -- Prospector Stormpike
    },
    {
        id = 2283,
        faction = "Horde",
        name = "Necklace Recovery",
        suggestedLevel = 41,
        requiredLevel = 37,
        source = Q.Sources[205], -- Shattered Necklace
    },
    {
        id = 2284,
        faction = "Horde",
        name = "Necklace Recovery, Take 2",
        suggestedLevel = 41,
        requiredLevel = 37,
        prerequisites = {
            { id = 2283, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[70], -- Dran Droffers
    },
    {
        id = 2318,
        faction = "Horde",
        name = "Translating the Journal (1/2)",
        suggestedLevel = 42,
        requiredLevel = 37,
        prerequisites = {
            { id = 2284, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[191], -- Remains of a Paladin
    },
    {
        id = 2338,
        faction = "Horde",
        name = "Translating the Journal (2/2)",
        suggestedLevel = 42,
        requiredLevel = 37,
        prerequisites = {
            { id = 2318, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[118], -- Jarkal Mossmeld
    },
    {
        id = 709,
        faction = nil,
        name = "Solution to Doom",
        suggestedLevel = 40,
        requiredLevel = 30,
        source = Q.Sources[223], -- Theldurin the Lost
        instances = { Q.Instances["Uldaman"] },
    },
    --#endregion

    --#region Zul'Farrak
    {
        id = 2933,
        faction = "Horde",
        name = "Venom Bottles",
        suggestedLevel = 45,
        requiredLevel = 40,
        source = Q.Sources[245], -- Venom Bottle
    },
    {
        id = 2934,
        faction = "Horde",
        name = "Undamaged Venom Sac",
        suggestedLevel = 45,
        requiredLevel = 40,
        prerequisites = {
            { id = 2933, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[9], -- Apotechary Lydon
    },
    {
        id = 2935,
        faction = "Horde",
        name = "Consult Master Gadrin",
        suggestedLevel = 44,
        requiredLevel = 40,
        prerequisites = {
            { id = 2934, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[9], -- Apotechary Lydon
    },
    {
        id = 2936,
        faction = "Horde",
        name = "The Spider God",
        suggestedLevel = 44,
        requiredLevel = 40,
        prerequisites = {
            { id = 2935, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[154], -- Master Gadrin
        instances = { Q.Instances["Zul'Farrak"] },
    },
    {
        id = 3042,
        faction = nil,
        name = "Troll Temper",
        suggestedLevel = 45,
        requiredLevel = 40,
        source = Q.Sources[237], -- Trenton Lighthammer
        instances = { Q.Instances["Zul'Farrak"] },
    },
    {
        id = 2768,
        faction = nil,
        name = "Divino-matic Rod",
        suggestedLevel = 45,
        requiredLevel = 40,
        source = Q.Sources[46], -- Chief Engineer Bilgewhizzle
        instances = { Q.Instances["Zul'Farrak"] },
    },
    {
        id = 2864,
        faction = nil,
        name = "Tran'rek",
        suggestedLevel = 45,
        requiredLevel = 40,
        source = Q.Sources[130], -- Krazek
    },
    {
        id = 2865,
        faction = nil,
        name = "Scarab Shells",
        suggestedLevel = 45,
        requiredLevel = 40,
        prerequisites = {
            { id = 2864, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[235], -- Tran'rek
        instances = { Q.Instances["Zul'Farrak"] },
    },
    {
        id = 2861,
        faction = nil,
        name = "Tabetha's Task",
        suggestedLevel = 46,
        requiredLevel = 40,
        sources = {
            Q.Sources[263], -- Anastasia Hartwell
            Q.Sources[264], -- Bink
            Q.Sources[265], -- Jennea Cannon
            Q.Sources[266] -- Deino
        }
    },
    {
        id = 2846,
        faction = nil,
        name = "Tiara of the Deep",
        suggestedLevel = 45,
        requiredLevel = 40,
        prerequisites = {
            { id = 2861, type = Q.PrerequisiteType.BREADCRUMB }
        },
        source = Q.Sources[214], -- Tabetha
        instances = { Q.Instances["Zul'Farrak"] },
    },
     {
        id = 96770,
        faction = "Alliance",
        name = "The Witch Doctor's Head",
        suggestedLevel = 46,
        requiredLevel = 39,
        source = Q.Sources[289], -- Archmage Lan'dock
        instances = { Q.Instances["Zul'Farrak"] },
    },
    {
        id = 2770,
        faction = nil,
        name = "Gahz'rilla",
        suggestedLevel = 50,
        requiredLevel = 40,
        source = Q.Sources[256], -- Wizzle Brassbolts
        instances = { Q.Instances["Zul'Farrak"] },
    },

    {
        id = 2988,
        faction = "Alliance",
        name = "Witherbark Cages",
        suggestedLevel = 45,
        requiredLevel = 40,
        source = Q.Sources[100], -- Gryphon Master Talonaxe
    },
    {
        id = 2989,
        faction = "Alliance",
        name = "The Altar of Zul",
        suggestedLevel = 48,
        requiredLevel = 40,
        prerequisites = {
            { id = 2988, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[100], -- Gryphon Master Talonaxe
    },
    {
        id = 2990,
        faction = "Alliance",
        name = "Thadius Grimshade",
        suggestedLevel = 47,
        requiredLevel = 40,
        prerequisites = {
            { id = 2989, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[100], -- Gryphon Master Talonaxe
    },
    {
        id = 2991,
        faction = "Alliance",
        name = "Nekrum's Medallion",
        suggestedLevel = 47,
        requiredLevel = 40,
        prerequisites = {
            { id = 2990, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[220], -- Thadius Grimshade
        instances = { Q.Instances["Zul'Farrak"] },
    },
    {
        id = 3520,
        faction = nil,
        name = "Screecher Spirits",
        suggestedLevel = 42,
        requiredLevel = 40,
        source = Q.Sources[257], -- Yeh'kinya
    },
    {
        id = 3527,
        faction = nil,
        name = "The Prophecy of Mosh'aru",
        suggestedLevel = 47,
        requiredLevel = 40,
        prerequisites = {
            { id = 3520, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[257], -- Yeh'kinya
        instances = { Q.Instances["Zul'Farrak"] },
    },
    --#endregion

    --#region Maraudon
    {
        id = 7070,
        faction = "Alliance",
        name = "Shadowshard Fragments",
        suggestedLevel = 41,
        requiredLevel = 39,
        source = Q.Sources[14], -- Archmage Tervosh
        instances = { Q.Instances["Maraudon"] },
    },
    {
        id = 7068,
        faction = "Horde",
        name = "Shadowshard Fragments",
        suggestedLevel = 41,
        requiredLevel = 39,
        source = Q.Sources[241], -- Uthel'nay
        instances = { Q.Instances["Maraudon"] },
    },
    {
        id = 7028,
        faction = nil,
        name = "Twisted Evils",
        suggestedLevel = 45,
        requiredLevel = 41,
        source = Q.Sources[254], -- Willow
        instances = { Q.Instances["Maraudon"] },
    },
    {
        id = 7044,
        faction = nil,
        name = "Legends of Maraudon",
        suggestedLevel = 49,
        requiredLevel = 41,
        source = Q.Sources[42], -- Cavindra
    },
    {
        id = 7029,
        faction = "Horde",
        name = "Vyletongue Corruption",
        suggestedLevel = 47,
        requiredLevel = 41,
        source = Q.Sources[243], -- Vark Battlescar
        instances = { Q.Instances["Maraudon"] },
    },
    {
        id = 7041,
        faction = "Alliance",
        name = "Vyletongue Corruption",
        suggestedLevel = 47,
        requiredLevel = 41,
        source = Q.Sources[216], -- Talendria
        instances = { Q.Instances["Maraudon"] },
    },
    {
        id = 7064,
        faction = "Horde",
        name = "Corruption of Earth and Seed",
        suggestedLevel = 51,
        requiredLevel = 45,
        source = Q.Sources[203], -- Selendra
        instances = { Q.Instances["Maraudon"] },
    },
    {
        id = 7065,
        faction = "Alliance",
        name = "Corruption of Earth and Seed",
        suggestedLevel = 51,
        requiredLevel = 45,
        source = Q.Sources[123], -- Keeper Marandis
        instances = { Q.Instances["Maraudon"] },
    },
    {
        id = 7046,
        faction = nil,
        name = "The Scepter of Celebras",
        suggestedLevel = 49,
        requiredLevel = 41,
        prerequisites = {
            { id = 7044, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[43], -- Celebras the Redeemed
        instances = { Q.Instances["Maraudon"] },
    },
    {
        id = 7066,
        faction = nil,
        name = "Seed of Life",
        suggestedLevel = 51,
        requiredLevel = 39,
        source = Q.Sources[261], -- Zaetar's Spirit
        instances = { Q.Instances["Maraudon"] },
    },
    {
        id = 7067,
        faction = nil,
        name = "The Pariah's Instructions",
        suggestedLevel = 48,
        requiredLevel = 39,
        source = Q.Sources[44], -- Centaur Pariah
        instances = { Q.Instances["Maraudon"] },
    },
    --#endregion

    --#region Temple of Atal'Hakkar
    {
        id = 1424,
        faction = "Horde",
        name = "Pool of Tears",
        suggestedLevel = 43,
        requiredLevel = 38,
        source = Q.Sources[82], -- Fel'zerul
    },
    {
        id = 1429,
        faction = "Horde",
        name = "The Atal'ai Exile",
        suggestedLevel = 44,
        requiredLevel = 38,
        prerequisites = {
            { id = 1424, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[82], -- Fel'zerul
    },
    {
        id = 1444,
        faction = "Horde",
        name = "Return to Fel'Zerul",
        suggestedLevel = 44,
        requiredLevel = 38,
        prerequisites = {
            { id = 1429, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[19], -- Atal'ai Exile
    },
    {
        id = 1445,
        faction = "Horde",
        name = "The Temple of Atal'Hakkar",
        suggestedLevel = 50,
        requiredLevel = 38,
        prerequisites = {
            { id = 1444, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[82], -- Fel'zerul
        instances = { Q.Instances["Temple of Atal'Hakkar"] },
    },
    {
        id = 4143,
        faction = "Alliance",
        name = "Haze of Evil",
        suggestedLevel = 52,
        requiredLevel = 47,
        prerequisites = {
            { id = 4142, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[96], -- Gregan Brewspewer
        instances = { Q.Instances["Temple of Atal'Hakkar"] },
    },
    {
        id = 1448,
        faction = "Alliance",
        name = "In Search of The Temple",
        suggestedLevel = 43,
        requiredLevel = 38,
        source = Q.Sources[35], -- Brohann Caskbelly
    },
    {
        id = 4145,
        faction = "Horde",
        name = "Larion and Muigin",
        suggestedLevel = 52,
        requiredLevel = 47,
        source = Q.Sources[132], -- Larion
    },
    {
        id = 4147,
        faction = "Horde",
        name = "Marvon's Workshop",
        suggestedLevel = 52,
        requiredLevel = 47,
        prerequisites = {
            { id = 4145, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[132], -- Larion
    },
    {
        id = 4146,
        faction = "Horde",
        name = "Zapper Fuel",
        suggestedLevel = 52,
        requiredLevel = 47,
        prerequisites = {
            { id = 4147, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[137], -- Liv Rizzlefix
        instances = { Q.Instances["Temple of Atal'Hakkar"] },
    },
    {
        id = 4141,
        faction = "Alliance",
        name = "Muigin and Larion",
        suggestedLevel = 52,
        requiredLevel = 47,
        source = Q.Sources[168], -- Muigin
    },
    {
        id = 4142,
        faction = "Alliance",
        name = "A Visit to Gregan",
        suggestedLevel = 52,
        requiredLevel = 47,
        prerequisites = {
            { id = 4141, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[168], -- Muigin
    },
    {
        id = 1449,
        faction = "Alliance",
        name = "To The Hinterlands",
        suggestedLevel = 43,
        requiredLevel = 38,
        prerequisites = {
            { id = 1448, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[35], -- Brohann Caskbelly
    },
    {
        id = 1450,
        faction = "Alliance",
        name = "Gryphon Master Talonaxe",
        suggestedLevel = 43,
        requiredLevel = 38,
        prerequisites = {
            { id = 1449, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[81], -- Falstad Wildhammer
    },
    {
        id = 1451,
        faction = "Alliance",
        name = "Rhapsody Shindigger",
        suggestedLevel = 43,
        requiredLevel = 38,
        prerequisites = {
            { id = 1450, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[100], -- Gryphon Master Talonaxe
    },
    {
        id = 1452,
        faction = "Alliance",
        name = "Rhapsody's Kalimdor Kocktail",
        suggestedLevel = 43,
        requiredLevel = 38,
        prerequisites = {
            { id = 1451, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[194], -- Rhapsody Shindigger
    },
    {
        id = 1469,
        faction = "Alliance",
        name = "Rhapsody's Tale",
        suggestedLevel = 43,
        requiredLevel = 38,
        prerequisites = {
            { id = 1452, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[194], -- Rhapsody Shindigger
    },
    {
        id = 1475,
        faction = "Alliance",
        name = "Into The Temple of Atal'Hakkar",
        suggestedLevel = 50,
        requiredLevel = 38,
        prerequisites = {
            { id = 1469, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[35], -- Brohann Caskbelly
        instances = { Q.Instances["Temple of Atal'Hakkar"] },
    },
    {
        id = 3373,
        faction = nil,
        name = "The Essence of Eranikus",
        suggestedLevel = 52,
        requiredLevel = 48,
        source = Q.Sources[78], -- Essence of Eranikus
        instances = { Q.Instances["Temple of Atal'Hakkar"] },
    },
    {
        id = 3528,
        faction = nil,
        name = "The God Hakkar",
        suggestedLevel = 50,
        requiredLevel = 40,
        prerequisites = {
            { id = 4787, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[257], -- Yeh'kinya
        instances = { Q.Instances["Temple of Atal'Hakkar"] },
    },
    {
        id = 4787,
        faction = nil,
        name = "The Ancient Egg",
        suggestedLevel = 50,
        requiredLevel = 40,
        prerequisites = {
            { id = 3527, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[257], -- Yeh'kinya
    },
    {
        id = 1446,
        faction = nil,
        name = "Jammal'an the Prophet",
        suggestedLevel = 53,
        requiredLevel = 38,
        source = Q.Sources[19], -- Atal'ai Exile
        instances = { Q.Instances["Temple of Atal'Hakkar"] },
    },
    {
        id = 3380,
        faction = "Horde",
        name = "The Sunken Temple",
        suggestedLevel = 51,
        requiredLevel = 46,
        source = Q.Sources[255], -- Witch Doctor Uzer'i
    },
    {
        id = 3445,
        faction = "Alliance",
        name = "The Sunken Temple",
        suggestedLevel = 51,
        requiredLevel = 46,
        source = Q.Sources[8], -- Angelas Moonbreeze
    },
    {
        id = 3444,
        faction = nil,
        name = "The Stone Circle",
        suggestedLevel = 51,
        requiredLevel = 46,
        prerequisites = {
            { id = 3380, type = Q.PrerequisiteType.REQUIRED },
            { id = 3445, type = Q.PrerequisiteType.REQUIRED },
        },
        source = Q.Sources[152], -- Marvon Rivetseeker
    },
    {
        id = 3446,
        faction = nil,
        name = "Into the Depths",
        suggestedLevel = 51,
        requiredLevel = 46,
        prerequisites = {
            { id = 3444, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[152], -- Marvon Rivetseeker
        instances = { Q.Instances["Temple of Atal'Hakkar"] },
    },
    {
        id = 3447,
        faction = nil,
        name = "Secret of the Circle",
        suggestedLevel = 51,
        requiredLevel = 46,
        prerequisites = {
            { id = 3444, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[152], -- Marvon Rivetseeker
        instances = { Q.Instances["Temple of Atal'Hakkar"] },
    },
    --#endregion

    --#region Blackrock Depths
    {
        id = 3981,
        faction = "Horde",
        name = "Commander Gor'shak",
        suggestedLevel = 52,
        requiredLevel = 48,
        prerequisites = {
            { id = 3906, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[85], -- Galamav the Marksman
    },
    {
        id = 3982,
        faction = "Horde",
        name = "What Is Going On? (1/2)",
        suggestedLevel = 54,
        requiredLevel = 48,
        prerequisites = {
            { id = 3981, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[47], -- Commander Gor'shak
    },
    {
        id = 4001,
        faction = "Horde",
        name = "What Is Going On? (2/2)",
        suggestedLevel = 54,
        requiredLevel = 48,
        prerequisites = {
            { id = 3982, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[47], -- Commander Gor'shak
    },
    {
        id = 4002,
        faction = "Horde",
        name = "The Eastern Kingdoms",
        suggestedLevel = 54,
        requiredLevel = 48,
        prerequisites = {
            { id = 4001, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[226], -- Thrall
    },
    {
        id = 4003,
        faction = "Horde",
        name = "The Royal Rescue",
        suggestedLevel = 59,
        requiredLevel = 48,
        prerequisites = {
            { id = 4002, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[226], -- Thrall
        instances = { Q.Instances["Blackrock Depths"] }
    },
    {
        id = 4061,
        faction = "Horde",
        name = "The Rise of the Machines (1/3)",
        suggestedLevel = 54,
        requiredLevel = 52,
        source = Q.Sources[108], -- Hierophant Theodora Mulvadania
    },
    {
        id = 4062,
        faction = "Horde",
        name = "The Rise of the Machines (2/3)",
        suggestedLevel = 54,
        requiredLevel = 52,
        prerequisites = {
            { id = 4061, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[108], -- Hierophant Theodora Mulvadania
    },
    {
        id = 4063,
        faction = "Horde",
        name = "The Rise of the Machines (3/3)",
        suggestedLevel = 58,
        requiredLevel = 52,
        prerequisites = {
            { id = 4062, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[144], -- Lotwil Veriatus
        instances = { Q.Instances["Blackrock Depths"] }
    },
    {
        id = 4122,
        faction = "Horde",
        name = "Grark Lorkrub",
        suggestedLevel = 58,
        requiredLevel = 52,
        prerequisites = {
            { id = 4082, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[135], -- Lexlort
    },
    {
        id = 4121,
        faction = "Horde",
        name = "Precarious Predicament",
        suggestedLevel = 58,
        requiredLevel = 52,
        prerequisites = {
            { id = 4122, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[95], -- Grark Lorkrub
    },
    {
        id = 4132,
        faction = "Horde",
        name = "Operation: Death to Angerforge",
        suggestedLevel = 58,
        requiredLevel = 52,
        prerequisites = {
            { id = 4121, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[249], -- Warlord Goretooth
        instances = { Q.Instances["Blackrock Depths"] }
    },
    {
        id = 4081,
        faction = "Horde",
        name = "KILL ON SIGHT: Dark Iron Dwarves",
        suggestedLevel = 52,
        requiredLevel = 48,
        source = Q.Sources[247], -- WANTED
    },
    {
        id = 4082,
        faction = "Horde",
        name = "KILL ON SIGHT: High Ranking Dark Iron Officials",
        suggestedLevel = 54,
        requiredLevel = 50,
        prerequisites = {
            { id = 4081, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[247], -- WANTED
    },
    {
        id = 3441,
        faction = nil,
        name = "Divine Retribution",
        suggestedLevel = 48,
        requiredLevel = 40,
        source = Q.Sources[244], -- Velarok Windblade
    },
    {
        id = 3442,
        faction = nil,
        name = "The Flawless Flame",
        suggestedLevel = 48,
        requiredLevel = 40,
        prerequisites = {
            { id = 3441, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[244], -- Velarok Windblade
    },
    {
        id = 3443,
        faction = nil,
        name = "Forging the Shaft",
        suggestedLevel = 48,
        requiredLevel = 40,
        prerequisites = {
            { id = 3442, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[244], -- Velarok Windblade
    },
    {
        id = 3452,
        faction = nil,
        name = "The Flame's Casing",
        suggestedLevel = 50,
        requiredLevel = 40,
        prerequisites = {
            { id = 3443, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[244], -- Velarok Windblade
    },
    {
        id = 3453,
        faction = nil,
        name = "The Torch of Retribution (1/2)",
        suggestedLevel = 50,
        requiredLevel = 40,
        prerequisites = {
            { id = 3452, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[244], -- Velarok Windblade
    },
    {
        id = 3454,
        faction = nil,
        name = "The Torch of Retribution (2/2)",
        suggestedLevel = 50,
        requiredLevel = 40,
        prerequisites = {
            { id = 3453, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[244], -- Velarok Windblade
    },
    {
        id = 3462,
        faction = nil,
        name = "Squire Maltrake",
        suggestedLevel = 50,
        requiredLevel = 40,
        prerequisites = {
            { id = 3454, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[244], -- Velarok Windblade
    },
    {
        id = 3463,
        faction = nil,
        name = "Set Them Ablaze!",
        suggestedLevel = 50,
        requiredLevel = 40,
        prerequisites = {
            { id = 3462, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[212], -- Squire Maltrake
    },
    {
        id = 3481,
        faction = nil,
        name = "Trinkets...",
        suggestedLevel = 50,
        requiredLevel = 40,
        prerequisites = {
            { id = 3463, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[114], -- Hoard of the Black Dragonflight
    },
    {
        id = 4022,
        faction = nil,
        name = "A Taste of Flame",
        suggestedLevel = 58,
        requiredLevel = 52,
        prerequisites = {
            { id = 3481, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[54], -- Cyrus Therepentous
    },
    {
        id = 4023,
        faction = nil,
        name = "A Taste of Flame",
        suggestedLevel = 58,
        requiredLevel = 52,
        prerequisites = {
            { id = 3481, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[54], -- Cyrus Therepentous
    },
    {
        id = 4024,
        faction = nil,
        name = "A Taste of Flame",
        suggestedLevel = 58,
        requiredLevel = 52,
        prerequisites = {
            { id = 4023, type = Q.PrerequisiteType.ANY },
            { id = 4022, type = Q.PrerequisiteType.ANY },
        },
        source = Q.Sources[54], -- Cyrus Therepentous
        instances = { Q.Instances["Blackrock Depths"] }
    },
    {
        id = 4262,
        faction = "Alliance",
        name = "Overmaster Pyron",
        suggestedLevel = 56,
        requiredLevel = 48,
        source = Q.Sources[116], -- Jalinda Sprig
    },
    {
        id = 4263,
        faction = "Alliance",
        name = "Incendius!",
        suggestedLevel = 56,
        requiredLevel = 48,
        prerequisites = {
            { id = 4262, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[116], -- Jalinda Sprig
        instances = { Q.Instances["Blackrock Depths"] }
    },
    {
        id = 3906,
        faction = "Horde",
        name = "Disharmony of Flame",
        suggestedLevel = 52,
        requiredLevel = 48,
        source = Q.Sources[228], -- Thunderheart
    },
    {
        id = 3907,
        faction = "Horde",
        name = "Disharmony of Fire",
        suggestedLevel = 56,
        requiredLevel = 48,
        prerequisites = {
            { id = 3906, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[228], -- Thunderheart
        instances = { Q.Instances["Blackrock Depths"] }
    },
    {
        id = 7201,
        faction = "Horde",
        name = "The Last Element",
        suggestedLevel = 54,
        requiredLevel = 48,
        prerequisites = {
            { id = 3906, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[204], -- Shadowmage Vivian Lagrave
        instances = { Q.Instances["Blackrock Depths"] }
    },
    {
        id = 4134,
        faction = "Horde",
        name = "Lost Thunderbrew Recipe",
        suggestedLevel = 55,
        requiredLevel = 50,
        source = Q.Sources[204], -- Shadowmage Vivian Lagrave
        instances = { Q.Instances["Blackrock Depths"] }
    },
    {
        id = 4123,
        faction = nil,
        name = "The Heart of the Mountain",
        suggestedLevel = 55,
        requiredLevel = 50,
        source = Q.Sources[158], -- Maxwort Uberglint
        instances = { Q.Instances["Blackrock Depths"] }
    },
    {
        id = 7848,
        faction = nil,
        name = "Attunement to the Core",
        suggestedLevel = 55,
        requiredLevel = 55,
        source = Q.Sources[143], -- Lothos Riftwaker
        instances = { Q.Instances["Blackrock Depths"] }
    },
    {
        id = 3702,
        faction = "Alliance",
        name = "The Smoldering Ruins of Thaurissan (1/2)",
        suggestedLevel = 54,
        requiredLevel = 50,
        source = Q.Sources[196], -- Royal Historian Archenosus
    },
    {
        id = 3701,
        faction = "Alliance",
        name = "The Smoldering Ruins of Thaurissan (2/2)",
        suggestedLevel = 54,
        requiredLevel = 50,
        prerequisites = {
            { id = 3702, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[196], -- Royal Historian Archenosus
    },
    {
        id = 4341,
        faction = "Alliance",
        name = "Kharan Mighthammer",
        suggestedLevel = 55,
        requiredLevel = 50,
        prerequisites = {
            { id = 3701, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[127], -- King Magni Bronzebeard
    },
    {
        id = 4342,
        faction = "Alliance",
        name = "Kharan's Tale",
        suggestedLevel = 59,
        requiredLevel = 50,
        prerequisites = {
            { id = 4341, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[125], -- Kharan Mighthammer
    },
    {
        id = 4361,
        faction = "Alliance",
        name = "The Bearer of Bad News",
        suggestedLevel = 59,
        requiredLevel = 50,
        prerequisites = {
            { id = 4342, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[125], -- Kharan Mighthammer
    },
    {
        id = 4362,
        faction = "Alliance",
        name = "The Fate of the Kingdom",
        suggestedLevel = 59,
        requiredLevel = 50,
        prerequisites = {
            { id = 4361, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[127], -- King Magni Bronzebeard
    },
    {
        id = 4363,
        faction = "Alliance",
        name = "The Princess's Surprise",
        suggestedLevel = 59,
        requiredLevel = 50,
        prerequisites = {
            { id = 4362, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[182], -- Princess Moira Bronzebeard
        instances = { Q.Instances["Blackrock Depths"] }
    },
    {
        id = 4324,
        faction = nil,
        name = "Yuka Screwspigot",
        suggestedLevel = 53,
        requiredLevel = 48,
        source = Q.Sources[258], -- Yorba Screwspigot
    },
    {
        id = 4136,
        faction = nil,
        name = "Ribbly Screwspigot",
        suggestedLevel = 53,
        requiredLevel = 48,
        prerequisites = {
            { id = 4324, type = Q.PrerequisiteType.BREADCRUMB }
        },
        source = Q.Sources[260], -- Yuka Screwspigot
        instances = { Q.Instances["Blackrock Depths"] }
    },
    {
        id = 4286,
        faction = "Alliance",
        name = "The Good Stuff",
        suggestedLevel = 56,
        requiredLevel = 50,
        source = Q.Sources[177], -- Oralius
        instances = { Q.Instances["Blackrock Depths"] }
    },
    {
        id = 4126,
        faction = "Alliance",
        name = "Hurley Blackbreath",
        suggestedLevel = 55,
        requiredLevel = 50,
        source = Q.Sources[188], -- Ragnar Thunderbrew
        instances = { Q.Instances["Blackrock Depths"] }
    },
    {
        id = 3801,
        faction = nil,
        name = "Dark Iron Legacy (1/2)",
        suggestedLevel = 52,
        requiredLevel = 48,
        source = Q.Sources[83], -- Franclorn Forgewright
    },
    {
        id = 3802,
        faction = nil,
        name = "Dark Iron Legacy (2/2)",
        suggestedLevel = 52,
        requiredLevel = 48,
        prerequisites = {
            { id = 3801, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[83], -- Franclorn Forgewright
        instances = { Q.Instances["Blackrock Depths"] }
    },
    {
        id = 5201,
        faction = nil,
        name = "The Love Potion",
        suggestedLevel = 54,
        requiredLevel = 50,
        source = Q.Sources[164], -- Mistress Nagmara
        instances = { Q.Instances["Blackrock Depths"] }
    },
    --#endregion

    --#region Dire Maul: West
    {
        id = 7507,
        faction = nil,
        classes = { "PALADIN", "WARRIOR" },
        name = "Nostro's Compendium",
        suggestedLevel = 60,
        requiredLevel = 60,
        source = Q.Sources[176], -- Nostro's Compendium of Dragon Slaying
        instances = { Q.Instances["Dire Maul: West"] }
    },
    {
        id = 7509,
        faction = nil,
        classes = { "PALADIN", "WARRIOR" },
        name = "The Forging of Quel'Serrar",
        suggestedLevel = 60,
        requiredLevel = 60,
        prerequisites = {
            { id = 7507, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[142], -- Lorekeeper Lydros
        instances = { Q.Instances["Dire Maul: North"] }
    },
    {
        id = 7461,
        faction = nil,
        name = "The Madness Within",
        suggestedLevel = 58,
        requiredLevel = 56,
        source = Q.Sources[206], -- Shen'dralar Ancient
        instances = { Q.Instances["Dire Maul: West"] }
    },
    {
        id = 7877,
        faction = nil,
        name = "The Treasure of the Shen'dralar",
        suggestedLevel = 58,
        requiredLevel = 56,
        prerequisites = {
            { id = 7461, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[206], -- Shen'dralar Ancient
        instances = { Q.Instances["Dire Maul: West"] }
    },
    {
        id = 5527,
        faction = nil,
        name = "A Reliquary of Purity",
        suggestedLevel = 60,
        requiredLevel = 56,
        source = Q.Sources[187], -- Rabine Saturna
    },
    {
        id = 5526,
        faction = nil,
        name = "Shards of the Felvine",
        suggestedLevel = 60,
        requiredLevel = 56,
        prerequisites = {
            { id = 5527, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[187], -- Rabine Saturna
        instances = { Q.Instances["Dire Maul: East"] }
    },
    --#endregion

    --#region Dire Maul: East
    {
        id = 7488,
        faction = "Alliance",
        name = "Lethtendris's Web",
        suggestedLevel = 56,
        requiredLevel = 54,
        source = Q.Sources[133], -- Latronicus Moonspear
        instances = { Q.Instances["Dire Maul: East"] }
    },
    {
        id = 7489,
        faction = "Horde",
        name = "Lethtendris's Web",
        suggestedLevel = 56,
        requiredLevel = 54,
        source = Q.Sources[217], -- Talo Thornhoof
        instances = { Q.Instances["Dire Maul: East"] }
    },
    {
        id = 7441,
        faction = nil,
        name = "Pusillin and the Elder Azj'Tordin",
        suggestedLevel = 56,
        requiredLevel = 54,
        source = Q.Sources[23], -- Azj'Tordin
        instances = { Q.Instances["Dire Maul: East"] }
    },
    --#endregion

    --#region Dire Maul: North
    {
        id = 5525,
        faction = nil,
        name = "Free Knot!",
        suggestedLevel = 60,
        requiredLevel = 56,
        source = Q.Sources[129], -- Knot Thimblejack
        instances = { Q.Instances["Dire Maul: North"] }
    },
    {
        id = 5518,
        faction = nil,
        name = "The Gordok Ogre Suit",
        suggestedLevel = 60,
        requiredLevel = 56,
        source = Q.Sources[129], -- Knot Thimblejack
        instances = { Q.Instances["Dire Maul: North"] }
    },
    {
        id = 7703,
        faction = nil,
        name = "Unfinished Gordok Business",
        suggestedLevel = 60,
        requiredLevel = 56,
        source = Q.Sources[39], -- Captain Kromcrush
        instances = { Q.Instances["Dire Maul: North"] }
    },
    {
        id = 7481,
        faction = "Horde",
        name = "Elven Legends",
        suggestedLevel = 56,
        requiredLevel = 54,
        source = Q.Sources[198], -- Sage Korolusk
        instances = { Q.Instances["Dire Maul: North"] }
    },
    {
        id = 7482,
        faction = "Alliance",
        name = "Elven Legends",
        suggestedLevel = 56,
        requiredLevel = 54,
        source = Q.Sources[198], -- Sage Korolusk
        instances = { Q.Instances["Dire Maul: North"] }
    },
    --#endregion

    --#region Lower Blackrock Spire
    {
        id = 5065,
        faction = nil,
        name = "The Lost Tablets of Mosh'aru",
        suggestedLevel = 58,
        requiredLevel = 40,
        prerequisites = {
            { id = 3528, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[184], -- Prospector Ironboot
    },
    {
        id = 4788,
        faction = nil,
        name = "The Final Tablets",
        suggestedLevel = 58,
        requiredLevel = 40,
        prerequisites = {
            { id = 5065, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[184], -- Prospector Ironboot
        instances = { Q.Instances["Lower Blackrock Spire"] }
    },
    {
        id = 5001,
        faction = "Alliance",
        name = "Bijou's Belongings",
        suggestedLevel = 59,
        requiredLevel = 55,
        source = Q.Sources[29], -- Bijou
    },
    {
        id = 5002,
        faction = "Alliance",
        name = "Message to Maxwell",
        suggestedLevel = 59,
        requiredLevel = 55,
        prerequisites = {
            { id = 5001, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[29], -- Bijou
    },
    {
        id = 5081,
        faction = "Alliance",
        name = "Maxwell's Mission",
        suggestedLevel = 60,
        requiredLevel = 55,
        prerequisites = {
            { id = 5002, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[150], -- Marshal Maxwell
        instances = { Q.Instances["Lower Blackrock Spire"] }
    },
    {
        id = 5089,
        faction = "Alliance",
        name = "General Drakkisath's Command",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = Q.Sources[87], -- General Drakkisath's Command
        instances = { Q.Instances["Lower Blackrock Spire"] }
    },
    {
        id = 4862,
        faction = nil,
        name = "En-Ay-Es-Tee-Why",
        suggestedLevel = 59,
        requiredLevel = 55,
        source = Q.Sources[126], -- Kibler
        instances = { Q.Instances["Lower Blackrock Spire"] }
    },
    {
        id = 4724,
        faction = "Horde",
        name = "The Pack Mistress",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = Q.Sources[85], -- Galamav the Marksman
        instances = { Q.Instances["Lower Blackrock Spire"] }
    },
    {
        id = 4701,
        faction = "Alliance",
        name = "Put Her Down",
        suggestedLevel = 59,
        requiredLevel = 55,
        source = Q.Sources[106], -- Helendis Riverhorn
        instances = { Q.Instances["Lower Blackrock Spire"] }
    },
    {
        id = 4981,
        faction = "Horde",
        name = "Operative Bijou",
        suggestedLevel = 59,
        requiredLevel = 55,
        source = Q.Sources[135], -- Lexlort
    },
    {
        id = 4982,
        faction = "Horde",
        name = "Bijou's Belongings",
        suggestedLevel = 59,
        requiredLevel = 55,
        prerequisites = {
            { id = 4981, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[29], -- Bijou
        instances = { Q.Instances["Lower Blackrock Spire"] }
    },
    {
        id = 4903,
        faction = "Horde",
        name = "Warlord's Command",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = Q.Sources[249], -- Warlord Goretooth
        instances = { Q.Instances["Lower Blackrock Spire"] }
    },
    {
        id = 4729,
        faction = nil,
        name = "Kibler's Exotic Pets",
        suggestedLevel = 59,
        requiredLevel = 55,
        source = Q.Sources[126], -- Kibler
        instances = { Q.Instances["Lower Blackrock Spire"] }
    },
    {
        id = 4742,
        faction = nil,
        name = "Seal of Ascension",
        suggestedLevel = 60,
        requiredLevel = 57,
        source = Q.Sources[239], -- Unadorned Seal of Ascension
        instances = { Q.Instances["Lower Blackrock Spire"] }
    },
    --#endregion

    --#region Scholomance
    {
        id = 5582,
        faction = nil,
        name = "Healthy Dragon Scale",
        suggestedLevel = 60,
        requiredLevel = 52,
        source = Q.Sources[105], -- Healthy Dragon Scale
        instances = { Q.Instances["Scholomance"] }
    },
    {
        id = 5341,
        faction = "Horde",
        name = "Barov Family Fortune",
        suggestedLevel = 60,
        requiredLevel = 52,
        source = Q.Sources[4], -- Alexi Barov
        instances = { Q.Instances["Scholomance"] }
    },
    {
        id = 5343,
        faction = "Alliance",
        name = "Barov Family Fortune",
        suggestedLevel = 60,
        requiredLevel = 52,
        source = Q.Sources[250], -- Weldon Barov
        instances = { Q.Instances["Scholomance"] }
    },
    {
        id = 5382,
        faction = nil,
        name = "Doctor Theolen Krastinov, the Butcher",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = Q.Sources[79], -- Eva Sarkhoff
    },
    {
        id = 5515,
        faction = nil,
        name = "Krastinov's Bag of Horrors",
        suggestedLevel = 60,
        requiredLevel = 55,
        prerequisites = {
            { id = 5382, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[79], -- Eva Sarkhoff
    },
    {
        id = 5384,
        faction = nil,
        name = "Kirtonos the Herald",
        suggestedLevel = 60,
        requiredLevel = 55,
        prerequisites = {
            { id = 5515, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[79], -- Eva Sarkhoff
        instances = { Q.Instances["Scholomance"] }
    },
    {
        id = 5461,
        faction = nil,
        name = "The Human, Ras Frostwhisper",
        suggestedLevel = 60,
        requiredLevel = 57,
        prerequisites = {
            { id = 5384, type = Q.PrerequisiteType.REQUIRED }
        },
        source = Q.Sources[146], -- Magistrate Marduke
    },
    {
        id = 5462,
        faction = nil,
        name = "The Dying, Ras Frostwhisper",
        suggestedLevel = 60,
        requiredLevel = 57,
        prerequisites = {
            { id = 5461, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[146], -- Magistrate Marduke
    },
    {
        id = 5529,
        faction = nil,
        name = "Plagued Hatchlings",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = Q.Sources[28], -- Betina Bigglezink
        instances = { Q.Instances["Scholomance"] }
    },
    {
        id = 5466,
        faction = nil,
        name = "The Lich, Ras Frostwhisper",
        suggestedLevel = 60,
        requiredLevel = 57,
        prerequisites = {
            { id = 5465, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[146], -- Magistrate Marduke
        instances = { Q.Instances["Scholomance"] }
    },
    --#endregion

    --#region Stratholme
    {
        id = 5742,
        faction = nil,
        name = "Redemption",
        suggestedLevel = 56,
        requiredLevel = 52,
        source = Q.Sources[230], -- Tirion Fordring
    },
    {
        id = 5781,
        faction = nil,
        name = "Of Forgotten Memories",
        suggestedLevel = 57,
        requiredLevel = 52,
        prerequisites = {
            { id = 5742, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[230], -- Tirion Fordring
    },
    {
        id = 5845,
        faction = nil,
        name = "Of Lost Honor",
        suggestedLevel = 58,
        requiredLevel = 52,
        prerequisites = {
            { id = 5781, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[230], -- Tirion Fordring
    },
    {
        id = 5846,
        faction = nil,
        name = "Of Love and Family (1/2)",
        suggestedLevel = 57,
        requiredLevel = 52,
        prerequisites = {
            { id = 5845, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[230], -- Tirion Fordring
    },
    {
        id = 5848,
        faction = nil,
        name = "Of Love and Family (2/2)",
        suggestedLevel = 57,
        requiredLevel = 52,
        prerequisites = {
            { id = 5846, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[18], -- Artist Renfray
        instances = { Q.Instances["Stratholme"] }
    },
    {
        id = 5214,
        faction = nil,
        name = "The Great Ezra Grimm",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = Q.Sources[210], -- Smokey LaRue
        instances = { Q.Instances["Stratholme"] }
    },
    {
        id = 5212,
        faction = nil,
        name = "The Flesh Does Not Lie",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = Q.Sources[28], -- Betina Bigglezink
        instances = { Q.Instances["Stratholme"] }
    },
    {
        id = 5251,
        faction = nil,
        name = "The Archivist",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = Q.Sources[72], -- Duke Nicholas Zverenhoff
    },
    {
        id = 5281,
        faction = nil,
        name = "The Restless Souls (1/2)",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = Q.Sources[41], -- Caretaker Alen
    },
    {
        id = 5282,
        faction = nil,
        name = "The Restless Souls (2/2)",
        suggestedLevel = 60,
        requiredLevel = 55,
        prerequisites = {
            { id = 5281, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[76], -- Egan
        instances = { Q.Instances["Stratholme"] }
    },
    {
        id = 5122,
        faction = nil,
        name = "The Medallion of Faith",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = Q.Sources[21], -- Aurius
        instances = { Q.Instances["Stratholme"] }
    },
    {
        id = 5243,
        faction = nil,
        name = "Houses of the Holy",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = Q.Sources[134], -- Leonid Barthalomew the Revered
        instances = { Q.Instances["Stratholme"] }
    },
    {
        id = 5262,
        faction = nil,
        name = "The Truth Comes Crashing Down",
        suggestedLevel = 60,
        requiredLevel = 55,
        prerequisites = {
            { id = 5251, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[104], -- Head of Balnazzar
    },
    {
        id = 5263,
        faction = nil,
        name = "Above and Beyond",
        suggestedLevel = 60,
        requiredLevel = 55,
        prerequisites = {
            { id = 5262, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[72], -- Duke Nicholas Zverenhoff
        instances = { Q.Instances["Stratholme"] }
    },
    {
        id = 6133,
        faction = "Horde",
        name = "The Ranger Lord's Behest",
        suggestedLevel = 60,
        requiredLevel = 54,
        source = Q.Sources[172], -- Nathanos Blightcaller
    },
    {
        id = 6135,
        faction = "Horde",
        name = "Duskwing, Oh How I Hate Thee...",
        suggestedLevel = 60,
        requiredLevel = 56,
        prerequisites = {
            { id = 6133, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[172], -- Nathanos Blightcaller
    },
    {
        id = 6163,
        faction = "Horde",
        name = "Ramstein",
        suggestedLevel = 60,
        requiredLevel = 56,
        prerequisites = {
            { id = 6135, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[172], -- Nathanos Blightcaller
        instances = { Q.Instances["Stratholme"] }
    },
    {
        id = 5463,
        faction = nil,
        name = "Menethil's Gift (1/2)",
        suggestedLevel = 60,
        requiredLevel = 57,
        prerequisites = {
            { id = 5462, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[134], -- Leonid Barthalomew the Revered
    },
    {
        id = 5464,
        faction = nil,
        name = "Menethil's Gift (2/2)",
        suggestedLevel = 60,
        requiredLevel = 57,
        prerequisites = {
            { id = 5463, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[163], -- Menethil's Gift
        instances = { Q.Instances["Stratholme"] }
    },
    {
        id = 5465,
        faction = nil,
        name = "Soulbound Keepsake",
        suggestedLevel = 60,
        requiredLevel = 57,
        prerequisites = {
            { id = 5464, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[134], -- Leonid Barthalomew the Revered
    },
    --#endregion

    --#region Upper Blackrock Spire
    {
        id = 4941,
        faction = "Horde",
        name = "Eitrigg's Wisdom",
        suggestedLevel = 60,
        requiredLevel = 55,
        prerequisites = {
            { id = 4903, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[249], -- Warlord Goretooth
    },
    {
        id = 4974,
        faction = "Horde",
        name = "For The Horde!",
        suggestedLevel = 60,
        requiredLevel = 55,
        prerequisites = {
            { id = 4941, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[226], -- Thrall
        instances = { Q.Instances["Upper Blackrock Spire"] }
    },
    {
        id = 5102,
        faction = "Alliance",
        name = "General Drakkisath's Demise",
        suggestedLevel = 60,
        requiredLevel = 55,
        prerequisites = {
            { id = 5089, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[151], -- Marshall Maxwell
        instances = { Q.Instances["Upper Blackrock Spire"] }
    },
    {
        id = 6805,
        faction = nil,
        name = "Stormers and Rumblers",
        suggestedLevel = 57,
        requiredLevel = 55,
        source = Q.Sources[71], -- Duke Hydraxis
    },
    {
        id = 6804,
        faction = nil,
        name = "Poisoned Water",
        suggestedLevel = 56,
        requiredLevel = 55,
        source = Q.Sources[71], -- Duke Hydraxis
    },
    {
        id = 6821,
        faction = nil,
        name = "Eye of the Emberseer",
        suggestedLevel = 60,
        requiredLevel = 55,
        prerequisites = {
            { id = 6804, type = Q.PrerequisiteType.REQUIRED },
            { id = 6805, type = Q.PrerequisiteType.REQUIRED }
        },
        source = Q.Sources[71], -- Duke Hydraxis
        instances = { Q.Instances["Upper Blackrock Spire"] }
    },
    {
        id = 5160,
        faction = nil,
        name = "The Matron Protectorate",
        suggestedLevel = 60,
        requiredLevel = 57,
        source = Q.Sources[22], -- Awbee
        instances = { Q.Instances["Upper Blackrock Spire"] }
    },
    {
        id = 5047,
        faction = nil,
        name = "Pip Quickwit, At Your Service!",
        suggestedLevel = 60,
        requiredLevel = 57,
        source = Q.Sources[181], -- Pip Quickwit
        instances = { Q.Instances["Upper Blackrock Spire"] }
    },
    {
        id = 7761,
        faction = nil,
        name = "Blackhand's Command",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = Q.Sources[30], -- Blackhand's Command
        instances = { Q.Instances["Upper Blackrock Spire"] }
    },
    {
        id = 4766,
        faction = "Alliance",
        name = "Mayara Brightwing",
        suggestedLevel = 60,
        requiredLevel = 57,
        source = Q.Sources[49], -- Count Remington Ridgewell
        instances = { Q.Instances["Upper Blackrock Spire"] }
    },
    {
        id = 4764,
        faction = "Alliance",
        name = "Doomrigger's Clasp",
        suggestedLevel = 60,
        requiredLevel = 57,
        prerequisites = {
            { id = 4766, type = Q.PrerequisiteType.BREADCRUMB }
        },
        source = Q.Sources[159], -- Mayara Brightwing
        instances = { Q.Instances["Upper Blackrock Spire"] }
    },
    {
        id = 4768,
        faction = "Horde",
        name = "The Darkstone Tablet",
        suggestedLevel = 60,
        requiredLevel = 57,
        prerequisites = {
            { id = 4769, type = Q.PrerequisiteType.BREADCRUMB }
        },
        source = Q.Sources[204], -- Shadowmage Vivian Lagrave
        instances = { Q.Instances["Upper Blackrock Spire"] }
    },
    {
        id = 4769,
        faction = "Horde",
        name = "Vivian Lagrave and the Darkstone Tablet",
        suggestedLevel = 60,
        requiredLevel = 57,
        source = Q.Sources[11], -- Apothecary Zinge
    },
    --#endregion

    --#region Paladin Quests
    {
        id = 1654,
        faction = "Alliance",
        class = "PALADIN",
        name = "The Test of Righteousness (2/2)",
        suggestedLevel = 20,
        requiredLevel = 20,
        prerequisites = {
            { id = 1653, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[120], -- Jordan Stilwell
        instances = { Q.Instances["Shadowfang Keep"], Q.Instances["The Deadmines"], Q.Instances["Blackfathom Deeps"] },
    },
    {
        id = 1649,
        faction = "Alliance",
        class = "PALADIN",
        name = "The Tome of Valor (1/4)",
        suggestedLevel = 20,
        requiredLevel = 20,
        source = Q.Sources[233], -- Tome of Valor
        text = "Speak to Duthorian Rall to receive the tome and start the quest"
    },
    {
        id = 1650,
        faction = "Alliance",
        class = "PALADIN",
        name = "The Tome of Valor (2/4)",
        suggestedLevel = 23,
        requiredLevel = 20,
        prerequisites = {
            { id = 1649, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[58], -- Daphne Stilwell
    },
    {
        id = 1651,
        faction = "Alliance",
        class = "PALADIN",
        name = "The Tome of Valor (3/4)",
        suggestedLevel = 25,
        requiredLevel = 20,
        prerequisites = {
            { id = 1650, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[58], -- Daphne Stilwell
    },
    {
        id = 1652,
        faction = "Alliance",
        class = "PALADIN",
        name = "The Tome of Valor (4/4)",
        suggestedLevel = 25,
        requiredLevel = 20,
        prerequisites = {
            { id = 1651, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[73], -- Duthorian Rall
    },
    {
        id = 1653,
        faction = "Alliance",
        class = "PALADIN",
        name = "The Test of Righteousness (1/2)",
        suggestedLevel = 25,
        requiredLevel = 20,
        prerequisites = {
            { id = 1652, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[73], -- Duthorian Rall
    },
    {
        id = 7670,
        faction = "Alliance",
        class = "PALADIN",
        name = "Lord Grayson Shadowbreaker",
        suggestedLevel = 60,
        requiredLevel = 60,
        source = Q.Sources[279], -- Brandur Ironhammer
    },
    {
        id = 7638,
        faction = "Alliance",
        class = "PALADIN",
        name = "Lord Grayson Shadowbreaker",
        suggestedLevel = 60,
        requiredLevel = 60,
        source = Q.Sources[73], -- Duthorian Rall
    },
    {
        id = 7637,
        faction = "Alliance",
        class = "PALADIN",
        name = "Emphasis on Sacrifice",
        suggestedLevel = 60,
        requiredLevel = 60,
        prerequisites = {
            { id = 7638, type = Q.PrerequisiteType.ANY },
            { id = 7670, type = Q.PrerequisiteType.ANY }
        },
        source = Q.Sources[141], -- Lord Grayson Shadowbreaker
    },
    {
        id = 7639,
        faction = "Alliance",
        class = "PALADIN",
        name = "To Show Due Judgment",
        suggestedLevel = 60,
        requiredLevel = 60,
        prerequisites = {
            { id = 7637, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[110], -- High Priest Rohan
    },
    {
        id = 7640,
        faction = "Alliance",
        class = "PALADIN",
        name = "Exorcising Terrordale",
        suggestedLevel = 60,
        requiredLevel = 60,
        prerequisites = {
            { id = 7639, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[141], -- Lord Grayson Shadowbreaker
    },
    {
        id = 7641,
        faction = "Alliance",
        class = "PALADIN",
        name = "The Work of Grimand Elmore",
        suggestedLevel = 60,
        requiredLevel = 60,
        prerequisites = {
            { id = 7640, type = Q.PrerequisiteType.REQUIRED }
        },
        source = Q.Sources[141], -- Lord Grayson Shadowbreaker
    },
    {
        id = 7642,
        faction = "Alliance",
        class = "PALADIN",
        name = "Collection of Goods",
        suggestedLevel = 60,
        requiredLevel = 60,
        prerequisites = {
            { id = 7641, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[97], -- Grimand Elmore
    },
    {
        id = 7643,
        faction = "Alliance",
        class = "PALADIN",
        name = "Ancient Equine Spirit",
        suggestedLevel = 60,
        requiredLevel = 60,
        prerequisites = {
            { id = 7642, type = Q.PrerequisiteType.REQUIRED }
        },
        source = Q.Sources[141], -- Lord Grayson Shadowbreaker
        instances = { Q.Instances["Dire Maul: West"] }
    },
    {
        id = 7644,
        faction = "Alliance",
        class = "PALADIN",
        name = "Blessed Arcanite Barding",
        suggestedLevel = 60,
        requiredLevel = 60,
        prerequisites = {
            { id = 7643, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[6], -- Ancient Equine Spirit
    },
    {
        id = 7646,
        faction = "Alliance",
        class = "PALADIN",
        name = "The Divination Scryer",
        suggestedLevel = 60,
        requiredLevel = 60,
        prerequisites = {
            { id = 7644, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[141], -- Lord Grayson Shadowbreaker
    },
    {
        id = 7647,
        faction = "Alliance",
        class = "PALADIN",
        name = "Judgment and Redemption",
        suggestedLevel = 60,
        requiredLevel = 60,
        prerequisites = {
            { id = 7646, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[141], -- Lord Grayson Shadowbreaker
        instances = { Q.Instances["Scholomance"] }
    },
    {
        id = 91858,
        faction = "Horde",
        class = "PALADIN",
        name = "Diplomatic Incident",
        suggestedLevel = 22,
        requiredLevel = 20,
        source = Q.Sources[57], -- Danitha Morr
    },
    {
        id = 91859,
        faction = "Horde",
        class = "PALADIN",
        name = "A Curious Pair",
        suggestedLevel = 22,
        requiredLevel = 20,
        prerequisites = {
            { id = 91858, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[238], -- Trevan Rol
    },
    {
        id = 91860,
        faction = "Horde",
        class = "PALADIN",
        name = "A Grim Fate",
        suggestedLevel = 22,
        requiredLevel = 20,
        prerequisites = {
            { id = 91859, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[63], -- Deathguard Baldren
    },
    {
        id = 91861,
        faction = "Horde",
        class = "PALADIN",
        name = "Into Fenris Keep",
        suggestedLevel = 22,
        requiredLevel = 20,
        prerequisites = {
            { id = 91860, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[45], -- Charred Remains
    },
    {
        id = 91862,
        faction = "Horde",
        class = "PALADIN",
        name = "Lumina Windsinger",
        suggestedLevel = 22,
        requiredLevel = 20,
        prerequisites = {
            { id = 91861, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[145], -- Lumina Windsinger
    },
    {
        id = 96204,
        faction = "Horde",
        class = "PALADIN",
        name = "The Windshaper's Wrath",
        suggestedLevel = 22,
        requiredLevel = 20,
        prerequisites = {
            { id = 91862, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[145], -- Lumina Windsinger
    },
    {
        id = 95036,
        faction = "Horde",
        class = "PALADIN",
        name = "A Moon-Kissed Blade",
        suggestedLevel = 25,
        requiredLevel = 20,
        prerequisites = {
            { id = 96204, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[145], -- Lumina Windsinger
        instances = { Q.Instances["Shadowfang Keep"], Q.Instances["The Deadmines"], Q.Instances["Blackfathom Deeps"] },
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
        source = Q.Sources[66], -- Doan Karhan
        instances = { Q.Instances["Shadowfang Keep"], Q.Instances["Blackfathom Deeps"] }
    },
    {
        id = 7562,
        faction = nil,
        class = "WARLOCK",
        name = "Mor'zul Bloodbringer",
        suggestedLevel = 60,
        requiredLevel = 60,
        sources = {
            Q.Sources[267], -- Martha Strain
            Q.Sources[268], -- Kurgul
            Q.Sources[269], -- Jubahl Corpseseeker
            Q.Sources[270] -- Spackle Thornberry
        },
    },
    {
        id = 7563,
        faction = nil,
        class = "WARLOCK",
        name = "Rage of Blood",
        suggestedLevel = 60,
        requiredLevel = 60,
        prerequisites = {
            { id = 7562, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[165], -- Mor'zul Bloodbringer
    },
    {
        id = 7564,
        faction = nil,
        class = "WARLOCK",
        name = "Wildeyes",
        suggestedLevel = 60,
        requiredLevel = 60,
        prerequisites = {
            { id = 7563, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[165], -- Mor'zul Bloodbringer
    },
    {
        id = 7623,
        faction = nil,
        class = "WARLOCK",
        name = "Lord Banehollow",
        suggestedLevel = 60,
        requiredLevel = 60,
        prerequisites = {
            { id = 7564, type = Q.PrerequisiteType.REQUIRED }
        },
        source = Q.Sources[94], -- Gorzeeki Wildeyes
    },
    {
        id = 7624,
        faction = nil,
        class = "WARLOCK",
        name = "Ulathek the Traitor",
        suggestedLevel = 60,
        requiredLevel = 60,
        prerequisites = {
            { id = 7623, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[140], -- Lord Banehollow
    },
    {
        id = 7625,
        faction = nil,
        class = "WARLOCK",
        name = "Xorothian Stardust",
        suggestedLevel = 60,
        requiredLevel = 60,
        prerequisites = {
            { id = 7624, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[140], -- Lord Banehollow
    },
    {
        id = 7629,
        faction = nil,
        class = "WARLOCK",
        name = "Imp Delivery",
        suggestedLevel = 60,
        requiredLevel = 60,
        prerequisites = {
            { id = 7630, type = Q.PrerequisiteType.REQUIRED },
            { id = 7625, type = Q.PrerequisiteType.REQUIRED }
        },
        source = Q.Sources[94], -- Gorzeeki Wildeyes
        instances = { Q.Instances["Scholomance"] }
    },
    {
        id = 7631,
        class = "WARLOCK",
        name = "Dreadsteed of Xoroth",
        suggestedLevel = 60,
        requiredLevel = 60,
        prerequisites = {
            { id = 7629, type = Q.PrerequisiteType.REQUIRED }
        },
        source = Q.Sources[165], -- Mor'zul Bloodbringer
        instances = { Q.Instances["Dire Maul: West"] }
    },
    {
        id = 7630,
        faction = nil,
        class = "WARLOCK",
        name = "Arcanite",
        suggestedLevel = 60,
        requiredLevel = 60,
        prerequisites = {
            { id = 7626, type = Q.PrerequisiteType.REQUIRED },
            { id = 7628, type = Q.PrerequisiteType.REQUIRED },
            { id = 7627, type = Q.PrerequisiteType.REQUIRED }
        },
        source = Q.Sources[94], -- Gorzeeki Wildeyes
    },
    {
        id = 7628,
        faction = nil,
        class = "WARLOCK",
        name = "Doomsday Candle",
        suggestedLevel = 60,
        requiredLevel = 60,
        prerequisites = {
            { id = 7564, type = Q.PrerequisiteType.REQUIRED },
        },
        source = Q.Sources[165], -- Mor'zul Bloodbringer
    },
    {
        id = 7627,
        faction = nil,
        class = "WARLOCK",
        name = "Wheel of the Black March",
        suggestedLevel = 60,
        requiredLevel = 60,
        prerequisites = {
            { id = 7564, type = Q.PrerequisiteType.REQUIRED },
        },
        source = Q.Sources[165], -- Mor'zul Bloodbringer
    },
    {
        id = 7626,
        faction = nil,
        class = "WARLOCK",
        name = "Bell of Dethmoora",
        suggestedLevel = 60,
        requiredLevel = 60,
        prerequisites = {
            { id = 7564, type = Q.PrerequisiteType.REQUIRED },
        },
        source = Q.Sources[165], -- Mor'zul Bloodbringer
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
        prerequisites = {
            { id = 1702, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[84], -- Furen Longbeard
        instances = { Q.Instances["Razorfen Kraul"] }
    },
    {
        id = 1699,
        faction = "Alliance",
        class = "WARRIOR",
        name = "The Rethban Gauntlet",
        suggestedLevel = 22,
        requiredLevel = 20,
        source = Q.Sources[259], -- Yorus Barleybrew
    },
    {
        id = 1702,
        faction = "Alliance",
        class = "WARRIOR",
        name = "The Shieldsmith",
        suggestedLevel = 22,
        requiredLevel = 20,
        prerequisites = {
            { id = 1699, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[84], -- Furen Longbeard
    },
    {
        id = 1838,
        faction = "Horde",
        class = "WARRIOR",
        name = "Brutal Armor",
        suggestedLevel = 30,
        requiredLevel = 20,
        prerequisites = {
            { id = 1825, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[227], -- Thun'grim Firegaze
        instances = { Q.Instances["Razorfen Kraul"] }
    },
    {
        id = 1823,
        faction = "Horde",
        class = "WARRIOR",
        name = "Speak with Ruga",
        suggestedLevel = 20,
        requiredLevel = 20,
        sources = {
            Q.Sources[271], -- Sorek
            Q.Sources[272], -- Torm Ragetotem
            Q.Sources[273] -- Baltus Fowler
        },
    },
    {
        id = 1824,
        faction = "Horde",
        class = "WARRIOR",
        name = "Trial at the Field of Giants",
        suggestedLevel = 20,
        requiredLevel = 20,
        prerequisites = {
            { id = 1823, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[197], -- Ruga Ragetotem
    },
    {
        id = 1825,
        faction = "Horde",
        class = "WARRIOR",
        name = "Speak with Thun'grim",
        suggestedLevel = 20,
        requiredLevel = 20,
        prerequisites = {
            { id = 1824, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[227], -- Thun'grim Firegaze
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
            Q.Sources[274], -- Ursyn Ghull
            Q.Sources[263], -- Anastasia Hartwell
            Q.Sources[266], -- Deino
            Q.Sources[265], -- Jennea Cannon
            Q.Sources[264] -- Bink
        }
    },
    {
        id = 1949,
        class = "MAGE",
        name = "Hidden Secrets",
        suggestedLevel = 38,
        requiredLevel = 30,
        prerequisites = {
            { id = 1947, type = Q.PrerequisiteType.BREADCRUMB }
        },
        source = Q.Sources[214], -- Tabetha
    },
    {
        id = 1950,
        class = "MAGE",
        name = "Get the Scoop",
        suggestedLevel = 30,
        requiredLevel = 30,
        prerequisites = {
            { id = 1949, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[148], -- Magus Tirth
    },
    {
        id = 1953,
        class = "MAGE",
        name = "Return to the Marsh",
        suggestedLevel = 40,
        requiredLevel = 35,
        sources = {
            Q.Sources[274], -- Ursyn Ghull
            Q.Sources[263], -- Anastasia Hartwell
            Q.Sources[266], -- Deino
            Q.Sources[265], -- Jennea Cannon
            Q.Sources[264] -- Bink
        }
    },
    {
        id = 1954,
        class = "MAGE",
        name = "The Infernal Orb",
        suggestedLevel = 40,
        requiredLevel = 35,
        prerequisites = {
            { id = 1953, type = Q.PrerequisiteType.BREADCRUMB }
        },
        source = Q.Sources[214], -- Tabetha
    },
    {
        id = 1955,
        class = "MAGE",
        name = "The Exorcism",
        suggestedLevel = 40,
        requiredLevel = 35,
        prerequisites = {
            { id = 1954, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[214], -- Tabetha
    },
    {
        id = 1956,
        class = "MAGE",
        name = "Power in Uldaman",
        suggestedLevel = 40,
        requiredLevel = 35,
        prerequisites = {
            { id = 1955, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[214], -- Tabetha
        instances = { Q.Instances["Uldaman"] },
    },
    {
        id = 1951,
        class = "MAGE",
        name = "Rituals of Power",
        suggestedLevel = 40,
        requiredLevel = 30,
        prerequisites = {
            { id = 1950, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[148], -- Magus Tirth
        instances = { Q.Instances["Scarlet Monastery: Library"] },
    },
    {
        id = 7463,
        class = "MAGE",
        name = "Arcane Refreshment",
        suggestedLevel = 60,
        requiredLevel = 60,
        source = Q.Sources[142], -- Lorekeeper Lydros
        instances = { Q.Instances["Dire Maul: East"] },
    },
    --#endregion

    --#region Shaman Quests
    {
        id = 7667,
        class = "SHAMAN",
        name = "Material Assistance",
        suggestedLevel = 60,
        requiredLevel = 58,
        source = Q.Sources[200], -- Sagorne Creststrider
    },
    {
        id = 8258,
        class = "SHAMAN",
        name = "The Darkreaver Menace",
        suggestedLevel = 60,
        requiredLevel = 58,
        prerequisites = {
            { id = 7667, type = Q.PrerequisiteType.CHAIN }
        },
        source = Q.Sources[200], -- Sagorne Creststrider
        instances = { Q.Instances["Scholomance"] }
    },
    {
        id = 96264,
        faction = "Alliance",
        class = "SHAMAN",
        name = "Elemental Aid ",
        suggestedLevel = 33,
        requiredLevel = 30,
        prerequisites = {
            { id = 94789, type = Q.PrerequisiteType.CHAIN }
        },
        sources = {
            Q.Sources[284] -- Eldrun Stormbreaker
        }
    },
    {
        id = 79360,
        faction = "Horde",
        class = "SHAMAN",
        name = "Elemental Aid ",
        suggestedLevel = 33,
        requiredLevel = 30,
        prerequisites = {
            { id = 1532, type = Q.PrerequisiteType.CHAIN }
        },
        sources = {
            Q.Sources[275], -- Rau Cliffrunner
            Q.Sources[276] -- Prate Cloudseer
        },
        instances = { Q.Instances["Razorfen Kraul"] }
    },
    {
        id = 1532,
        class = "SHAMAN",
        name = "Call of Air",
        suggestedLevel = 30,
        requiredLevel = 30,
        sources = {
            Q.Sources[277], -- Searn Firewarder
            Q.Sources[278] -- Xanis Flameweaver
        }
    },
    --#endregion

    --#region Blacksmithing Quests
    {
        id = 5126,
        profession = "Blacksmithing",
        name = "Lorax's Tale",
        suggestedLevel = 60,
        requiredLevel = 55,
        source = Q.Sources[139], -- Lorax
    },
    {
        id = 5127,
        profession = "Blacksmithing",
        name = "The Demon Forge",
        suggestedLevel = 60,
        requiredLevel = 55,
        prerequisites = {
            { id = 5126, type = Q.PrerequisiteType.REQUIRED }
        },
        source = Q.Sources[139], -- Lorax
        instances = { Q.Instances["Upper Blackrock Spire"] }
    },
    --#endregion

    --#region The Drowned City
    {
        id = 203,
        faction = "Alliance",
        name = "The Second Rebellion",
        suggestedLevel = 34,
        requiredLevel = 30,
        source = Q.Sources[303], -- Sergeant Yohwa
    },
    {
        id = 204,
        faction = "Alliance",
        name = "Bad Medicine",
        suggestedLevel = 34,
        requiredLevel = 30,
        source = Q.Sources[303], -- Sergeant Yohwa
    },
    {
        id = 207,
        faction = "Alliance",
        name = "Kurzen's Mystery",
        prerequisites = {
            { id = 204, type = Q.PrerequisiteType.REQUIRED },
            { id = 203, type = Q.PrerequisiteType.REQUIRED }
        },
        suggestedLevel = 38,
        requiredLevel = 30,
        source = Q.Sources[291], -- Brother Nimetz
    },
    {
        id = 205,
        faction = "Alliance",
        name = "Troll Witchery",
        prerequisites = {
            { id = 207, type = Q.PrerequisiteType.REQUIRED }
        },
        suggestedLevel = 40,
        requiredLevel = 30,
        source = Q.Sources[291], -- Brother Nimetz
    },
    {
        id = 95786,
        faction = "Alliance",
        name = "An Acquaintance in Southshore",
        prerequisites = {
            { id = 205, type = Q.PrerequisiteType.REQUIRED }
        },
        suggestedLevel = 40,
        requiredLevel = 30,
        source = Q.Sources[291], -- Brother Nimetz
    },
    {
        id = 95775,
        faction = "Horde",
        name = "The Drowned City",
        suggestedLevel = 40,
        requiredLevel = 30,
        source = Q.Sources[240], -- Unknown
        instances = { Q.Instances["The Drowned City"] }
    },
    {
        id = 95787,
        faction = "Alliance",
        name = "Take Two With Water",
        prerequisites = {
            { id = 95786, type = Q.PrerequisiteType.REQUIRED }
        },
        suggestedLevel = 40,
        requiredLevel = 30,
        source = Q.Sources[240], -- Unknown
        instances = { Q.Instances["The Drowned City"] }
    },
    {
        id = 95788,
        faction = "Alliance",
        name = "Magic of the Drowned City",
        prerequisites = {
            { id = 95786, type = Q.PrerequisiteType.REQUIRED }
        },
        suggestedLevel = 40,
        requiredLevel = 30,
        source = Q.Sources[240], -- Unknown
        instances = { Q.Instances["The Drowned City"] }
    },
    {
        id = 97130,
        faction = "Alliance",
        name = "Ancient Gurubashi Idol",
        suggestedLevel = 40,
        requiredLevel = 34,
        source = Q.Sources[288], -- Archmage Timear
        instances = { Q.Instances["The Drowned City"] }
    },
    {
        id = 96774,
        faction = "Horde",
        name = "Ancient Gurubashi Idol",
        suggestedLevel = 40,
        requiredLevel = 30,
        source = Q.Sources[160], -- Mazu'kon
        instances = { Q.Instances["The Drowned City"] }
    },
    {
        id = 95776,
        faction = "Horde",
        name = "The Only Good Brinescale...",
        suggestedLevel = 38,
        requiredLevel = 30,
        source = Q.Sources[292], -- Commander Aggro'gosh
        instances = { Q.Instances["The Drowned City"] }
    },
    {
        id = 95789,
        name = "Shady Saltseer",
        suggestedLevel = 40,
        requiredLevel = 34,
        source = Q.Sources[130], -- Krazek
        instances = { Q.Instances["The Drowned City"] }
    },
    {
        id = 95791,
        name = "The Saltseer Captain",
        suggestedLevel = 40,
        requiredLevel = 34,
        source = Q.Sources[130], -- Krazek
        instances = { Q.Instances["The Drowned City"] }
    },
    --#endregion
    --#region Rogue Quests
    {
        id = 78676,
        class = "ROGUE",
        name = "The Eye of Bhossca",
        suggestedLevel = 35,
        requiredLevel = 30,
        source = Q.Sources[61], -- Dead Drop
        instances = { Q.Instances["Scarlet Monastery: Library"], Q.Instances["Scarlet Monastery: Graveyard"] }
    },
    {
        id = 78261,
        class = "ROGUE",
        name = "The Horn of Xelthos",
        suggestedLevel = 23,
        requiredLevel = 20,
        source = Q.Sources[62], -- Dead Drop
        instances = { Q.Instances["Shadowfang Keep"] }
    },
    --#endregion
    --#region Krol'dok Stronghold Prerequisites
    {
        id = 94879,
        faction = "Alliance",
        name = "Scraps of Knowledge",
        suggestedLevel = 40,
        requiredLevel = 36,
        source = Q.Sources[296], -- Ashe Amberhall
    },
    {
        id = 94886,
        faction = "Alliance",
        name = "The Western Front",
        prerequisites = {
            { id = 94879, type = Q.PrerequisiteType.CHAIN }
        },
        suggestedLevel = 44,
        requiredLevel = 38,
        source = Q.Sources[294] -- Demar Brant
    },
    {
        id = 94889,
        faction = "Alliance",
        name = "Carving a Path",
        prerequisites = {
            { id = 94886, type = Q.PrerequisiteType.CHAIN }
        },
        suggestedLevel = 44,
        requiredLevel = 38,
        source = Q.Sources[297], -- Sergeant Riftan
    },
    {
        id = 94890,
        faction = "Alliance",
        name = "Bring Me His Head",
        prerequisites = {
            { id = 94889, type = Q.PrerequisiteType.CHAIN }
        },
        suggestedLevel = 46,
        requiredLevel = 38,
        source = Q.Sources[297], -- Sergeant Riftan
    },
    {
        id = 94744,
        faction = "Horde",
        name = "The Wayward Warrior",
        suggestedLevel = 43,
        requiredLevel = 38,
        source = Q.Sources[302], -- Da'grosh
    },
    {
        id = 94748,
        faction = "Horde",
        name = "Break Their Chains",
        prerequisites = {
            { id = 94744, type = Q.PrerequisiteType.CHAIN }
        },
        suggestedLevel = 44,
        requiredLevel = 38,
        source = Q.Sources[302], -- Da'grosh
    },
    {
        id = 94745,
        faction = "Horde",
        name = "Carving a Path",
        prerequisites = {
            { id = 94744, type = Q.PrerequisiteType.CHAIN }
        },
        suggestedLevel = 44,
        requiredLevel = 38,
        source = Q.Sources[302], -- Da'grosh
    },
    {
        id = 95432,
        faction = "Horde",
        name = "Rise Up!",
        suggestedLevel = 43,
        requiredLevel = 38,
        source = Q.Sources[240], -- Unknown
    },
    {
        id = 94768,
        faction = "Horde",
        name = "Bring Me His Head",
        prerequisites = {
            { id = 94748, type = Q.PrerequisiteType.REQUIRED },
            { id = 94745, type = Q.PrerequisiteType.REQUIRED },
            { id = 95432, type = Q.PrerequisiteType.REQUIRED }
        },
        suggestedLevel = 46,
        requiredLevel = 38,
        source = Q.Sources[302], -- Da'grosh
    },
    {
        id = 95278,
        faction = "Horde",
        name = "It Is Time, Brother...",
        prerequisites = {
            { id = 94768, type = Q.PrerequisiteType.CHAIN }
        },
        suggestedLevel = 45,
        requiredLevel = 38,
        source = Q.Sources[240], -- Unknown; starts from the Blood and Battle item
    },
    --#endregion
    {
        id = 94968,
        faction = "Horde",
        name = "Eye of Mugg",
        prerequisites = {
            { id = 95278, type = Q.PrerequisiteType.REQUIRED }
        },
        suggestedLevel = 45,
        requiredLevel = 40,
        source = Q.Sources[293], -- Krom'rosh
        instances = { Q.Instances["Krol'dok Stronghold"] }
    },
    {
        id = 94982,
        faction = "Alliance",
        name = "Eye of Mugg",
        prerequisites = {
            { id = 94890, type = Q.PrerequisiteType.REQUIRED }
        },
        suggestedLevel = 45,
        requiredLevel = 40,
        source = Q.Sources[294], -- Demar Brant
        instances = { Q.Instances["Krol'dok Stronghold"] }
    },
    {
        id = 94881,
        faction = "Alliance",
        name = "Curious Trinkets",
        suggestedLevel = 39,
        requiredLevel = 36,
        source = Q.Sources[296], -- Ashe Amberhall
    },
    {
        id = 94907,
        faction = "Alliance",
        name = "A Small Favor",
        prerequisites = {
            { id = 94881, type = Q.PrerequisiteType.REQUIRED }
        },
        suggestedLevel = 44,
        requiredLevel = 36,
        source = Q.Sources[296], -- Ashe Amberhall
    },
    {
        id = 94972,
        faction = "Horde",
        name = "Tome of Twilight",
        prerequisites = {
            { id = 95278, type = Q.PrerequisiteType.REQUIRED }
        },
        suggestedLevel = 44,
        requiredLevel = 39,
        source = Q.Sources[295], -- Tran'gul
        instances = { Q.Instances["Krol'dok Stronghold"] }
    },
    {
        id = 94984,
        faction = "Alliance",
        name = "Tome of Twilight",
        prerequisites = {
            { id = 94907, type = Q.PrerequisiteType.REQUIRED }
        },
        suggestedLevel = 44,
        requiredLevel = 39,
        source = Q.Sources[296], -- Ashe Amberhall
        instances = { Q.Instances["Krol'dok Stronghold"] }
    },
    {
        id = 94975,
        faction = "Horde",
        name = "A Token of Vengeance",
        prerequisites = {
            { id = 94768, type = Q.PrerequisiteType.REQUIRED }
        },
        suggestedLevel = 42,
        requiredLevel = 38,
        source = Q.Sources[240], -- Unknown
        instances = { Q.Instances["Krol'dok Stronghold"] }
    },
    {
        id = 94983,
        faction = "Alliance",
        name = "Twilight Mementos",
        prerequisites = {
            { id = 94890, type = Q.PrerequisiteType.REQUIRED }
        },
        suggestedLevel = 42,
        requiredLevel = 38,
        source = Q.Sources[297], -- Sergeant Riftan
        instances = { Q.Instances["Krol'dok Stronghold"] }
    },
    {
        id = 94973,
        faction = "Horde",
        name = "Krol'dok Moulding",
        suggestedLevel = 41,
        requiredLevel = 38,
        source = Q.Sources[301], -- Krol'dok Moulding
        instances = { Q.Instances["Krol'dok Stronghold"] }
    },
    {
        id = 94980,
        faction = "Alliance",
        name = "Krol'dok Moulding",
        suggestedLevel = 41,
        requiredLevel = 38,
        source = Q.Sources[301], -- Krol'dok Moulding
        instances = { Q.Instances["Krol'dok Stronghold"] }
    },
    {
        id = 96771,
        faction = "Alliance",
        name = "Vengeance of the Highborne",
        suggestedLevel = 45,
        requiredLevel = 37,
        source = Q.Sources[290], -- Ranath Nightstride
        instances = { Q.Instances["Krol'dok Stronghold"] }
    },

    --#region Alcaz Prison
    -- Horde rescue chain
    {
        id = 95309,
        faction = "Horde",
        name = "No Orc Left Behind",
        suggestedLevel = 53,
        requiredLevel = 48,
        source = Q.Sources[304], -- Sergeant Ulka
        instances = { Q.Instances["Alcaz Prison"] }
    },
    {
        id = 95454,
        faction = "Horde",
        name = "The Honor of the Kor'kron",
        prerequisites = {
            { id = 95309, type = Q.PrerequisiteType.CHAIN }
        },
        suggestedLevel = 53,
        requiredLevel = 48,
        source = Q.Sources[305], -- Commander Folkar
        instances = { Q.Instances["Alcaz Prison"] }
    },
    {
        id = 96369,
        faction = "Horde",
        name = "Bad News for Folkar",
        prerequisites = {
            { id = 95454, type = Q.PrerequisiteType.CHAIN }
        },
        suggestedLevel = 53,
        requiredLevel = 48,
        source = Q.Sources[240], -- Unknown; starts from the Perfumed Note
        instances = { Q.Instances["Alcaz Prison"] }
    },
    {
        id = 95483,
        faction = "Horde",
        name = "Thrall Needs to Know",
        prerequisites = {
            { id = 96369, type = Q.PrerequisiteType.CHAIN }
        },
        suggestedLevel = 53,
        requiredLevel = 48,
        source = Q.Sources[305], -- Commander Folkar
        instances = { Q.Instances["Alcaz Prison"] }
    },
    {
        id = 96334,
        faction = "Horde",
        name = "Blood Red Bandanas",
        suggestedLevel = 53,
        requiredLevel = 48,
        source = Q.Sources[240], -- Unknown
        instances = { Q.Instances["Alcaz Prison"] }
    },
    {
        id = 96332,
        faction = "Horde",
        name = "A Little Payback",
        suggestedLevel = 53,
        requiredLevel = 48,
        source = Q.Sources[304], -- Sergeant Ulka
        instances = { Q.Instances["Alcaz Prison"] }
    },

    -- Alliance lead-in to The Secret Prison
    {
        id = 95194,
        faction = "Alliance",
        name = "Our Man in Theramore",
        suggestedLevel = 53,
        requiredLevel = 48,
        source = Q.Sources[240], -- Unknown
    },
    {
        id = 95196,
        faction = "Alliance",
        name = "Watch Yer Back",
        prerequisites = {
            { id = 95194, type = Q.PrerequisiteType.CHAIN }
        },
        suggestedLevel = 53,
        requiredLevel = 48,
        source = Q.Sources[240], -- Unknown
    },
    {
        id = 95198,
        faction = "Alliance",
        name = "The Return of the King?",
        prerequisites = {
            { id = 95196, type = Q.PrerequisiteType.CHAIN }
        },
        suggestedLevel = 53,
        requiredLevel = 48,
        source = Q.Sources[240], -- Unknown
    },
    {
        id = 95262,
        faction = "Alliance",
        name = "The Secret Prison",
        prerequisites = {
            { id = 95198, type = Q.PrerequisiteType.CHAIN }
        },
        suggestedLevel = 53,
        requiredLevel = 48,
        source = Q.Sources[240], -- Unknown
        instances = { Q.Instances["Alcaz Prison"] }
    },
    {
        id = 96335,
        name = "The Man in the Iron Chains",
        prerequisites = {
            { id = 95262, type = Q.PrerequisiteType.CHAIN }
        },
        suggestedLevel = 53,
        requiredLevel = 48,
        source = Q.Sources[240], -- Unknown
        instances = { Q.Instances["Alcaz Prison"] }
    },
    {
        id = 96337,
        name = "More Valuable Than Gold",
        prerequisites = {
            { id = 96335, type = Q.PrerequisiteType.CHAIN }
        },
        suggestedLevel = 53,
        requiredLevel = 48,
        source = Q.Sources[240], -- Unknown
        instances = { Q.Instances["Alcaz Prison"] }
    },
    {
        id = 96381,
        faction = "Alliance",
        name = "A Bit of Wet Work",
        suggestedLevel = 53,
        requiredLevel = 48,
        source = Q.Sources[240], -- Unknown
        instances = { Q.Instances["Alcaz Prison"] }
    },
    {
        id = 96772,
        faction = "Alliance",
        name = "The Dragon's Journal",
        suggestedLevel = 53,
        requiredLevel = 46,
        source = Q.Sources[289], -- Archmage Lan'dalock
        instances = { Q.Instances["Alcaz Prison"] }
    },
    {
        id = 96376,
        faction = "Horde",
        name = "State Secrets",
        suggestedLevel = 53,
        requiredLevel = 48,
        source = Q.Sources[240], -- Unknown
        instances = { Q.Instances["Alcaz Prison"] }
    },
    {
        id = 96377,
        faction = "Alliance",
        name = "State Secrets",
        suggestedLevel = 53,
        requiredLevel = 48,
        source = Q.Sources[240], -- Unknown
        instances = { Q.Instances["Alcaz Prison"] }
    }
    --#endregion
}
