extends Sprite

export var damage = 10
export (String, "Front", "Left", "Center", "Right" ) var door_position
onready var collisionShape=get_node("Area2D/CollisionShape2D")
onready var collisionShape2=get_node("Area2D/CollisionShape2D")
var initiative = 0


func _ready():
	if door_position=="Front":
		region_rect.position.x=96
		region_rect.position.y=96
		region_rect.size.x=32
		region_rect.size.y=16
		collisionShape.shape.extents.x=32
		collisionShape.shape.extents.y=24
		collisionShape2.shape.extents.x=16
		collisionShape2.shape.extents.y=12
	else:
		region_rect.position.y=64
		region_rect.size.x=16
		region_rect.size.y=32
		collisionShape.shape.extents.x=24
		collisionShape.shape.extents.y=32
		collisionShape2.shape.extents.x=12
		collisionShape2.shape.extents.y=16
		if door_position=="Center":
			region_rect.position.x=96
		elif door_position=="Right":
			region_rect.position.x=128
		elif door_position=="Left":
			region_rect.position.x=112


func _on_Area2D_body_entered(body):
	if Input.is_action_just_pressed("interact") and body==character:
		queue_free()
