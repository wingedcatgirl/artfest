---@meta
do return end

---@class Comedy26.Attack:SMODS.Joker
---@field super? SMODS.Joker|table
---@field credit26? {name:string, team:string}
---@overload fun(self: Comedy26.Attack): Comedy26.Attack
Comedy26.Attack = setmetatable({}, {
    __call = function(self)
        return self
    end
})