extends AnimatedSprite

class_name skill_travel

var used_skill
var caster
var cast_direction
var start_pos
var frame_counter = 0.0


func _init(_caster, _used_skill : skill, pos, _cast_direction, aoe_range):
	self.frames = _used_skill.animation
	self.playing = true
	
	start_pos = pos
	used_skill = _used_skill
	cast_direction = _cast_direction
	caster = _caster
	self.connect("animation_finished", self, "skill_delete")
	var area = Area2D.new()
	var collision = CollisionShape2D.new()
	collision.shape = load("res://Resources/Character/Skills/C_Skills.tres")

	if aoe_range >= 1:
		collision.shape.extents = Vector2((aoe_range) * 32 + 16, (aoe_range) * 32 + 16)
	else:
		collision.shape.extents = Vector2(14, 14)
	
	area.add_child(collision)
	add_child(area)
	area.monitoring = true
	area.set_collision_layer_bit(0, false)
	area.set_collision_mask_bit(2, true)
	area.set_collision_mask_bit(6, true)
	scale = Vector2(0.5, 0.5)
	area.connect("body_entered", self, "_on_hit")

	if cast_direction == "right":
		position = start_pos + Vector2(16, 0)
	elif cast_direction == "left":
		position = start_pos + Vector2(-16, 0)				
	elif cast_direction == "up":
		position = start_pos + Vector2(0, -16)
	elif cast_direction == "down":
		position = start_pos + Vector2(0, 16)
	elif cast_direction == "center":
		position = start_pos
	if _used_skill.sound_effect:
		_used_skill.sound_effect.loop=false
	EventManager.emit_signal("play_sound_effect",_used_skill.sound_effect )
	
			
func _process(delta):
	frame_counter += delta
	if frame_counter > 0.01 :
		if cast_direction == "right":
			if position.x < start_pos.x + used_skill.travel_range * 16 + 1:
				rotation_degrees = 0
				if used_skill.travel_range > 1:
					position.x +=1
				elif used_skill.travel_range == 1:
					position.x = start_pos.x + 16
		elif cast_direction == "left":
			if position.x > start_pos.x - used_skill.travel_range * 16 - 1:
				flip_h = true
				if used_skill.travel_range > 1:
					position.x -= 1
				elif used_skill.travel_range == 1:
					position.x = start_pos.x - 16
		elif cast_direction == "down":
			if position.y < start_pos.y + used_skill.travel_range * 16 + 1:
				rotation_degrees = 90
				if used_skill.travel_range > 1:
					position.y += 1
				elif used_skill.travel_range == 1:
					position.y = start_pos.y + 16
		elif cast_direction == "up":
			if position.y > start_pos.y - used_skill.travel_range * 16 - 1:
				rotation_degrees = 270
				if used_skill.travel_range > 1:
					position.y -= 1
				elif used_skill.travel_range == 1:
					position.y = start_pos.y - 16
		frame_counter = 0.0
		
		
func skill_delete():
	queue_free()


func _on_hit(body):
	if body != caster:
		EventManager.emit_signal("hit_object", caster, body, used_skill)
		if used_skill.animation_hit != null:
			var hit = skill_hit.new(used_skill, body.position)
	elif body == caster and used_skill.skill_type == "heal":
		EventManager.emit_signal("hit_object", caster, body, used_skill)
