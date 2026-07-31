Mintfight.Attack {
    key = "amara",
    name = "Amara Bisan Desta",
    pronouns = "she_her",

    atlas = 'jokers',
    pos = {
        x = 8,
        y = 1
    },
    soul_pos = {
        x = 8,
        y = 2
    },
    
    artfight_credit = {
        name = "marisa",
        team = "Tragedy",
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
            ready = true
        }
    },

    attributes = {

    },
    loc_vars = function(self, info_queue, card)
        local key = self.key
        if next(SMODS.find_mod("playwright")) then
            key = key.."_alt"
        end
        return {
            key = key,
            vars = {
                
            }
        }
    end,

    add_to_deck = function (self, card, from_debuff)
        if next(SMODS.find_mod("playwright")) then
            local another = SMODS.poll_object{
                type = "Joker",
                filter = function (pool)
                    local new_pool = {}
                    for i,v in ipairs(pool) do
                        local center = G.P_CENTERS[v.key]
                        if center and center.original_mod and center.original_mod.id == "playwright" then
                            new_pool[#new_pool+1] = v
                        end
                    end
                    if not next(new_pool) then
                        new_pool[1] = {key = "j_joker", type = "Joker"}
                    end
                    return new_pool
                end
            }
        end

        if another and another ~= "j_joker" then
            SMODS.add_card{
                key = another,
                area = G.jokers
            }
        end
    end,
    
    calculate = function(self, card, context)
        if context.before and card.ability.extra.ready then
            local target
            for i,v in ipairs(context.full_hand) do
                target = v
                for ii,vv in ipairs(context.scoring_hand) do
                    if vv == v then target = nil break end
                end
                if target then break end
            end

            if target then
                card.ability.extra.ready = false
                return {
                    func = function ()
                        G.E_MANAGER:add_event(Event{
                            func = function ()
                                target:flip()
                                return true
                            end
                        })
                        G.E_MANAGER:add_event(Event{
                            func = function ()
                                assert(SMODS.change_base(target, nil, 'Ace'))
                                target:juice_up()
                                return true
                            end
                        })
                        G.E_MANAGER:add_event(Event{
                            func = function ()
                                target:flip()
                                return true
                            end
                        })
                    end
                }
            end
        end

        if context.end_of_round and context.main_eval and not card.ability.extra.ready then
            card.ability.extra.ready = true
            return {
                message = localize("mintfight_ready_ex")
            }
        end
    end
}