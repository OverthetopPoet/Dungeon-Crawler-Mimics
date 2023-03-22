extends Node2D

class_name dungeon

var level=1
var monster_lst=[null]
var boss_resource
export (String) var character_name = "Ranger"
export (Resource) var monsters
var chest_check = false
var monster_check = false
var player_check = false
	

func _ready():
	if monster_lst==[null]:
		monster_lst=monsters['monsters']
		boss_resource= monsters['boss']
	EventManager.emit_signal("spawn_player", character_name)
	EventManager.emit_signal("spawn_chest", level)
	EventManager.emit_signal("spawn_exit")
	EventManager.emit_signal("spawn_monster", monster_lst, level)
	EventManager.emit_signal("spawn_boss", boss_resource, level)
	EventManager.emit_signal("completed_dungeon_generation")
	EventManager.emit_signal("add_monsters", monster_lst)
