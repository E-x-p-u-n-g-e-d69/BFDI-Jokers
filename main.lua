CFG = SMODS.current_mod.config

local BFDITabs = function()
    return {
        {
            label = "BFDI",
            tab_definition_function = function()
                bfdi_nodes = {
                    {
                        n = G.UIT.R,
                        config = { align = "tm" },
                        nodes = {
                        },
                    },
                }
                settings = { n = G.UIT.C, config = { align = "tl", padding = 0.05 }, nodes = {} }
                settings.nodes[#settings.nodes + 1] = create_toggle({
                    active_colour = G.C.RED,
                    label = "BFDI Jokers",
                    ref_table = CFG.BFDI,
                    ref_value = "bfdi_jokers",
                })
                settings.nodes[#settings.nodes + 1] = create_toggle({
                    active_colour = G.C.RED,
                    label = "BFDIA Jokers",
                    ref_table = CFG.BFDI,
                    ref_value = "bfdia_jokers",
                })
                config = { n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = { settings } }
                bfdi_nodes[#bfdi_nodes + 1] = config
                return {
                    n = G.UIT.ROOT,
                    config = {
                        emboss = 0.05,
                        minh = 1,
                        r = 0.1,
                        minw = 1,
                        align = "tm",
                        padding = 0.2,
                        colour = G.C.BLACK,
                    },
                    nodes = bfdi_nodes,
                }
            end,
        },
    }
end
SMODS.current_mod.extra_tabs = BFDITabs
if CFG.BFDI.bfdi_jokers ~= false then
    assert(SMODS.load_file("jokers/BFDI.lua"))()
end
if CFG.BFDI.bfdia_jokers ~= false then
    assert(SMODS.load_file("jokers/BFDIA.lua"))()
end