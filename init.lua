letters = {}
letters.modpath = minetest.get_modpath("letters")
local x, y, z

--- FORMSPEC GENERATION AND HANDLING ---

local function display_formspec(name, pos)
	local pos_string = tostring(pos.x) .. "," .. tostring(pos.y) .. "," .. tostring(pos.z)
	minetest.show_formspec(name, "letters:formspec" .. pos_string, "formspec_version[3]size[5,3]field[1,1;3,1;x;Zeichen oder Text;]")
end

minetest.register_on_player_receive_fields(
	function(player, formname, fields)
		if string.sub(formname,1,16) == "letters:formspec" and fields.x then
			x, y, z = string.match(string.sub(formname,17), "([-]?%d+),([-]?%d+),([-]?%d+)")
			if x ~= nil and y ~= nil and z ~= nil then
				set_letter(player, vector.new(tonumber(x),tonumber(y),tonumber(z)), string.lower(fields.x))
			end
		end
	end
)

--- NODE PLACEMENT FUNCTION ---

function set_letter(player, pos, text)
	if text == nil or text == "" or minetest.is_protected(pos, player:get_player_name()) or string.sub(minetest.get_node(pos).name, 1, 8) ~= "letters:" then
		return
	end
	local face_param = minetest.get_node(pos).param2
	if letter_table[string.sub(text,1,1)] ~= nil then
		minetest.set_node(pos, {name="letters:" .. letter_table[string.sub(text,1,1)], param2=face_param})
	else
		minetest.set_node(pos, {name="letters:letter", param2=face_param})
	end
	
	-- calculate next node
	local next_pos = pos
	if     face_param == 0 then next_pos = vector.add(pos, vector.new( 0 ,0,-1)) -- bottom
	elseif face_param == 1 then next_pos = vector.add(pos, vector.new( 0 ,0,-1)) -- top
	elseif face_param == 2 then next_pos = vector.add(pos, vector.new( 0 ,0,-1)) -- +X
	elseif face_param == 3 then next_pos = vector.add(pos, vector.new( 0 ,0, 1)) -- -X
    elseif face_param == 4 then next_pos = vector.add(pos, vector.new( 1 ,0, 0)) -- +Z
	elseif face_param == 5 then next_pos = vector.add(pos, vector.new(-1 ,0, 0)) -- -Z
	else   return
	end
	
	set_letter(player, next_pos, string.sub(text, 2))
end

--- REGISTER NODES ---

letter_table = {}

local function register_letter(name, symbol)
	minetest.register_node("letters:" .. name, {
		drawtype            = "signlike",
		tiles               = {name .. ".png"},
		walkable            = false,
		paramtype           = "light",
		sunlight_propagates = true,
		drop                = "letters:letter",
		groups              = {dig_immediate = 2},
		paramtype2          = "wallmounted",
		selection_box       = {type = "wallmounted"},
		on_rightclick       = function(pos, node, clicker, itemstack, pointed_thing)
			if not minetest.is_protected(pos, clicker:get_player_name()) then
				display_formspec(clicker:get_player_name(), pos)
			end
		end
	})
	letter_table[symbol] = name
end

-- letter
minetest.register_node("letters:letter", {
	description         = "Letter",
	inventory_image     = "letter_inventoryimage.png",
	wield_image         = "letter_inventoryimage.png",
	drawtype            = "signlike",
	tiles               = {"letter.png"},
	walkable            = false,
	paramtype           = "light",
	sunlight_propagates = true,
	groups              = {dig_immediate = 2},
	paramtype2          = "wallmounted",
	selection_box       = {type = "wallmounted"},
	on_rightclick       = function(pos, node, clicker, itemstack, pointed_thing)
		if not minetest.is_protected(pos, clicker:get_player_name()) then
			display_formspec(clicker:get_player_name(), pos)
		end
	end
})

minetest.register_craft({
	type = "shapeless",
	output = "letters:letter 1",
	recipe = { "dye:black", "dye:black", "dye:black", "dye:black" }
})

-- alphabet
for c=string.byte("a"),string.byte("z") do
	register_letter(string.char(c), string.char(c))
end

-- digit
for i=0,9 do
	register_letter(tostring(i), tostring(i))
end

-- punctuation
register_letter("comma", ",")
register_letter("exclamation_mark", "!")
register_letter("full_stop", ".")
register_letter("question_mark", "?")
register_letter("minus", "-")
register_letter("plus", "+")
register_letter("slash", "/")
register_letter("back_slash", "\\")
register_letter("tilde", "~")
register_letter("equal", "=")
register_letter("less_than", "<")
register_letter("greater_than", ">")
register_letter("number_sign", "#")
register_letter("circumflex", "^")
register_letter("percent_sign", "%")
register_letter("ampersand", "&")
register_letter("dolla", "$")
register_letter("colon", ":")
register_letter("semicolon", ";")
register_letter("star", "*")
register_letter("apostrophe", "'")
register_letter("pipe", "|")
register_letter("parentheses_left", "(")
register_letter("parentheses_right", ")")
register_letter("brackets_left", "[")
register_letter("brackets_right", "]")
register_letter("braces_left", "{")
register_letter("braces_right", "}")
register_letter("underscore", "_")