-- Text, area, zone and room info from Datacrystal

-- the ofset is not the key cause we need the guaranteed ordering of ipairs()
actorStruct = {
--  { offset = 0x0  , name = 'next'         , size = 4 }
  { offset = 0x2c , name = 'X_coordinate' , size = 2 , sameline = true}
, { offset = 0x2e , name = 'Y_coordinate' , size = 2 , sameline = true}
, { offset = 0x50 , name = 'Name'         , size = 2 , text = true } --24
, { offset = 0x68 , name = 'CurrentHP'    , size = 2 , sameline = true}
, { offset = 0x6a , name = 'MaxHP'        , size = 2 }
, { offset = 0x6c , name = 'Current MP'   , size = 2 , sameline = true}
, { offset = 0x6e , name = 'MaxMP'        , size = 2 }
, { offset = 0x70 , name = 'RISK'         , size = 2 }
, { offset = 0x72 , name = 'Original STR' , size = 2 , sameline = true}
, { offset = 0x74 , name = 'Equipped STR' , size = 2 }
, { offset = 0x76 , name = 'Original INT' , size = 2 , sameline = true}
, { offset = 0x78 , name = 'Equipped INT' , size = 2 }
, { offset = 0x7a , name = 'Original AGL' , size = 2 , sameline = true}
, { offset = 0x7c , name = 'Equipped AGL' , size = 2 }
, { offset = 0x8c , name = 'Weapon Name'  , size = 2 , text = true } --24
}


text_t = { [0]= --starts at zero
  '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F',  
  'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V',  
  'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l',  
  'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '' , '' ,  
  'Ć', 'Â', 'Ä', 'Ç', 'È', 'É', 'Ê', 'Ë', 'Ì', 'ő', 'Î', 'í', 'Ò', 'Ó', 'Ô', 'Ö',
  'Ù', 'Ú', 'Û', 'Ü', 'ß', 'æ', 'à', 'á', 'â', 'ä', 'ç', 'è', 'é', 'ê', 'ë', 'ì',
  'í', 'î', 'ï', 'ò', 'ó', 'ô', 'ö', 'ù', 'ú', 'û', 'ü', '' , '' , '' , '' , '' ,
  '' , '' , '' , '' , '' , '' , '' , '' , '' , '' , '' , '' , '' , '' , '' , '' ,
  '' , '' , '' , '' , '' , '' , '' , '‼', '≠', '≦', '≧', '÷', '-', '—', '⋯', ' ',
  '!', '"', '#', '$', '%', '&', "'", '(', ')', '{', '}', '[', ']', ';', ':', ',',
  '.', '/','\\', '<', '>', '?', '_', '-', '+', '*', '' , '{', '}', '♪',
  [0xB6] = 'Lv.', 
  [0xE7] = '',    -- [end string]
  [0xE8] = '',    -- [new line]
  [0xEB] = '',    -- [filler byte]  End Dialogue?
  [0xF801] = '«p1»', 
  [0xF802] = '«p2»', 
  [0xF808] = '«p8»', 
  [0xF80A] = '«p10»', 
  [0xFA06] = ' '  -- 0x8F is also a space
} 


items_t = {}
items_t[0x43] = "Cure Root";            items_t[0x44] = "Cure Bulb";
items_t[0x45] = "Cure Tonic";           items_t[0x46] = "Cure Potion";
items_t[0x47] = "Mana Root";            items_t[0x48] = "Mana Bulb";
items_t[0x49] = "Mana Tonic";           items_t[0x4A] = "Mana Potion";
items_t[0x4B] = "Vera Root";            items_t[0x4C] = "Vera Bulb";
items_t[0x4D] = "Vera Tonic";           items_t[0x4E] = "Vera Potion";
items_t[0x4F] = "Acolytes Nostrum";     items_t[0x50] = "Saints Nostrum";
items_t[0x51] = "Alchemists Reagent";   items_t[0x52] = "Sorcerers Reagent";
items_t[0x53] = "Yggdrasils Tears";     items_t[0x54] = "Faerie Chortle";
items_t[0x55] = "Spirit Orison";        items_t[0x56] = "Angelic Paean";
items_t[0x57] = "Panacea";              items_t[0x58] = "Snowfly Draught";
items_t[0x59] = "Faerie Wing";          items_t[0x5A] = "Elixir Of Kings";
items_t[0x5B] = "Elixir Of Sages";      items_t[0x5C] = "Elixir Of Dragoons";
items_t[0x5D] = "Elixir Of Queens";     items_t[0x5E] = "Elixir Of Mages";
items_t[0x5F] = "Valens";               items_t[0x60] = "Prudens";
items_t[0x61] = "Volare";               items_t[0x62] = "Audentia";
items_t[0x63] = "Virtus";               items_t[0x64] = "Eye Of Argon";
--Grimoire Items
items_t[0x82] = "Grimoire Zephyr";      items_t[0x83] = "Grimoire Teslae";
items_t[0x84] = "Grimoire Incendie";    items_t[0x85] = "Grimoire Terre";
items_t[0x86] = "Grimoire Glace";       items_t[0x87] = "Grimoire Lux";
items_t[0x88] = "Grimoire Pater";       items_t[0x89] = "Grimoire Exsorcer";
items_t[0x8A] = "Grimoire Banish";      items_t[0x8B] = "Grimoire Demolir";
items_t[0x93] = "Grimoire Flamme";      items_t[0x97] = "Grimoire Gaea";
items_t[0x9B] = "Grimoire Avalanche";   items_t[0x9F] = "Grimoire Radius";
items_t[0xA1] = "Grimoire Meteore";     items_t[0xA7] = "Grimoire Egout";
items_t[0xA8] = "Grimoire Demance";     items_t[0xA9] = "Grimoire Guerir";
items_t[0xAA] = "Grimoire Mollesse";    items_t[0xAB] = "Grimoire Antidote";
items_t[0xAC] = "Grimoire Benir";       items_t[0xAD] = "Grimoire Purifier";
items_t[0xAE] = "Grimoire Vie";         items_t[0xAF] = "Grimoire Intensite";
items_t[0xB0] = "Grimoire Debile";      items_t[0xB1] = "Grimoire Eclairer";
items_t[0xB2] = "Grimoire Nuageux";     items_t[0xB3] = "Grimoire Agilite";
items_t[0xB4] = "Grimoire Tardif";      items_t[0xB5] = "Grimoire Ameliorer";
items_t[0xB6] = "Grimoire Deterior";    items_t[0xB7] = "Grimoire Muet";
items_t[0xB8] = "Grimoire Annuler";     items_t[0xB9] = "Grimoire Paralysie";
items_t[0xBA] = "Grimoire Venin";       items_t[0xBB] = "Grimoire Fleau";
items_t[0xBC] = "Grimoire Halte";       items_t[0xBD] = "Grimoire Dissiper";
items_t[0xBE] = "Grimoire Clef";        items_t[0xBF] = "Grimoire Visual";
items_t[0xC0] = "Grimoire Snalyse";     items_t[0xC1] = "Grimoire Sylphe";
items_t[0xC2] = "Grimoire Salamander";  items_t[0xC3] = "Grimoire Gnome";
items_t[0xC4] = "Grimoire Undine";      items_t[0xC5] = "Grimoire Parebrise";
items_t[0xC6] = "Grimoire Ignifuge";    items_t[0xC7] = "Grimoire Rempart";
items_t[0xC8] = "Grimoire Barrer";    
-- Key Items (On Max Codes Change 007F to 0001 For The Key Items)";
items_t[0xCA] = "Bronze Key";           items_t[0xCB] = "Iron Key";
items_t[0xCC] = "Silver Key";           items_t[0xCD] = "Gold Key";
items_t[0xCE] = "Platinum Key";         items_t[0xCF] = "Steel Key";
items_t[0xD0] = "Crimson Key";          items_t[0xD1] = "Chest Key";
items_t[0xD2] = "Chamomile Sigil";      items_t[0xD3] = "Lily Sigil";
items_t[0xD4] = "Tearose Sigil";        items_t[0xD5] = "Clematis Sigil";
items_t[0xD6] = "Hyacinth Sigil";       items_t[0xD7] = "Fern Sigil";
items_t[0xD8] = "Aster Sigil";          items_t[0xD9] = "Eulelia Sigil";
items_t[0xDA] = "Melissa Sigil";        items_t[0xDB] = "Calla Sigil";
items_t[0xDC] = "Laurel Sigil";         items_t[0xDD] = "Acacia Sigil";
items_t[0xDE] = "Palm Sigil";           items_t[0xDF] = "Kalmia Sigil";
items_t[0xE0] = "Colombine Sigil";      items_t[0xE1] = "Anemone Sigil";
items_t[0xE2] = "Verbena Sigil";        items_t[0xE3] = "Schirra Sigil";
items_t[0xE4] = "Marigold Sigil";       items_t[0xE5] = "Azalea Sigil";
items_t[0xE6] = "Tigertail Sigil";      items_t[0xE7] = "Stock Sigil";
items_t[0xE8] = "Cattleya Sigil";       items_t[0xE9] = "Mandrake Sigil";


area_t = {}
area_t[1] = "Unmapped";               area_t[2] = "Wine Cellar"
area_t[3] = "Catacombs";              area_t[4] = "Sanctum"
area_t[5] = "Abandoned Mines B1";     area_t[6] = "Abandoned Mines B2"
area_t[7] = "Limestone Quarry";       area_t[8] = "Temple of Kiltia"
area_t[9] = "Great Cathedral B1";     area_t[10] = "Great Cathedral L1"
area_t[11] = "Great Cathedral L2";    area_t[12] = "Great Cathedral L3"
area_t[13] = "Great Cathedral L4";    area_t[14] = "Forgotten Pathway"
area_t[15] = "Escapeway";             area_t[16] = "Iron Maiden B1"
area_t[17] = "Iron Maiden B2";        area_t[18] = "Iron Maiden B3"
area_t[20] = "Undercity West";        area_t[21] = "Undercity East"
area_t[22] = "The Keep";              area_t[23] = "City Walls West"
area_t[24] = "City Walls South";      area_t[25] = "City Walls East"
area_t[26] = "City Walls North";      area_t[27] = "Snowfly Forest"
area_t[28] = "Snowfly Forest East";   area_t[29] = "Town Center West"
area_t[30] = "Town Center South";     area_t[31] = "Town Center East"
area_t[19] = "unused (Town Center, but very different)"
area_t[32] = "unused (Snowfly Forest)"

area_t2 = {
 "Unmapped"              ,"Wine Cellar"         ,"Catacombs"             ,"Sanctum"
,"Abandoned Mines B1"    ,"Abandoned Mines B2"  ,"Limestone Quarry"      ,"Temple of Kiltia"
,"Great Cathedral B1"    ,"Great Cathedral L1"  ,"Great Cathedral L2"    ,"Great Cathedral L3"
,"Great Cathedral L4"    ,"Forgotten Pathway"   ,"Escapeway"             ,"Iron Maiden B1"
,"Iron Maiden B2"        ,"Iron Maiden B3"      ,"unused (Town Center)"  ,"Undercity West"
,"Undercity East"        ,"The Keep"            ,"City Walls West"       ,"City Walls South"
,"City Walls East"       ,"City Walls North"    ,"Snowfly Forest"        ,"Snowfly Forest East"
,"Town Center West"      ,"Town Center South"   ,"Town Center East"      ,"unused (Snowfly Forest)"
}


map_t = {
{area = 1, id = 10,    desc = "Ashley and Merlose outside the Wine Cellar gate"},
{area = 1, id = 12,    desc = "Wine Cellar: The Gallows (Mino Zombie, new chest)"},
{area = 1, id = 18,    desc = "Bardorba and Rosencrantz"},
{area = 1, id = 19,    desc = "Ashley's flashback"},
{area = 1, id = 20,    desc = "VKP briefing"},
{area = 1, id = 21,    desc = "Ashley meets Merlose outside manor"},
{area = 1, id = 23,    desc = "Great Cathedral: unused room5"},
{area = 1, id = 26,    desc = "Ashley finds Sydney in the Cathedral"},
{area = 1, id = 27,    desc = "Ashley fights Guildestern, part 1"},
{area = 1, id = 33,    desc = "Merlose finds corpses at Leà Monde's entrance"},
{area = 1, id = 57,    desc = "Great Cathedral: Hardin's past"},
{area = 1, id = 58,    desc = "Joshua's dream"},
{area = 1, id = 59,    desc = "Great Cathedral: Sydney reaches Hardin and Guildestern"},
{area = 1, id = 60,    desc = "Ending - Escape from Leà Monde"},
{area = 1, id = 61,    desc = "Collapse of Leà Monde1"},
{area = 1, id = 62,    desc = "Collapse of Leà Monde2"},
{area = 1, id = 63,    desc = "Collapse of Leà Monde3"},
{area = 1, id = 64,    desc = "Collapse of Leà Monde4"},
{area = 1, id = 65,    desc = "Big Bang"},
{area = 1, id = 66,    desc = "Hardin dies"},
{area = 1, id = 67,    desc = "Bardorba reunion"},
{area = 1, id = 68,    desc = "So began the story of the vagrant"},
{area = 1, id = 69,    desc = "Merlose questions Hardin"},
{area = 1, id = 70,    desc = "The Dark tempts Ashley"},
{area = 1, id = 96,    desc = "Debug pathfinding"},
{area = 1, id = 97,    desc = "Debug1"},
{area = 1, id = 98,    desc = "Debug2"},
{area = 1, id = 99,    desc = "Debug AI"},
{area = 1, id = 100,   desc = "Debug traps, goto degub room"},
{area = 1, id = 250,   desc = "Debug room (MAPs)"},
{area = 1, id = 278,   desc = "Great Cathedral: unused room1"},
{area = 1, id = 283,   desc = "Ashley fights Guildestern, part 2"},
{area = 1, id = 285,   desc = "Keep: unused room"},
{area = 1, id = 534,   desc = "Great Cathedral: unused room2"},
{area = 1, id = 790,   desc = "Great Cathedral: unused room3"},
{area = 1, id = 1302,  desc = "Great Cathedral: unused room4"},
{area = 1, id = 1805,  desc = "Catacombs: unused room"},
{area = 1, id = 2063,  desc = "Sanctum: Passage of the Refugees (after cloudstone activated)"},
{area = 1, id = 2319,  desc = "Sanctum: unused room"},
{area = 1, id = 3337,  desc = "Wine Cellar: Chamber of Fear (after the quake)"},
{area = 1, id = 3593,  desc = "Ashley and Merlose at the Wine Cellar gate"},
{area = 1, id = 3616,  desc = "Town Center: unused room1"},
{area = 1, id = 4365,  desc = "Catacombs: The Lamenting Mother (after the quake)"},
{area = 1, id = 4617,  desc = "Wine Cellar: Room of Rotten Grapes (after defeating Lich)"},
{area = 1, id = 5152,  desc = "Town Center: unused room2"},
{area = 1, id = 5408,  desc = "Town Center: unused room3"},
{area = 1, id = 5664,  desc = "Town Center: unused room4"},
{area = 1, id = 5920,  desc = "Town Center: unused room5"},
{area = 1, id = 7733,  desc = "Limestone Quarry: unused room"},
{area = 2, id = 9,     desc = "Entrance to Darkness"},
{area = 2, id = 11,    desc = "The Hero's Winehall"},
{area = 2, id = 12,    desc = "The Gallows"},
{area = 2, id = 265,   desc = "Room of Cheap Red Wine"},
{area = 2, id = 521,   desc = "Room of Cheap White Wine"},
{area = 2, id = 777,   desc = "Hall of Struggle"},
{area = 2, id = 1033,  desc = "Smokebarrel Stair"},
{area = 2, id = 1289,  desc = "Wine Guild Hall"},
{area = 2, id = 1545,  desc = "Wine Magnate's Chambers"},
{area = 2, id = 1801,  desc = "Fine Vintage Vault"},
{area = 2, id = 2057,  desc = "Chamber of Fear"},
{area = 2, id = 2313,  desc = "The Reckoning Room"},
{area = 2, id = 2569,  desc = "A Laborer's Thirst"},
{area = 2, id = 2825,  desc = "The Rich Drown in Wine"},
{area = 2, id = 3081,  desc = "Room of Rotten Grapes"},
{area = 2, id = 3849,  desc = "The Greedy One's Den"},
{area = 2, id = 4105,  desc = "Worker's Breakroom"},
{area = 2, id = 4361,  desc = "Blackmarket of Wines"},
{area = 3, id = 13,    desc = "Hall of Sworn Revenge"},
{area = 3, id = 14,    desc = "The Beast's Domain"},
{area = 3, id = 42,    desc = "Workshop Work of Art"},
{area = 3, id = 269,   desc = "The Last Blessing"},
{area = 3, id = 525,   desc = "The Weeping Corridor"},
{area = 3, id = 781,   desc = "Persecution Hall"},
{area = 3, id = 1037,  desc = "The Lamenting Mother"},
{area = 3, id = 1293,  desc = "Rodent"},
{area = 3, id = 1549,  desc = "Shrine to the Martyrs"},
{area = 3, id = 2061,  desc = "Hall of Dying Hope"},
{area = 3, id = 2317,  desc = "Bandits' Hideout"},
{area = 3, id = 2573,  desc = "The Bloody Hallway"},
{area = 3, id = 2829,  desc = "Faith Overcame Fear"},
{area = 3, id = 3085,  desc = "The Withered Spring"},
{area = 3, id = 3341,  desc = "Repent, O ye Sinners"},
{area = 3, id = 3597,  desc = "The Reaper's Victims"},
{area = 3, id = 3853,  desc = "The Last Stab of Hope"},
{area = 3, id = 4109,  desc = "Hallway of Heroes"},
{area = 4, id = 15,    desc = "Prisoners' Niche"},
{area = 4, id = 16,    desc = "Hall of Sacrilege"},
{area = 4, id = 17,    desc = "The Cleansing Chantry"},
{area = 4, id = 271,   desc = "Corridor of the Clerics"},
{area = 4, id = 527,   desc = "Priests' Confinement"},
{area = 4, id = 783,   desc = "Alchemists' Laboratory"},
{area = 4, id = 1039,  desc = "Theology Classroom"},
{area = 4, id = 1295,  desc = "Shrine of the Martyrs"},
{area = 4, id = 1551,  desc = "Advent Ground"},
{area = 4, id = 1807,  desc = "Passage of the Refugees"},
{area = 4, id = 2575,  desc = "Stairway to the Light"},
{area = 4, id = 2831,  desc = "Hallowed Hope"},
{area = 4, id = 3087,  desc = "The Academia Corridor"},
{area = 5, id = 50,    desc = "Dreamers' Entrance"},
{area = 5, id = 306,   desc = "Miners' Resting Hall"},
{area = 5, id = 562,   desc = "The Crossing"},
{area = 5, id = 818,   desc = "Conflict and Accord"},
{area = 5, id = 1074,  desc = "The Suicide King"},
{area = 5, id = 1330,  desc = "The End of the Line"},
{area = 5, id = 1586,  desc = "The Battle's Beginning"},
{area = 5, id = 1842,  desc = "What Lies Ahead?"},
{area = 5, id = 2098,  desc = "The Fruits of Friendship"},
{area = 5, id = 2354,  desc = "The Earthquake's Mark"},
{area = 5, id = 2610,  desc = "Coal Mine Storage"},
{area = 5, id = 2866,  desc = "The Passion of Lovers"},
{area = 5, id = 3122,  desc = "The Hall of Hope"},
{area = 5, id = 3378,  desc = "The Dark Tunnel"},
{area = 5, id = 3634,  desc = "Rust in Peace"},
{area = 5, id = 3890,  desc = "Everwant Passage"},
{area = 5, id = 4146,  desc = "Mining Regrets"},
{area = 5, id = 4402,  desc = "The Smeltry"},
{area = 5, id = 4658,  desc = "Clash of Hyaenas"},
{area = 5, id = 4914,  desc = "Greed Knows No Bounds"},
{area = 5, id = 5170,  desc = "Live Long and Prosper"},
{area = 5, id = 5426,  desc = "Pray to the Mineral Gods"},
{area = 5, id = 5682,  desc = "Traitor's Parting"},
{area = 5, id = 5938,  desc = "Escapeway"},
{area = 6, id = 51,    desc = "Gambler's Passage"},
{area = 6, id = 307,   desc = "Treaty Room"},
{area = 6, id = 563,   desc = "The Miner's End"},
{area = 6, id = 819,   desc = "Work, Then Die"},
{area = 6, id = 1075,  desc = "Bandits' Hollow"},
{area = 6, id = 1331,  desc = "Delusions of Happiness"},
{area = 6, id = 1587,  desc = "Dining in Darkness"},
{area = 6, id = 1843,  desc = "Subtellurian Horrors"},
{area = 6, id = 2099,  desc = "Hidden Resources"},
{area = 6, id = 2355,  desc = "Way of Lost Children"},
{area = 6, id = 2611,  desc = "Hall of the Empty Sconce"},
{area = 6, id = 2867,  desc = "Acolyte's Burial Vault"},
{area = 6, id = 3123,  desc = "Hall of Contemplation"},
{area = 6, id = 3379,  desc = "The Abandoned Catspaw"},
{area = 6, id = 3635,  desc = "Tomb of the Reborn"},
{area = 6, id = 3891,  desc = "The Fallen Bricklayer"},
{area = 6, id = 4147,  desc = "Crossing of Blood"},
{area = 6, id = 4403,  desc = "Fool's Gold, Fool's Loss"},
{area = 6, id = 4659,  desc = "Cry of the Beast"},
{area = 6, id = 4915,  desc = "Senses Lost"},
{area = 6, id = 5171,  desc = "Desire's Passage"},
{area = 6, id = 5427,  desc = "Kilroy Was Here"},
{area = 6, id = 5683,  desc = "Suicidal Desires"},
{area = 6, id = 5939,  desc = "The Ore of Legend"},
{area = 6, id = 6195,  desc = "Lambs to the Slaughter"},
{area = 6, id = 6451,  desc = "A Wager of Noble Gold"},
{area = 6, id = 6707,  desc = "The Lunatic Veins"},
{area = 6, id = 6963,  desc = "Corridor of Shade"},
{area = 6, id = 7219,  desc = "Revelation Shaft"},
{area = 7, id = 53,    desc = "Dark Abhors Light"},
{area = 7, id = 309,   desc = "Dream of the Holy Land"},
{area = 7, id = 565,   desc = "The Ore Road"},
{area = 7, id = 821,   desc = "Atone for Eternity"},
{area = 7, id = 1077,  desc = "The Air Stirs"},
{area = 7, id = 1333,  desc = "Bonds of Friendship"},
{area = 7, id = 1589,  desc = "Stair to Sanctuary"},
{area = 7, id = 1845,  desc = "The Fallen Hall"},
{area = 7, id = 2101,  desc = "The Rotten Core"},
{area = 7, id = 2357,  desc = "Bacchus is Cheap"},
{area = 7, id = 2613,  desc = "Screams of the Wounded"},
{area = 7, id = 2869,  desc = "The Ore"},
{area = 7, id = 3125,  desc = "The Dreamer's Climb"},
{area = 7, id = 3381,  desc = "Sinner's Sustenence"},
{area = 7, id = 3637,  desc = "The Timely Dew of Sleep"},
{area = 7, id = 3893,  desc = "Companions in Arms"},
{area = 7, id = 4149,  desc = "The Auction Block"},
{area = 7, id = 4405,  desc = "Ascension"},
{area = 7, id = 4661,  desc = "Where the Serpent Hunts"},
{area = 7, id = 4917,  desc = "Ants Prepare for Winter"},
{area = 7, id = 5173,  desc = "Drowned in Fleeting Joy"},
{area = 7, id = 5429,  desc = "The Laborer's Bonfire"},
{area = 7, id = 5685,  desc = "Stone and Sulfurous Fire"},
{area = 7, id = 5941,  desc = "Torture Without End"},
{area = 7, id = 6197,  desc = "Way Down"},
{area = 7, id = 6453,  desc = "Excavated Hollow"},
{area = 7, id = 6709,  desc = "Parting Regrets"},
{area = 7, id = 6965,  desc = "Corridor of Tales"},
{area = 7, id = 7221,  desc = "Dust Shall Eat the Days"},
{area = 7, id = 7477,  desc = "Hall of the Wage"},
{area = 7, id = 7989,  desc = "Tunnel of the Heartless"},
{area = 8, id = 30,    desc = "The Dark Coast"},
{area = 8, id = 31,    desc = "Chamber of Reason"},
{area = 8, id = 286,   desc = "Hall of Prayer"},
{area = 8, id = 287,   desc = "Exit to City Center"},
{area = 8, id = 542,   desc = "Those who Drink the Dark"},
{area = 8, id = 798,   desc = "The Chapel of Meschaunce"},
{area = 8, id = 1054,  desc = "The Resentful Ones"},
{area = 8, id = 1310,  desc = "Those who Fear the Light"},
{area = 9, id = 22,    desc = "Sanity and Madness"},
{area = 9, id = 1046,  desc = "Truth and Lies"},
{area = 9, id = 1558,  desc = "Order and Chaos"},
{area = 9, id = 1814,  desc = "The Victor's Laurels"},
{area = 9, id = 2070,  desc = "Struggle for the Soul"},
{area = 9, id = 2326,  desc = "An Offering of Souls"},
{area = 10, id = 24,   desc = "The Flayed Confessional"},
{area = 10, id = 280,  desc = "Monk's Leap"},
{area = 10, id = 536,  desc = "Where Darkness Spreads"},
{area = 10, id = 792,  desc = "Hieratic Recollections"},
{area = 10, id = 1048, desc = "A Light in the Dark"},
{area = 10, id = 1304, desc = "The Poisoned Chapel"},
{area = 10, id = 1560, desc = "Sin and Punishment"},
{area = 10, id = 1816, desc = "Cracked Pleasures"},
{area = 10, id = 2072, desc = "Into Holy Battle"},
{area = 11, id = 25,   desc = "An Arrow into Darkness"},
{area = 11, id = 279,  desc = "He Screams for Mercy"},
{area = 11, id = 281,  desc = "What Ails You, Kills You"},
{area = 11, id = 535,  desc = "Light and Dark Wage War"},
{area = 11, id = 791,  desc = "Abasement from Above"},
{area = 11, id = 2328, desc = "Maelstrom of Malice"},
{area = 11, id = 2584, desc = "The Acolyte's Weakness"},
{area = 11, id = 2840, desc = "The Hall of Broken Vows"},
{area = 11, id = 3096, desc = "The Melodics of Madness"},
{area = 11, id = 3352, desc = "Free from Base Desires"},
{area = 11, id = 3608, desc = "The Convent Room"},
{area = 12, id = 537,  desc = "Where the Soul Rots"},
{area = 12, id = 793,  desc = "Despair of the Fallen"},
{area = 12, id = 1047, desc = "The Heretics' Story"},
{area = 12, id = 1303, desc = "The Wine"},
{area = 12, id = 3864, desc = "Hopes of the Idealist"},
{area = 13, id = 1049, desc = "The Atrium"},
{area = 14, id = 54,   desc = "Stair to the Sinners"},
{area = 14, id = 310,  desc = "Slaugher of the Innocent"},
{area = 14, id = 566,  desc = "The Fallen Knight"},
{area = 14, id = 822,  desc = "The Oracle Sins No More"},
{area = 14, id = 1078, desc = "Awaiting Retribution"},
{area = 15, id = 52,   desc = "Shelter From the Quake"},
{area = 15, id = 308,  desc = "Buried Alive"},
{area = 15, id = 564,  desc = "Movement of Fear"},
{area = 15, id = 820,  desc = "Facing Your Illusions"},
{area = 15, id = 1076, desc = "The Darkness Drinks"},
{area = 15, id = 1332, desc = "Fear and Loathing"},
{area = 15, id = 1588, desc = "Blood and the Beast"},
{area = 15, id = 1844, desc = "Where Body and Soul Part"},
{area = 16, id = 55,   desc = "The Cage"},
{area = 16, id = 311,  desc = "The Cauldron"},
{area = 16, id = 567,  desc = "Wooden Horse"},
{area = 16, id = 823,  desc = "Starvation"},
{area = 16, id = 1079, desc = "The Breast Ripper"},
{area = 16, id = 1335, desc = "The Pear"},
{area = 16, id = 1591, desc = "The Whirligig"},
{area = 16, id = 1847, desc = "Spanish Tickler"},
{area = 16, id = 2103, desc = "Heretic's Fork"},
{area = 16, id = 2359, desc = "The Chair of Spikes"},
{area = 16, id = 2615, desc = "Blooding"},
{area = 16, id = 2871, desc = "Bootikens"},
{area = 16, id = 3127, desc = "Burial"},
{area = 16, id = 3383, desc = "Burning"},
{area = 16, id = 3639, desc = "Cleansing the Soul"},
{area = 16, id = 3895, desc = "The Garotte"},
{area = 16, id = 4151, desc = "Hanging"},
{area = 16, id = 4407, desc = "Impalement"},
{area = 16, id = 4663, desc = "Knotting"},
{area = 16, id = 4919, desc = "The Branks"},
{area = 16, id = 5175, desc = "The Wheel"},
{area = 16, id = 5431, desc = "The Judas Cradle"},
{area = 16, id = 5687, desc = "The Ducking Stool"},
{area = 17, id = 56,   desc = "The Eunics' Lot"},
{area = 17, id = 312,  desc = "Ordeal By Fire"},
{area = 17, id = 568,  desc = "Tablillas"},
{area = 17, id = 824,  desc = "The Oven at Neisse"},
{area = 17, id = 1080, desc = "Strangulation"},
{area = 17, id = 1336, desc = "Pressing"},
{area = 17, id = 1592, desc = "The Strappado"},
{area = 17, id = 1848, desc = "The Mind Burns"},
{area = 17, id = 2104, desc = "Thumbscrews"},
{area = 17, id = 2360, desc = "The Rack"},
{area = 17, id = 2616, desc = "The Saw"},
{area = 17, id = 2872, desc = "Ordeal By Water"},
{area = 17, id = 3128, desc = "The Cold's Bridle"},
{area = 17, id = 3384, desc = "Brank"},
{area = 17, id = 3640, desc = "The Shin"},
{area = 17, id = 3896, desc = "Squassation"},
{area = 17, id = 4152, desc = "The Spider"},
{area = 17, id = 4408, desc = "Lead Sprinkler"},
{area = 17, id = 4664, desc = "Pendulum"},
{area = 17, id = 4920, desc = "Dragging"},
{area = 17, id = 5176, desc = "Tongue Slicer"},
{area = 17, id = 5432, desc = "Tormentum Insomniae"},
{area = 18, id = 5688, desc = "The Iron Maiden"},
{area = 18, id = 5944, desc = "Saint Elmo's Belt"},
{area = 18, id = 6200, desc = "Judgement"},
{area = 18, id = 6456, desc = "Dunking the Witch"},
{area = 20, id = 47,   desc = "Workshop Godhands"},
{area = 20, id = 48,   desc = "The Bread Peddler's Way"},
{area = 20, id = 304,  desc = "Way of the Mother Lode"},
{area = 20, id = 560,  desc = "Sewer of Ravenous Rats"},
{area = 20, id = 816,  desc = "Underdark Fishmarket"},
{area = 20, id = 1072, desc = "The Sunless Way"},
{area = 20, id = 1328, desc = "Remembering Days of Yore"},
{area = 20, id = 1584, desc = "Where the Hunter Climbed"},
{area = 20, id = 1840, desc = "Larder for a Lean Winter"},
{area = 20, id = 2096, desc = "Hall of Poverty"},
{area = 20, id = 2352, desc = "The Washing"},
{area = 20, id = 2608, desc = "Beggars of the Mouthharp"},
{area = 20, id = 2864, desc = "Corner of the Wretched"},
{area = 20, id = 3120, desc = "Path to the Greengrocer"},
{area = 20, id = 3376, desc = "Crossroads of Rest"},
{area = 20, id = 3632, desc = "Path of the Children"},
{area = 20, id = 3888, desc = "Fear of the Fall"},
{area = 20, id = 4144, desc = "Sinner's Corner"},
{area = 20, id = 4400, desc = "Nameless Dark Oblivion"},
{area = 20, id = 4656, desc = "Corner of Prayers"},
{area = 20, id = 4912, desc = "Hope Obstructed"},
{area = 20, id = 5168, desc = "The Children's Hideout"},
{area = 20, id = 5424, desc = "The Crumbling Market"},
{area = 20, id = 5680, desc = "Tears from Empty Sockets"},
{area = 20, id = 5936, desc = "Where Flood Waters Ran"},
{area = 20, id = 6192, desc = "The Body Fragile Yields"},
{area = 20, id = 6448, desc = "Salvation for the Mother"},
{area = 20, id = 6704, desc = "Bite the Master's Wounds"},
{area = 21, id = 49,   desc = "Hall to a New World"},
{area = 21, id = 305,  desc = "Place of Free Words"},
{area = 21, id = 561,  desc = "Bazaar of the Bizarre"},
{area = 21, id = 817,  desc = "Noble Gold and Silk"},
{area = 21, id = 1073, desc = "A Knight Sells his Sword"},
{area = 21, id = 1329, desc = "Gemsword Blackmarket"},
{area = 21, id = 1585, desc = "The Pirate's Son"},
{area = 21, id = 1841, desc = "Sale of the Sword"},
{area = 21, id = 2097, desc = "Weapons Not Allowed"},
{area = 21, id = 2353, desc = "The Greengrocer's Stair"},
{area = 21, id = 2609, desc = "Where Black Waters Ran"},
{area = 21, id = 2865, desc = "Arms Against Invaders"},
{area = 21, id = 3121, desc = "Catspaw Blackmarket"},
{area = 22, id = 29,   desc = "The Warrior's Rest"},
{area = 22, id = 44,   desc = "Wkshop Keane's Crafts"},
{area = 22, id = 541,  desc = "The Soldier's Bedding"},
{area = 22, id = 797,  desc = "A Storm of Arrows"},
{area = 22, id = 1053, desc = "Urge the Boy On"},
{area = 22, id = 1309, desc = "A Taste of the Spoils"},
{area = 22, id = 1565, desc = "Wiping Blood from Blades"},
{area = 23, id = 28,   desc = "Students of Death"},
{area = 23, id = 284,  desc = "The Gabled Hall"},
{area = 23, id = 540,  desc = "Where the Master Fell"},
{area = 24, id = 796,  desc = "The Weeping Boy"},
{area = 24, id = 1052, desc = "Swords for the Land"},
{area = 24, id = 1308, desc = "In Wait of the Foe"},
{area = 24, id = 1564, desc = "Where Weary Riders Rest"},
{area = 24, id = 1820, desc = "The Boy's Training Room"},
{area = 25, id = 2076, desc = "Train and Grow Strong"},
{area = 25, id = 2332, desc = "The Squire's Gathering"},
{area = 25, id = 2588, desc = "The Invaders are Found"},
{area = 25, id = 2844, desc = "The Dream"},
{area = 25, id = 3100, desc = "The Cornered Savage"},
{area = 26, id = 3356, desc = "Traces of Invasion Past"},
{area = 26, id = 3612, desc = "From Squire to Knight"},
{area = 26, id = 3868, desc = "Be for Battle Prepared"},
{area = 26, id = 4124, desc = "Destruction and Rebirth"},
{area = 26, id = 4380, desc = "From Boy to Hero"},
{area = 26, id = 4636, desc = "A Welcome Invasion"},
{area = 27, id = 40,   desc = "The Hunt Begins"},
{area = 27, id = 296,  desc = "Which Way Home"},
{area = 27, id = 552,  desc = "The Giving Trees"},
{area = 27, id = 808,  desc = "The Wounded Boar"},
{area = 27, id = 1064, desc = "Golden Egg Way"},
{area = 27, id = 1320, desc = "The Birds and the Bees"},
{area = 27, id = 1576, desc = "The Woodcutter's Run"},
{area = 27, id = 1832, desc = "The Wolves' Choice"},
{area = 27, id = 2088, desc = "Howl of the Wolf King"},
{area = 27, id = 2344, desc = "Fluttering Hope"},
{area = 27, id = 2600, desc = "Traces of the Beast"},
{area = 27, id = 2856, desc = "The Yellow Wood"},
{area = 27, id = 3112, desc = "They Also Feed"},
{area = 27, id = 3368, desc = "Where Soft Rains Fell"},
{area = 27, id = 3624, desc = "The Spirit Trees"},
{area = 27, id = 3880, desc = "The Silent Hedges"},
{area = 27, id = 4136, desc = "Lamenting to the Moon"},
{area = 27, id = 4392, desc = "The Hollow Hills"},
{area = 27, id = 4648, desc = "Running with the Wolves"},
{area = 27, id = 4904, desc = "You Are the Prey"},
{area = 27, id = 5160, desc = "The Secret Path"},
{area = 27, id = 5416, desc = "The Faerie Circle"},
{area = 27, id = 5672, desc = "Return to the Land"},
{area = 27, id = 5928, desc = "Forest River"},
{area = 27, id = 6184, desc = "Hewn from Nature"},
{area = 27, id = 6440, desc = "The Wood Gate"},
{area = 28, id = 41,   desc = "Steady the Boar"},
{area = 28, id = 297,  desc = "The Boar's Revenge"},
{area = 28, id = 553,  desc = "Nature's Womb"},
{area = 29, id = 32,   desc = "Rue Vermillion"},
{area = 29, id = 34,   desc = "Dinas Walk"},
{area = 29, id = 43,   desc = "Workshop Magic Hammer"},
{area = 29, id = 288,  desc = "The Rene Coastroad"},
{area = 29, id = 544,  desc = "Rue Mal Fallde"},
{area = 29, id = 800,  desc = "Tircolas Flow"},
{area = 29, id = 1056, desc = "Glacialdra Kirk Ruins"},
{area = 29, id = 1312, desc = "Rue Bouquet"},
{area = 29, id = 1568, desc = "Villeport Way"},
{area = 29, id = 1824, desc = "Rue Sant D'alsa"},
{area = 30, id = 35,   desc = "Zebel's Walk"},
{area = 30, id = 37,   desc = "The House Khazabas"},
{area = 30, id = 2080, desc = "Valdiman Gates"},
{area = 30, id = 2336, desc = "Rue Faltes"},
{area = 30, id = 2592, desc = "Forcas Rise"},
{area = 30, id = 2848, desc = "Rue Aliano"},
{area = 30, id = 3104, desc = "Rue Volnac"},
{area = 30, id = 3360, desc = "Rue Morgue"},
{area = 31, id = 36,   desc = "Gharmes Walk"},
{area = 31, id = 38,   desc = "The House Gilgitte"},
{area = 31, id = 39,   desc = "Plateia Lumitar"},
{area = 31, id = 45,   desc = "Workshop Metal Works"},
{area = 31, id = 46,   desc = "Wkshop Junction Point"},
{area = 31, id = 3872, desc = "Rue Lejour"},
{area = 31, id = 4128, desc = "Kesch Bridge"},
{area = 31, id = 4384, desc = "Rue Crimnade"},
{area = 31, id = 4640, desc = "Rue Fisserano"},
{area = 31, id = 4896, desc = "Shasras Hill Park"}
}
