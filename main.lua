Comedy26 = {}
Comedy26.prefix = SMODS.current_mod.prefix
Comedy26.config = SMODS.current_mod.config
Comedy26.id = SMODS.current_mod.id
local prefix = Comedy26.prefix

Comedy26.Attack = SMODS.Joker:extend{
    loc_vars = function (self, info_queue, card)
        local key = self.key
        if not G.localization.descriptions[self.set][self.key] then
            key = prefix.."_no_desc"
        end
        if self.calculate == Comedy26.Attack.calculate then
            if not card.ability.extra.default_effect then
                if G.SETTINGS.paused then
                    card.ability.extra.default_effect = pseudorandom_element({ "mult", "chips", "xmult", "balance" },
                        "no advancing the rng by looking at the collection :p")
                else
                    card.ability.extra.default_effect = pseudorandom_element({ "mult", "chips", "xmult", "balance" },
                        "mincom_26_undefined_effect")
                end
            end
            local eff = card.ability.extra.default_effect
            info_queue[#info_queue+1] = {set = "Other", key = "mincom26_default_"..eff, vars = {card.ability.extra[eff]}}
        end
        return {
            key = key
        }
    end,
    atlas = "jokers",
    pos = {
        x=8, y=0
    },
    soul_pos = {
        x=9, y=0
    },
    config = {
        extra = {
            mult = 10,
            chips = 50,
            xmult = 1.5,
            balance = 25
        }
    },
    set_badges = function (self, card, badges)
        if not (self.discovered or card.bypass_discovery_ui) then return end
        local badge_cols = {
            comedy = "F6833A",
            tragedy = "236672",
            mystery = "AD2431",
            ["Unspecified Team"] = "CA7CA7"
        }
        local text_cols = {
            comedy = "000000",
            tragedy = "AAAAAA",
            mystery = "000000",
            ["Unspecified Artist"] = "FFFFFF"
        }

        local team = (self.credit26 or {}).team or "unspecified"
        local artist = (self.credit26 or {}).name or "unspecified"
        team = team:lower()
        local team_key = "mincom26_team_"..team
        badges[#badges+1] = create_badge({artist, localize(team_key)}, HEX(badge_cols[artist] or badge_cols[team] or "CA7CA7"), HEX(text_cols[artist] or text_cols[team] or "FFFFFF"), 1)
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            if not card.ability.extra.default_effect then
                card.ability.extra.default_effect = pseudorandom_element({"mult", "chips", "xmult", "balance"})
            end
            local eff = card.ability.extra.default_effect

            if eff == "mult" then
                return {
                    mult = card.ability.extra.mult
                }
            elseif eff == "chips" then
                return {
                    chips = card.ability.extra.chips
                }
            elseif eff == "xmult" then
                return {
                    xmult = card.ability.extra.xmult
                }
            elseif eff == "balance" then
                return {
                    func = function()
                        local diff = math.abs(mult - hand_chips)
                        diff = math.min(diff * (card.ability.extra.balance / 100), diff)
                        if diff < 1 then goto nvm end

                        if mult > hand_chips then
                            mult = mod_mult(mult - (diff / 2))
                            hand_chips = mod_chips(hand_chips + (diff / 2))
                        else
                            mult = mod_mult(mult + (diff / 2))
                            hand_chips = mod_chips(hand_chips - (diff / 2))
                        end

                        ::nvm::

                        G.E_MANAGER:add_event(Event({
                            func = (function()
                                play_sound('gong', 0.94, 0.3)
                                play_sound('gong', 0.94 * 1.5, 0.2)
                                play_sound('tarot1', 1.5)
                                ease_colour(G.C.UI_CHIPS, { 0.8, 0.45, 0.85, 1 })
                                ease_colour(G.C.UI_MULT, { 0.8, 0.45, 0.85, 1 })
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'after',
                                    blockable = false,
                                    blocking = false,
                                    delay = 0.8,
                                    func = (function()
                                        ease_colour(G.C.UI_CHIPS, G.C.BLUE, 0.8)
                                        ease_colour(G.C.UI_MULT, G.C.RED, 0.8)
                                        return true
                                    end)
                                }))
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'after',
                                    blockable = false,
                                    blocking = false,
                                    no_delete = true,
                                    delay = 1.3,
                                    func = (function()
                                        G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1],
                                            G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
                                        G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1],
                                            G.C.RED[2], G.C.RED[3], G.C.RED[4]
                                        return true
                                    end)
                                }))
                                return true
                            end)
                        }))
                    end,
                    message = localize('k_balanced'),
                    colour = G.C.PURPLE
                }
            end
        end
    end
}

SMODS.Atlas{
    key = "jokers",
    path = "jokers.png",
    px = 71,
    py = 95,
}

print("starting recursive load")
---@param path? string
local function recursive_load(path)
    path = path or ""

    ---@type string
    local full_path = SMODS.current_mod.path
    --ensure exactly one trailing slash by stripping the existing one(s) and then adding our own
    while full_path:len() > 0 and (full_path:sub(-1) == "/" or full_path:sub(-1) == "\\") do
        full_path = full_path:sub(1, -2)
    end
    full_path = full_path.."/"..(path)

    ---@class FileInfo
    ---@field type string
    ---@field name string
    ---@field size number
    ---@field modtime number

    ---@type FileInfo[]
    local info = NFS.getDirectoryItemsInfo(full_path)

    local function loading_blacklist(file)
        local directory_blacklist = {
            assets = true,
            localization = true,
        }
        local file_blacklist = {
            ["main.lua"] = true,
            ["config.lua"] = true,
            ["lsp_defs.lua"] = true,
            ["template.lua"] = true
        }

        if file.type == "directory" then return directory_blacklist[file.name] end
        
        local extension = file.name:sub(-4)
        if extension:lower() ~= ".lua" then return true end

        return file_blacklist[file.name:lower()]
    end
    for i,v in ipairs(info) do
        local filename = v.name
        if not loading_blacklist(v) then
            if v.type == "directory" then
                recursive_load(path..v.name.."/")
            else
                print(path..filename)
                assert(SMODS.load_file(path..filename))()
            end
        end
    end
end

recursive_load()

SMODS.current_mod.menu_cards = function()
    local cards, cards_left = {}, {}
    local minty_key = "j_" .. Comedy26.prefix .. "_minty_title"

    for k, v in pairs(G.P_CENTERS) do
        if v.original_mod and v.original_mod.id == Comedy26.id and v.key ~= minty_key then
            cards[#cards + 1] = k
            cards_left[#cards_left + 1] = k
        end
    end

    local menu_cards = {}

    for i = 1, math.min(#cards+1, 4) do
        if not next(cards_left) then break end
        local edition = SMODS.poll_edition() or SMODS.poll_edition() --Roll with advantage!
        local key = "sdkjfhgkldshgkl"
        if i == 1 then
            key = minty_key
        else
            local index = math.random(#cards_left)
            key = cards[index]
            table.remove(cards_left, index)
        end
        print(key, edition)
        menu_cards[#menu_cards + 1] = { key = key, edition = edition }
    end

    local msg = "Mrrp :3"
    menu_cards.func = function()
        local minty
        for i, v in ipairs(G.title_top.cards) do
            if v.config.center and v.config.center.key == minty_key then
                minty = v
                v.click = function(self)
                    G.FUNCS["openModUI_" .. self.config.center.original_mod.id]()
                end
                break
            end
        end
        local frames = 0
        G.E_MANAGER:add_event(Event {
            func = function()
                if not minty then
                    print("mrrp?")
                    return true
                end
                frames = frames + 1
                if frames >= 150 then
                    card_eval_status_text(minty, 'extra', nil, nil, nil, { message = msg, delay = 1.5 })
                    return true
                end
            end, blocking = false, blockable = true
        })
    end
    return menu_cards
end