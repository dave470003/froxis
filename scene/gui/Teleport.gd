extends "res://library/Skill.gd"

func _ready():
	_triggerChar = KEY_T
	_initial_cooldown = 10
	super()

func _on_PCMove_teleport_kill():
	_do_not_reset_cooldown_this_turn = true
