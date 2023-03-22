extends Control

#Dungeon
export(NodePath) onready var portrait = get_node(portrait) as TextureRect
export(NodePath) onready var xp_bar = get_node(xp_bar) as TextureProgress
export(NodePath) onready var health_bar = get_node(health_bar) as TextureProgress
export(NodePath) onready var gold = get_node(gold) as Label
export(NodePath) onready var end_turn = get_node(end_turn) as TextureButton
export(NodePath) onready var quickselect_slots = get_node(quickselect_slots) as Control


#Menu UI
onready var animations_node = preload("res://Scenes/Main_Screen_Animations.tscn")
var play_animation
export(NodePath) onready var main_menu = get_node(main_menu) as Control
export(NodePath) onready var game_ui = get_node(game_ui) as Control
export(NodePath) onready var pause = get_node(pause) as Control
export(NodePath) onready var help = get_node(help) as Control


#Character Select
export(NodePath) onready var cs = get_node(cs) as Control
export(NodePath) onready var cs_label = get_node(cs_label) as Label
export(NodePath) onready var cs_portrait = get_node(cs_portrait) as TextureRect
export(NodePath) onready var cs_description = get_node(cs_description) as Label
export(Array, Resource) var character_list
var i = 0


#Diary
export(NodePath) onready var diary = get_node(diary) as Control
export(NodePath) onready var diary_main = get_node(diary_main) as Control
export(NodePath) onready var diary_page_1 = get_node(diary_page_1) as Control
export(NodePath) onready var diary_page_2 = get_node(diary_page_2) as Control
export(NodePath) onready var diary_items = get_node(diary_items) as Control
export(NodePath) onready var diary_monsters = get_node(diary_monsters) as Control
export(NodePath) onready var diary_items_icon = get_node(diary_items_icon) as TextureRect
export(NodePath) onready var diary_items_name = get_node(diary_items_name) as Label
export(NodePath) onready var diary_items_description = get_node(diary_items_description) as Label
export(NodePath) onready var diary_monsters_icon = get_node(diary_monsters_icon) as TextureRect
export(NodePath) onready var diary_monsters_name = get_node(diary_monsters_name) as Label
export(NodePath) onready var diary_monsters_description = get_node(diary_monsters_description) as Label
var diary_item_list = []
var diary_monsters_list = []
var j = 0


func _ready():
	EventManager.connect("open_diary", self, "_on_open_diary")
	EventManager.connect("character_selected", self, "_on_character_selected")
	EventManager.connect("item_collected", self, "update_diary_item_list")
	EventManager.connect("attack_player", self, "subtract_health")
	EventManager.connect("heal_player", self, "add_health")
	EventManager.connect("enable_end_turn_button", self, "on_enable_end_turn_button")
	EventManager.connect("disable_end_turn_button", self, "on_disable_end_turn_button")
	EventManager.connect("add_monsters", self, "update_diary_monster_list")
	EventManager.connect("gold_collected", self, "add_gold")
	EventManager.connect("completed_dungeon_generation", self, "on_enable_end_turn_button")
	EventManager.connect("exit_dungeon", self, "on_disable_end_turn_button")
	EventManager.connect("reset_to_main", self, "on_disable_end_turn_button")
	EventManager.connect("monster_died", self, "add_xp")
	EventManager.connect("used_QS_slot", self, "trigger_QS_slot")
	EventManager.connect("get_QS_skills", self, "set_QS_slots")
	EventManager.connect("reset_QS_cooldowns", self, "reset_QS_slots")
	EventManager.connect("player_died", self, "_on_player_died")
	play_animation = animations_node.instance()
	main_menu.add_child(play_animation)
	main_menu.move_child(play_animation, 1)


func _process(delta):
	if i > -1 and i < character_list.size():
		cs_label.text = character_list[i].characterName
		cs_portrait.texture = character_list[i].characterPortrait
		cs_description.text = character_list[i].characterDescription
		health_bar.max_value = character_list[i].characterHealth
	elif i < 0:
		i = character_list.size() -1 
	elif i > character_list.size() - 1:
		i = 0
	if help.visible == true:
		if Input.is_action_just_pressed("back"):
			help.visible = false
			

#Dungeon
func _on_character_selected(current_character : character):	
	portrait.texture = current_character.characterPortrait
	health_bar.value = character_list[i].characterHealth
	set_QS_slots()
		
		
func _on_player_died(character_class):
	health_bar.value = character_list[i].characterHealth
	reset_QS_slots()
	
	
func subtract_health(used_skill : skill):
	health_bar.value -= used_skill.damage
	
	
func add_health(used_skill : skill):
	health_bar.value += used_skill.heal
	
	
func add_xp(xp_amount):
	xp_bar.value = int(xp_bar.value + xp_amount) % 100
		
		
func add_gold(amount):
	var current_amount = int(gold.get_text())
	current_amount += amount
	gold.text = str(current_amount)
	
	
func _on_End_Turn_pressed():
	EventManager.emit_signal("end_turn")
	
	
func on_enable_end_turn_button():
	end_turn.visible = true
	end_turn.disabled = false
	
	
func on_disable_end_turn_button():
	end_turn.visible = false
	end_turn.disabled = true
	
	
#Character Selection	
func _on_Cycle_Left_pressed():
	i -= 1


func _on_Cycle_Right_pressed():
	i += 1


func _on_Select_pressed():
	game_ui.visible = true
	cs.visible = false
	EventManager.emit_signal("character_selected", character_list[i])


func set_QS_slots():
	var k = 0
	var QS_slots = quickselect_slots.get_children()
	for slot in QS_slots:
		slot.texture = null
	for slot in EventManager._quickselect_slots:
		var node = quickselect_slots.get_child(k)
		node.texture = null
		node.texture = slot.icon
		k += 1


func trigger_QS_slot(index):
	reset_QS_slots()
	var node = quickselect_slots.get_child(index)
	node.set_modulate(Color.darkgray)
	
	
func reset_QS_slots():
	var k = 0	
	for slot in EventManager._quickselect_slots:
		if !slot.is_on_cooldown:
			var node = quickselect_slots.get_child(k)
			node.set_modulate(Color.white)
		k += 1


#Menu UI
func _on_Pause_Base_pressed():
	pause.visible = true


func _on_Help_Base_pressed():
	help.visible = true


func _on_Resume_pressed():
	pause.visible = false


func _on_Quit_to_Menu_pressed():
	main_menu.visible = true
	game_ui.visible = false
	play_animation = animations_node.instance()
	main_menu.add_child(play_animation)
	main_menu.move_child(play_animation, 1)
	EventManager.emit_signal("reset_to_main")
	pause.visible = false


#Main Menu
func _on_Main_Start_pressed():
	main_menu.visible = false
	cs.visible = true
	play_animation.queue_free()
	

func _on_Main_Options_pressed():
	pass # Replace with function body.


func _on_Main_Quit_pressed():
	get_tree().quit()


#Diary
func update_diary_item_list(item):
	if !(item in diary_item_list):
		diary_item_list.append(item)


func update_diary_monster_list(monsters):
	for _monster in monsters:
		if !(_monster in diary_monsters_list):
			diary_monsters_list.append(_monster)


func _on_items_button_pressed():
	if diary_item_list.size() > 0:
		diary_main.visible = false
		diary_items.visible = true
		diary_items_description.text = diary_item_list[0].itemDescription
		diary_items_icon.texture = diary_item_list[0].icon
		diary_items_name.text = diary_item_list[0].name
	
	
func _on_monster_button_pressed():
	if diary_monsters_list.size() > 0:
		diary_main.visible = false
		diary_monsters.visible = true
		diary_monsters_description.text = diary_monsters_list[0].description
		diary_monsters_icon.texture = diary_monsters_list[0].monsterAnimations.get_frame("default", 0)
		diary_monsters_name.text = diary_monsters_list[0].monsterName


func _on_achievements_button_pressed():
	pass # Replace with function body.


func _on_button_left_pressed():
	if diary_items.visible == true:
		if diary_item_list != null and diary_item_list.size() > 0:
			var current_item : Item
			j -= 1
			current_item = diary_item_list[j % diary_item_list.size()]
			diary_items_description.text = current_item.itemDescription
			diary_items_icon.texture = current_item.icon
			diary_items_name.text = current_item.name
	elif diary_monsters.visible == true:
		if diary_monsters_list != null and diary_monsters_list.size() > 0:
			var current_monster : monster
			j -= 1
			current_monster = diary_monsters_list[j % diary_monsters_list.size()]
			diary_monsters_description.text = current_monster.description
			diary_monsters_icon.texture = current_monster.monsterAnimations.get_frame("default", 0)
			diary_monsters_name.text = current_monster.monsterName


func _on_button_right_pressed():
	if diary_items.visible == true:
		if diary_item_list != null and diary_item_list.size() > 0:
			var current_item : Item
			j += 1
			current_item = diary_item_list[j % diary_item_list.size()]
			diary_items_description.text = current_item.itemDescription
			diary_items_icon.texture = current_item.icon
			diary_items_name.text = current_item.name
	elif diary_monsters.visible == true:
		if diary_monsters_list != null and diary_monsters_list.size() > 0:
			var current_monster : monster
			j += 1
			current_monster = diary_monsters_list[j % diary_monsters_list.size()]
			diary_monsters_description.text = current_monster.description
			diary_monsters_icon.texture = current_monster.monsterAnimations.get_frame("default", 0)
			diary_monsters_name.text = current_monster.monsterName


func _on_open_diary():
	diary.visible = true
	j = 0


func _on_exit_diary_pressed():
	diary.visible = false


func _on_exit_pressed():
	diary_main.visible = true
	diary_items.visible = false
	diary_monsters.visible = false
	
	
func _on_main_button_left_pressed():
	if diary_page_2.visible == true:
		diary_page_2.visible = false
		diary_page_1.visible = true


func _on_main_button_right_pressed():
	if diary_page_1.visible == true:
		diary_page_1.visible = false
		diary_page_2.visible = true


