extends Resource

class_name character

export(String) var characterName
export(Shape2D) var characterCollisionShape = characterCollisionShape as Shape 
export(SpriteFrames) var characterAnimations = characterAnimations as SpriteFrames
export(Texture) var characterPortrait 
export(Array, Resource) var startingSkills
export(String, MULTILINE) var characterDescription

export(int) var initiative
export(int) var stamina
export var characterLevel : int
export var characterXP : int
export var characterHealth : int
