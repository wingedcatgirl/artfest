Mintfight.Attack {
    key = "kaya",
    name = "Kaya",
    pronouns = "she_her",

    atlas = 'jokers',
    pos = {
        x = 7,
        y = 1
    },
    soul_pos = {
        x = 7,
        y = 2
    },

    artfight_credit = {
        name = "Beeeenoz",
        team = "Tragedy",
        year = "2026",
    },

    rarity = 3,
    cost = 9,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    demicoloncompat = true,
    
    config = {
        extra = {
            any_aces_xmult = 2,
            all_aces_xmult = 4,
        }
    },

    attributes = {
        "ace", "xmult", "rank"
    },
    loc_vars = function(self, info_queue, card)
        local key = self.key
        return {
            key = key,
            vars = {
                card.ability.extra.any_aces_xmult,
                card.ability.extra.all_aces_xmult
            }
        }
    end,
    
    calculate = function(self, card, context)
        if context.forcetrigger then
            return {
                xmult = card.ability.extra.all_aces_xmult
            }
        end

        if context.joker_main then
            local an_ace, all_aces = false, true
            for i,v in ipairs(context.scoring_hand) do
                if v:get_id() == SMODS.Ranks.Ace.id then
                    an_ace = true
                else
                    all_aces = false
                end
            end
            if all_aces then
                return {
                    xmult = card.ability.extra.all_aces_xmult
                }
            elseif an_ace then
                return {
                    xmult = card.ability.extra.any_aces_xmult
                }
            end
        end
    end
}