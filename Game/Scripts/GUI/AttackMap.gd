extends TileMap

var _centre_pos
var centre_cell = Vector2(4,4)
var mouse_pos
var current_tile
var map = self
var _travel_range
var _cast_range
var _aoe_range
var cast_direction
var selected = false
var cast_flag = false


func _ready():
	EventManager.connect("display_attack_map", self, "generate_map")
	
	
func generate_map(centre_pos, cast_range, travel_range, aoe_range):	
	_centre_pos = centre_pos
	_travel_range = travel_range
	_cast_range = cast_range
	_aoe_range = aoe_range
	reset_cells()
	if _travel_range == 0 and _cast_range == 0:
		set_cellv(Vector2(4,3), 0)		
		set_cellv(Vector2(4,5), 0)
		set_cellv(Vector2(3,4), 0)
		set_cellv(Vector2(5,4), 0)
	map.position = Vector2.ZERO
	map.position = map.world_to_map(map.to_local(centre_pos)) + Vector2(-72, -72)
	map.visible = true
	cast_flag = true
	
	
func _process(delta):
	var last_tile
	mouse_pos = get_global_mouse_position()
	current_tile =  map.world_to_map(map.to_local(mouse_pos))
	
	# Displays tiles which the attack will hit
	if Input.is_mouse_button_pressed(BUTTON_RIGHT) and cast_flag:
		if get_cellv(current_tile) == 1 and last_tile != current_tile:
			reset_cells()
			if current_tile.x > 4:
				cast_direction = "right"
				selected = true
				for i in range(5 - _aoe_range, 5 + _travel_range + _aoe_range):
					for j in range(4 - _cast_range - _aoe_range + 1, 4 + _cast_range + _aoe_range):
						set_cellv(Vector2(i, j), 1)
			elif current_tile.x < 4:
				cast_direction = "left"
				selected = true
				for i in range( 4 - _travel_range - _aoe_range, 4 + _aoe_range):
					for j in range(4 - _cast_range - _aoe_range + 1, 4 + _cast_range + _aoe_range):
						set_cellv(Vector2(i, j), 1)
			elif current_tile.y < 4:
				cast_direction = "up"
				selected = true
				for j in range( 4 - _travel_range - _aoe_range, 4 + _aoe_range):
					for i in range(5 - _cast_range - _aoe_range, 4 + _cast_range + _aoe_range):
						set_cellv(Vector2(i, j), 1)
			elif current_tile.y > 4:
				cast_direction = "down"
				selected = true
				for j in range(5 - _aoe_range , 5 + _travel_range + _aoe_range):
					for i in range(5 - _cast_range - _aoe_range, 4 + _cast_range + _aoe_range):
						set_cellv(Vector2(i, j), 1)
			elif current_tile == Vector2(4,4) and _travel_range == 0 and _cast_range == 0:
				cast_direction = "center"
				selected = true							
				set_cellv(Vector2(4,3), 0)		
				set_cellv(Vector2(4,5), 0)
				set_cellv(Vector2(3,4), 0)
				set_cellv(Vector2(5,4), 0)
		last_tile = current_tile
		
	# Stops using the skill
	if Input.is_action_just_pressed("back") or Input.is_action_just_pressed("up") or Input.is_action_just_pressed("left") or Input.is_action_just_pressed("down") or Input.is_action_just_pressed("right"):
		map.visible = false
		selected = false
		cast_flag = false
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and selected:
		EventManager.emit_signal("confirmed_attack_cell", _centre_pos, cast_direction)
		selected = false
		visible = false
		cast_flag = false
		
		
# Resets the tilemap to its default state
func reset_cells():
	for i in range(centre_cell.x - 5, centre_cell.x + 6):
		for j in range(centre_cell.y - 5, centre_cell.y + 6):
			set_cellv(Vector2(i,j), 2)
	for i in range(centre_cell.x - 4, centre_cell.x + 5):
		for j in range(centre_cell.y - 4, centre_cell.y + 5):
			set_cellv(Vector2(i,j), 0)
	set_cellv(Vector2(4,3), 1)		
	set_cellv(Vector2(4,5), 1)
	set_cellv(Vector2(3,4), 1)
	set_cellv(Vector2(5,4), 1)
	set_cellv(centre_cell, 1)


