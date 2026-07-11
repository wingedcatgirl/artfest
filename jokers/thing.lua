Comedy26.Attack {
    key = "thing",
    name = "Thing",
    pronouns = "he_any",

    atlas = 'jokers',
    pos = {
        x = 1,
        y = 1
    },
    soul_pos = {
        x = 1,
        y = 2
    },
    credit26 = {
        team = "Tragedy",
        name = "RabAlienThing"
    },
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    demicoloncompat = false,

    --[[
    config = {
        extra = {
            
        }
    },
    --]]
    
    attributes = {

    },
    --[[
    loc_vars = function(self, info_queue, card)
        local key = self.key
        return {
            key = key,
            vars = {
                
            }
        }
    end,
    --]]
    
    --[[
    calculate = function(self, card, context)
        -- Calculation goes here
    end
    --]]
}