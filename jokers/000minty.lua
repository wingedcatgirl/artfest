SMODS.Atlas{
    key = "minty_title",
    path = "minty.png",
    px = 71,
    py = 95
}

SMODS.Joker{
    key = "minty_title",
    loc_txt = {
        name = "Minty :3",
        text = {
            "Hi! I made this!",
            "Go click 'unlock all'",
            "in the config menu",
            "if you want to see",
            "everything right away!"
        }
    },
    atlas = "minty_title",
    discovered = true,
    pos = {x=0, y=0},
    soul_pos = {x=1,y=0},
    in_pool = function (self, args)
        return false
    end,
    calculate = function (self, card, context)
        if not G.SETTINGS.paused and not (card.area and card.area.config.collection or card.area == G.title_top) and not card.byebye then
            card.byebye = true
            G.E_MANAGER:add_event(Event{
                func = function ()
                    card:remove()
                    return true
                end, blockable = true, blocking = false
            })
        end
    end
}