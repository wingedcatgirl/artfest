Mintfight.Attack {
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

    artfight_credit = {
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
    
    config = {
        extra = {
            
        }
    },

    attributes = {

    },
    loc_vars = function(self, info_queue, card)
        local key = self.key
        if not card.ability.extra.fallback_torment then
            card.ability.extra.fallback_torment = math.random(3,17)
        end
        return {
            key = key,
            vars = {
                G.GAME.mintfight_duck_torment or card.ability.extra.fallback_torment
            }
        }
    end,
    get_weight = function (self, weight)
        local gravity = 1
        if G.GAME and G.GAME.mintfight_duck_torment then
            gravity = math.max(gravity, math.log(G.GAME.mintfight_duck_torment, 6))
        end

        return weight * gravity
    end,
    
    calculate = function(self, card, context)
        if context.joker_type_destroyed then
            if context.card ~= card and not context.card.ability.mintfight_temporary and context.card.config.center.set == "Joker" and not card.blocking then
                card.blocking = true
                return {
                    no_destroy = true,
                    extra = {
                        func = function ()
                            SMODS.calculate_effect({message = localize("mintfight_tormented_ex")}, card)
                            SMODS.destroy_cards(card, {immediate = true})
                            G.GAME.mintfight_duck_torment = G.GAME.mintfight_duck_torment + pseudorandom("mintfight_duck_torment", 3, 17)
                        end
                    }
                }
            end
        end
    end
}