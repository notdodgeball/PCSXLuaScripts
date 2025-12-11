# vagrant-story-lua-script
A script to be used with the [PCSX-Redux emulator](https://pcsx-redux.consoledev.net/) for the game Vagrant Story.

It can display and edit values like enemies and Ashley's stats and coordinates, insert strings into memory, modify the inventory, load any room, freeze memory addresses and output text on top of the screen. It also has a custom lua memory display and saveStates manager.

 It needs the https://github.com/notdodgeball/PCSX-Redux-lua-scripts in the same folder.

## Summary

__vg.lua__ is the main file and the one executed by the emulator.

__map.lua__ contains the area and text encoding info for the game.

Showcase video of a older version:
[![Showcase video](https://i3.ytimg.com/vi/Wyxv00NZJdc/maxresdefault.jpg)](https://youtu.be/Wyxv00NZJdc)

## Usage

Type into the lua console:

`dofile 'C:\\Path\\to\\vg.lua'`

Or use the command line arguments

`pcsx.exe -loadiso "Vagrant Story.bin" -dofile "vg.lua" `


