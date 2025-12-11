# PCSXLuaScripts
A collection of scripts to be used with the [PCSX-Redux emulator](https://pcsx-redux.consoledev.net/) for the games I am working on.

## Summary

__widgets.lua__ implements several support functions, file loading functions and imgui helpers:
* drawFreezeCheck
* drawFrozen
* drawMemory
* drawColorPicker
* drawCheckbox
* drawSlider
* drawMemory
* drawInputInt
* drawDrag
* drawRadio
* drawJumpButton
* drawInputText
* drawSaveButton
* drawLoadButton
* drawLoadSave

__gui.lua__ implements the output process, and some helpers:
* drawRectangle
* text
* textBox
* addmessage

__out.lua__ is the file to replace the content of the original output.lua to enable drawing into the screen.

__disassembler.lua__ contains exactly that.

## Vagrant Story

It can display and edit values like enemies and Ashley's stats and coordinates, insert strings into memory, modify the inventory, load any room, freeze memory addresses and output text on top of the screen. It also has a custom lua memory display and saveStates manager.

__vg.lua__ is the main file and the one executed by the emulator.

__map.lua__ contains the area and text encoding info for the game.

Showcase video of a older version:
[![Showcase video](https://i3.ytimg.com/vi/Wyxv00NZJdc/maxresdefault.jpg)](https://youtu.be/Wyxv00NZJdc)

### Usage

Type into the lua console:

`dofile 'C:\\Path\\to\\vg.lua'`

Or use the command line arguments

`pcsx.exe -loadiso "Vagrant Story.bin" -dofile "vg.lua" `

## As a module

You can use this script for your own needs, just make sure to put all the files in the emulator path. Example:

```lua
gui = require 'gui'
w   = require 'widgets'

gui.setOutput(
  function() 
    gui.text(150,50,'Look at me')
    gui.textBox(150,75,'Look at me',{r = 1, g = 1, b = 0})
    gui.addmessage( 'Message' )
    gui.addmessage( '--------' )
    gui.printCoordinates()
  end
)

function DrawImguiFrame()
  
  imgui.safe.Begin('Title', true, function()
    w.drawSlider(0x80000000, 'Something', 'uint8_t*', 0, 0xFF)
  end)

end
```

