local storage = minetest.get_mod_storage()

minetest.register_privilege("death_message", {
	description = "Allow player to use set_death_message command",
	give_to_singleplayer = false,
	give_to_admin = true,
})

-- Override the show_death_screen function
core.show_death_screen = function(player, reason)
    local player_name = player:get_player_name()

    -- Load custom death message from mod storage
    local custom_death_message = storage:get_string("custom_death_message")

    if custom_death_message == "" then
        custom_death_message = "You died!"
    end

    local formspec = "size[6,3]" ..
                     "textarea[1,0;5,2;;;" .. custom_death_message .. "]" ..
                     "button_exit[2,2;2,1;respawn;Respawn]"

    -- Show the formspec to the player
    minetest.show_formspec(player_name, "__builtin:death", formspec)
end

-- Register new chatcommand to set the message
minetest.register_chatcommand("set_death_message", {
    description = "Set the death message shown when a player dies.",
    params = "<value>",
    privs = {death_message=true},

    func = function(name, param)

        if param == "" then
            return false
        end

        -- Save to mod storage
        storage:set_string("custom_death_message", param)

        minetest.chat_send_player(name, "Changed the death message to: " .. param)

        return true
    end,
})
