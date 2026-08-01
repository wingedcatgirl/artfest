Mintfight.Attack {
    key = "babble",
    name = "Babble",
    pronouns = "she_her",

    atlas = 'jokers',
    pos = {
        x = 9,
        y = 1
    },
    soul_pos = {
        x = 9,
        y = 2
    },

    artfight_credit = {
        name = "babblerabbit",
        team = "Comedy",
        year = "2026",
    },

    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    demicoloncompat = false,
    
    config = {
        extra = {
            req = 3
        }
    },

    attributes = {

    },
    loc_vars = function(self, info_queue, card)
        local key = self.key
        return {
            key = key,
            vars = {
                card.ability.extra.req
            }
        }
    end,
    
    calculate = function(self, card, context)
        if context.before and #context.scoring_hand >= card.ability.extra.req then
            local target = pseudorandom_element(context.scoring_hand, "mintfight_babble_target")
            card.ability.extra.target = target
            return
        end

        if context.repetition and context.other_card == card.ability.extra.target then
            card.ability.extra.target = nil
            return {
                repetitions = #context.scoring_hand
            }
        end

        if context.after then
            card.ability.extra.target = nil
            return
        end
    end
}