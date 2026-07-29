Mintfight.Attack {
    key = "rose",
    name = "Rosé Fleur",
    pronouns = "she_her",
    atlas = 'jokers',
    pos = {
        x = 2,
        y = 1
    },
    soul_pos = {
        x = 2,
        y = 2
    },
    artfight_credit = {
        team = "Mystery",
        name = "projectpurr"
    },
    rarity = 1,
    cost = 6,
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
    loc_vars = function(self, info_queue, card)
        local key = self.key
        info_queue[#info_queue+1] = G.P_CENTERS.m_gold
        return {
            key = key,
            vars = {
                
            }
        }
    end,
    
    calculate = function(self, card, context)
        if context.before and next(context.scoring_hand) then
            local target = pseudorandom_element(context.scoring_hand, "26_rose_transmute")
            return {
                func = function()
                    target:set_ability("m_gold")
                    G.E_MANAGER:add_event(Event {
                        func = function()
                            target:juice_up()
                            return true
                        end
                    })
                end,
                message = localize("k_gold"),
                message_card = target
            }
        end
    end
}