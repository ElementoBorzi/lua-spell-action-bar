local Object = require("Lib.Object")
local Config = require("Spell_Action_Bar.Config.Spell_Action_Bar_Config")
local Spell_Action_Bar = Object:extend()

function Spell_Action_Bar:load()
    local data = WorldDBQuery(string.format("SELECT * FROM %s.index_Spell_Action_Bar", Config.DATABASE))
    if (data) then
        repeat
            local spell_id = data:GetUInt32(0)
            local texture = data:GetString(1)

            if (not self.spells[spell_id]) then
                self.spells[spell_id] = {
                    texture = texture,
                    conditions = { }
                }
            end
        until not data:NextRow()
    end

    local conditions = WorldDBQuery(string.format("SELECT * FROM %s.index_Spell_Action_Bar_conditions", Config.DATABASE))
    if (conditions) then
        repeat
            local spell_id = conditions:GetUInt32(0)
            local source_type = conditions:GetString(1)
            local source_id = conditions:GetUInt32(2)

            local index = #self.spells[spell_id].conditions + 1
            self.spells[spell_id].conditions[index] = {
                source_type = source_type,
                source_id = source_id,
            }

        until not conditions:NextRow()
        self:Order()
    end
end

function Spell_Action_Bar:OrderBy(source_type, source_table)
    for spell_id, sub_array in pairs(self.spells) do
        for _, spell_data in pairs(sub_array.conditions) do
            if (spell_data.source_type == source_type) then
                source_table[spell_data.source_id] = spell_id
            end
        end
    end
end

function Spell_Action_Bar:Order()
    self:OrderBy( "item"    ,  self.items )
    self:OrderBy( "map_id"  ,  self.maps  )
    self:OrderBy( "zone_id" ,  self.zones )
    self:OrderBy( "aura"    ,  self.auras )
    self:OrderBy( "area_id" ,  self.areas )
end

function Spell_Action_Bar:new()
    self.spells = { }

    self.items = { }
    self.maps = { }
    self.zones = { }
    self.auras = { }
    self.areas = { }

    self:load()
end

local instance = nil
local function singleton()
    if not (instance) then
        instance = Spell_Action_Bar()
    end
    return instance
end

return instance or singleton()