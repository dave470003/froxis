extends "res://library/Skill.gd"

func _ready():
	_triggerChar = KEY_C
	_initial_cooldown = 4
	_is_skill_unlocked_at_start = true
	super()
