if not next(SMODS.find_mod("cardpronouns")) then return end

CardPronouns.Pronoun{
    colour = HEX("FF90FF"),
    text_colour = G.C.WHITE,
    pronoun_table = { "He", "Him", "Any", "All" },
    in_pool = function()
        return true
    end,
    key = "he_any"
}