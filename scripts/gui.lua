--========================================================
-- Screen output module for the pcsx-redux emulator
-- made by optrin
--========================================================

-- see: https://pcsx-redux.consoledev.net/Lua/rendering/
-- The logic flow: setOutput() => setScale() => draw()

-- Also implements the folowing bizhawk functions:
-- gui.addmessage, gui.drawRectangle, gui.text()

-- TODO:
-- color given as number "0xrrggbbaa" or as a string (e.g. "red")

local g = {}

g.filename = 'out.lua'
g.isOutputSet = false

-- Minimal X and Y offsets, mainly because of the Menu Bar 
g.minX = 10
g.minY = 40

function g.setOutput(func)

  -- Entry point of the whole print on screen process
  -- loads g.filename onto output.lua and
  -- sets a function, g.func, to be executed every cycle
  
  PCSX.GUI.OutputShader.setDefaults()
  
  local f = Support.File.open(g.filename)

  if not f:failed() then
    print('output.lua set with file ' .. g.filename .. ',size: ' .. f:size())
    PCSX.GUI.OutputShader.setTextL(f)
    g.isOutputSet = true
  else
    print('could not find file ' .. g.filename)
  end

  f:close()
  
  g.func = func

end


-- Screen size
g.dstSizeX   = 0
g.dstSizeY   = 0
g.cx         = 0
g.cy         = 0

-- Scaling factor
g.scaleX     = 0
g.scaleY     = 0

-- Formatting
g.fontSize   = 0
g.fontScale  = 9
g.lineHeight = 25

function g.setScale(dstSizeX,dstSizeY,cx,cy)

  -- This function is called by the output rendering process

  -- Set screen size
  g.dstSizeX   = dstSizeX
  g.dstSizeY   = dstSizeY
  g.cx         = cx
  g.cy         = cy

  -- Scaling factor based on the default 4:3 aspect ratio
  g.scaleX     = dstSizeX / 320
  g.scaleY     = dstSizeY / 240
  g.fontSize   = g.fontScale * g.scaleX

end


g.fontLoaded = false
g.fontFileName = '..\\fonts\\SpaceMono-Regular.ttf'

function g.setFont()

  -- createFont() has no error handling, we use File.open() for that
  -- fontFace() needs to be called every frame

  if not g.fontFile then
    g.fontFile = Support.File.open(g.fontFileName, 'READ')

    if not g.fontFile:failed() then
      print(g.fontFileName .. ' loaded')
      nvg:createFont('myfont', g.fontFileName)
      g.fontLoaded = true
    end
    
    g.fontFile:close()
  end
  
  if g.fontLoaded then
    nvg:fontFace('myfont')
  end
  
  nvg:fontSize(g.fontSize)
  
end


function g.ColorToNVG(colors, alpha)
  
  -- converts color table to a NVGcolor struct
  if colors == nil then -- or w.isArrayAllZeros(colors)
    colors = {r = 0, g = 1, b = 0}
  end
  
  local alpha = alpha or 200

  return  nvg.transRGBA( nvg.Color.New(colors.r, colors.g, colors.b) , alpha)
  -- return nvg.Color.New(colors.r, colors.g, colors.b, alpha)
  -- return nvg.RGBA(colors.r* 255, colors.g* 255, colors.b* 255, colors.a* 255)
end


function g.drawRectangle(x, y, width, height, strokeWidth, colors)
  
  -- equivalent to bizhawk gui.drawRectangle
  if not ffi.istype('NVGcolor', colors) then colors = g.ColorToNVG(colors) end
  
  nvg:beginPath()
  nvg:rect(x, y, width, height)
  nvg:strokeColor(colors)
  nvg:strokeWidth(strokeWidth)
  nvg:stroke()
  
end


function g.text(x,y,text,colors)
  -- equivalent to bizhawk gui.text
  nvg:text( g.minX + x, g.minY + y, tostring(text) )
end


function g.textBox(x,y,text,colors,maxWidth)

  -- gui.text within a box
  local maxWidth = maxWidth or 9999

  nvg:textBox( g.minX + x, g.minY + y, maxWidth, tostring(text) )
  local boxBounds = nvg:textBoxBounds(g.minX + x, g.minY + y, maxWidth, tostring(text))
  -- nvg:textBoxBounds returns [xmin,ymin,xmax,ymax]
  g.drawRectangle( boxBounds[0], boxBounds[1], boxBounds[2] - boxBounds[0] , boxBounds[3] - boxBounds[1] , 2 , colors)

end


g.offset     = 0

function g.addmessage(t,colors,maxWidth)

  -- prints into the screen left size, can be called multiple times at the same cycle.
  -- equivalent to bizhawk gui.addmessage
  output = ''
  local maxWidth = maxWidth or 9999
  
  if type(t) == 'string' or type(t) == 'number' then
    output = output .. '\n' .. t
  elseif type(t) == 'table' then
    for i,v in ipairs(t) do
      output = output .. '\n' .. tostring(v)
    end
  else
    error("wrong argument to addmessage()")
  end
  
  nvg:textBox( g.minX, g.minY + g.offset, maxWidth, tostring(output) )
  local boxBounds = nvg:textBoxBounds(g.minX , g.minY , maxWidth, tostring(output))
  -- nvg:textBoxBounds returns [xmin,ymin,xmax,ymax]
  
  if colors ~= nil then
    g.drawRectangle( boxBounds[0], boxBounds[1] + g.offset, boxBounds[2] - boxBounds[0] , boxBounds[3] - boxBounds[1] , 2, colors)
  end
  
  g.offset = g.offset + boxBounds[3] - boxBounds[1]

end


function g.printCoordinates()
  -- Coordinates for debugging
  g.addmessage( {g.scaleX,g.scaleY,g.dstSizeX,g.dstSizeY,g.cx,g.cy} )
end


function g.draw()
  
  -- main function
  -- the nvg context is only avaiable at nvg.queueNvgRender
  nvg:queueNvgRender(g.setFont)
  nvg:queueNvgRender(g.func)
  
  -- Every cycle we reset it so addmessage() will be at the same place
  g.offset = 0

end


return g