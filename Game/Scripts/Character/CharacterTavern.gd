extends KinematicBody2D

class_name playable_Character_Tavern

export(String, "Sorceress", "Warrior", "Ranger") var characterName
var characterClass : character
var direction = Vector2.ZERO
export(int) var speed 
var velocity : Vector2
var accel = 0.1
var friction = 0.1
var max_speed = 100
var gravity = 1000
var interactable = false

var level : int
var xp : int
var health : int
export(Array) var skills

onready var collShape = get_node("CollisionShape2D")
onready var charAnimations  = get_node("AnimatedSprite")


# Changing Character variables
func _ready(): 
	EventManager.connect("trader_area_entered", self, "_on_trader_area_entered")
	EventManager.connect("trader_area_exited", self, "_on_trader_area_exited")
	
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
	collShape.position.y += 1
	charAnimations.frames = characterClass.characterAnimations
	if EventManager._quickselect_slots == null:
		EventManager._quickselect_slots = characterClass.startingSkills
	EventManager.emit_signal("get_QS_skills")
	

# Basic movement
func getInput():
	if Input.is_action_pressed("left"):
		direction.x -= 1 
		charAnimations.animation = "Idle_Side"
		charAnimations.flip_h = true
	if Input.is_action_pressed("right"):
		direction.x += 1 
		charAnimations.animation = "Idle_Side"
		charAnimations.flip_h = false
	if Input.is_action_just_pressed("interact") and interactable:
		EventManager.emit_signal("initiate_dialogue")
	# Diary
	if Input.is_action_just_pressed("diary"):
		EventManager.emit_signal("open_diary")	
	

func _process(delta):
	getInput()
	velocity.y += gravity * delta
	velocity.x = speed * direction.normalized().x
	velocity = move_and_slide(velocity)
	direction = Vector2.ZERO


func _on_trader_area_entered(position):
	interactable = true


func _on_trader_area_exited():
	interactable = false
