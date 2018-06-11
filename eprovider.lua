--
-- Created by IntelliJ IDEA.
-- User: will7200
-- Date: 5/16/18
-- Time: 2:28 PM
-- To change this template use File | Settings | File Templates.
--

-- this wraps the provider module with extensions that allow feasibility for scripting
-- ususally they are helper functions that don't need to be defined in golang

local provider = require("provider")
local detector = require("detector")
local definitions = require("definitions")
local common = require("common")
local battle = require("modes.battle")

-- tapnsleep taps the ui interface and then sleeps in seconds the specified amount
provider.tapnsleep = function(location, time)
    time = time or 0
    local l = getmetatable(location)
    if l.__type == "dl.Circle" then
        provider.tap(location:point())
    else
        provider.tap(location)
    end
    if time > 0 then
        provider.wait_for_ui(time)
    end
end

-- work in progress do no call dnw
provider.in_progress_pass_through_initial_screen = function(already_started)
    already_started = already_started or False
    provider.start_app()
    if already_started then
        luaprint("Checking for start screen")
    end
end

-- scans for a back button
provider.scan_for_back_button = function(correlation)
    correlation = correlation or 3
    local found, point = detector.compare(definitions._c_back_button,
        provider.get_img_from_screen_shot(false, 5), correlation)
    if found then
        provider.tap(point)
        return true
    end
    return false
end

-- scans for a close button
function provider.scan_for_close(correlation)
    correlation = correlation or 3
    local found, point = detector.compare(definitions._c_close_button,
        provider.get_img_from_screen_shot(false, 5), correlation)
    if found then
        provider.tap(point)
        return true
    end
    return false
end

-- scans for a ok button
function provider.scan_for_ok(correlation, limg)
    correlation = correlation or 3
    limg = limg or provider.get_img_from_screen_shot(false, 5)
    local found, point = detector.compare(definitions._c_ok_button,
        limg, correlation)
    if found then
        provider.tap(point)
        return true
    end
    return false
end

-- scans for a download screen
function provider.scan_for_download(correlation)
    correlation = correlation or 3
    local found, point = detector.compare(definitions._c_download_button,
        provider.get_img_from_screen_shot(false, 5), correlation)
    if found then
        provider.tap(point)
        return true
    end
    return false
end

-- scans for a close button
function provider.scan_for_close(correlation)
    correlation = correlation or 3
    local found, point = detector.compare(definitions._c_close_button,
        provider.get_img_from_screen_shot(false, 5), correlation)
    if found then
        provider.tap(point)
        return true
    end
    return false
end

-- waits until a notifications screen appears
function provider.wait_for_notifications()
    error("Not Implemented")
end

-- wrapper to swipe right
function provider.swipe_right(sleep_amount)
    sleep_amount = sleep_amount or 0
    provider.swipe(definitions.swipe_right_start, definitions.swipe_right_end)
    if sleep_amount > 0 then
        provider.wait_for_ui(sleep_amount)
    end
end

function check_if_battle(img, amount)
    local battle, err = common.check_if_battle(img, amount)
    if err then
        error(err)
    end
    return battle
end

function check_area_for_word(img, areaKey, textMatch, find)
    local img = common.crop_image(img, areaKey)
    local text, err = common.img_to_string(img, textMatch)
    if err then
        error(err)
    end
    if string.match(text, find) then
        return true, text
    end
    return false, text
end

function verify_battle(img)
    return check_area_for_word(img, "auto_duel_location", "Auto-Duel", "Auto--Duel")
end

function wait_for(areaKey, textMatch, find)
    local found = false
    while not found do
        local img = provider.get_img_from_screen_shot(false, 5)
        found = check_area_for_word(img, areaKey, textMatch, find)
        provider.wait_for_ui(1)
    end
end

local battle_modes = {}
for k, v in pairs(battle.modes) do
    battle_modes[k] = v(provider)
end

function possible_battle_points()
    local img = provider.get_img_from_screen_shot(false, 5)
    local circles, ok = detector.circles(definitions._c_npc_detection, img)
    if not ok then
        error("Error detecting Worlds Rewards and NPCs")
    end
    local current_page = provider.get_current_page(img)
    for _, circle in ipairs(circles) do
        coroutine.yield(circle, current_page)
    end
end

provider.check_if_battle = check_if_battle
provider.verify_battle = verify_battle
provider.wait_for = wait_for

-- wrapper to get npcs and world rewards
function provider.scan()
    -- local current_page = provider.get_current_page()
    local circles, ok = detector.circles(definitions._c_npc_detection, provider.get_img_from_screen_shot(false, 5))
    for i, circle in ipairs(circles) do
        if circle:radius() > 5 then
            provider.scan_for_back_button()
            provider.wait_for_ui(1)
            luaprint("Tapping at circle ", circle:point())
            provider.tapnsleep(circle, 1.5)
            local img = provider.get_img_from_screen_shot(false, 5)
            luaprint("Checking if a battle")
            local battleV = check_if_battle(img, .50)
            if battleV then
                luaprint("precusor to a battle")
                while battleV do
                    luaprint("Tapping dialog area")
                    provider.tapnsleep(definitions.dialog_ok, 2.5)
                    local img = provider.get_img_from_screen_shot(false, 5)
                    battleV = check_if_battle(img, .50)
                end
                local img = provider.get_img_from_screen_shot(false, 5)
                battleV = provider.verify_battle(img)
                if battleV then
                    -- update status that current battle is starting
                    if provider.scan_for_ok() then
                        img = provider.get_img_from_screen_shot(false, 5)
                    end
                    local info = {}
                    for _, mode in pairs(battle_modes) do
                        if mode:check_battle(info, img) then
                            -- get battle area
                            mode:start(definitions.auto_duel_location, info)
                            break
                        end
                    end
                    -- update status that current battle is done
                end
            end
            luaprint("completed run of point at ", circle:point())
        end
    end
end

function provider.scan()
    local img = provider.get_img_from_screen_shot(false, 5)
    local battleV = provider.verify_battle(img)
    if battleV then
        -- update status that current battle is starting
        if provider.scan_for_ok() then
            img = provider.get_img_from_screen_shot(false, 5)
        end
        local info = {}
        for _, mode in pairs(battle_modes) do
            if mode:check_battle(info, img) then
                -- get battle area
                mode:start(definitions.auto_duel_location, info)
                break
            end
        end
        -- update status that current battle is done
    end
end

return provider


