extends AnimatedSprite

class_name skill_hit


func _init(used_skill : skill, pos):
	self.frames = used_skill.animation_hit
	position = pos


func _on_Hit_animation_finished():
	queue_free()
