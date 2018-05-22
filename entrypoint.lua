local rt = require("rt")
local autoplay = require("modes.autoplay")
local pvp = require("modes.pvp")
local provider = require("eprovider")

rt.register_playmode("autoplay", autoplay.start)
rt.register_playmode("pvp", pvp.start)

function determine_playthrough(mode)
    if mode == "auto" then
        return autoplay.start
    elseif mode == "pvp" then
        return pvp.start
    else
        error("Invalid mode[" .. mode .. "] choose another")
    end
end

-- img = provider.get_img_from_screen_shot(false, 1)
already_open = false
if not provider.is_process_running() then
    provider.start_process()
    provider.wait_for_ui(30)
else
    already_open = true
end

err = provider.pass_through_initial_screen(already_open)
if not (err == nil) then
    error("Couldn't pass through initial screen")
end

mode = determine_playthrough(rt.current_playmode())
mode(provider)

--provider.tap(1,1)
