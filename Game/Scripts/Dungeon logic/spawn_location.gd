extends Node2D

export (String, "Player", "Monster", "Statue", "Chest", "Boss", "Exit" ) var spawn_type
export (int) var mimic_chance = 10
export (int) var spawn_chance = 45
var randomizer
var character_scene = preload("res://Scenes/Character/Character.tscn")
var mimic_resource = load("res://Resources/Monster/Monsters/mimic.tres")


func _ready():
	if spawn_type == "Player":
		EventManager.connect("spawn_player", self, "_on_spawn_player")
	if spawn_type == "Exit":
		EventManager.connect("spawn_exit", self, "_on_spawn_exit")
	if spawn_type == "Chest":
		EventManager.connect("spawn_chest", self, "_on_spawn_chest")
	if spawn_type == "Monster":
		EventManager.connect("spawn_monster", self, "_on_spawn_monster")
	if spawn_type == "Boss":
		EventManager.connect("spawn_boss", self, "_on_spawn_boss")
	randomizer=RandomNumberGenerator.new()
	randomizer.randomize()
	
	
func _on_spawn_player(char_name):
	var character_instance=character_scene.instance()
	character_instance.characterName=char_name
	character_instance.position=position
	get_parent().add_child(character_instance)
	queue_free()

		
func _on_spawn_boss(boss_resource, level):
	var new_boss=monsterObject.new(boss_resource, position, level)
	get_parent().add_child(new_boss)
	queue_free()
		
		
func _on_spawn_chest(level):
	var random_spawn_number=randomizer.randi_range(0,100)
	var random_mimic_number=randomizer.randi_range(0,100)
	if random_spawn_number <= spawn_chance:
		if random_mimic_number <= mimic_chance:
			var new_mimic=monsterObject.new(mimic_resource, position, level)
			get_parent().add_child(new_mimic)
		else:
			var spawn_location=get_parent().get_parent().position
			spawn_location.x+=position.x
			spawn_location.y+=position.y
			EventManager.emit_signal("place_chest", spawn_location)
	queue_free()
	
	
func _on_spawn_monster(monster_lst:Array, level):
	var random_spawn_number=randomizer.randi_range(0,100)
	if random_spawn_number <= spawn_chance:
		var new_monster=monsterObject.new(monster_lst[randomizer.randi_range(0,monster_lst.size()-1)], position, level)
		get_parent().add_child(new_monster)
		pass
	else:
		var new_statue=statueObject.new(monster_lst[randomizer.randi_range(0,monster_lst.size()-1)], position)
		get_parent().add_child(new_statue)
	queue_free()
	
	
func _on_spawn_exit():
	var interaction_area = preload("res://Scenes/interaction_area.tscn")
	var new_interaction_area = interaction_area.instance()
	new_interaction_area.position.x=position.x+6
	new_interaction_area.position.y=position.y-1
	new_interaction_area.interactable_object={"type":"exit", "location":position}
	add_child(new_interaction_area)


