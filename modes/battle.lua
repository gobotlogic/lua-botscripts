--
-- Created by IntelliJ IDEA.
-- User: williamflores
-- Date: 6/10/18
-- Time: 12:48 PM
-- To change this template use File | Settings | File Templates.
--
local common = require("common")
local definitions = require("definitions")

local AbstractBattle = {}
AbstractBattle.__index = AbstractBattle

setmetatable(AbstractBattle, {
    __value = -1,
    __name = "AbstractBattle",
    __call = function(cls, ...)
        local self = setmetatable({}, cls)
        self.__name = "AbstractBattle"
        self:_init(...)
        return self
    end,
})

function AbstractBattle:__tostring()
    return "<" .. self.__name .. ":" .. ">"
end

function AbstractBattle:_init(init)
    self.provider = init
end

function AbstractBattle:set_provider(newval)
    self.provider = newval
end

function AbstractBattle:get_provider()
    return self.provider
end

function AbstractBattle:check_battle(info, img)
    error("Implement Check Battle for " .. self.__name)
end

function AbstractBattle:start(battleLocation, info)
    --error("Implement Start for " .. self.__name)
    self.provider.tap(battleLocation)
    self:battle(info)
end

function AbstractBattle:battle(info)
    error("Implement battle for " .. self.__name)
end

---

local NPCBattle = {}
NPCBattle.__index = NPCBattle

setmetatable(NPCBattle, {
    __value = 0,
    __index = AbstractBattle, -- this is what makes the inheritance work
    __name = "NPCBattle",
    __call = function(cls, ...)
        local self = setmetatable({}, cls)
        self.__name = "NPCBattle"
        self:_init(...)
        return self
    end,
})

function NPCBattle:check_battle(info, img)
    --"""Will Always return true since this is the last possible battle mode available"""
    local img1, err = common.crop_image(img, definitions._c_duelist_name_area)
    if err then
        error(err)
    end
    local name = common.img_to_string(img1, definitions.alphabet)
    info.name = name
    return true
end

function NPCBattle:battle(info)
    luaprint("Battling with " .. info.name)
    self.provider.wait_for(definitions._c_button_battle_done, "OK", "OK")
    self.provider.wait_for_ui(.5)
    self.provider.tap(definitions.button_duel)
    self.provider.wait_for(definitions._c_button_battle_done, "NEXT", "NEXT")
    self.provider.tapnsleep(definitions.button_duel, .5)
    self.provider.wait_for(definitions._c_button_battle_done, "NEXT", "NEXT")
    self.provider.wait_for_ui(.3)
    self.provider.tap(definitions.button_duel)
    local foundWhiteBottom = false
    local count = 2
    while not foundWhiteBottom do
        local img = self.provider.get_img_from_screen_shot(false, 5)
        foundWhiteBottom = self.provider.check_if_battle(img, .50)
        if foundWhiteBottom then
            count = count - 1
            if count ~= 0 then
                foundWhiteBottom = false
            end
        end
        self.provider.wait_for_ui(1)
    end
    luaprint("Found White Bottom")
    self.provider.wait_for_ui(.5)
    self.provider.tapnsleep(definitions.button_duel, 1)

    local dialog = true
    while dialog do
        local img = self.provider.get_img_from_screen_shot(false, 5)
        dialog = self.provider.check_if_battle(img, .50)
        if dialog then
            self.provider.tap(definitions.button_duel)
        end
        self.provider.wait_for_ui(1)
    end

    self.provider.wait_for_ui(.5)
    while self.provider.scan_for_ok() do
        self.provider.wait_for_ui(.5)
    end
end

local ordered = {
    [1] = NPCBattle,
    -- [2] = AbstractBattle
}

--[[table.sort(ordered, function(a, b)
    local aa = getmetatable(a)
    local bb = getmetatable(b)
    return aa.__value < bb.__value
end)
--]]
-- use the keys to retrieve the values in the sorted order
-- for _, k in ipairs(ordered) do print(getmetatable(k).__value) end

return {
    NPCBattle = NPCBattle,
    AbstractBattle = AbstractBattle,
    modes = ordered
}