SMODS.Atlas{
    key = 'BFDIA',
    path = 'bfdia.png',
    px = 71,
    py = 95
}
-- nickel
SMODS.Joker {
    key = "nickel",
    loc_txt = {
        name = "Nickel",
        text = {
            "This joker gives",
            "{X:chips,C:white}X#1# {} or {X:chips,C:white}X#2#{} Chips, {X:mult,C:white}X#3# {} or {X:mult,C:white}X#4#{} Mult,",
            "and {C:money}$#5#{} or {C:money}$#6#{} at the end of the round."
        }
    },
    config = {
        extra = {
            chip_low = 0.1,
            chip_high = 10,
            mult_low = 0.1,
            mult_high = 10,
            money_low = -10,
            money_high = 10
        }
    },
    rarity = 2,
    atlas = "BFDIA",
    pos = {
        x = 0,
        y = 0
    },
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rental_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chip_low,
                card.ability.extra.chip_high,
                card.ability.extra.mult_low,
                card.ability.extra.mult_high,
                card.ability.extra.money_low,
                card.ability.extra.money_high
            }
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            resetflag = false
        end
        if context.joker_main then
            chiprandom = pseudorandom("nickel_chip")
            multrandom = pseudorandom("nickel_mult")
            if chiprandom < 0.5 then
                Xc = card.ability.extra.chip_low or 0
            else
                Xc = card.ability.extra.chip_high or 0
            end
            if multrandom < 0.5 then
                Xm = card.ability.extra.mult_low or 0
            else
                Xm = card.ability.extra.mult_high or 0
            end

            return {
                xchips = Xc,
                xmult = Xm
            }
        end
        if context.end_of_round and context.game_over == false then
            moneyrandom = pseudorandom("nickel_money")
            if moneyrandom < 0.5 then
                givedollars = card.ability.extra.money_low or 0
            else
                givedollars = card.ability.extra.money_high or 0
            end
            return {
                dollars = givedollars
            }
        end
    end
}
-- bomby
SMODS.Joker {
    key = "bomby",
    loc_txt = {
        name = "Bomby",
        text = {
            "This joker's Mult is {C:attention}multiplied{} by {X:mult,C:white}X#1#{} at the end of the round.",
            "At the end of the round, it also has a",
            "{C:green,E:1}(#3#^1.25)%{} chance this joker is destroyed",
            "{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult) (Currently {C:green,E:1}#2#%{C:inactive} chance to be destroyed)"
        }
    },
    config = {
        extra = {
            xmult_mult = 1.5,
            destroy_chance = 1,
            xmult = 1
        }
    },
    rarity = 2,
    atlas = "BFDIA",
    pos = {
        x = 1,
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
                card.ability.extra.xmult_mult,
                card.ability.extra.destroy_chance,
                card.ability.extra.xmult
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
        if context.end_of_round and not context.blueprint and context.game_over == false then
            card.ability.extra.xmult = card.ability.extra.xmult * card.ability.extra.xmult_mult
            card.ability.extra.destroy_chance = card.ability.extra.xmult ^ 1.25
            if pseudorandom('bomby') < card.ability.extra.destroy_chance / 100 then
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
                    message = 'Exploded!'
                }
            end
            return {
                message = 'Upgraded!'
            }
        end
    end,
}
-- book
SMODS.Joker {
    key = "book",
    loc_txt = {
        name = "Book",
        text = {
            "Whenever a {C:attention}joker{} (other than this one) is {C:attention}bought{}",
            "gain {C:mult}+#1#{} Mult",
            "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
        }
    },
    config = {
        extra = {
            mult_gain = 15,
            mult = 0
        }
    },
    rarity = 1,
    atlas = "BFDIA",
    pos = {
        x = 2,
        y = 0
    },
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rental_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult_gain,
                card.ability.extra.mult
            }
        }
    end,
    calculate = function(self, card, context)
        if context.buying_card then
            print(context.card.config.center)
            if context.card.config.center.set == "Joker" and not context.card.config.center.key == "j_bfdi_book" then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                return {
                    message = "Upgraded!"
                }
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
}
-- dora
SMODS.Joker {
    key = "dora",
    loc_txt = {
        name = "Dora",
        text = {
            "At the end of the round",
            "{C:green,E:1}#1# in #2#{} chance to create",
            "{C:attention}#3#{} {C:dark_edition}negative{} {C:spectral}Soul{} cards"
        }
    },
    config = {
        extra = {
            soul_cards = 5,
            odds = 100
        }
    },
    rarity = 3,
    atlas = "BFDIA",
    pos = {
        x = 3,
        y = 0
    },
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    rental_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                G.GAME.probabilities.normal,
                card.ability.extra.odds,
                card.ability.extra.soul_cards
            }
        }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and not context.repetition and context.game_over == false then
            prob = G.GAME.probabilities.normal
            if pseudorandom("dora") < (prob/card.ability.extra.odds) then
                for i = 1, card.ability.extra.soul_cards do
                    G.E_MANAGER:add_event(Event({
                        trigger = "before",
                        delay = 0.0,
                        func = function()
                            local new_card = create_card(nil, G.consumeables, nil, nil, nil, nil, "c_soul", "-")
                            new_card:set_edition({ negative = true }, true)
                            new_card:add_to_deck()
                            G.consumeables:emplace(new_card)
                            return true
                        end,
                    }))
                end
            end
        end
    end

}
-- fries
SMODS.Joker {
    key = "fries",
    loc_txt = {
        name = "Fries",
        text = {
            "At the end of round, {C:green,E:1}#1# in #2#{} chance to",
            "{C:attention}multiply{} Mult by #3#",
            "Otherwise, {C:attention}divide{} Mult by #4#",
            "{C:inactive} (Currently {X:mult,C:white}X#5#{C:inactive} Mult) (FIXED PROBABILITY)"
        }
    },
    config = {
        extra = {
            odds = 2,
            xmult_mult = 4,
            xmult_div = 2,
            xmult = 1
        }
    },
    rarity = 2,
    atlas = "BFDIA",
    pos = {
        x = 4,
        y = 0
    },
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rental_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                1,
                card.ability.extra.odds,
                card.ability.extra.xmult_mult,
                card.ability.extra.xmult_div,
                card.ability.extra.xmult
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
        if context.end_of_round and not context.blueprint and not context.repetition and context.game_over == false then
            prob = 1
            if pseudorandom("fries") < (prob/card.ability.extra.odds) then
                card.ability.extra.xmult = card.ability.extra.xmult * card.ability.extra.xmult_mult
                return {
                    message = "Upgraded!"
                }
            else
                card.ability.extra.xmult = card.ability.extra.xmult / card.ability.extra.xmult_div
                return {
                    message = "Decreased!"
                }
            end
        end
    end,
}
-- gelatin
SMODS.Joker {
    key = "gelatin",
    loc_txt = {
        name = "Gelatin",
        text = {
            "This joker gains {X:chips,C:white}X#1#{} whenever a(n) {C:attention}#2#{} is scored",
            "{C:inactive}(Currently {X:chips,C:white}X#3#{C:inactive} Chips)",
            "{C:inactive}(Rank changes at the end of every round)",
            "{C:inactive}(Rank will never be a face card)"
        }
    },
    config = {
        extra = {
            rank = 1,
            xchips_gain = 0.01,
            xchips = 1
        }
    },
    rarity = 1,
    atlas = "BFDIA",
    pos = {
        x = 5,
        y = 0
    },
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rental_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xchips_gain,
                card.ability.extra.rank,
                card.ability.extra.xchips,
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual then
        end
        if context.individual and context.cardarea == G.play and (context.other_card:get_id() == card.ability.extra.rank or (context.other_card:get_id() == 14 and card.ability.extra.rank == 1)) and not context.blueprint then
            card.ability.extra.xchips = card.ability.extra.xchips + card.ability.extra.xchips_gain
            return {
                message = "Upgraded!",
                message_card = card,
                colour = G.C.CHIPS
            }
        end
        if context.joker_main then
            return {
                xchips = card.ability.extra.xchips
            }
        end
        if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
            rank = pseudorandom("gelatin",1,10)
            if rank > 1 then
                card.ability.extra.rank = rank
            else
                card.ability.extra.rank = "Ace"
            card.ability.extra.xchips_gain = card.ability.extra.rank/100
        end
    end,
}
-- puffball TODO: fix animation
SMODS.Joker {
    key = "puffball",
    loc_txt = {
        name = "Puffball",
        text = {
            "Before a hand is scored",
            "changes the {C:attention}suit{} of every scoring card",
            "For each card changed, gain {X:mult,C:white}X#1#{} Mult",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
        }
    },
    config = {
        extra = {
            xmult_gain = 0.02,
            xmult = 1
        }
    },
    rarity = 2,
    atlas = "BFDIA",
    pos = {
        x = 6,
        y = 0
    },
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rental_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult_gain,
                card.ability.extra.xmult
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            suitnum = pseudorandom("puffball",1,4)
            if suitnum == 1 then
                suit = "Hearts"
            elseif suitnum == 2 then
                suit = "Diamonds"
            elseif suitnum == 3 then
                suit = "Clubs"
            else
                suit = "Spades"
            end
            context.other_card:change_suit(suit)
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
}
-- ruby
SMODS.Joker {
    key = "ruby",
    loc_txt = {
        name = "Ruby",
        text = {
            "Destroys {C:attention}all{} held jokers, and gain", 
            "{X:mult,C:white}X#1#{} Mult and {X:chips,C:white}X#1#{} Chips per Joker destroyed",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult and {X:chips,C:white}X#2#{C:inactive} Chips)",
            " ",
            "{C:inactive,s:0.8}Trust me, I am desprate to win this run."
        }
    },
    config = {
        extra = {
            x_gain = 0.75,
            x = 1
        }
    },
    rarity = 2,
    atlas = "BFDIA",
    pos = {
        x = 7,
        y = 0
    },
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rental_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.x_gain,
                card.ability.extra.x
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xchips = card.ability.extra.x,
                xmult = card.ability.extra.x
            }
        end
        if context.ending_shop and #G.jokers.cards > 1 and not context.blueprint then
            for i, joker in ipairs(G.jokers.cards) do
                if joker ~= card then
                    card.ability.extra.x = card.ability.extra.x + card.ability.extra.x_gain
                    G.E_MANAGER:add_event(Event({
                    func = function()
                        joker.T.r = -0.2
                        joker:juice_up(0.3, 0.4)
						joker.states.drag.is = true
						joker.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(joker)
								joker:remove()
								joker = nil
								return true;
							end
						}))
						return true
                    end
                }))
                end
            end
            return {
                message = "Destroyed!"
            }
        end
    end,
}
-- yellow face
SMODS.Joker {
    key = "yellowface",
    loc_txt = {
        name = "Yellow Face",
        text = {
            "At the start and end of the round",
            "create a random consumeable for {C:money}$#1#"
        }
    },
    config = {
        extra = {
            cost = 1
        }
    },
    rarity = 1,
    atlas = "BFDIA",
    pos = {
        x = 8,
        y = 0
    },
    cost = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rental_compat = false,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.cost
            }
        }
    end,
    calculate = function(self, card, context)
        if ((context.ending_shop) or (context.end_of_round and context.game_over == false)) and #G.consumeables.cards+G.GAME.consumeable_buffer<G.consumeables.config.card_limit then
            typenum = pseudorandom("yellowface",1,3)
            function changetype(number)
                if number == 1 then
                    typecard = "Spectral"
                elseif number == 2 then
                    typecard = "Tarot"
                else
                    typecard = "Planet"
                end
            end
            changetype(typenum)
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = (function()
                    local new_card = SMODS.add_card {
                        set = typecard,
                        key_append = 'j_bfdi_yellowface',
                    }
                    G.GAME.consumeable_buffer = 0
                    typenum = pseudorandom("yellowface",1,3)
                    changetype(typenum)
                    return true
                end)
            }))
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) - card.ability.extra.cost
            return {
                dollars = -card.ability.extra.cost,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.dollar_buffer = 0
                            typenum = pseudorandom("yellowface",1,3)
                            changetype(typenum)
                            return true
                        end
                    }))
                end
            }
        end
    end,
}
-- donut
SMODS.Joker {
    key = "donut",
    loc_txt = {
        name = "Donut",
        text = {
            "{X:mult,C:white}X#1#{} Mult if it is {C:attention}Summer{}"
        }
    },
    config = {
        extra = {
            xmult = 5
        }
    },
    rarity = 2,
    atlas = "BFDIA",
    pos = {
        x = 9,
        y = 0
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
        if context.joker_main and (os.date("%B") == "December" or os.date("%B") == "January" or os.date("%B") == "November") then
            return {
                xmult = card.ability.extra.xmult
            }
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
    atlas = "BFDIA",
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