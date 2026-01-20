--========================================================
-- helper and dear imgui module for the pcsx-redux emulator
-- made by optrin
--========================================================

d = require 'disassembler'

local w = {}

local mem             = PCSX.getMemPtr()


-- Flags
--========================================================

w.textFlags       = bit.bor( imgui.constant.InputTextFlags.EnterReturnsTrue , imgui.constant.InputTextFlags.CharsNoBlank )

w.hexFlags        =  bit.bor ( 
    bit.bor( imgui.constant.InputTextFlags.CharsHexadecimal , imgui.constant.InputTextFlags.CharsUppercase )
  , bit.bor( imgui.constant.InputTextFlags.EnterReturnsTrue , imgui.constant.InputTextFlags.CharsNoBlank )
)

w.tableFlags      =  bit.bor ( 
    bit.bor( imgui.constant.TableFlags.NoSavedSettings , imgui.constant.TableFlags.NoClip ) -- Resizable
  , bit.bor( imgui.constant.TableFlags.NoPadOuterX   , imgui.constant.TableFlags.NoPadInnerX )
)

w.tabFlags        = bit.bor ( imgui.constant.TabBarFlags.TabListPopupButton , imgui.constant.TabBarFlags.AutoSelectNewTabs )



-- RNG
--========================================================

w.rngCounter = 0
w.RNGs = {}        -- our rand numbers
w.RNGsOut = {}     -- our formatted rand numbers for output

  -- ANSI C Linear Congruential Pseudo-RNG
local function nextRNG(value)
  local high = (value * 0x41C6) % 0x10000
  local low  = (value * 0x4E6D) % 0x100000000
  return ((low + high * 0x10000) % 0x100000000) + 0x3039
end


  -- Return previous, current and upcoming rng values
function w.rngTable(seedPtr,maxLines,current)

  current = current or 2                            -- the position of the current seed in the array
  local newRNG = seedPtr[0]
  
  if newRNG ~= w.RNGs[current] then
    
    w.rngCounter = w.rngCounter + 1
    
    -- mismatch (a loaded save more likely)
    local mismatch = newRNG ~= w.RNGs[current+1]
    if mismatch and newRNG and w.RNGs[current+1] then print('newRNG ' .. newRNG .. ', w.RNGs[current+1] ' .. w.RNGs[current+1]) end

    for i=1, maxLines do
    
      if i < current and (mismatch or newRNG == 0)      -- When no seed has yet been calculated or a mismatch
        then w.RNGs[i] = 0
      elseif i == current
        then w.RNGs[i] = newRNG
      elseif i == maxLines or mismatch                      -- new seeds when there is a mismatch or it's the last one
        then w.RNGs[i] = nextRNG( w.RNGs[i-1] )
      else                                              -- otherwise it's the following one
        w.RNGs[i] = w.RNGs[i+1]
      end
      
      w.RNGsOut[i] = string.format("%02d", i - current) .. ' - ' .. w.dec2hex( w.RNGs[i] , '%08X' ) -- bit.band(w.RNGs[i], 0xffffffff)
    end

  end

return w.RNGsOut

end


  -- advances the RNG n steps, credits to ALAKTORN
local function RNGSteps(iRNG, steps)
  for i = 1, steps do
    iRNG = nextRNG(iRNG)
  end
  return iRNG
end



-- Controller input
--========================================================

local lastInput = 0

local input_t = {}
input_t[0x0001] = 'L2';       input_t[0x0002] = 'R2'
input_t[0x0004] = 'L1';       input_t[0x0008] = 'R1'
input_t[0x0010] = 'Triangle'; input_t[0x0020] = 'Circle'
input_t[0x0040] = 'X';        input_t[0x0080] = 'Square'
input_t[0x0100] = 'Select';   input_t[0x0200] = 'NULL'
input_t[0x0400] = 'NULL';     input_t[0x0800] = 'Start'
input_t[0x1000] = 'Up';       input_t[0x2000] = 'Right'
input_t[0x4000] = 'Down';     input_t[0x8000] = 'Left'


  -- prints the controller input, needs to be called from inside DrawImguiFrame()
function w.inputLogger(address)
  
  local jokerPtr, value = w.validateAddress(address,'uint16_t*')
  local input = ''
  
  if jokerPtr[0] ~= lastInput and jokerPtr[0] ~= 0 then
    for k, v in pairs(input_t) do
      if bit.band( jokerPtr[0] , k ) ~= 0 then
        if input == '' then input = v else input = input .. ' + ' .. v end
      end
    end
    print (input)
  end
  
  lastInput = value
end



-- Helpers
--========================================================

  -- Define a custom hex-print function
  -- this breaks multi-argument print(a, b, c)

w.overridePrint = false
if w.overridePrint then
  
  -- Save the original print
  _originalPrint = print
  
  local function hexPrint(value)

    if type(value) == 'number' then
      _originalPrint('0x' .. w.dec2hex(value))
    elseif type(value) == 'table' then
      for k, v in pairs(value) do
        _originalPrint(tostring(k) .. ' = ' .. ( type(v) == 'number' and '0x' .. w.dec2hex(v) or tostring(v) ) )
      end
    else
      _originalPrint(value)
    end
  end

  print = hexPrint 
end


  -- ctSize_t[ct] will return the size of ct in bytes
  -- ffi.sizeof doesn't work with pointers because all pointers are 8 byte long in a 64 bit system 
  -- even reflect.typeof(ct).size will get it "wrong"

local ptrSizeByType = {
 ['__int8']   = 1,   ['__int8*'] = 1
,['int8_t']   = 1,   ['int8_t*'] = 1
,['uint8_t']  = 1,  ['uint8_t*'] = 1

,['__int16']  = 2,  ['__int16*'] = 2
,['int16_t']  = 2,  ['int16_t*'] = 2
,['uint16_t'] = 2, ['uint16_t*'] = 2

,['__int32']  = 4,  ['__int32*'] = 4
,['int32_t']  = 4,  ['int32_t*'] = 4
,['uint32_t'] = 4, ['uint32_t*'] = 4
}

local ptrTypeBySize = {
 [1] = 'uint8_t*'
,[2] = 'uint16_t*'
,[4] = 'uint32_t*'
}


function w.roundTo2(n)
  return math.floor((math.floor(n*2) + 1)/2)
end


  -- Check if all values are zero
function w.isArrayAllZeros(array)
  for k, v in pairs(array) do
    if v ~= 0 then return false end
  end
  
  return true
end


  -- Sum all the values in the array
function w.isArrayAllZeros2(array)
  local sum = 0
  for k, v in pairs(array) do
    sum = sum + v
  end

  return sum == 0
end


  -- returns hex string, similar to bit.tohex(x)
function w.dec2hex(num, format)
  format = format or "%X"
  return string.format(format , num)
end


  -- hex string to number
function w.hex2num(hexStr)
    return tonumber(hexStr, 16)
end


  -- Return true if its a valid address
function w.isValidAddress(n)
  return ( n > 0x80000000 and n < 0x80200000 )
end


  -- Return true if its a valid address mirrored or not.
function w.isValidAddress2(n)
  return n < 0x200000 or (n >= 0x80000000 and n < 0x80200000)
end


function w.isEmpty(s)
  return s == nil or s == ''
end


  -- returns the pointer's address
function w.backPointer(ptr)
    local base = tonumber( ffi.cast('uintptr_t', mem))
    local temp = tonumber( ffi.cast('uintptr_t', ptr))
    return  bit.bor( ffi.cast('uintptr_t', temp - base ) ,0x80000000 )
end


  -- main function to deal with pointers
function w.validateAddress(address,ct)
  
  assert( address ~= nil , 'null address call to validateAddress() ' .. ct )
  assert( w.isValidAddress2(address) , 'address out of bounds, ' .. address )
  
  if type(ct) == 'number' then
    local size = ct
    ct = w.ptrTypeBySize[size]
    assert(ct, 'unsupported access size: ' .. tostring(size))
  end
  
  assert( reflect.typeof(ct).what == 'ptr' , ct .. ' is not a pointer type.' )
  assert( not ffi.istype(ct, address) , w.dec2hex(w.backPointer(address)) .. ' already a ' .. ct .. ' pointer' )

  local addressPtr
  address = bit.band(address, 0x1fffff)
  addressPtr = ffi.cast(ct, mem + address)

  return addressPtr, addressPtr[0], address
end


  -- Formats lua table to be used with imgui.Combo:
  -- c, n = imgui.Combo( "label", n, w.comboList(t) )
  -- remember imgui.Combo return value is 0 indexed
function w.comboList(t)
  local list = ''
  for k, v in ipairs(t) do
    list = list .. v .. '\0'
  end
  return list
end


  -- Return the array key for the given value
function w.returnKey (t, value)
  for k, v in pairs(t) do
    if v == value then return k end
  end
end


-- Text
--========================================================

  -- Decodes text from game memory using the a text table file
  -- for ASCII, string.byte should work
function w.decode(address,size,tbl)
  
  local addressPtr = ffi.cast('uint8_t*', mem + bit.band(address, 0x1fffff))
  local text = ''
  
  local i = 0
  while i < size do

    local charIndex = addressPtr[i]
    
    -- VG has some 16bit chars, which we can mostly ignore, sadly 0xFA06 is a space and so is 0x8F
    if charIndex == 0xFA then 
      i = i + 1; text = text .. " ";
    elseif charIndex == 0xE7 then 
      break
    else
      if tbl[charIndex] ~= nil then text = text .. tbl[charIndex] end
    end;
    
    i = i + 1
    
  end
  
  return text
end

  -- Inserts string into game memory using the a text table file
function w.insert_string(address,size,tbl,text)
  
  local addressPtr = ffi.cast('uint8_t*', mem + bit.band(address, 0x1fffff))
  
  -- Trim down to size
  text = string.sub(text,1,size-1)
  
  for i=0,size,1 do
    if #text -i > 0 then
      -- returnKey uses a simple ipairs() and will return a space as 0x8F
      addressPtr[i] = w.returnKey( tbl, string.sub(text,i+1,i+1) )
    elseif #text -i == 0 and #text ~= 0 then
      -- 0xE7 is the string terminator for Vagrant Story
      addressPtr[i] = 0xE7
    else
      -- bytes ahead are cleared
      addressPtr[i] = 0
    end
  end
end



-- Events
--========================================================

  -- A simple frame counter
w.vblankCtr = 0

eventVsyncCtr = PCSX.Events.createEventListener('GPU::Vsync', function()
  w.vblankCtr = w.vblankCtr +1
end )


  -- A simple cycle counter, it's printed to console when the emulator is paused
w.cycleCtr = 0

eventPauseCtr = PCSX.Events.createEventListener('ExecutionFlow::Pause', function()
  print( string.format('%d',PCSX.getCPUCycles() - w.cycleCtr) .. ' cycles' )
  w.cycleCtr = PCSX.getCPUCycles()
end )



-- Breakpoint functions
--========================================================

  -- only breaks if the opcode is equal the given parameter
function w.addBpOpcode( id, condition)
  
  assert( not w[id] , id .. ' already defined.')
  
  w[id] = PCSX.addBreakpoint(0x80000000, 'Exec', 0x7ffffd, id , function()
    
    local regs = PCSX.getRegisters()
    local pc = regs.pc
    local pcPtr, code = w.validateAddress(pc,'uint32_t*')

    local inst = d.Instruction(code,regs)
    local opcode = inst:opcode()

    if opcode == condition then
        pprint('opcode ' .. w.dec2hex(opcode) .. ' at ' .. w.dec2hex(pc) ); PCSX.pauseEmulator(); PCSX.GUI.jumpToPC(pc)
    end
    
  end)
end


  -- only breaks if the value being written is equal the given parameter
function w.addBpWrittenAs(address, width, id, condition)
  
  assert( not w[id] , id .. ' already defined.')
  
  w[id] = PCSX.addBreakpoint(address, 'Write', width, id , function()
    
    local regs = PCSX.getRegisters()
    local pc = regs.pc
    local pcPtr, code = w.validateAddress(pc,'uint32_t*')
      
    local regIndex = bit.band( bit.rshift(code , 16), 0x1f )
    local regValue = PCSX.getRegisters().GPR.r[regIndex]               -- array starts at 0
      
    if regValue == condition then PCSX.pauseEmulator(); PCSX.GUI.jumpToPC(pc) end
    
  end)
end


  -- only breaks if the value is being read at the given address
function w.addBpNotReadAt(address, width, id, condition)
  
  assert( not w[id] , id .. ' already defined.')
    
  w[id] = PCSX.addBreakpoint( address, 'Read', width, id , function()
    
    local regs = PCSX.getRegisters()
    local pc = regs.pc

    if pc ~= condition then
      PCSX.pauseEmulator(); PCSX.GUI.jumpToPC(pc)
    end
    
  end)
end


  -- Breaks when a specified register is used anywhere, won't work with r0
function w.addBpRegister(id, condition)
  
  assert( not w[id] , id .. ' already defined.')
  
  if type(condition) == 'string' then condition = d.registers[condition] end
  
  w[id] = PCSX.addBreakpoint( 0x80000000, 'Exec', 0x7ffffd, id, function()
    
    local regs = PCSX.getRegisters()
    local pc = regs.pc
    local pcPtr, code = w.validateAddress(pc,'uint32_t*')
  
    local inst = d.Instruction(code,regs)
    local mnemonic, group = inst:mnemonic() 
    
    local tabRegisters = {}
    
    if group == 'BCOND'     then tabRegisters = {s=inst:rs()}
    elseif group == 'ITYPE' then tabRegisters = {s=inst:rs(),t=inst:rt()}
    elseif group == 'RTYPE' then tabRegisters = {s=inst:rs(),t=inst:rt(),d=inst:rd()}
    end
    
    if w.returnKey (tabRegisters, condition) then
      PCSX.pauseEmulator(); PCSX.GUI.jumpToPC(pc)
    end
    
  end)
end


  -- for adding breakpoints in bulk, use it with parseFileAsTable()
function w.addBreakpointTable(bTable,width,id,bType)

  assert( not w[id] , id .. ' already defined.')
  
  w[id] = {}

  for k, v in ipairs(bTable) do
    PCSX.insertSymbol(w.hex2num(v[1]),v[2])
    
    w[id][k] = PCSX.addBreakpoint(w.hex2num(v[1]), bType, width, v[2] , function()
      PCSX.pauseEmulator();
    end)
  end

end


function w.addSymbolTable(sTable)
  
  -- for adding symbols in bulk, use with parseFileAsTable()
  for k, v in ipairs(sTable) do
    PCSX.insertSymbol(w.hex2num(v[1]),v[2])
  end
end


-- Freeze addresses
-- Write every VSync
--========================================================

w.canFreeze = false
w.frozenAddresses = {}


  -- Does the actual freezing, used with createEventListener
function w.doFreeze()
  if w.canFreeze then 
    for k, v in pairs(w.frozenAddresses) do
      v[1][0] = v[2] -- pointer[0] = value
    end
  end
end


  -- Register an listener every frame
  -- when reenabling, we must revaluate the values in case they have changed

function w.updateFreezeEvent()
  
  local function refreshFreezeValues()
    for k, v in pairs(w.frozenAddresses) do
      v[2] = v[1][0]
    end
  end

  if w.canFreeze then
    w.refreshFreezeValues()
    w.eventVsyncFreeze = PCSX.Events.createEventListener('GPU::Vsync', w.doFreeze)
  else
    w.eventVsyncFreeze = nil
  end
  
end


function w.isFrozen(address)
  return w.frozenAddresses[address] ~= nil
end


function w.addFreeze(address,ct,value)
  
  -- Add an address to the frozenAddresses table, can be supplied with a custom value
  ct = ct or 'uint8_t*'
  local addressPtr, cur_value, address = w.validateAddress(address,ct)
  
  if not w.frozenAddresses[address] then 
    local value = value or cur_value
    w.frozenAddresses[address] = { addressPtr, value }
  end
end


  -- Freeze checkbox for an address or a range of addresses
function w.drawFreezeCheckbox(address, name, ct, range)
  local isFrozen = w.isFrozen(address)
  if not w.canFreeze then imgui.BeginDisabled() end
  local changed, isFrozen = imgui.Checkbox('Freeze##' .. name, isFrozen )
  if not w.canFreeze then imgui.EndDisabled() end

  -- ptrSizeByType[ct] Returns the size of ct in bytes
  if changed then
    for i=0, range*ptrSizeByType[ct], ptrSizeByType[ct] do
      if isFrozen then w.addFreeze(address+i,ct) else w.frozenAddresses[address+i] = nil end
    end
  end

  -- We might as well return it
  return isFrozen

end


  -- Controls the whole freezing process, w.canFreeze is exposed here
  -- draws a text field for adding addresses and a ListBox with the all frozen addresses
function w.DrawFrozen()
  
  local function DrawFrozenListBox()
    imgui.safe.BeginListBox('##Frozen', function()
      for k, v in pairs(w.frozenAddresses) do
        if imgui.SmallButton('x##'..k) then w.frozenAddresses[k] = nil end
        imgui.SameLine();
        if imgui.Selectable(("8%.7X"):format(math.abs(k)) .. ' - ' .. w.dec2hex( v[2] )) then
          PCSX.GUI.jumpToMemory(k,4)
        end
      end
    end)
    
  end
  
  -- changedBox is local and needs to be declared separately here
  local changedBox
  changedBox, w.canFreeze = imgui.Checkbox('Enable?', w.canFreeze)
  if changedBox then w.updateFreezeEvent() end
  
  imgui.SameLine()
  imgui.SetNextItemWidth(100)
  local changedInput, freezeValue = imgui.extra.InputText('Add address', '' , w.hexFlags )
  
  if changedInput and not w.isEmpty(freezeValue) then
    local freezeNumber = w.hex2num(freezeValue)
    w.addFreeze(freezeNumber)
  end
  
  imgui.SetNextItemWidth(280)
  DrawFrozenListBox()
  
end



-- Memory
--========================================================

local memWatch        = '80000000'
local memWatchInt     = w.hex2num(memWatch)
local size_bytes      = 0
local size_bytes_t    = {8,16}

  -- custom memory display for better vizualization and copying
function w.DrawMemory()
  
  _, memWatch = imgui.extra.InputText('Add address', memWatch , w.hexFlags)
  if _ then memWatchInt = w.hex2num(memWatch) end
  
  imgui.SetNextItemWidth(150)
  _, size_bytes = imgui.Combo("##size_bytes", size_bytes, w.comboList( size_bytes_t ) )
  w.drawMemory(memWatchInt,size_bytes + 1)
  
end

function w.drawMemory(address, size, range)
  
  range = range or 143
  size = size or 1
  local ct = ''
  local formato = ''
  local text = ''
  
  if size == 1 then 
    ct = 'uint8_t*'
    formato = '%02X'
  elseif size == 2 then
    ct = 'uint16_t*'
    formato = '%04X'
  else error ("unsupported size")
  end
  
  local addressPtr, value = w.validateAddress(address,ct)
  
  for i=0,range,1 do
    if math.fmod(i,16) == 0 then text = text .. '\n' .. w.dec2hex( i*(size) + address, '%08X') .. ': ' end
    text = text .. w.dec2hex( addressPtr[i] , formato ) .. ' ' 
  end
  
  -- imgui.safe.BeginListBox('Address', function()
  PCSX.GUI.useMonoFont()
  imgui.TextUnformatted(text)
  imgui.PopFont()
  -- end)
  
  if imgui.Button('Copy')  then
    imgui.LogToClipboard()
    imgui.extra.logText(text)
    imgui.LogFinish()
  end
  
end



-- Color functions
--========================================================

local function rgbTableToHex(colorTable)
  
  --  math.ceil or floor won't work
  local r, g, b = w.roundTo2(colorTable.r * 255), w.roundTo2(colorTable.g * 255), w.roundTo2(colorTable.b * 255)
  return string.format("#%02X%02X%02X", r, g, b)
end


local ColorPickerFlags     = 0

function w.drawColorPicker3(label,colors)
  
  if imgui.Button(label) then w[label] = not w[label] end
  
  if w[label] then
    imgui.SetNextItemWidth(150)
    _, colors = imgui.extra.ColorPicker3(label,colors,ColorPickerFlags)
    if _ then print(rgbTableToHex(colors)) end
  end
  return colors
end


function w.drawColorPicker4(label,colors)

  if imgui.Button(label) then w[label] = not w[label] end
  
  if w[label] then
    imgui.SetNextItemWidth(150)
    _,colors = imgui.extra.ColorPicker4(label,colors,ColorPickerFlags)
    if _ then print(rgbTableToHex(colors)) end
  end
  
  return colors
    
end



-- imgui widgets
--========================================================

w.fontsize = imgui.GetFontSize()

  -- display checkbox, if isReadOnly is true valueOff is not even used
function w.drawCheckbox(address, name, valueOn, valueOff, isReadOnly)
  
  local addressPtr, value = w.validateAddress(address,'uint8_t*')
  
  local check
  if value == valueOn then check = true else check = false end
  
  if isReadOnly then imgui.BeginDisabled() end
  
  local changed, check = imgui.Checkbox(name, check)
  if changed and not isReadOnly then
    if check then addressPtr[0] = valueOn else addressPtr[0] = valueOff end
  end
  
  if isReadOnly then imgui.EndDisabled() end

end


function w.drawSlider(address, name, ct, min, max, range)
  
  -- works nicely with min>max in cases where the logic is reversed
  -- also changes the bytes ahead, defined by range
  range = range or 0
  local addressPtr, value, address = w.validateAddress(address,ct)
  local changed, value = imgui.SliderInt(name, value, min, max, '%d', imgui.constant.SliderFlags.AlwaysClamp)

  local isfrozen = w.isFrozen(address)
  -- imgui.SameLine(); w.drawFreezeCheckbox(address, name, ct, range)

  if changed and not isfrozen then
    for i=0,range,1 do
      addressPtr[i] = value
    end
  end
  
end


function w.drawInputInt(address, name, ct, step, isReversed, width )
  
  -- isReversed = true in the few cases in which the logic is reversed
  step = step or 1
  width = width or 100
  imgui.SetNextItemWidth(width);
  
  local addressPtr, value = w.validateAddress(address,ct)
  local changed, value  = imgui.InputInt(name, value, step)
  
  if changed then
    if isReversed then addressPtr[0] = 2*addressPtr[0] - value else addressPtr[0] = value end
  end
  
end


function w.drawDrag( address, name, ct, min, max, speed )
  
  -- it needs AlwaysClamp otherwise it updates the values as soon you start typing
  speed = speed or 1
  local addressPtr, value = w.validateAddress(address,ct)
  local changed, value  = imgui.DragInt(name, value, speed, min, max, '%d', imgui.constant.SliderFlags.AlwaysClamp)
  
  if changed then
    addressPtr[0] = value
  end
  
end


  -- display a bunch of radio buttons in case you want to visually debug a single nibble
function w.drawRadio( address, name )
  local addressPtr, value = w.validateAddress(address,'uint8_t*')
  local nibble = bit.band( value , 0x0f )  -- better than using math.fmod(value,16) ?
  imgui.SeparatorText(name)
  imgui.NewLine()
  imgui.BeginGroup()
  for i = 0,15,1 do
    imgui.SameLine()
    if imgui.RadioButton(w.dec2hex(i), nibble == i) then
      addressPtr[0] = bit.bor ( bit.band( value , 0xf0) ,  i )
    end
  end
  imgui.EndGroup()
  
end


  -- display button to jump to the address at the Memory Editor
function w.drawJumpButton(address)

  imgui.SameLine();
  if imgui.Button( '>##' .. address ) then
     PCSX.GUI.jumpToMemory(address,4)
  end

  if imgui.IsItemHovered(imgui.constant.HoveredFlags.ForTooltip) and imgui.BeginTooltip() then
      imgui.TextUnformatted('Jump to memory');
    imgui.EndTooltip();
  end

end


function w.drawInputText(address, name, size, width)
  
  -- Last input is used as hint, otherwise it is read from memory
  width = width or 200
  local hint = w[address] or w.decode(address,size,text_t)
   imgui.SetNextItemWidth(width)
  
  local changedText, value = imgui.extra.InputText(name, hint, imgui.constant.InputTextFlags.EnterReturnsTrue)

  if changedText then
    w.insert_string(address,size,text_t,value)
    w[address] = string.sub(value,1,size-1)
  end

  w.drawJumpButton(address)
  
end


-- File manipulation
--========================================================

  
  -- Lists files in a directory that match a given file extension or lack one entirely if no extension is passed
function w.listFiles(extension,directory)
  if not w.isEmpty(extension) then extension =  '%.' .. extension .. '%d*$' else extension = '^[^.]+$' end
  directory = directory or lfs.currentdir()
  
  local files = {}
  for file in lfs.dir(directory) do
    filePath = directory .. "/" .. file
    local attr = lfs.attributes(filePath)
    
    if file:match(extension) and attr.mode == "file" then
      table.insert(files, file)
    end
  end
  
  return files
end


  --Open a file and return its content
function w.readFileAsString(filename)
  local file = Support.File.open(filename, 'READ')

  if not file:failed() then
    local buffer = file:read(file:size())
    file:close()
    return tostring(buffer)
  end
end


  -- Parse a file like a csv, can and should be used as input for w.addBreakpointTable
function w.parseFileAsTable(filename,separator)
  separator = separator or ' '
  local fileData = w.readFileAsString(filename)
  local tableData = {}

  for line in fileData:gmatch("[^\r\n]+") do
    local fields = {}
    string.gsub(line, '([^'..separator..']+)', function(x) table.insert(fields, x) end)
    table.insert(tableData, fields)
  end
  
  return tableData
end


  -- same as parseFileAsTable, but uses the I/O library and its lines() method
function w.parseFileAsTable2(filename,separator)
  local separator = separator or ' '
  local file = io.open(filename, "r")
  
  if not file then
    print("Error opening file: " .. filename)
    return nil
  end

  local tableData = {}

  for line in file:lines() do
    if line:match("%S") then
      local fields = {}
      string.gsub(line, '([^'..separator..']+)', function(c) table.insert(fields, c) end)
      table.insert(tableData, fields)
    end
  end
  
  file:close()
  return tableData
end



-- Save state functions
-- these two below save and load uncompressed files and therefore are incompatible with saves created from the pcsx interface
--========================================================

function w.drawSaveButton(saveName)

  if imgui.Button('Save') and not w.isEmpty(saveName)  then
    local save = PCSX.createSaveState()
    local file = Support.File.open(saveName, 'TRUNCATE')
    if not file:failed() then
      file:writeMoveSlice(save)
      print('Saved file ' .. saveName)
    end
    file:close()
  end

end


function w.drawLoadButton(saveName)

  function formatAsKB(num)
    return string.format("%.1f KB", num / 1000)
  end
    
  if imgui.Button('Load') and not w.isEmpty(saveName) then
    
    local file = Support.File.open(saveName, 'READ')
    local size = file:size()
    
    -- if its compressed, decompress it
    -- for now, this will do
    if size < 5000000 then file = Support.File.zReader(file) end
    
    if not file:failed() then
      PCSX.loadSaveState(file)
      print('Loaded file ' .. saveName .. ' - ' .. formatAsKB(size))
    end
    
    file:close()
  end

end


local saveExtension       = 'sstate'
local saveDirectory       = lfs.currentdir() -- '%APPDATA%\\pcsx-redux' 
local saveName            = ''
local saveInt             = 0

  -- Display and loads savestates create by PCSX.createSaveState()
function w.DrawLoadSave()
  imgui.SeparatorText("Directory:")
  _, saveDirectory = imgui.extra.InputText('##Save Directory', saveDirectory )
  if _ then lfs.chdir(saveDirectory) end
  
  imgui.SeparatorText("Saving:")
  _, saveName = imgui.extra.InputText('##Save file', saveName )
  imgui.SameLine(); w.drawSaveButton(saveName)

  imgui.SeparatorText("Loading:")
  imgui.SetNextItemWidth(60)
  _, saveExtension = imgui.extra.InputText('File Extension', saveExtension, w.textFlags )
  if _ then saveInt = 0 end
  
  local files = w.listFiles(saveExtension)
  _, saveInt = imgui.Combo('##Load file', saveInt, w.comboList( files ) )
  imgui.SameLine(); w.drawLoadButton( files[saveInt+1] )

end


-- ScreenShot
--========================================================


local function expand5to8(v)
    -- (v * 8) + floor(v / 4)
    -- (v << 3) | (v >> 2)
    return bit.bor(bit.lshift(v, 3), bit.rshift(v, 2))
end

function w.takeScreenShot(saveName)

  local file = Support.File.open(saveName .. '.ppm', 'TRUNCATE')
  
  if file:failed() then
     file:close()
     return
  end
    
  local screen = PCSX.GPU.takeScreenShot()
  
  local width  = tonumber(screen.width)
  local height = tonumber(screen.height)
  local bpp    = tonumber(screen.bpp)
  local data   = tostring(screen.data)

  -- Convert image data to 24bpp if 16bpp (5-bit channels)
  if bpp == 0 then

  local out = {}
  for i = 1, #data, 2 do
    -- For every little-endian 2 byte pixel
    local lo, hi = string.byte(data, i, i + 1)
    local pixel = lo + bit.lshift(hi, 8)

    -- We get the 5-bit colors
    local r5 = bit.band(pixel, 0x1F)
    local g5 = bit.band(bit.rshift(pixel, 5), 0x1F)
    local b5 = bit.band(bit.rshift(pixel, 10), 0x1F)

    -- And expand them to 8-bit color
    -- string.char is required because table.concat deals with numbers by converting them 
    -- to their decimal text representation and we have no string.pack :(
    out[#out + 1] = string.char(expand5to8(r5), expand5to8(g5), expand5to8(b5))
  end

  data = table.concat(out)
  
  end
 
  local header = "P6\n" .. string.format("%d %d\n", width, height) .. "255\n"
  file:write(header .. data)
  
  print('Saved file ' .. saveName)

  file:close()

end


return w
