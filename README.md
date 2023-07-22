# Spell Action Bar

## Short description
This project is to make additional spell action bars on version 3.3.5a. 

Action Bar is added starting from the Cataclysm add-on and above. Often used in quests and scenarios. You will be able to make used spells through the database as on newer versions. This will allow you to update the perception of the game.

## How it works
Inside the project contains 2 script handler files, which are linked together for better code readability. I made 2 files - Controller and Entity

**Entity** is the main module that deals with offloading information from the database and directly structuring the query. 
**Controller** is a secondary module which is responsible for event handling. It also describes the scenarios in which the script will trigger and run the spell.
