--========================================================
-- Original copyright (c) 2025 PCSX-Redux authors (MIT License)
-- Converted to lua from code from Nicolas Noble
-- https://github.com/grumpycoders/pcsx-redux/blob/main/src/mips/common/util/decoder.hh
--========================================================

-- In redux's implementation of extract(), the third parameter is posicional, not width
-- we reimplement it here just like the bit32 library
-- right to left (least to most significant digit)
bit.extract = function(n, f, w)
  return bit.band(bit.rshift(n, f), bit.lshift(1, w) - 1)
end


local d = {}

d.registers = { [0]=
  'r0', 'at', 'v0', 'v1', 'a0', 'a1', 'a2', 'a3',
  't0', 't1', 't2', 't3', 't4', 't5', 't6', 't7',
  's0', 's1', 's2', 's3', 's4', 's5', 's6', 's7',
  't8', 't9', 'k0', 'k1', 'gp', 'sp', 's8', 'ra',
  'lo', 'hi'
}

-- both numeric and string indexing for this table
for k, v in pairs(d.registers) do
  d.registers[v] = k
end


--##############################

d.Instruction = {}
d.Instruction.__index = d.Instruction

setmetatable(d.Instruction, {
  __call = function(class, new_code, new_regs)
    return setmetatable({ code = new_code, regs = new_regs }, class)
  end
})

function d.Instruction:opcode()   return bit.rshift(self.code, 26) end
function d.Instruction:rs()       return bit.extract(self.code, 21, 5) end
function d.Instruction:rt()       return bit.extract(self.code, 16, 5) end

-- J-Type
function d.Instruction:target()   return bit.extract(self.code, 0, 26) end

-- I-Type
function d.Instruction:imm()
    local raw = bit.band(self.code, 0xFFFF)
    return raw >= 0x8000 and raw - 0x10000 or raw
end

-- R-Type
function d.Instruction:rd()       return bit.extract(self.code, 11, 5) end
function d.Instruction:sa()       return bit.extract(self.code, 6, 5) end
function d.Instruction:funct()    return bit.extract(self.code, 0, 6) end


-- returns both the mnemonic and the group type
function d.Instruction:mnemonic()
    local op = self:opcode()

    if op == 0x00 then
        local f = self:funct()
        return ({
            [0x20] = 'ADD',   [0x21] = 'ADDU',  [0x22] = 'SUB',   [0x23] = 'SUBU',
            [0x2A] = 'SLT',   [0x2B] = 'SLTU',  [0x1A] = 'DIV',   [0x1B] = 'DIVU',
            [0x18] = 'MULT',  [0x19] = 'MULTU', [0x10] = 'MFHI',  [0x11] = 'MTHI',
            [0x12] = 'MFLO',  [0x13] = 'MTLO',  [0x00] = 'SLL',   [0x02] = 'SRL',
            [0x03] = 'SRA',   [0x04] = 'SLLV',  [0x06] = 'SRLV',  [0x07] = 'SRAV',
            [0x27] = 'NOR',   [0x08] = 'JR',    [0x09] = 'JALR',  [0x24] = 'AND',
            [0x25] = 'OR',    [0x26] = 'XOR',   [0x0D] = 'BREAK', [0x0C] = 'SYSCALL'
        })[f] or 'INVALID', 'RTYPE'

    elseif op == 0x01 then
        local r = self:rt()
        return ({
            [0x01] = 'BGEZ',   [0x11] = 'BGEZAL',
            [0x00] = 'BLTZ',   [0x10] = 'BLTZAL',
        })[r] or 'INVALID', 'BCOND'

    elseif op == 0x10 then
        local s = self:rs()
        return ({
            [0x00] = 'MFC0',  [0x04] = 'MTC0',
            [0x02] = 'CFC0',  [0x06] = 'CTC0',
        })[s] or 'INVALID', 'COP0'

    elseif op == 0x12 then
        local s = self:rs()
        return ({
            [0x00] = 'MFC2',  [0x04] = 'MTC2',
            [0x02] = 'CFC2',  [0x06] = 'CTC2',
        })[s] or 'INVALID', 'COP2'

    elseif op == 0x02 or op == 0x03 then
        return ({
            [0x02] = 'J',
            [0x03] = 'JAL',
        })[op], 'JTYPE'

    else
        return ({
            [0x08] = 'ADDI',     [0x09] = 'ADDIU',
            [0x0A] = 'SLTI',     [0x0B] = 'SLTIU',
            [0x0C] = 'ANDI',     [0x0D] = 'ORI',
            [0x0E] = 'XORI',     [0x04] = 'BEQ',
            [0x05] = 'BNE',      [0x07] = 'BGTZ',
            [0x06] = 'BLEZ',     [0x20] = 'LB',
            [0x24] = 'LBU',      [0x21] = 'LH',
            [0x25] = 'LHU',      [0x0F] = 'LUI',
            [0x23] = 'LW',       [0x22] = 'LWL',
            [0x26] = 'LWR',      [0x28] = 'SB',
            [0x29] = 'SH',       [0x2B] = 'SW',
            [0x2A] = 'SWL',      [0x2E] = 'SWR',
            -- [0x03] = 'JAL',      [0x02] = 'J',
            -- [0x3A] = 'SWC2',     [0x32] = 'LWC2',
        })[op], 'ITYPE'

    end
end

function d.Instruction:isStore()
    local m = self:mnemonic()
    local isStore = {
        SB=true, SH=true, SW=true,
        SWL=true, SWR=true, SWC2=true
    }
    return isStore[m]
end

function d.Instruction:isLoad()
    local m = self:mnemonic()
    local isLoad = {
        LB=true, LBU=true, LH=true, LHU=true,
        LW=true, LWL=true, LWR=true, LWC2=true
    }
    return isLoad[m]
end

function d.Instruction:isBranch()
    local m = self:mnemonic()
    local isBranch = {
        BEQ=true, BNE=true, BGEZ=true, BGTZ=true,
        BLEZ=true, BLTZ=true, BGEZAL=true, BLTZAL=true
    }
    return isBranch[m]
end

function d.Instruction:isImm()
    local m = self:mnemonic()
    local isImm = {
        ADDI=true, ADDIU=true, SLTI=true, SLTIU=true,
        ANDI=true, ORI=true, XORI=true, LUI=true, 
    }
    return isImm[m]
end

function d.Instruction:getLoadAddress()
    return self:isLoad() and (self.regs.GPR.r[self:rs()] + self:imm()) or 0
end

function d.Instruction:getLoadMask()
    local m = self:mnemonic()

    if m == 'LB' or m == 'LBU' then
        return 0xff

    elseif m == 'LH' or m == 'LHU' then
        return 0xffff

    elseif m == 'LWL' then
        local address = self.regs.GPR.r[self:rs()] + self:imm()
        local offset = address % 4
        return bit.rshift(0xffffffff, (3 - offset) * 8)

    elseif m == 'LWR' then
        local address = self.regs.GPR.r[self:rs()] + self:imm()
        local offset = address % 4
        return bit.lshift(0xffffffff, offset * 8)

    else
        return 0xffffffff
    end
end

function d.Instruction:getStoreAddress()
    return self:isStore() and (self.regs.GPR.r[self:rs()] + self:imm()) or 0
end

function d.Instruction:getValueToStore()
    local m = self:mnemonic()
    local rt = self.regs.GPR.r[self:rt()]
    -- local CP2C = self.regs.CP2C.r[self:rt()]

    if m == 'SB' then
        return bit.band(rt, 0xff)

    elseif m == 'SH' then
        return bit.band(rt, 0xffff)

    elseif m == 'SWL' then
        local addr = self.regs.GPR.r[self:rs()] + self:imm()
        local offset = addr % 4
        return bit.lshift(rt, (3 - offset) * 8)

    elseif m == 'SWR' then
        local addr = self.regs.GPR.r[self:rs()] + self:imm()
        local offset = addr % 4
        return bit.rshift(rt, offset * 8)

    elseif m == 'SWC2' then
        return self.regs.CP2D.r[self:rt()]

    elseif m == 'SW' then
        return rt
    else
        return 0
    end
end

function d.Instruction:getBranchAddress()
    return self:isBranch() and (self.regs.pc + bit.lshift(self:imm(), 2) + 4) or 0
end

function d.Instruction:getJumpAddress()
    local m = self:mnemonic()
    if m == 'J' or m == 'JAL' then
        return bit.bor(bit.band(self.regs.pc, 0xf0000000), bit.lshift(self:target(), 2))
    else
        return 0
    end
end

function d.Instruction:getJumpRegisterAddress()
    local m = self:mnemonic()
    if m == 'JR' or m == 'JALR' then
        return self.regs.GPR.r[self:rs()]
    else
        return 0
    end
end


return d