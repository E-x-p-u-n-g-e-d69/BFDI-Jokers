function hasJoker(key)
    return next(find_joker("j_bfdi_"..key)) ~= nil
end
SMODS.Atlas{
    key = 'BFDI',
    path = 'bfdi.png',
    px = 71,
    py = 95
}
-- firey
SMODS.Joker{
    key = 'firey',
    loc_txt = { -- local text
        name = 'Firey',
        text = {
          'If card played is red',
          'gain {X:mult,C:white}X#2#{} mult',
          "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} mult)"
        },
    },
    atlas = 'BFDI',
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    config = {
      extra = {
        xmult = 1,
        xmult_gain = 0.025
      }
    },
    init = function(self)
        self.held_leafy = false
    end,
    loc_vars = function(self,info_queue,center)
        return {
            vars = {
                center.ability.extra.xmult, center.ability.extra.xmult_gain
            }
        }
    end,
    check_for_unlock = function(self, args)
        if args.type == 'firey' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
    calculate = function(self,card,context)
        if context.individual and context.cardarea == G.play and (context.other_card:is_suit("Diamonds") or context.other_card:is_suit("Hearts")) and not context.blueprint then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT,
                message_card = card
            }
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult,
            }
        end
    end,
}
-- leafy
SMODS.Joker{
    key = 'leafy',
    loc_txt = {
        name = 'Leafy',
        text = {
          'If card played is black',
          'gain {X:mult,C:white}X#2#{} mult',
          "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} mult)"
        },
    },
    atlas = 'BFDI',
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 0},
    config = {
      extra = {
        xmult = 1,
        xmult_gain = 0.025,
      }
    },
    init = function(self)
        self.held_firey = false
    end,
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.xmult, center.ability.extra.xmult_gain, center.ability.extra.xmult_gain*2}}
    end,
    check_for_unlock = function(self, args)
        if args.type == 'leafy' then
            unlock_card(self)
        end
        unlock_card(self)
    end,
    calculate = function(self,card,context)
        held_firey = held_firey or false
        if context.individual and context.cardarea == G.play and (context.other_card:is_suit("Clubs") or context.other_card:is_suit("Spades")) and not context.blueprint then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT,
                message_card = card
            }
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
}
-- boible
SMODS.Joker{
    key = "bubble",
    loc_txt = {
        name = 'Bubble',
        text = {
            "{X:mult,C:white}X#1#{} mult",
            "{C:green,E:1}#2# in #3#{} chance this",
            "card is destroyed",
            "at end of round",
        }
    },
    config = {
        extra = {
            xmult = 5,
            odds = 3
        }
    },
    rarity = 1,
    atlas = "BFDI",
    pos = {
        x = 4,
        y = 0
    },
    cost = 6,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    rental_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult,
                (G.GAME.probabilities.normal or 1),
                card.ability.extra.odds,
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
        if context.end_of_round and context.game_over == false and not context.repetition and not context.blueprint then
            prob = G.GAME.probabilities.normal or 1
            if pseudorandom('bubble') < prob / card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
                    end
                }))
                return {
                    message = 'Popped!'
                }
            else
                return {
                    message = 'Safe!'
                }
            end
        end
    end
}
-- pencil
SMODS.Joker{
    key = "pencil",
    loc_txt = {
        name = 'Pencil',
        text = {
            "{C:mult}+#1#{} mult if",
            "played card has an {C:enhanced}enhancement{}",
        }
    },
    config = {
        extra = {
            mult = 5,
            xmult = 1.5
        }
    },
    rarity = 2,
    atlas = "BFDI",
    pos = { x = 3, y = 0 },
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rental_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and (next(SMODS.get_enhancements(context.other_card, false)) ~= nil) then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}
-- match
SMODS.Joker{
    key = "match",
    loc_txt = {
        name = 'Match',
        text = {
            "{C:mult}+#1#{} mult if",
            "played card has no {C:enhanced}enhancement{}",
        }
    },
    config = {
        extra = {
            mult = 10,
            xmult = 2
        }
    },
    rarity = 2,
    atlas = "BFDI",
    pos = { x = 2, y = 0 },
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rental_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and next(SMODS.get_enhancements(context.other_card, false)) == nil then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}
-- flower
SMODS.Joker {
    key = "flower",
    loc_txt = {
        name = "Flower",
        text = {
            "{X:mult,C:white}X#1#{} mult",
            "{C:red}disabled{} in {C:attention}boss blinds{}"
        }
    },
    config = {
        extra = {
            xmult = 5
        }
    },
    rarity = 2,
    atlas = "BFDI",
    pos = {
        x = 5,
        y = 0
    },
    cost = 5,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if not G.GAME.blind.boss then
                return {
                    xmult = card.ability.extra.xmult
                }
            else
                return {
                    message = "Disabled!"
                }
            end
        end
    end
}
-- pin
SMODS.Joker {
    key = "pin",
    loc_txt = {
        name = "Pin",
        text = {
            "{C:mult}+#1#{} mult if played",
            "card is of a sharp suit",
        }
    },
    config = {
        extra = {
            mult = 5,
        }
    },
    rarity = 2,
    atlas = "BFDI",
    pos = {
        x = 6,
        y = 0
    },
    cost = 5,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not (context.other_card:is_suit("Hearts") or context.other_card:is_suit("Clubs")) then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}
-- coiny
SMODS.Joker {
    key = "coiny",
    loc_txt = {
        name = "Coiny",
        text = {
            "{C:mult}+#1#{} mult if played",
            "card is of a round suit",
        }
    },
    config = {
        extra = {
            mult = 5,
        }
    },
    rarity = 2,
    atlas = "BFDI",
    pos = {
        x = 7,
        y = 0
    },
    cost = 5,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and (context.other_card:is_suit("Hearts") or context.other_card:is_suit("Clubs")) then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}
-- golf ball
SMODS.Joker {
    key = "golfball",
    loc_txt = {
        name = "Golf Ball",
        text = {
            "Gives the leftmost card of scoring hand",
            "an {C:edition}edition{}",
            "{C:inactive}(Overwrites current edition, Excludes {C:dark_edition}Negative{C:inactive}){}"
        }
    },
    config = {
        extra = {
        }
    },
    rarity = 2,
    atlas = "BFDI",
    pos = {
        x = 8,
        y = 0
    },
    cost = 5,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    rental_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
        }
    end,
    calculate = function(self, card, context)
        if context.before and context.main_eval	then
            local card = context.scoring_hand[1]
            if not card.debuff then
                local edition = pseudorandom_element({{polychrome = true}, {foil = true}, {holo = true}}, pseudoseed("golfball"))
                card:set_edition(edition, true)
            end
		end
    end,
}
-- tennis ball
SMODS.Joker {
    key = "tennisball",
    loc_txt = {
        name = "Tennis Ball",
        text = {
            "Gives the leftmost card of scoring hand",
            "a {C:edition}seal{}",
            "{C:inactive}(Overwrites current seal){}"
        }
    },
    config = {
        extra = {
        }
    },
    rarity = 2,
    atlas = "BFDI",
    pos = {
        x = 9,
        y = 0
    },
    cost = 5,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    rental_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
        }
    end,
    calculate = function(self, card, context)
        if context.before and context.main_eval	then
            local card = context.scoring_hand[1]
            if not card.debuff then
                local seal = pseudorandom_element({"Red", "Blue", "Purple", "Gold"}, pseudoseed("golfball"))
                card:set_seal(seal)
            end
		end
    end,
}
-- teardrop
SMODS.Joker {
    key = "teardrop",
    loc_txt = {
        name = "Teardrop",
        text = {
            "{X:chips,C:white}X#1#{C:chips} chips{} and {X:mult,C:white}X#2#{C:mult} mult{}",
            "if played hand consists of",
            "only {C:red}debuffed{} cards"
        }
    },
    config = {
        extra = {
            xchips = 10,
            xmult = 10
        }
    },
    rarity = 2,
    atlas = "BFDI",
    pos = {
        x = 0,
        y = 1
    },
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rental_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xchips,
                card.ability.extra.xmult
            }
        }
    end,
    calculate = function(self, card, context)
        if context.before and context.main_eval then
            hand_debuff = true
            for _, card in ipairs(context.scoring_hand) do
                if not card.debuff then
                    hand_debuff = false
                end
            end
        end
        if context.joker_main and hand_debuff then
            return {
                xchips = card.ability.extra.xchips,
                xmult = card.ability.extra.xmult
            }
        end
    end,
}
-- eraser
SMODS.Joker {
    key = "eraser",
    loc_txt = {
        name = "Eraser",
        text = {
            "Cards with the rank of the factorial of the difference of",
            "the square of the number of spacial dimensions in this universe,",
            "and one more than the smallest perfect number each give {X:mult,C:white}X#1#{} mult",
        }
    },
    config = {
        extra = {
            xmult = 2
        }
    },
    rarity = 2,
    atlas = "BFDI",
    pos = {
        x = 1,
        y = 1
    },
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rental_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 2 then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
}
-- ice cube
SMODS.Joker {
    key = "ice_cube",
    loc_txt = {
        name = "Ice Cube",
        text = {
            "This joker gains {C:chips}+#1#{} chip(s)",
            "for each pip on the triggered card.",
            "{C:inactive}(Currently {C:chips}+#2#{C:inactive} chips)",
            "{C:inactive}(Face cards have 1 pip)"
        }
    },
    config = {
        extra = {
            chip_gain = 0.5,
            chips = 0
        }
    },
    rarity = 2,
    atlas = "BFDI",
    pos = {
        x = 2,
        y = 1
    },
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rental_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chip_gain,
                card.ability.extra.chips
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            local id = context.other_card:get_id()
            if id > 10 then
                pip = 1
            elseif id > 0 then
                pip = id
            end
            card.ability.extra.chips = card.ability.extra.chips + pip * card.ability.extra.chip_gain
            return {
                message = localize("k_upgrade_ex"),
                colour = G.C.CHIPS,
                message_card = card
            }
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end,
}
-- rocky
SMODS.Joker {
    key = "rocky",
    loc_txt = {
        name = "Rocky",
        text = {
            "This joker gains {X:dark_edition, C:white}^#1#{} mult",
            "if played hand is a flush five",
            "{C:inactive}(Currently {X:dark_edition, C:white}^#2#{C:inactive} mult)"
        }
    },
    config = {
        extra = {
            Emult_gain = 0.01,
            Emult = 1
        }
    },
    rarity = 3,
    atlas = "BFDI",
    pos = {
        x = 3,
        y = 1
    },
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rental_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.Emult_gain,
                card.ability.extra.Emult
            }
        }
    end,
    calculate = function(self, card, context)
    if context.before and next(context.poker_hands["Flush Five"]) and not context.blueprint then
        card.ability.extra.Emult = card.ability.extra.Emult + card.ability.extra.Emult_gain
        return {
            message = localize("k_upgrade_ex"),
            colour = G.C.DARK_EDITION,
            message_card = card
        }
    end
    if context.joker_main then
        return {
            Emult_mod = card.ability.extra.Emult,
            message = "^" .. number_format(card.ability.extra.Emult) .. " mult",
            colour = G.C.DARK_EDITION,
        }
    end
end,
}
-- snowball
SMODS.Joker {
    key = "snowball",
    loc_txt = {
        name = "Snowball",
        text = {
            "Has a {C:green}#1# in #2#{} chance to create a",
            "{C:tarot}Strength{} card when a card is played"
        }
    },
    config = {
        extra = {
            odds = 5,
        }
    },
    rarity = 2,
    atlas = "BFDI",
    pos = {
        x = 4,
        y = 1
    },
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rental_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                (G.GAME.probabilities.normal or 1),
                card.ability.extra.odds,
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            if pseudorandom('snowball') < (G.GAME.probabilities.normal or 1) / card.ability.extra.odds then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            set = 'Tarot',
                            key_append = 'j_bfdi_snowball',
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                return {
                    message = localize('k_plus_tarot'),
                    message_card = card,
                    colour = G.C.TAROT,
                }
            end
        end
    end
}
-- david
SMODS.Joker {
    key = "david",
    loc_txt = {
        name = "David",
        text = {
            "Aw, seriously!"
        }
    },
    config = {
        extra = {
            odds = 10
        }
    },
    rarity = 3,
    atlas = "BFDI",
    pos = {
        x = 5,
        y = 1
    },
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rental_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                (G.GAME.probabilities.normal or 1),
                card.ability.extra.odds,
            }
        }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and not context.repetition then
            local prob = G.GAME.probabilities.normal
            if pseudorandom('david') < prob / card.ability.extra.odds then
                local jokers = {}
                for _, j in ipairs(G.jokers.cards) do
                    if j ~= card then
                        table.insert(jokers, j)
                    end
                end
                if #jokers > 0 then
                    local valid_jokers = {}
                    for _, j in ipairs(jokers) do
                        if j.config.center.key then
                            table.insert(valid_jokers, j)
                        end
                    end
                    if #valid_jokers > 0 then
                        local idx = pseudorandom("", 1, #valid_jokers)
                        local joker_to_copy = valid_jokers[idx]
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                SMODS.add_card{
                                    set = 'Joker',
                                    key = joker_to_copy.config.center.key
                                }
                                return true
                            end
                        }))
                        return {
                            message = "Aw, seriously!",
                            message_card = card,
                            colour = G.C.MULT,
                        }
                    end
                end
            end
        end
    end,
}
-- pen
SMODS.Joker {
    key = "pen",
    loc_txt = {
        name = "Pen",
        text = {
            "Give {C:mult}+#1#{} mult for each 4 triggered",
            "Gives {X:mult,C:white}X#2#{} mult instead if held for #5# rounds",
            "Gives {X:dark_edition,C:white}^#3#{} mult instead if held for #6# rounds",
            "{C:inactive}(Currently #4# rounds)"
        }
    },
    config = {
        extra = {
            mult = 5,
            xmult = 2.5,
            Emult = 1.25,
            heldrounds = 0,
            heldroundcap1 = 5,
            heldroundcap2 = 15
        }
    },
    rarity = 2,
    atlas = "BFDI",
    pos = {
        x = 6,
        y = 1
    },
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rental_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.xmult,
                card.ability.extra.Emult,
                card.ability.extra.heldrounds,
                card.ability.extra.heldroundcap1,
                card.ability.extra.heldroundcap2
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 4 then
                if card.ability.extra.heldrounds >= card.ability.extra.heldroundcap2 then
                    return {
                        Emult_mod = card.ability.extra.Emult,
                        message = "^" .. number_format(card.ability.extra.Emult) .. " mult",
                        colour = G.C.DARK_EDITION,
                    }
                elseif card.ability.extra.heldrounds >= card.ability.extra.heldroundcap1 then
                    return{
                        xmult = card.ability.extra.xmult
                    }
                else
                    return{
                        mult = card.ability.extra.mult
                    }
                end
            end
        end
        if context.end_of_round and context.game_over == false and not context.repetition and not context.blueprint then
            card.ability.extra.heldrounds = card.ability.extra.heldrounds + 1
            return {}
        end
    end
}
-- woody
SMODS.Joker {
    key = "woody",
    loc_txt = {
        name = "Woody",
        text = {
            "Gives a {C:spectral}spectral{} card",
            "if you end the round with",
            "no hands to spare"
        }
    },
    config = {
        extra = {
        }
    },
    rarity = 2,
    atlas = "BFDI",
    pos = {
        x = 7,
        y = 1
    },
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rental_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {

            }
        }
    end,
    calculate = function(self, card, context)

        if context.end_of_round and context.game_over == false and not context.repetition and not context.blueprint then
            if G.GAME.current_round.hands_left <= 0 then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            set = 'Spectral',
                            key_append = 'j_bfdi_woody',
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                return {
                    message = localize('k_plus_spectral'),
                    message_card = card,
                    colour = G.C.SPECTRAL,
                }
            end
        end
    end,
}
-- spongy
SMODS.Joker {
    key = "spongy",
    loc_txt = {
        name = "Spongy",
        text = {
            "Reduces joker slots by #1# every round",
            "and gain {X:mult,C:white}X#2#{} mult",
            "{C:inactive}(Minimum of 0 slots)(Currently {X:mult,C:white}X#3#{C:inactive} mult)"
        }
    },
    config = {
        extra = {
            slots = 1,
            xmult_gain = 2,
            xmult = 1,
        }
    },
    rarity = 2,
    atlas = "BFDI",
    pos = {
        x = 8,
        y = 1
    },
    cost = 5,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    rental_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.slots,
                card.ability.extra.xmult_gain,
                card.ability.extra.xmult,
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult,
            }
        end
        if context.end_of_round and context.game_over == false and not context.repetition and not context.blueprint and not (G.jokers.config.card_limit <= 0) then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
            G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT,
                message_card = card
            }
        end
    end,
}
-- needle
SMODS.Joker {
    key = "needle",
    loc_txt = {
        name = "Needle",
        text = {
            "Gives {X:mult,C:white}X#1#{} mult and {X:chips,C:white}X#2#{} chips if",
            "played hand does not contain sharp suits",
            "and does not contain a #3#"
        }
    },
    config = {
        extra = {
            xmult = 3,
            xchips = 3,
            type = "Flush"
        }
    },
    rarity = 2,
    atlas = "BFDI",
    pos = {
        x = 9,
        y = 1
    },
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rental_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult,
                card.ability.extra.xchips,
                card.ability.extra.type
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main and not next(context.poker_hands[card.ability.extra.type]) then
            local sharp = false
            for _, c in ipairs(context.full_hand) do
                if c:is_suit("Diamonds") or c:is_suit("Spades") then
                    sharp = true
                end
            end
            if not sharp then
                return {
                    xmult = card.ability.extra.xmult,
                    xchips = card.ability.extra.xchips,
                }
            end
        end 
    end,
}
--[[
SMODS.Joker {
    key = "",
    loc_txt = {
        name = "",
        text = {
            ""
        }
    },
    config = {
        extra = {

        }
    },
    rarity = ,
    atlas = "BFDI",
    pos = {
        x = ,
        y = 
    },
    cost = ,
    blueprint_compat = ,
    eternal_compat = ,
    perishable_compat = ,
    rental_compat = ,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {

            }
        }
    end,
    calculate = function(self, card, context)
    
    end,
}
]]