minetest.register_node("langton:langton",{
	description = "Langton's Ant",
	diggable = true,
	tiles = {"ant.png"},
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand = 3, langton=1},
	on_construct = function(pos)
		if pos.y ~= 0 then
			minetest.set_node(pos,{name="air"})
		end
	end,
	on_rightclick = function(pos)
		minetest.swap_node(pos,{name="langton:pause"})
	end
})

minetest.register_node("langton:error",{
	description = "Cprrupted Langton's Ants",
	diggable = true,
	tiles = {"ant.png^[colorize:#F0F:50]"},
	groups = {oddly_breakable_by_hand = 3},
	drop = "langton:langton",
})

minetest.register_node("langton:pause",{
	description = "Paused Langton's Ants",
	diggable = true,
	tiles = {"ant.png^[colorize:#0F0:50]"},
	groups = {oddly_breakable_by_hand = 3},
	drop = "langton:langton",
	on_rightclick = function(pos)
		minetest.swap_node(pos,{name="langton:langton"})
	end
})

local white = "mapgen:white"
local black = "mapgen:black"

local dirmap = {
	[0] = {x=0,y=0,z=1},
	[1] = {x=1,y=0,z=0},
	[2] = {x=0,y=0,z=-1},
	[3] = {x=-1,y=0,z=0}
}

-- + TURN LEFT
-- - TURN RIGHT
minetest.register_abm({
	label = "Langton's Ant Movement",
	nodenames = {"langton:langton"},
	interval = 0.5,
	chance = 1,
	min_y = 0,
	max_y = 0,
	catch_up = false,
	action = function(pos,node)
		local old_meta = minetest.get_meta(pos):to_table()
		if pos.y ~= 0 then
			minetest.set_node(pos,{name="air"})
			return
		end
		-- TODO: Handle crashes between multiple Ants
		local bottom_pos = vector.add(pos,{x=0,y=-1,z=0})
		local bottom_node = minetest.get_node_or_nil(bottom_pos)
		if not bottom_node then return end
		local bottom_type = bottom_node.name
		if bottom_type == white then
			minetest.swap_node(bottom_pos,{name=black})
			node.param2 = node.param2 - 1
			if node.param2 == -1 then
				node.param2 = 3
			end
		elseif bottom_type == black then
			minetest.swap_node(bottom_pos,{name=white})
			node.param2 = node.param2 + 1
			if node.param2 == 4 then
				node.param2 = 0
			end
		else
			minetest.swap_node(pos,{name="langton:error"})
			return
		end
		minetest.set_node(pos,{name="air"})
		local dir = dirmap[node.param2]
		local new_pos = vector.add(pos,dir)
		minetest.set_node(new_pos,node)
		local meta = minetest.get_meta(new_pos)
		meta:from_table(old_meta)
		meta:set_int("step",meta:get_int("step") + 1)
		meta:set_string("infotext",tostring(meta:get_int("step") ) .. " steps")
	end
})
