extends TileMap

onready var astar_node = AStar2D.new()
onready var obstacles = get_parent().get_node("background_tiles").get_used_cells_by_id(1)
onready var doors
var point_path = []
var max_x = 0
var min_x = 1000
var max_y = 0
var min_y = 1000
var map_size 
var _half_cell_size

var path_start_position
var path_end_position


func _ready():
	map_size = calculate_bounds()
	_half_cell_size = cell_size / 2
	get_doors()
	var walkable_cells_list = astar_add_walkable_cells(obstacles)
	astar_connect_walkable_cells(walkable_cells_list)
	update_obstacles()


func calculate_bounds():
	var used_cells = get_used_cells()
	for pos in used_cells:
		if pos.x > max_x:
			max_x = int(pos.x)
		if pos.x < min_x:
			min_x = int(pos.x)
		if pos.y > max_y:
			max_y = int(pos.y)
		if pos.y < min_y:
			min_y = int(pos.y)
	return Vector2(max_x - min_x, max_y - min_y)


func update_obstacles():
	var actor_list = get_parent().get_parent().get_node("Battle System").get_actor_list()
	for actor in actor_list:
		if is_instance_valid(actor):
			if (actor is monsterObject) or actor is statueObject:
				if calculate_point_index(world_to_map(actor.global_position)) in astar_node.get_points():
					astar_node.set_point_disabled(calculate_point_index(world_to_map(actor.global_position)), true)
	
	
func get_doors():
	doors = []
	for i in range(6,13):
		doors.append_array(get_parent().get_node("wall_tiles").get_used_cells_by_id(i))
		
	
func astar_add_walkable_cells(_obstacles = []):
	var points_array = []
	for y in range(min_y, max_y):
		for x in range(min_x, max_x):
			var point = Vector2(x, y)
			if point in _obstacles or point in doors or get_cellv(point) != 0:
				continue
			points_array.append(point)
			var point_index = calculate_point_index(point)
			astar_node.add_point(point_index, Vector2(point.x, point.y))
	return points_array
	
	
func astar_connect_walkable_cells(points_array):
	for point in points_array:
		var point_index = calculate_point_index(point)
		var points_relative = PoolVector2Array([
			point + Vector2.RIGHT,
			point + Vector2.LEFT,
			point + Vector2.UP,
			point + Vector2.DOWN,
		])
		for point_relative in points_relative:
			var point_relative_index = calculate_point_index(point_relative)
			if is_outside_map(point_relative):
				continue
			if not astar_node.has_point(point_relative_index):
				continue
			astar_node.connect_points(point_index, point_relative_index, false)


func is_outside_map(point):
	return point.x < 0 or point.y < 0 or point.x >= max_x or point.y >= max_y
	
	
func calculate_point_index(point):
	return point.x + map_size.x * point.y
	
	
func _recalculate_path():
	astar_reset()
	var start_point_index = calculate_point_index(path_start_position)
	var end_point_index = calculate_point_index(path_end_position)
	point_path = astar_node.get_point_path(start_point_index, end_point_index)

	
func find_path(monster_pos, target_pos):
	self.path_start_position = world_to_map(monster_pos) 
	self.path_end_position = world_to_map(target_pos) 
	if is_outside_map(path_start_position) or is_outside_map(path_end_position):
		return
	_recalculate_path()
	var path_world = []
	for point in point_path:
		var point_world = map_to_world(Vector2(point.x, point.y)) + _half_cell_size
		path_world.append(point_world)
	return path_world
	
	
func astar_reset():
	astar_node.clear()
	get_doors()
	var walkable_cells_list = astar_add_walkable_cells(obstacles)
	astar_connect_walkable_cells(walkable_cells_list)
	update_obstacles()

