extends KinematicBody2D

class_name playable_Character

export(String, "Sorceress", "Warrior", "Ranger") var characterName
var characterClass : character
var direction = Vector2.ZERO
var tile_size = 16

# Character attributes
var level :int
var xp : int
var gold : int
var max_health
var health = 0
var initiative : int
var stamina : int

signal turn_complete
var active = false
var movement_allowed = true
var attack_allowed = true
var moves : int

export(Array, Resource) var skills
export(Array, Resource) var quickselect_slots

var current_cast_cell
var current_cast_skill

onready var collShape = get_node("CollisionShape2D")
onready var charAnimations  = get_node("AnimatedSprite")
onready var camera  = get_node("Camera2D")
onready var ray = get_node("RayCast2D")

# Changing Character variables
func _ready(): 
	EventManager.connect("heal_player", self, "heal_player")
	EventManager.connect("attack_player", self, "take_damage")
	EventManager.connect("confirmed_attack_cell", self, "_on_confirmed_attack_cell")
	EventManager.connect("change_level", self, "_on_change_level")
	EventManager.connect("end_turn", self, "_on_end_turn")
	EventManager.connect("monster_died", self, "_on_monster_died")

	if characterName == "Sorceress": 
		characterClass = load("res://Resources/Character/R_DeftSorceress.tres")
		level = EventManager.level[0]
	elif characterName == "Warrior":
		characterClass = load("res://Resources/Character/R_AncientFighter.tres")
		level = EventManager.level[1]
	elif characterName == "Ranger":
		characterClass = load("res://Resources/Character/R_HalflingRanger.tres")
		level = EventManager.level[2]
	
	collShape.shape = characterClass.characterCollisionShape
	charAnimations.frames = characterClass.characterAnimations
	charAnimations.position.y -= 4
	initiative = characterClass.initiative
	stamina = characterClass.stamina
	max_health = characterClass.characterHealth
	health = clamp(health, 0, max_health)
	health = max_health
	skills.clear()
	for i in characterClass.startingSkills:
		skills.append(i)
	if EventManager._quickselect_slots == null:
		EventManager._quickselect_slots = skills
	else:
		quickselect_slots = EventManager._quickselect_slots
	EventManager.emit_signal("get_QS_skills")
	
	
# Basic movement
func getInput():
	
	# Movement
	if Input.is_action_just_pressed("left"):
		ray.rotation_degrees = 180
		direction = Vector2(-1, 0)
		charAnimations.animation = "Idle_Side"
		charAnimations.flip_h = true
		moves += 1
	if Input.is_action_just_pressed("right"):
		ray.rotation_degrees = 0
		direction = Vector2(1, 0)
		charAnimations.animation = "Idle_Side"
		charAnimations.flip_h = false
		moves += 1
	if Input.is_action_just_pressed("up"):
		ray.rotation_degrees = 270
		direction = Vector2(0, -1)
		charAnimations.animation = "Idle_Back"
		moves += 1
	if Input.is_action_just_pressed("down"):
		ray.rotation_degrees = 90
		direction = Vector2(0, 1)
		charAnimations.animation = "Idle_Front"
		moves += 1

	# Quickselect	
	if Input.is_action_just_pressed("quickSlot_1"):
		if quickselect_slots.size() > 0 and quickselect_slots[0] != null and !quickselect_slots[0].is_on_cooldown:
			EventManager.emit_signal("used_QS_slot", 0)
			use(quickselect_slots[0])
	if Input.is_action_just_pressed("quickSlot_2"):
		if quickselect_slots.size() > 1 and quickselect_slots[1] != null and !quickselect_slots[1].is_on_cooldown:
			EventManager.emit_signal("used_QS_slot", 1)
			use(quickselect_slots[1])
	if Input.is_action_just_pressed("quickSlot_3"):
		if quickselect_slots.size() > 2 and quickselect_slots[2] != null and !quickselect_slots[2].is_on_cooldown:
			EventManager.emit_signal("used_QS_slot", 2)
			use(quickselect_slots[2])
	if Input.is_action_just_pressed("quickSlot_4"):
		if quickselect_slots.size() > 3 and quickselect_slots[3] != null and !quickselect_slots[3].is_on_cooldown:
			EventManager.emit_signal("used_QS_slot", 3)
			use(quickselect_slots[3])
	if Input.is_action_just_pressed("quickSlot_5"):
		if quickselect_slots.size() > 4 and quickselect_slots[4] != null and !quickselect_slots[4].is_on_cooldown:
			EventManager.emit_signal("used_QS_slot", 4)
			use(quickselect_slots[4])
	if Input.is_action_just_pressed("quickSlot_6"):
		if quickselect_slots.size() > 5 and quickselect_slots[5] != null and !quickselect_slots[5].is_on_cooldown:
			EventManager.emit_signal("used_QS_slot", 5)
			use(quickselect_slots[5])
	if Input.is_action_just_pressed("quickSlot_7"):
		if quickselect_slots.size() > 6 and quickselect_slots[6] != null and !quickselect_slots[6].is_on_cooldown:
			EventManager.emit_signal("used_QS_slot", 6)
			use(quickselect_slots[6])
	if Input.is_action_just_pressed("quickSlot_8"):
		if quickselect_slots.size() > 7 and quickselect_slots[7] != null and !quickselect_slots[7].is_on_cooldown:
			EventManager.emit_signal("used_QS_slot", 7)
			use(quickselect_slots[7])
	if Input.is_action_just_pressed("quickSlot_9"):
		if quickselect_slots.size() > 8 and quickselect_slots[8] != null and !quickselect_slots[8].is_on_cooldown:
			EventManager.emit_signal("used_QS_slot", 8)
			use(quickselect_slots[8])
	if Input.is_action_just_pressed("quickSlot_0"):
		if quickselect_slots.size() > 9 and quickselect_slots[9] != null and !quickselect_slots[9].is_on_cooldown:
			EventManager.emit_signal("used_QS_slot", 9)
			use(quickselect_slots[9])
	
	# Diary
	if Input.is_action_just_pressed("diary"):
		EventManager.emit_signal("open_diary")
	

func _process(delta):
	if active:
		if moves >= stamina:
			movement_allowed = false
		getInput()
		ray.force_raycast_update()
		if !ray.is_colliding() and movement_allowed: #remove second condition if you want to move infinitely
			position += tile_size * direction
		direction = Vector2.ZERO
		if !movement_allowed and !attack_allowed:
			emit_signal("turn_complete")
	
	
func play_turn():
	EventManager.emit_signal("enable_end_turn_button")
	for slot in quickselect_slots:
		if slot is skill:
			skill_cooldown(slot)
	EventManager.emit_signal("reset_QS_cooldowns")
	attack_allowed = true
	movement_allowed = true
	moves = 0
	active = true
	yield(self, "turn_complete")
	active = false
	EventManager._quickselect_slots = quickselect_slots
	EventManager.emit_signal("disable_end_turn_button")
	
	
func skill_cooldown(_skill : skill):
	if _skill.is_on_cooldown:
		_skill.current_cooldown += 1
		if _skill.current_cooldown >= _skill.cooldown:
			_skill.is_on_cooldown = false

	
func use(slot):
	if slot is skill and attack_allowed and !slot.is_on_cooldown:
		current_cast_skill = slot
		EventManager.emit_signal("display_attack_map", self.global_position, slot.cast_range, slot.travel_range, slot.aoe_range)
		
	
func _on_confirmed_attack_cell(cast_pos, cast_direction):
	var temp_skill = skill_travel.new(self, current_cast_skill, cast_pos, cast_direction, current_cast_skill.aoe_range)
	get_parent().get_parent().get_parent().add_child(temp_skill)
	if current_cast_skill.cast_range > 1 and current_cast_skill.aoe_range < 1 and (cast_direction == "left" or cast_direction == "right"):
		for j in range(1, current_cast_skill.cast_range):
			var temp_skill2 = skill_travel.new(self, current_cast_skill, cast_pos + Vector2(0,j * 16), cast_direction, current_cast_skill.aoe_range)
			var temp_skill3 = skill_travel.new(self, current_cast_skill, cast_pos - Vector2(0,j * 16), cast_direction, current_cast_skill.aoe_range)
			get_parent().get_parent().get_parent().add_child(temp_skill2)
			get_parent().get_parent().get_parent().add_child(temp_skill3)
	elif current_cast_skill.cast_range > 1 and current_cast_skill.aoe_range < 1 and (cast_direction == "up" or cast_direction == "down"):			
		for j in range(1, current_cast_skill.cast_range):
			var temp_skill2 = skill_travel.new(self, current_cast_skill, cast_pos + Vector2(j * 16, 0), cast_direction, current_cast_skill.aoe_range)
			var temp_skill3 = skill_travel.new(self, current_cast_skill, cast_pos - Vector2(j * 16, 0), cast_direction, current_cast_skill.aoe_range)
			get_parent().get_parent().get_parent().add_child(temp_skill2)
			get_parent().get_parent().get_parent().add_child(temp_skill3)	
	if current_cast_skill.turn_cost > 0:
		attack_allowed = false
	current_cast_skill.current_cooldown = 0
	current_cast_skill.is_on_cooldown = true
	
	
func take_damage(used_skill : skill):
	health -= used_skill.damage
	if health <= 0:
		EventManager.emit_signal("player_died", characterClass)
		emit_signal("turn_complete")


func heal_player(used_skill : skill):
	health += used_skill.heal


func _on_change_level():
	emit_signal("turn_complete")
	
	
func _on_end_turn():
	emit_signal("turn_complete")
	
	
func _on_monster_died(xp_drop):
	if xp + xp_drop < 100:
		xp += xp_drop
	else:
		if characterName == "Warrior":
			EventManager.level[0] += 1
		elif characterName == "Sorceress":
			EventManager.level[1] += 1
		elif characterName == "Ranger":
			EventManager.level[2] += 1
		level += 1
		xp = (xp + xp_drop) % 100
