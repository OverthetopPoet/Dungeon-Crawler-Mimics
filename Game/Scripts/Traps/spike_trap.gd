extends Sprite

export var damage = 10
var trap_stage=0
var initiative = 0


func _on_step_taken():
	if trap_stage==3:
		trap_stage=-2
	else:
		trap_stage+=1
	var trap_multiplier =trap_stage
	if trap_multiplier < 0:
		trap_multiplier*=-1
	region_rect.position.x=16+(trap_multiplier*16)


func _ready():
	region_rect.position.x=16+(trap_stage*16)

