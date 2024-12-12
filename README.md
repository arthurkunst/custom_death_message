# custom_death_message
Luanti (former Minetest) mod to set custom death messages with the command /set_death_message. For this command you need the death_message privilege (Admins get it automatically). This message gets stored using the mod_storage function of minetest.

You can also add a custom death message in the minetest.conf file as "customdeathmessage.death_message = "Example message"". This message will only be shown if there is no message in the mod storage, so it will not be used anymore if you change the message using the command.
