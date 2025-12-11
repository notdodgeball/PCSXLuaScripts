--========================================================
-- Vagrant Story script for the pcsx-redux emulator
-- made by optrin
--========================================================

-- jit.off()

local itialDir          = lfs.currentdir()

require 'map'
gui = require 'gui'
w   = require 'widgets'

local function reload()
  PCSX.pauseEmulator()
  lfs.chdir(itialDir)
  package.loaded['gui']     = nil
  package.loaded['widgets'] = nil
  package.loaded['map']     = nil
  dofile('vg.lua')
end


--==========-- Variables

local mem             = PCSX.getMemPtr()
local areaDesc        = 'Select area'
local areaDesc        = 'Select area'
local areaId          = 0

local joker           = 0x05E1C0 -- 0x05E238
local loadRoom        = 0x0F1A48
local roomIdToLoad    = 0x0F1AB0
local roomIdToLoadPtr = ffi.cast('uint16_t*', mem +  bit.band(roomIdToLoad, 0x1fffff))

-- 8011FA10 starts character data
local mode            = 0x11FA10
local curHP           = 0x11FA58
local maxHP           = 0x11FA5A
local curMP           = 0x11FA5C
local maxMP           = 0x11FA5E
local risk            = 0x11FA60
local strength        = 0x11FA62
local maxSpeed        = 0x11FA73
local ashleyStatus    = 0x120388
local ashleyState     = 0x1203AE

local posY            = 0x1203C0 -- mirrored at 0x1fff8c (on the stack)
local posZ            = 0x1203C2
local posX            = 0x1203C4
local posXPtr         = ffi.cast('uint16_t*', mem + bit.band(posX, 0x1fffff))
local posYPtr         = ffi.cast('uint16_t*', mem + bit.band(posY, 0x1fffff))
local posZPtr         = ffi.cast('uint16_t*', mem + bit.band(posZ, 0x1fffff))
local coor            = {
'x '.. w.dec2hex(posXPtr[0]),
'y '.. w.dec2hex(posYPtr[0]),
'z '.. w.dec2hex(posZPtr[0])
 }

local ashleySize      = 0x1203D0
local curAnimationID  = 0x12095C
local curSpeed        = 0x121BE4

local itemCount       = 20
local itemId          = 0x060F68
local itemQtd         = 0x060F6A
local itemIdPtr       = ffi.cast('uint8_t*', mem + bit.band(itemId, 0x1fffff))
local itemQtdPtr      = ffi.cast('uint8_t*', mem + bit.band(itemQtd, 0x1fffff))

local charName        = 0x11FA40
local currWeaponName  = 0x11fA7C
local square          = PCSX.CONSTS.PAD.BUTTON.SQUARE
local canMoonJump     = false

-- 0x0F1928: Actor Pointers Table (List all enemies / characters currently loaded in memory) 
-- also stored at 0x0F19FC
local actorPointer    = 0x8011F9F0
local actorPointerPtr = ffi.cast('uint32_t*', mem +  bit.band(actorPointer, 0x1fffff))
local actors          = {actorPointerPtr}

local colors1        = {r=0,g=0,b=0}
local colors2        = {r=0,g=0,b=0,a=0}

--==========-- imgui drawing

function DrawImguiFrame()
  
  imgui.safe.Begin('Command', true, function()

    -- w.inputLogger(mem,joker)
    
    -- if imgui.CollapsingHeader("Header") then
      if imgui.Button(w.vblankCtr) then w.vblankCtr = 0 end
      if imgui.Button("Reload scripts") then reload() end
    -- end
    
    imgui.safe.BeginTabBar('MainTabBar', w.tabFlags, function()
      
      imgui.safe.BeginTabItem('Actors', function()
        
        imgui.safe.BeginTabBar('ActorsChild', w.tabFlags, function()
          
          for actorIndex, ActorPtr in ipairs(actors) do

            local curActor = ActorPtr[0]
            if curActor == 0 then break end
            local curActorName = ActorPtr[0] + 0x50
            
            imgui.safe.BeginTabItem( tostring(actorIndex) .. w.decode(curActorName, 0x18, text_t) , function()
            
              imgui.safe.BeginTable('Actor Table##'.. actorIndex, 2, w.tableFlags, function()
                
                for _, field in ipairs(actorStruct) do
                  local curAddress = ActorPtr[0] + field.offset

                  imgui.TableNextColumn()
                  -- If last column, we start instead at the next row
                  if imgui.TableGetColumnIndex() == 1 and (field.sameline or field.text) then imgui.TableNextColumn(); end;
                  
                  if field.text then
                    w.drawInputText(curAddress, field.name, 23)
                  else
                    w.drawInputInt(curAddress, field.name, w.ctSize_t_inv[field.size])
                  end
                end -- ipairs(actorStruct)
                
              end) -- Actor Table
            end) -- curActorName Tab
            
            -- Add the pointer to the next actor to the actors table
            local ptrToNextActor, nextActor = w.validateAddress(curActor,'uint32_t*')
            
            if w.isValidAddress(nextActor) then
              if nextActor ~= 0 then actors[actorIndex+1] = ptrToNextActor end
            else
              actors[actorIndex+1] = nil
            end

            
          end -- ipairs(actors)
        end) -- ActorsChild TabBar
      end) -- Actors Tab
    
   
      imgui.safe.BeginTabItem('Ashley', function()

        w.drawSlider(maxSpeed , 'MaxSpeed', 'uint8_t*', 0, 40)
        w.drawSlider(curSpeed, 'CurSpeed', 'uint8_t*', 0, 40)
        w.drawSlider(strength, 'STR', 'uint8_t*', 0, 255)
        w.drawSlider(ashleySize , 'Size AS', 'int16_t*', 512, 14000, 2)
        
        imgui.SeparatorText('Coordinates')
        imgui.safe.BeginTable('TableCoordinates', 2, w.tableFlags, function() 
           imgui.TableSetupColumn('' , imgui.constant.TableColumnFlags.WidthFixed, 136 )

           imgui.TableNextColumn(); w.drawInputInt(posX, 'X', 'int16_t*')
           imgui.TableNextColumn(); w.drawSlider(posX, '##x', 'int16_t*', -2500, 2500)
           imgui.TableNextColumn(); w.drawInputInt(posY, 'Y', 'int16_t*')
           imgui.TableNextColumn(); w.drawSlider(posY, '##y', 'int16_t*', -2500, 2500)
           imgui.TableNextColumn(); w.drawInputInt(posZ, 'Z', 'int16_t*', 1, true)
           imgui.TableNextColumn(); w.drawSlider(posZ, '##z', 'int16_t*', 150, -500)
        end) -- TableCoordinates
        
        imgui.SeparatorText('Checks')
        w.drawCheckbox(mode, 'Battle Mode', 0x01, 0x00, true)
        imgui.SameLine()
        _, canMoonJump = imgui.Checkbox('Moon Jump', canMoonJump)
        
        if canMoonJump then
          if PCSX.SIO0.slots[1].pads[1].getButton(square) then posZPtr[0] = posZPtr[0] - 20 end
        end
        
        imgui.SeparatorText('Strings')
        w.drawInputText(currWeaponName, 'Weapon\'s name', 16 )
        w.drawInputText(charName, 'Character\'s name', 16 )
        
      end) -- Ashley
      
      
      imgui.safe.BeginTabItem('Rooms', function()
        
        if imgui.Button('Trigger Load Room:') and mem[loadRoom] == 0 then mem[loadRoom] = 2 end
        imgui.SameLine(); imgui.TextUnformatted( string.format( '%04X', roomIdToLoadPtr[0] ) )

        imgui.PushItemWidth(190)
        imgui.safe.BeginCombo( '##Area', areaDesc , function()
          for k, v in ipairs(area_t) do
            if imgui.Selectable( v ) then areaId=k; areaDesc=v end
          end
        end) -- ##Area
        imgui.PopItemWidth()
        
        imgui.safe.BeginListBox('##Room', function()
          for k, v in pairs(map_t) do
            if v.area == areaId then
              if imgui.Selectable( v.desc ) then roomIdToLoadPtr[0] = v.id end
            end
          end
        end) -- ##Room
        
      end) -- Rooms
      
      
      imgui.safe.BeginTabItem('Items', function()
        
        imgui.safe.BeginListBox('##Item', 0, itemCount*12, function()
          for i=0, itemCount, 4 do
            local id = itemIdPtr[i]
            if id > 0x42 then
              itemCount = i+4
              imgui.SetNextItemWidth(90)
              -- '## .. i' is for a unique imgui ID
              w.drawInputInt(itemQtd+i , items_t[ id ] .. '##' .. i, 'uint8_t*' )
            end
          end
        end)  -- ##Item
        
        imgui.SetNextItemWidth(150);
        imgui.safe.BeginCombo( '##New item', 'Add a new item:', function()
          for k, v in pairs(items_t) do
            if imgui.Selectable( v ) then itemIdPtr[itemCount] = k; itemIdPtr[itemCount+1] = 1; itemQtdPtr[itemCount] = 1 end
          end
        end) -- ##New item
        
      end) -- Items
      
      
      imgui.safe.BeginTabItem('Freeze', function()
        
        w.DrawFrozen()
        
      end) -- Freeze


      imgui.safe.BeginTabItem('Memory', function()
        
        w.DrawMemory()
        
      end) -- Memory
      

      imgui.safe.BeginTabItem('Save/Load', function()
        
        w.DrawLoadSave()
        
      end) -- Save/Load
      
      imgui.safe.BeginTabItem('Colors', function()
        
        colors1 = w.drawColorPicker3('colors1',colors1)
        colors2 = w.drawColorPicker4('colors2',colors2)

      end) -- Save/Load      
      
    end) -- MainTabBar

  end) -- Command

end --DrawImguiFrame

