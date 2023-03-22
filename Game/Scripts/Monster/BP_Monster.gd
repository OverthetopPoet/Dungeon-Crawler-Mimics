extends Resource

class_name monster

# General
export(String) var monsterName
export(String, MULTILINE) var description
export(bool) var isBoss
export(int) var initiative
export(Resource) var monsterDrop
export(int) var max_drop_amount = 1
export (int) var wakeup_radius = 72

# Combat 
export(String, "Standard", "Weakling", "Mimic", "Boss" ) var monster_type
export(int) var stamina = 2
export(int) var health
export(int) var armor
export(int) var damage
export(int) var xp_drop = 10
export(String) var damage_type
export(int) var attack_range
export(Array, Resource) var monster_skills
export(String, "none", "dark", "earth", "fire", "holy", "ice", "lightning", "physical", "water", "wind") var elemental_weakness0
export(String, "none", "dark", "earth", "fire", "holy", "ice", "lightning", "physical", "water", "wind") var elemental_weakness1
export(String, "none", "dark", "earth", "fire", "holy", "ice", "lightning", "physical", "water", "wind") var elemental_weakness2

# Graphics
export(SpriteFrames) var monsterAnimations = monsterAnimations as SpriteFrames
export(Texture) var characterPortrait 

