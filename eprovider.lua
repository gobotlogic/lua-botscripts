--
-- Created by IntelliJ IDEA.
-- User: williamflores
-- Date: 5/16/18
-- Time: 2:28 PM
-- To change this template use File | Settings | File Templates.
--
local provider = require("provider")
local comparator = require("comparator")
provider.tapnsleep = function(location, time)
    provider.tap(location)
    provider.wait_for_ui(time)
end
provider.in_progress_pass_through_initial_screen = function(already_started)
    already_started = already_started or False
    provider.start_app()
    if already_started then
        luaprint("Checking for start screen")
    end
end

provider.objects = {}
provider.initiate_link = provider.get_ui_location("initiate_link")
provider._c_back_button = "back_button"
-- scans for a back button
function provider.scan_for_back_button()
    comparator.compare(provider._c_back_button, provider.get_img_from_screen_shot(false, 5), 3)
end

-- scans for a close button
function provider.scan_for_close()
    error("Not Implemented")
end

-- scans for a download screen
function provider.scan_for_download()
    error("Not Implemented")
end

-- scans for a close button
function provider.scan_for_close()
    error("Not Implemented")
end

-- waits until a notifications screen appears
function provider.wait_for_notifications()
    error("Not Implemented")
end

return provider


