SMODS.Atlas{
    key = 'BFDI_planet',
    path = 'planet.png',
    px = 63,
    py = 93
}
function upgrade_hand(card, hand, levels)
    update_hand_text({ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 }, {
			handname = localize(hand, "poker_hands"),
			chips = G.GAME.hands[hand].chips,
			mult = G.GAME.hands[hand].mult,
			level = G.GAME.hands[hand].level,
		})
        level_up_hand(card, hand, nil, levels)
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
end
SMODS.Consumable {
    key = "weirdplanetintheorionnebula",
    set = "Planet",
    loc_txt = {
        name = "Weird Planet in the Orion Nebula",
        text = {
            'Upgrade a {C:attention}random',
			'poker hand by {C:attention}#1#{} levels',
        }
    },
    config = {
        extra = {
            levels = 3
        }
    },
    atlas = "BFDI_planet",
    pos = {
        x = 0,
        y = 0
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.levels
            }
        }
    end,
    can_use = function(self, card, context)
        return true
    end,
    use = function(self, card, context)
        chosen_hand = pseudorandom_element(G.handlist, pseudoseed("weird"))
        upgrade_hand(card, chosen_hand, card.ability.extra.levels)
    end,
}
--[[
SMODS.Consumable {
    key = "",
    set = "Planet",
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
    atlas = "BFDI_planet",
    pos = {
        x = ,
        y = 
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {

            }
        }
    end,
    use = function(self, card, context)
    
    end,
}
]]