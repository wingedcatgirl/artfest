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
            {
                "Hi! I made this!",
                "Go click 'unlock all'",
                "in the profile menu",
                "if you want to see",
                "everything right away!"
            },
            {
                "If the button is gone,",
                "I've got another mod",
                "to handle that!"
            }
        }
    },
    atlas = "minty_title",
    discovered = true,
    pos = {x=0, y=0},
    soul_pos = {x=1,y=0},
    in_pool = function (self, args)
        return false
    end,
    set_ability = function (self, card, initial, delay_sprites)
            G.E_MANAGER:add_event(Event {
                func = function()
                    if not card.area then return false end
                    if card.area.config.collection then
                        function card:click()
                            love.system.openURL("https://github.com/wingedcatgirl/re-Unlock-All")
                            card.click = Card.click
                        end
                    end
                    return true
                end, blocking = false, trigger = "after", delay = 0.25, timer = "UPTIME"
            })
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