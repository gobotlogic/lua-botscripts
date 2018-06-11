--
-- Created by IntelliJ IDEA.
-- User: will7200
-- Date: 5/25/18
-- Time: 4:12 PM
-- To change this template use File | Settings | File Templates.
--
local provider = require("provider")

definitions = {}
-- img to string
definitions.alpha_numeric = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
definitions.alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
definitions.numeric = "0123456789"

-- The following definitions are ui locations
definitions.initiate_link = provider.get_ui_location("initiate_link")
definitions.swipe_right_start = provider.get_ui_location("swipe_right_start")
definitions.swipe_right_end = provider.get_ui_location("swipe_right_end")
definitions.dialog_ok = provider.get_ui_location("dialog_ok")
definitions._ui_button_duel = "button_duel"
definitions.button_duel = provider.get_ui_location(definitions._ui_button_duel)

-- The following defintions are ui area locations
definitions.page_area = provider.get_area_location("page_area")
definitions._c_auto_duel_location = "auto_duel_location"
definitions.auto_duel_location = provider.get_area_location(definitions._c_auto_duel_location)
definitions.duelist_name_area = provider.get_area_location("duelist_name_area")
definitions._c_duelist_name_area = "duelist_name_area"
definitions._c_button_battle_done = "button_battle_done"
definitions.button_battle_done = provider.get_area_location(definitions._c_button_battle_done)

-- The following defintions are string defintions for image comparisons
definitions._c_back_button = "back_button"
definitions._c_close_button = "close_button"
definitions._c_ok_button = "ok_button"
definitions._c_download_button = "download_button"
definitions._c_npc_detection = "npc_detection"

return definitions