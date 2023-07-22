# Spell Action Bar

## Short description
This project is to make additional spell action bars on version 3.3.5a. 

Action Bar is added starting from the Cataclysm add-on and above. Often used in quests and scenarios. You will be able to make used spells through the database as on newer versions. This will allow you to update the perception of the game.

## How it works
Inside the project contains 2 script handler files, which are linked together for better code readability. I made 2 files - Controller and Entity

**Entity** is the main module that deals with offloading information from the database and directly structuring the query. 

**Controller** is a secondary module which is responsible for event handling. It also describes the scenarios in which the script will trigger and run the spell.

## Installation
First, make sure your project's dependencies(last revision of [AzerothCore](https://www.azerothcore.org/), [mod-eluna](https://github.com/azerothcore/mod-eluna) and [AIO](https://github.com/Rochet2/AIO)) are correctly installed.

Then clone this repository in the appropriate directory of your project.
```bash
https://github.com/ElementoBorzi/lua-spell-action-bar.git
```

Make a Patch with ClientSide content, simply, take the interface folder and drag it into a patch.
Share the patch with players.

**Database schema**

Make sure your database contains the tables required for the application. You can find the necessary schema in the database.sql file included in this repository.

```sql
CREATE TABLE `index_spell_bonus_action` (
  `spell_id` int(10) NOT NULL,
  `overlay_texture` varchar(150) NOT NULL DEFAULT 'stormyellow-extrabutton',
  PRIMARY KEY (`spell_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `index_spell_bonus_action_conditions` (
  `spell_id` int(11) NOT NULL,
  `condition_type` enum('aura','item','item_equipped','map_id','zone_id','area_id','active_event','min_level','class','race','phase_mask','quest_rewarded','quest_incomplete','min_hp_pct','max_hp_pct') NOT NULL,
  `condition_value` int(11) DEFAULT NULL,
  PRIMARY KEY (`spell_id`,`condition_type`),
  CONSTRAINT `spell_id` FOREIGN KEY (`spell_id`) REFERENCES `index_spell_bonus_action` (`spell_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
```

## Configuration
Just edit the database name in : 
> lua-spell-action-bar\ServerSide\Config\Spell_Action_Bar_Cfg.lua

## Use
Once the project has been set up correctly, each player event will trigger a check of the conditions associated with that type of event (e.g. equipping an item). If all conditions are met, the corresponding effect will be triggered.

## Exemple
I'd like to display spell 59752 (Will to Survive) to players who have the hearthstone in their bags, in Northrend, Dalaran and Runeweaver Square.

**MySQL Code**
```sql
INSERT INTO `index_spell_bonus_action` VALUES ('59752', 'air-extrabutton');

INSERT INTO `index_spell_bonus_action_conditions` (`spell_id`, `condition_type`, `condition_value`) VALUES
('59752', 'item', '6948'),
('59752', 'map_id', '571'),
('59752', 'zone_id', '4395'),
('59752', 'area_id', '4739');
```

**In-game command**
```bash
.reload eluna
```

**MySQL Code**
```sql
INSERT INTO `index_spell_bonus_action` VALUES ('59752', 'air-extrabutton');

INSERT INTO `index_spell_bonus_action_conditions` (`spell_id`, `condition_type`, `condition_value`) VALUES
('59752', 'item', '6948'),
('59752', 'map_id', '571'),
('59752', 'zone_id', '4395'),
('59752', 'area_id', '4739');
```

**In-game command**
```bash
.reload eluna
```

**Result**

![image](https://github-production-user-asset-6210df.s3.amazonaws.com/125808072/255312077-ca18b050-c444-40fd-a0f6-dae72bff3501.png)
