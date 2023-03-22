extends Node

class_name battle_system

var actor_list : Array
var next_actor
var current_actor
var dungeon_active


func _ready():
	EventManager.connect("completed_dungeon_generation", self, "initialize")
	EventManager.connect("hit_object", self, "_on_hit")
	EventManager.connect("update_actor_list", self, "update_battlers")
	EventManager.connect("change_level",self, "_on_change_level")
	EventManager.connect("player_died", self, "_on_player_died")


func initialize():
	yield(get_tree().create_timer(1), "timeout")
	update_battlers()
	current_actor = actor_list[0]
	dungeon_active = true
	play_turn()


func play_turn():
	while !(is_instance_valid(current_actor)):
		current_actor = next_actor
		var next_index = (actor_list.find(current_actor) + 1) % actor_list.size()
		next_actor = actor_list[next_index]
	if current_actor is monsterObject:
		if current_actor.player != null:
			yield(current_actor.play_turn(), "completed")
	else:
		yield(current_actor.play_turn(), "completed")
	if current_actor is monsterObject:
		if current_actor.player != null:
			yield(get_tree().create_timer(1), "timeout")
	if dungeon_active:
		var new_index = (actor_list.find(current_actor) + 1) % actor_list.size()
		current_actor = actor_list[new_index]
		var next_index = (actor_list.find(current_actor) + 1) % actor_list.size()
		next_actor = actor_list[next_index]
		if actor_list.size() > 1 and dungeon_active:
			play_turn()
				

func update_battlers():
	actor_list.clear()
	var monster_nodes = get_parent().get_child(1).get_child(4).get_child(1).get_children()
	var mimic_nodes = get_parent().get_child(1).get_child(4).get_child(0).get_children()
	for node in monster_nodes:
		if node is monsterObject:
			actor_list.push_back(node)
	for node in mimic_nodes:
		if node is monsterObject:
			actor_list.push_back(node)
	actor_list.append(get_parent().get_child(1).get_child(4).get_child(2).get_child(0))
	actor_list.sort_custom(self, "sort_battlers")


static func sort_battlers(a, b) -> bool:
	if a.initiative > b.initiative:
		return true
	else:
		return false


func get_actor_list():
	var complete_list : Array
	var monster_nodes = get_parent().get_child(1).get_child(4).get_child(1).get_children()
	for node in monster_nodes:
		if node is monsterObject or node is statueObject:
			complete_list.push_back(node)
	actor_list.append(get_parent().get_child(1).get_child(4).get_child(2).get_child(0))
	return complete_list


# Actions
func _on_hit(caster, body, used_skill):
	if body is playable_Character:
		if used_skill.skill_type == "heal" and caster is playable_Character:
			EventManager.emit_signal("heal_player", used_skill)
		else:
			EventManager.emit_signal("attack_player", used_skill)
	elif body is monsterObject:
		if used_skill.skill_type == "heal":
			EventManager.emit_signal("heal_monster", body, used_skill)
		else:
			if caster is playable_Character and body is monsterObject:
				EventManager.emit_signal("attack_monster", body, used_skill)


func _on_change_level():
	reset()
	

func reset():
	dungeon_active = false
	current_actor = null
	next_actor = null
	actor_list.clear()


func _on_player_died(selected_character):
	reset()
