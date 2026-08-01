Mintfight.Attack {
    key = "clem",
    name = "Clementine",
    pronouns = "he_they",

    atlas = 'jokers',
    pos = {
        x = 6,
        y = 1
    },
    soul_pos = {
        x = 6,
        y = 2
    },

    artfight_credit = {
        team = "Tragedy",
        name = "nightlightyyy",
        year = "2026",
    },

    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    demicoloncompat = true,

    config = {
        extra = {
            amt = 3
        }
    },

    attributes = {
        "generation", "enhancements", "seals", "editions"
    },
    loc_vars = function(self, info_queue, card)
        local key = self.key
        info_queue[#info_queue + 1] = { set = "Other", key = "mintfight_temporary", vars = {} }
        return {
            key = key,
            vars = {
                card.ability.extra.amt
            }
        }
    end,

    calculate = function(self, card, context)
        if context.setting_blind or context.forcetrigger then
            local any_improvable = false
            for i,v in ipairs(G.playing_cards) do
                if not (v.edition and v.seal and v.center_key ~= "c_base") then
                    any_improvable = true
                    break
                end
            end
            if not any_improvable then 
                return {
                    message = localize("k_nope_ex")
                }
            end

            local cards = {}

            for i=1,card.ability.extra.amt do
                local copied = pseudorandom_element(G.playing_cards, "mintfight_clem_copy_"..i)
                local repoll = 0
                while copied.edition and copied.center_key ~= "c_base" and copied.seal and repoll < 20 do
                    repoll = repoll + 1
                    copied = pseudorandom_element(G.playing_cards, "mintfight_clem_copy_"..i.."_"..repoll)
                end
                local edition, enhancement, seal

                repoll = 0
                while not (edition and enhancement and seal) and repoll < 20 do
                    repoll = repoll + 1
                    if not edition and not copied.edition then
                        edition = SMODS.poll_edition{key="mintfight_clem_init_ed_"..i.."_"..repoll, mod = copied.edition and 1 or 3}
                    end
                    if not enhancement and copied.center_key == "c_base" then
                        enhancement = SMODS.poll_enhancement{key = "mintfight_clem_init_enh_"..i.."_"..repoll, mod = copied.center_key == "c_base" and 2 or 1}
                    end
                    if not seal and not copied.seal then
                        seal = SMODS.poll_seal{key = "mintfight_clem_init_seal_"..i.."_"..repoll, mod = copied.seal and 1 or 3}
                    end
                end

                local front = copied.config.card_key
                if G.P_CARDS[front] then
                    G.E_MANAGER:add_event(Event{
                        func = function()
                            local next_card = SMODS.add_card {
                                front = front,
                                edition = edition,
                                enhancement = enhancement,
                                seal = seal,
                                force_stickers = {
                                    "mintfight_temporary"
                                },
                                area = G.play
                            }

                            cards[#cards+1] = next_card

                            G.E_MANAGER:add_event(Event{
                                func = function ()
                                    draw_card(G.play, G.deck, 90, "up", nil, next_card)
                                    return true
                                end
                            })
                            return true
                        end,
                    })
                end
            end

            playing_card_joker_effects(cards)

            if not context.blueprint and not context.forcetrigger then
                delay(1.5)
                G.E_MANAGER:add_event(Event {
                    func = function()
                        G.E_MANAGER:add_event(Event { 
                            func = function()
                                G.E_MANAGER:add_event(Event{ --Why do I have to put this into a triple-layered event lmao.
                                    func = function ()
                                        G.deck:shuffle("mintfight_clem_reshuffle")
                                        return true
                                    end
                                })
                                return true
                            end
                        })
                        return true
                    end
                })
            end
        end
    end
}