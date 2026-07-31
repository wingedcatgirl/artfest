SMODS.Sticker{
    key = "temporary",
    pos = { x = 100, y = 100 }, --Invisible sticker! \o/
    should_apply = function (self, card, center, area, bypass_roll)
        if bypass_roll then return true end
        --tba inherit perishable compatibility here if we ever do it in non-guaranteed ways
        return false
    end,
    calculate= function (self, card, context)
        if card.sell_cost ~= 0 then card.sell_cost = 0 end
        local ispc = SMODS.is_playing_card(card)
        if (not ispc and context.end_of_round) or (ispc and context.playing_card_end_of_round) then
            SMODS.destroy_cards(card, {pinch_anim = not SMODS.is_playing_card(card)})
        end
    end
}