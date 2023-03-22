extends Resource

class_name skill

export(String) var name
export(String, MULTILINE) var description
export(int) var level
export(int) var cooldown
export(int) var turn_cost
export(bool) var is_on_cooldown
export(int) var current_cooldown
export(String, "projectile", "pull", "push", "heal") var skill_type

export(String, "dark", "earth", "fire", "holy", "ice", "lightning", "water", "wind") var elemental_type
export(String) var effect
export(int) var damage
export(int) var heal
export(int) var cast_range
export(int) var travel_range
export(int) var aoe_range

export(Texture) var icon
export(AudioStreamMP3) var sound_effect
export(SpriteFrames) var animation
export(SpriteFrames) var animation_hit


