---@param center table
---@return boolean
local function is_artfight_joker(center)
    if not (center and center.original_mod) then return false end

    local ids = {
        ["minty-artfight"] = true,
        playwright = true,
        --and point me to any other attacks in the form of working balala mods and i'll add them here
    }

    return ids[center.original_mod.id] or false
end

SMODS.Back{
    key = "art",
    atlas = "backs",
    pos = {x=0, y=0},
    calculate = function (self, back, context)
        --[[ --I can't figure out what I'm trying to do with this math...
        if not Mintfight.joker_count then
            Mintfight.joker_count = 0
            for k,v in pairs(G.P_CENTERS) do
                if v.original_mod and v.original_mod.id == "minty-artfight" then
                    Mintfight.joker_count = Mintfight.joker_count + 1
                end
            end
        end
        --]]

        if context.modify_weights then
            for i,v in ipairs(context.pool) do
                local center = G.P_CENTERS[v.key]
                if is_artfight_joker(center) then
                    v.weight = v.weight * 2
                    if tostring(os.date("*t").year) == v.artfight_credit.year then
                        v.weight = v.weight * 1.5
                    end
                end
            end
        end
    end
}