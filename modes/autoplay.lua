--
-- Created by IntelliJ IDEA.
-- User: will7200
-- Date: 4/22/18
-- Time: 6:50 AM
-- To change this template use File | Settings | File Templates.
--
local autoplay = {}

function autoplay.start(provider)
    luaprint("Autoplay mode starting")
    for x = 1, 8 do
        luaprint(string.format("Run Through %s", x))
        -- provider.scan_for_back_button()
        -- provider.swipe_right(2)
        provider.scan()
    end
end

autoplay.name = 'autoplay'

return autoplay
