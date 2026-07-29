G.FUNCS.mintfight_optcycle = function(args)
    local refval = args.cycle_config.ref_value
    Mintfight.config[refval].current_option = args.cycle_config.current_option
    Mintfight.config[refval].option_value = args.to_val
end

G.FUNCS.mintfight_gameset_optcycle = function(args)
    local refval = args.cycle_config.ref_value
    G.PROFILES[G.SETTINGS.profile][refval].current_option = args.cycle_config.current_option
    G.PROFILES[G.SETTINGS.profile][refval].option_value = args.to_val
end

G.FUNCS.mintfight_unlock = function()
    for k, v in pairs(G.P_CENTERS) do --skips blinds and tags, remember to update this if we add any of those
        if v.original_mod and v.original_mod.id == "minty-artfight" then
            v.alerted = true
            v.discovered = true
            v.unlocked = true
        end
    end

    set_profile_progress()
    set_discover_tallies()
    G:save_progress()
    G.FILE_HANDLER.force = true
end

SMODS.current_mod.config_tab = function()
    return {
        n = G.UIT.ROOT,
        config = { r = 0.1, minw = 8, minh = 6, align = "tl", padding = 0.2, colour = G.C.BLACK },
        nodes = {
            {
                n = G.UIT.C,
                config = { minw = 1, minh = 1, align = "tl", colour = G.C.CLEAR, padding = 0.15 },
                nodes = {
                    UIBox_button({
                        button = "mintfight_unlock",
                        label = { "Unlock all (local)" },
                        colour = G.C.GREY
                    }),
                    create_toggle({
                        label = "Violate Geneva conventions",
                        ref_table = Mintfight.config,
                        ref_value = 'violate_geneva_conventions',
                    }),
                    --[[
                    create_toggle({
                        label = "Checkbox",
                        ref_table = Mintfight.config,
                        ref_value = 'flavor_text',
                    }),
                    create_option_cycle {
                        label = "Option cycle",
                        options = { 'Unlocked', "Locked", "Sealed" },
                        current_option = Mintfight.config.three_lock.current_option,
                        ref_table = Mintfight.config,
                        ref_value = "three_lock",
                        opt_callback = 'minty_optcycle',
                        w = 5.5
                    },
                    ]]
                }
            }
        }
    }
end
