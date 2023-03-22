extends TileMap

var interaction_area = preload("res://Scenes/interaction_area.tscn")
var preloadGoldResource = preload("res://Resources/Items/Tradeable/gold.tres")
var preloadItemResource = preload("res://Resources/Items/Staff.tres")


func _on_interacted_with_object(object):
	if object["type"]=="door":
		set_cell(object["location"].x,object["location"].y,-1)
	elif object["type"]=="chest":
		set_cell(object["location"].x,object["location"].y,5)
		var lootPosition = map_to_world(object["location"])
		lootPosition.x = lootPosition.x + 8
		lootPosition.y = lootPosition.y + 8
		var indexno = 0
		
		var adjacent_cells = [
			Vector2(lootPosition.x - 16, lootPosition.y - 16),	# oben links
			Vector2(lootPosition.x - 0, lootPosition.y - 16),	# oben mittig
			Vector2(lootPosition.x + 16, lootPosition.y - 16),	# oben rechts
			Vector2(lootPosition.x - 16, lootPosition.y),		# mitte links
			Vector2(lootPosition.x + 16, lootPosition.y),		# mitte rechts
			Vector2(lootPosition.x - 16, lootPosition.y + 16),	# unten links
			Vector2(lootPosition.x + 0, lootPosition.y + 16),	# unten mittig
			Vector2(lootPosition.x + 16, lootPosition.y + 16),	# unten rechts
			]
		
		var adjacent_tiles = []
		for index in adjacent_cells:
			var buffer = world_to_map(adjacent_cells[indexno])
			adjacent_tiles.append(get_cell(buffer.x, buffer.y))
			indexno += 1
		
		if(adjacent_tiles[6] == -1):
			lootPosition.x = adjacent_cells[6].x
			lootPosition.y = adjacent_cells[6].y
		elif(adjacent_tiles[5] == -1):
			lootPosition.x = adjacent_cells[5].x
		elif(adjacent_tiles[7] == -1):
			lootPosition.x = adjacent_cells[7].x
			lootPosition.y = adjacent_cells[7].y
		elif(adjacent_tiles[3] == -1):
			lootPosition.x = adjacent_cells[3].x
			lootPosition.y = adjacent_cells[3].y
		elif(adjacent_tiles[4] == -1):
			lootPosition.x = adjacent_cells[4].x
			lootPosition.y = adjacent_cells[4].y
		elif(adjacent_tiles[0] == -1):
			lootPosition.x = adjacent_cells[0].x
			lootPosition.y = adjacent_cells[0].y
		elif(adjacent_tiles[2] == -1):
			lootPosition.x = adjacent_cells[2].x
			lootPosition.y = adjacent_cells[2].y
		elif(adjacent_tiles[1] == -1):
			lootPosition.x = adjacent_cells[1].x
			lootPosition.y = adjacent_cells[1].y
		else:
			print("DEBUG: NO OPEN SPACE FOUND FOR BAG")

		var randomGenerator = RandomNumberGenerator.new()
		randomGenerator.randomize()
		var goldAmount = randomGenerator.randi_range(3,5)
		var bagnew = lootBag.new(lootPosition, preloadGoldResource, goldAmount)
		add_child(bagnew)
	elif object["type"]=="trap":
		set_cell(object["location"].x,object["location"].y,-1)


func _on_place_chest(position):
	var chest_position=world_to_map(position)
	set_cell(chest_position.x, chest_position.y,4)
	var new_interaction_area = interaction_area.instance()
	new_interaction_area.position.x=position.x
	new_interaction_area.position.y=position.y
	new_interaction_area.interactable_object={"type":"chest", "location":chest_position}
	add_child(new_interaction_area)
	
	
func _ready():
	EventManager.connect("interacted_with_object",self,"_on_interacted_with_object")
	EventManager.connect("place_chest",self,"_on_place_chest")

	for door_cell_id in range(6,16):
		var door_locations=get_used_cells_by_id(door_cell_id)
		for door in door_locations:
			var door_position=map_to_world(door)
			var new_interaction_area = interaction_area.instance()
			new_interaction_area.position.x=door_position.x+8
			new_interaction_area.position.y=door_position.y+8
			new_interaction_area.interactable_object={"type":"door", "location":door}
			add_child(new_interaction_area)
	for exit_cell_id in range(17,20):
		var exit_locations=get_used_cells_by_id(exit_cell_id)
		for exit in exit_locations:
			var exit_position=map_to_world(exit)
			var new_interaction_area = interaction_area.instance()
			new_interaction_area.position.x=exit_position.x+8
			new_interaction_area.position.y=exit_position.y+8
			new_interaction_area.interactable_object={"type":"exit", "location":exit}
			add_child(new_interaction_area)
