Mintfight.Attack {
    key = "vivica",
    name = "Vivica",
    pronouns = "she_her",

    atlas = 'jokers',
    pos = {
        x = 4,
        y = 1
    },
    soul_pos = {
        x = 4,
        y = 2
    },
    set_sprites = function (self, card, front)
        if Mintfight.config.violate_geneva_conventions then
            self.soul_pos = {x=5, y=2}
        else
            self.soul_pos = {x=4, y=2}
        end
    end,
    update = function (self, card, dt)
        if not self.soul_pos then return end
        if Mintfight.config.violate_geneva_conventions and self.soul_pos.x ~= 5 then
            self.soul_pos.x = 5
        elseif not Mintfight.config.violate_geneva_conventions and self.soul_pos.x ~= 4 then
            self.soul_pos.x = 4
        else
            return
        end
        G.E_MANAGER:add_event(Event{
            func = function ()
                card:set_sprites(self)
                return true
            end, blockable = false, blocking = false
        })
    end,

    artfight_credit = {
        team = "Tragedy",
        name = "mikufanclub",
        year = "2026",
    },

    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = false,
    demicoloncompat = false,

    --[[
    config = {
        extra = {
            
        }
    },
    --]]

    attributes = {
        "prevents_death", "destroy_card"
    },
    loc_vars = function(self, info_queue, card)
        local key = self.key
        local main_end
        local colour = mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8)
        local text = localize("k_compatible")
        if G.jokers and card.area == G.jokers then
            local my_pos
            for i, v in ipairs(G.jokers.cards) do
                if v == card then
                    my_pos = i
                    break
                end
            end
            if not my_pos or my_pos == 1 then
                colour = mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8)
                text = localize("k_incompatible")
            end
            print("creating main end...")
            main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { align = "m", colour = colour, r = 0.05, padding = 0.06, },
                            nodes = {
                                { n = G.UIT.T, config = { text = text, colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                } }
        end


        return {
            key = key,
            main_end = main_end
        }
    end,

    calculate = function(self, card, context)
        if context.game_over then
            local my_pos
            for i, v in ipairs(G.jokers.cards) do
                if v == card then
                    my_pos = i
                    break
                end
            end

            if my_pos and my_pos > 1 and G.jokers.cards[my_pos-1] then
                SMODS.destroy_cards(G.jokers.cards[my_pos-1],{
                    bypass_eternal = true
                })
                G.E_MANAGER:add_event(Event{
                    func = function ()
                        play_sound('slice1', 0.96+math.random()*0.08)
                        return true
                    end
                })

                return {
                    saved = "mintfight_saved_by_vivica"
                }
            end
        end
    end
}