gui = require 'gui'
w = require 'widgets'

mem      = PCSX.getMemPtr()

-- The rng address may change depending of the bios, it might be 0x800086cc for example
seedAdd  = 0x80009010 -- scph5501.bin
seedPtr  = ffi.cast('uint32_t*', mem +  bit.band( seedAdd, 0x1fffff))

gui.setOutput(
  function() 
    gui.addmessage( w.vblankCtr  )
    gui.addmessage( '--------' )
    gui.addmessage( w.rngCounter )
    gui.addmessage( w.rngTable(seedPtr,19,4) )
    gui.printCoordinates()
  end
)