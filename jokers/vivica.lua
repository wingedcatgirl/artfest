Comedy26.Attack {
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
        if Comedy26.config.violate_geneva_conventions then
            self.soul_pos = {x=5, y=2}
        else
            self.soul_pos = {x=4, y=2}
        end
    end,
    update = function (self, card, dt)
        if not self.soul_pos then return end
        if Comedy26.config.violate_geneva_conventions and self.soul_pos.x ~= 5 then
            self.soul_pos.x = 5
        elseif not Comedy26.config.violate_geneva_conventions and self.soul_pos.x ~= 4 then
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

    credit26 = {
        team = "Tragedy",
        name = "mikufanclub"
    },

    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = false,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    demicoloncompat = false,

    --[[
    config = {
        extra = {
            
        }
    },
    --]]

    attributes = {

    },
    --[[
    loc_vars = function(self, info_queue, card)
        local key = self.key
        return {
            key = key,
            vars = {
                
            }
        }
    end,
    --]]

    --[[
    calculate = function(self, card, context)
        -- Prevent death and destroy joker to the left, bypassing eternal
    end
    --]]
}