extends Node2D

onready var dungeon_node = get_node("Dungeon")
onready var tavern_node = get_node("Tavern")
var current_level
export (String, "Warrior", "Ranger", "Sorceress") var current_character
var tavern_scene = preload("res://Scenes/Tavern.tscn")
onready var gui = get_node("CanvasLayer/GUI")
var dungeon_scene_1 = preload("res://Scenes/Dungeon/dungeon_layout_1.tscn")
var dungeon_scene_2 = preload("res://Scenes/Dungeon/dungeon_layout_2.tscn")
var dungeon_scene_3 = preload("res://Scenes/Dungeon/dungeon_layout_3.tscn")
var dungeon_scene_4 = preload("res://Scenes/Dungeon/dungeon_layout_4.tscn")
var dungeon_scene_5 = preload("res://Scenes/Dungeon/dungeon_layout_5.tscn")
var randomizer
var dungeons
export (Array, Resource) var monster_level_list = []
var game_location
var battle_system_node
var last_dungeon

var main_menu_music=preload("res://Assets/Music and Sounds/Track_#2.mp3")
var dungeon_music=preload("res://Assets/Music and Sounds/dungeon_theme_1.mp3")
var tavern_music=preload("res://Assets/Music and Sounds/Track_#1.mp3")

onready var music_player=get_node("AudioStreamPlayer")
onready var sound_effect_player=get_node("AudioStreamPlayer2")


func _ready():
	tavern_music.loop=true
	dungeon_music.loop=true
	main_menu_music.loop=true
	music_player.stream=main_menu_music
	music_player.playing=true
	randomizer=RandomNumberGenerator.new()
	randomizer.randomize()
	dungeons=[dungeon_scene_1, dungeon_scene_2, dungeon_scene_3, dungeon_scene_4, dungeon_scene_5]
	current_level=1
	EventManager.connect("change_level",self, "_on_change_level")
	EventManager.connect("exit_dungeon", self, "_on_exit_dungeon")
	EventManager.connect("enter_dungeon", self, "_on_enter_dungeon")
	EventManager.connect("character_selected", self, "_on_character_selected")
	EventManager.connect("reset_to_main", self, "_on_reset_to_main")
	EventManager.connect("player_died", self, "_on_player_died")
	EventManager.connect("play_sound_effect",self,"_play_sound_effect")
	battle_system_node = battle_system.new()
	dungeon_node.add_child(battle_system_node)
	battle_system_node.set_name("Battle System")


func _on_change_level():
	last_dungeon.queue_free()
	current_level+=1
	var new_dungeon=dungeons[randomizer.randi_range(0,4)].instance()
	new_dungeon.character_name=current_character.characterName
	var monster_level=0
	if current_level>monster_level_list.size():
		monster_level=randomizer.randi_range(0,monster_level_list.size()-1)
	else:
		monster_level=current_level-1
	new_dungeon.monster_lst=monster_level_list[monster_level].monsters
	new_dungeon.boss_resource=monster_level_list[monster_level].boss

	dungeon_node.add_child(new_dungeon)
	last_dungeon = new_dungeon
	

func _on_exit_dungeon():
	last_dungeon.queue_free()
	var tavern_instance = tavern_scene.instance()
	tavern_instance.init(current_character)
	tavern_node.add_child(tavern_instance)
	current_level=1
	game_location="tavern"
	music_player.stream=tavern_music
	music_player.playing=true
	
	
func _on_enter_dungeon():
	if EventManager._quickselect_slots != null:
		for slot in EventManager._quickselect_slots:
			slot.current_cooldown = 0
			slot.is_on_cooldown = false
	game_location="dungeon"
	current_level=1
	gui.get_node("Game_UI").visible = true
	var new_dungeon=dungeons[randomizer.randi_range(0,4)].instance()
	new_dungeon.character_name=current_character.characterName
	var monster_level=0
	if current_level>monster_level_list.size():
		monster_level=randomizer.randi_range(0,monster_level_list.size()-1)
	else:
		monster_level=current_level-1
	new_dungeon.monster_lst=monster_level_list[monster_level].monsters
	new_dungeon.boss_resource=monster_level_list[monster_level].boss
	dungeon_node.call_deferred("add_child",new_dungeon)
	last_dungeon = new_dungeon
	music_player.stream=dungeon_music
	music_player.playing=true
	

func _on_character_selected(selected_character):
	EventManager._quickselect_slots = null
	game_location="tavern"
	current_character = selected_character
	tavern_node.visible = true
	var tavern_instance = tavern_scene.instance()
	tavern_instance.init(current_character)
	tavern_node.add_child(tavern_instance)
	music_player.stream=tavern_music
	music_player.playing=true


func _on_reset_to_main():
	if game_location=="tavern":
		tavern_node.get_child(0).queue_free()
	elif game_location=="dungeon":
		dungeon_node.get_child(1).queue_free()
	game_location="main_menu"
	music_player.stream=main_menu_music
	music_player.playing=true
	
	
func _on_player_died(selected_character):
	dungeon_node.get_child(1).queue_free()
	game_location="tavern"
	current_character = selected_character
	tavern_node.visible = true
	var tavern_instance = tavern_scene.instance()
	tavern_instance.init(current_character)
	tavern_node.call_deferred("add_child", tavern_instance)
	music_player.stream=tavern_music
	music_player.playing=true
	
	
func _play_sound_effect(sound_effect):
	sound_effect_player.stream=sound_effect
	sound_effect_player.play()


func _process(delta):
	if music_player.playing==false:
		music_player.playing=true
	
