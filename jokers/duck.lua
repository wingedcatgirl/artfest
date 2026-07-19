Comedy26.Attack {
    key = "duck",
    name = "Duck",
    pronouns = "he_him",

    atlas = 'jokers',
    pos = {
        x = 3,
        y = 1
    },
    soul_pos = {
        x = 3,
        y = 2
    },

    credit26 = {
        team = "Comedy",
        name = "Technically_no"
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