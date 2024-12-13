local S, NS = core.get_translator("customdeathmessage")

local storage = minetest.get_mod_storage()

local custom_death_message_config = minetest.settings:get("customdeathmessage.death_message")
custom_death_message_config = custom_death_message_config:sub(2, -2) -- Remove the first and last letter as they are always ""

local message_in_config = true

if custom_death_message_config == "" then
    message_in_config = false
end

minetest.register_privilege("death_message", {
	description = S("Allow player to use set_death_message command"),
	give_to_singleplayer = false,
	give_to_admin = true,
})

-- Override the show_death_screen function
core.show_death_screen = function(player, reason)
    local player_name = player:get_player_name()

    -- Load custom death message from mod storage
    custom_death_message = storage:get_string("custom_death_message")

    if custom_death_message == "" then
        if message_in_config then
            custom_death_message = custom_death_message_config
        else
            custom_death_message = "You died!"
        end
    end

    local formspec = "size[6,3]" ..
                     "textarea[1,0;5,2;;;" .. S(custom_death_message) .. "]" ..
                     "button_exit[2,2;2,1;respawn;" .. S("Respawn") .. "]"

    -- Show the formspec to the player
    minetest.show_formspec(player_name, "__builtin:death", formspec)
end

-- Register new chatcommand to set the message
minetest.register_chatcommand("set_death_message", {
    description = S("Set the death message shown when a player dies."),
    params = S("<value>"),
    privs = {death_message=true},

    func = function(name, param)

        if param == "" then
            return false
        end

        -- Save to mod storage
        storage:set_string("custom_death_message", param)

        minetest.chat_send_player(name, S("Changed the death message to: ") .. param)

        return true
    end,
})

-- Register new chatcommand to reset the message
minetest.register_chatcommand("reset_death_message", {
    description = S("Set the death message shown when a player dies to the value specified in the minetest.conf."),
    params = "",
    privs = {death_message=true},

    func = function(name, param)

        if param == "" then
            storage:set_string("custom_death_message", "")

            minetest.chat_send_player(name, S("Changed the death message to the default in the minetest.conf."))

            return true
        end
        return false
    end,
})
