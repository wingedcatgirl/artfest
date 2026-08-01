---@meta
do return end

---@class Mintfight.Attack:SMODS.Joker
---@field super? SMODS.Joker|table
---@field artfight_credit? {name:string, team:string, year:string}
---@overload fun(self: Mintfight.Attack): Mintfight.Attack
Mintfight.Attack = setmetatable({}, {
    __call = function(self)
        return self
    end
})