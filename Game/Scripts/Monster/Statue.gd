extends KinematicBody2D

class_name statueObject

var monster_resource


func _init(monster_res : Resource, pos: Vector2):
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
	
