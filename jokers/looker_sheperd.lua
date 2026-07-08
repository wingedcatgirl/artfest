Comedy26.Attack {
    key = "looker_shepard",
    name = "Looker \"Sparks\" Sheperd",
    pronouns = "he_him",
    atlas = 'jokers',
    pos = {
        x = 0,
        y = 1
    },
    soul_pos = {
        x = 0,
        y = 2
    },
    credit26 = {
        team = "Mystery",
        name = "SpoxxieRuckus"
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

        info_queue[#info_queue + 1] = { set = "Other", key = "mincom26_temporary", vars = {} }

        return {
            key = key,
            vars = {
                
            }
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            return {
                message = "Supplies!",
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function ()
                            SMODS.add_card {
                                set = "Consumeables",
                                force_stickers = {
                                    "mincom26_temporary"
                                },
                                soulable = true
                            }
                            return true
                        end
                    }))
                end
            }
        end
    end
}