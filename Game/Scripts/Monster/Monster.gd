extends KinematicBody2D

class_name monsterObject

var randomizer
var ray : RayCast2D 
var attack_ray : RayCast2D
var player : playable_Character
var monster_resource
var elemental_weaknesses
var initiative = 0
var stamina
var health
var movement_allowed = false
var attack_allowed = false
var moves : int
var direction = Vector2.ZERO
var active = false
var cast_direction
var path = []
var melee_skill = preload("res://Resources/Character/Skills/Physical/Melee.tres")
signal turn_complete
signal movement_complete
signal attack_complete


# Graphics
var animatedSprite
var statueSprite
var wakeupArea
var monster_trigger=preload("res://Scenes/monster_trigger.tscn")


func _ready():
	EventManager.connect("attack_monster", self, "take_damage")
	EventManager.connect("heal_monster", self, "heal_monster")
	randomizer=RandomNumberGenerator.new()


func _init(monster_res : Resource, pos: Vector2, level: int):
	position=pos
	monster_resource=monster_res
	var newColShape = CollisionShape2D.new()
	set_collision_layer(0b00000000000001000001)
	set_collision_mask(0b00000000000011111111)
	var newRectangle = RectangleShape2D.new()
	if not monster_resource.isBoss:
		newRectangle.extents.x=8
		newRectangle.extents.y=8
	else:
		newRectangle.extents.x=16
		newRectangle.extents.y=16
	newColShape.shape=newRectangle
	add_child(newColShape)
	
	var new_sprite=Sprite.new()
	new_sprite.texture=monster_resource.characterPortrait
	add_child(new_sprite)
	statueSprite=new_sprite

	var newAnimatedSprite= AnimatedSprite.new()
	newAnimatedSprite.frames=monster_resource.monsterAnimations
	add_child(newAnimatedSprite)
	animatedSprite=newAnimatedSprite
	animatedSprite.visible=false
	
	var new_ray = RayCast2D.new()
	new_ray.exclude_parent = true
	new_ray.enabled = true
	new_ray.cast_to = Vector2(16,0)
	new_ray.set_collision_mask_bit(0, true)
	new_ray.set_collision_mask_bit(2, true)
	add_child(new_ray)
	ray = new_ray
	ray.visible = false
	
	var new_attack_ray = RayCast2D.new()
	new_attack_ray.exclude_parent = true
	new_attack_ray.enabled = true
	new_attack_ray.cast_to = Vector2(16,0)
	new_attack_ray.set_collision_mask_bit(0, true)
	new_attack_ray.set_collision_mask_bit(2, true)
	add_child(new_attack_ray)
	attack_ray = new_attack_ray
	
	elemental_weaknesses=[monster_resource.elemental_weakness0,monster_resource.elemental_weakness1,monster_resource.elemental_weakness2]
	initiative = monster_resource.initiative
	stamina = monster_resource.stamina
	
	var newArea2D = Area2D.new()
	var wakeupColShape = CollisionShape2D.new()
	newArea2D.set_collision_layer(0b00000000001000000000)
	newArea2D.set_collision_mask(0b00000000010000000000)
	var newCircle = CircleShape2D.new()
	newCircle.radius=monster_resource.wakeup_radius


	wakeupColShape.shape=newCircle
	newArea2D.add_child(wakeupColShape)
	add_child(newArea2D)
	newArea2D.monitoring=true
	newArea2D.connect("area_entered",self,"_on_wakeup")
	wakeupArea=newArea2D
	wakeupArea.visible = false
	
	if monster_resource.monster_type == "Standard":
		monster_resource.damage=int(level*2.25)
		monster_resource.health=level*5
	elif monster_resource.monster_type == "Weakling":
		monster_resource.damage=int(level*1.5)
		monster_resource.health=level*2
	elif monster_resource.monster_type == "Mimic":
		monster_resource.damage=int(level*2)
		monster_resource.health=level*3
	elif monster_resource.monster_type == "Boss":
		monster_resource.damage=int(level*3.75)
		monster_resource.health=level*10

	# Detect player Area
	var new_area = Area2D.new()
	var new_coll_shape = CollisionShape2D.new()
	new_area.add_child(new_coll_shape)
	add_child(new_area)
	var new_shape = CircleShape2D.new()
	new_shape.radius = 80
	new_coll_shape.shape = new_shape
	new_area.set_collision_layer_bit(0, false)
	new_area.set_collision_mask_bit(0, false)
	new_area.set_collision_mask_bit(2, true)
	new_area.monitoring = true
	new_area.connect("body_entered", self ,"_on_seen")
	new_area.connect("body_exited", self ,"_on_left")
	new_area.visible = false
	
	
func play_turn():
	if player:
		attack_allowed = true
		path = get_parent().get_parent().get_parent().get_node("floor_tiles").find_path(global_position, player.global_position)
	moves = 0
	active = true
	yield(self, "turn_complete")
	active = false
	
	
func _on_wakeup(area):
	animatedSprite.visible=true
	animatedSprite.play("default")
	statueSprite.visible=false
	wakeupArea.queue_free()
	var newTriggerInstance = monster_trigger.instance()
	call_deferred("add_child",newTriggerInstance)
	EventManager.emit_signal("update_actor_list")


func _process(delta):
	if active:	# Is monster the current actor?
		if !player:	# Is a player in the vicinity 
			emit_signal("turn_complete")
		else:
			var _attacks = get_possible_attacks()
			if _attacks.size() > 0:
				var decide = randomizer.randi_range(0, 5)
				if decide < 3:
					attack()
					yield(self, "attack_complete")
					emit_signal("turn_complete")
				else:
					if moves < stamina:
						if path != null and path.size() > 2:
							if monster_resource.isBoss:
								if path.size() > 4:
									global_position = path[1]
							else:
								global_position = path[1]
							path.remove(0)
							moves += 1
					attack()
					yield(self, "attack_complete")
					if moves >= stamina or path.size() <= 2:
						emit_signal("turn_complete")
			else:
				if moves < stamina:
					if path != null and path.size() > 2:
						if monster_resource.isBoss:
							if path.size() > 4:
								global_position = path[1]
						else:
							global_position = path[1]
						path.remove(0)
						moves += 1
				attack()
				yield(self, "attack_complete")
				if moves >= stamina or path.size() <= 2:
					emit_signal("turn_complete")
			

func attack():
	var possible_attacks = get_possible_attacks()
	if possible_attacks.size() > 0 and attack_allowed:
		var current_attack = possible_attacks[randomizer.randi_range(0, (possible_attacks.size() - 1))]
		skill_attack(current_attack)
	attack_allowed = false
	emit_signal("attack_complete")


func get_possible_attacks():
	randomizer.randomize()
	var possible_attacks = []
	for monster_skill in monster_resource.monster_skills:
		attack_ray.cast_to *= monster_skill.travel_range
		focus_player()
		attack_ray.force_raycast_update()
		if attack_ray.is_colliding():
			var collider = attack_ray.get_collider()
			if collider == player:
				possible_attacks.append(monster_skill)
		attack_ray.cast_to = Vector2(16, 0)
	return possible_attacks
	

func focus_player():
	if player.global_position.x == global_position.x:
		if player.global_position.y < global_position.y:
			cast_direction = "up"
			attack_ray.rotation_degrees = -90
		elif player.global_position.y > global_position.y: 
			cast_direction = "down"
			attack_ray.rotation_degrees = 90
	elif player.global_position.y == global_position.y:
		if player.global_position.x < global_position.x:
			cast_direction = "left"
			attack_ray.rotation_degrees = 180
		elif player.global_position.x > global_position.x: 
			cast_direction = "right"
			attack_ray.rotation_degrees = 0


func _on_seen(body):
	player = body
	movement_allowed = true


func _on_left(body):
	if body == player:
		player = null


func skill_attack(used_skill : skill):
	var temp_skill = skill_travel.new(self, used_skill, global_position, cast_direction, used_skill.aoe_range)
	get_parent().get_parent().get_parent().add_child(temp_skill)
	if used_skill.cast_range > 1 and used_skill.aoe_range < 1 and (cast_direction == "left" or cast_direction == "right"):
		for j in range(1, used_skill.cast_range):
			var temp_skill2 = skill_travel.new(self, used_skill, global_position + Vector2(0,j * 16), cast_direction, used_skill.aoe_range)
			var temp_skill3 = skill_travel.new(self, used_skill, global_position - Vector2(0,j * 16), cast_direction, used_skill.aoe_range)
			get_parent().get_parent().get_parent().add_child(temp_skill2)
			get_parent().get_parent().get_parent().add_child(temp_skill3)
	elif used_skill.cast_range > 1 and used_skill.aoe_range < 1 and (cast_direction == "up" or cast_direction == "down"):			
		for j in range(1, used_skill.cast_range):
			var temp_skill2 = skill_travel.new(self, used_skill, global_position + Vector2(j * 16, 0), cast_direction, used_skill.aoe_range)
			var temp_skill3 = skill_travel.new(self, used_skill, global_position - Vector2(j * 16, 0), cast_direction, used_skill.aoe_range)
			get_parent().get_parent().get_parent().add_child(temp_skill2)
			get_parent().get_parent().get_parent().add_child(temp_skill3)	


func take_damage(body, used_skill : skill):
	if self == body:
		monster_resource.health -= used_skill.damage * (player.level * 1.05)
		if monster_resource.health <=0:
			if monster_resource.isBoss:
				EventManager.emit_signal("boss_killed")
			EventManager.emit_signal("monster_died", monster_resource.xp_drop)
			var bagnew = lootBag.new(position, monster_resource.monsterDrop, monster_resource.max_drop_amount)
			get_parent().call_deferred("add_child", bagnew)
			emit_signal("turn_complete")
			queue_free()
			EventManager.emit_signal("update_actor_list")


func heal_monster(body, used_skill : skill):
	if self == body:
		monster_resource.health += used_skill.heal



