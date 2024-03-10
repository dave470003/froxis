extends PanelContainer

const MainScene := preload("res://scene/main/MainScene.gd")

var _triggerChar = KEY_C
var _is_skill_primed: bool = false
var _ref_MainScene: MainScene
var _new_GroupName := preload("res://library/GroupName.gd").new()

@onready var thin_border := preload("res://scene/gui/ThinBorder.tres")
@onready var thick_border := preload("res://scene/gui/ThickBorder.tres")
@onready var reg_font := preload("res://scene/main/FiraTheme.tres")
@onready var bold_font := preload("res://scene/main/FiraThemeBold.tres")

signal skill_primed
signal skill_unprimed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event: InputEvent) -> void:
	if _ref_MainScene._game_paused == true:
		return

	if event is InputEventKey and event.keycode == _triggerChar and event.is_pressed() and !event.is_echo():
		if _is_skill_primed:
			_unprime_skill()
		else:
			_prime_skill()

func _prime_skill():
	_is_skill_primed = true
	skill_primed.emit()
	theme = bold_font
	add_theme_stylebox_override('panel', thick_border)

func _unprime_skill():
	_is_skill_primed = false
	skill_unprimed.emit()
	theme = reg_font
	add_theme_stylebox_override('panel', thin_border)

func _on_Schedule_turn_ended(current_sprite: Sprite2D) -> void:
	if current_sprite.is_in_group(_new_GroupName.PC):
		_unprime_skill()

