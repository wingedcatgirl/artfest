Mintfight.Attack {
    key = "moirai",
    name = "Moirai",
    pronouns = "any_all",

    atlas = 'jokers',
    pos = {
        x = 10,
        y = 1
    },
    soul_pos = {
        x = 10,
        y = 2
    },

    artfight_credit = {
        name = "artsyGeek",
        team = "Mystery",
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
            remembered_center_key = nil,
            remembered_extra = {

            },
            remembered_set = nil,
            remembered_front = nil,
            remembered_rank = nil,
            remembered_suit = nil,
            remembered_edition = nil,
            remembered_seal = nil,
            never_remembered = "true"
        }
    },

    attributes = {

    },
    loc_vars = function(self, info_queue, card)
        local key = self.key
        info_queue[#info_queue + 1] = { set = "Other", key = "mintfight_temporary", vars = {} }

        if card.ability.extra.never_remembered then
            return {
                vars = {
                    localize("k_none")
                }
            }
        end

        local center = card.ability.extra.remembered_center_key
        local ispc = not not card.ability.extra.remembered_front
        local rank, suit, prefix, suffix = "","","",""
        local suitcol = G.C.BLACK

        if center ~= "c_base" then
            info_queue[#info_queue + 1] = G.P_CENTERS[center]
        end

        if ispc then
            key = key.."_pc"
            if not G.P_CENTERS[center].no_rank then
                rank = localize(card.ability.extra.remembered_rank, "ranks")
            end
            if not G.P_CENTERS[center].no_suit then
                suit = localize(card.ability.extra.remembered_suit, "suits_plural")
                suitcol = G.C.SUITS[card.ability.extra.remembered_suit]
            end
            if center ~= "c_base" then
                suffix = localize{type = "name_text", set = "Enhanced", key = center}
            end
            if card.ability.extra.remembered_edition then
                prefix = localize{key = card.ability.extra.remembered_edition, type = "name_text", set = "Edition"}
                info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.remembered_edition]
            end
            if card.ability.extra.remembered_seal then
		        info_queue[#info_queue + 1] = { set = "Other", key = card.ability.extra.remembered_seal }
                prefix = prefix..(prefix ~= "" and " " or "")..localize{type = "name_text", set = "Other", key = card.ability.extra.remembered_seal}
            end
        elseif card.ability.extra.remembered_edition then
            prefix = localize{key = card.ability.extra.remembered_edition, type = "name_text", set = "Edition"}
            prefix = prefix.." "
            info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.remembered_edition]
        end

        return {
            key = key,
            vars = {
                localize(center and {key = center, type = "name_text", set = card.ability.extra.remembered_set} or "k_none"),
                rank,
                suit,
                (suit) and " of " or "",
                prefix or "",
                suffix,
                colours = {
                    suitcol
                }
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_type_destroyed and context.card.config.center_key ~= card.config.center_key then
            local last = context.card
            if not last or last.ability.mintfight_temporary then return end

            for k,v in pairs(card.ability.extra) do
                card.ability.extra[k] = nil
            end
            card.ability.extra.remembered_extra = {}

            card.ability.extra.remembered_center_key = last.config.center_key
            for k,v in pairs(last.ability.extra or {}) do
                card.ability.extra.remembered_extra[k] = v
            end
            card.ability.extra.remembered_set = last.config.center.set
            if last.edition then
                card.ability.extra.remembered_edition = last.edition.key
            end
        end

        if context.remove_playing_cards then
            local removed = {}
            for i,v in ipairs(context.removed) do
                if not v.ability.mintfight_temporary then
                    removed[#removed+1] = v
                end
            end
            if not next(removed) then return end

            local last = context.removed[#context.removed]
            if not last then return end

            for k,v in pairs(card.ability.extra) do
                card.ability.extra[k] = nil
            end
            card.ability.extra.remembered_extra = {}

            card.ability.extra.remembered_rank = last.base.value
            card.ability.extra.remembered_suit = last.base.suit

            card.ability.extra.remembered_center_key = last.config.center_key
            for k,v in pairs(last.ability.extra or {}) do
                card.ability.extra.remembered_extra[k] = v
            end
            card.ability.extra.remembered_set = last.config.center.set
            if last.edition then
                card.ability.extra.remembered_edition = last.edition.key
            end
            if last.seal then
                card.ability.extra.remembered_seal = last.seal
            end
            card.ability.extra.remembered_front = last.config.card_key
        end

        if context.setting_blind then
            local ispc = {
                Default = true,
                Base = true,
                ["Default Base"] = true,
                Enhanced = true,
            }

            local ghost = SMODS.add_card{
                key = card.ability.extra.remembered_center_key,
                edition = card.ability.extra.remembered_edition,
                seal = card.ability.extra.remembered_seal,
                front = card.ability.extra.remembered_front,
                area = G.play,
                force_stickers = {
                    "mintfight_temporary"
                }
            }

            for k,v in pairs(card.ability.extra.remembered_extra) do
                ghost.ability.extra[k] = v
            end

            delay(1)

            G.E_MANAGER:add_event(Event {
                func = function()
                    draw_card(G.play, ispc[card.ability.extra.remembered_set] and G.deck or card.ability.extra.remembered_set == "Joker" and G.jokers or G.consumeables, 90, "up", nil, ghost)
                    return true
                end
            })
        end
    end
}