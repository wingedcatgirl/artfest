Mintfight.Attack {
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
    artfight_credit = {
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

    config = {
        extra = {
            luck = 1,
            odds = 3
        }
    },

    attributes = {

    },
    loc_vars = function(self, info_queue, card)
        local key = self.key
        local luck, odds = SMODS.get_probability_vars(card, card.ability.extra.luck, card.ability.extra.odds, "tragedy_thing_level_doubler", false)
        return {
            key = key,
            vars = {
                luck,
                odds
            }
        }
    end,
    
    calculate = function(self, card, context)
        if context.poker_hand_changed and context.old_level < context.new_level and not (context.card and context.card.config.center_key == card.config.center_key) then
            if SMODS.pseudorandom_probability(card, "tragedy_thing_level_doubler", card.ability.extra.luck, card.ability.extra.odds) then
                return {
                    level_up = 1,
                    level_up_hand = context.scoring_name
                }
            end
        end
    end
}