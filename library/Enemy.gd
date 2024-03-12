extends Sprite2D

var _new_Colours = preload("Colours.gd")
var _new_GroupName := preload("res://library/GroupName.gd").new()

var _initial_health: int
var _health: int
var _move_speed: int
var _attack_range: int
var _name: String

# Called when the node enters the scene tree for the first time.
func _ready():
	set_health(_initial_health)
	if is_in_group(_new_GroupName.DWARF):
		_name = 'Dwarf'
	elif is_in_group(_new_GroupName.HARPY):
		_name = 'Harpy'
	elif is_in_group(_new_GroupName.TROLL):
		_name = 'Troll'
	elif is_in_group(_new_GroupName.ELF):
		_name = 'Elf'
	elif is_in_group(_new_GroupName.DEMON):
		_name = 'Demon'


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_health(health: int):
	match health:
		1:
			modulate = Color(_new_Colours.HEALTH_1)
		2:
			modulate = Color(_new_Colours.HEALTH_2)
		3:
			modulate = Color(_new_Colours.HEALTH_3)
		4:
			modulate = Color(_new_Colours.HEALTH_4)
		5:
			modulate = Color(_new_Colours.HEALTH_5)
		6:
			modulate = Color(_new_Colours.HEALTH_6)
		7:
			modulate = Color(_new_Colours.HEALTH_7)
		8:
			modulate = Color(_new_Colours.HEALTH_8)
		9:
			modulate = Color(_new_Colours.HEALTH_9)
		10:
			modulate = Color(_new_Colours.HEALTH_10)

	_health = health

func remove_health(damage: int):
	set_health(_health - damage)


