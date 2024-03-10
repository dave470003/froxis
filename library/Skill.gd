extends PanelContainer

const MainScene := preload("res://scene/main/MainScene.gd")

var _triggerChar: int
var _cooldown: int
var _cooldown_remaining: int = 0
var _is_skill_primed: bool = false
var _ref_MainScene: MainScene
var _new_GroupName := preload("res://library/GroupName.gd").new()

@onready var thin_border := preload("res://scene/gui/ThinBorder.tres")
@onready var thick_border := preload("res://scene/gui/ThickBorder.tres")
@onready var reg_font := preload("res://scene/main/FiraTheme.tres")
@onready var bold_font := preload("res://scene/main/FiraThemeBold.tres")
@onready var emptyCharge := preload("res://sprite/EmptyCharge.tscn") as PackedScene
@onready var fullCharge := preload("res://sprite/FullCharge.tscn") as PackedScene

signal skill_primed(skill_name: String)
signal skill_unprimed(skill_name: String)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event: InputEvent) -> void:
	if _ref_MainScene._game_paused == true:
		return

	if event is InputEventKey and event.keycode == _triggerChar and event.is_pressed() and !event.is_echo():
		if _cooldown_remaining == 0:
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
		print('turn ended trigger')
		if _is_skill_primed:
			_unprime_skill()
			_cooldown_remaining = _cooldown
		elif _cooldown_remaining > 0:
			_cooldown_remaining = _cooldown_remaining - 1

		_update_cooldown_sprites()

		if _cooldown_remaining == 0:
			modulate.a = 1
		else:
			modulate.a = 0.5

func _update_cooldown_sprites():
	var cooldown_parent_node = get_node("SkillMarginWrapper/VBoxContainer/SkillCooldown")

	for n in cooldown_parent_node.get_children():
		cooldown_parent_node.remove_child(n)
		n.queue_free()

	var empty_charge = _cooldown_remaining
	var full_charge = _cooldown - empty_charge

	var empty_charge_node
	var full_charge_node

	var xpos = 0

	for i in range(0, full_charge):
		full_charge_node = fullCharge.instantiate()
		cooldown_parent_node.add_child(full_charge_node)
		full_charge_node.position = Vector2(xpos, 0)
		xpos = xpos + 24

	for i in range(0, empty_charge):
		empty_charge_node = emptyCharge.instantiate()
		cooldown_parent_node.add_child(empty_charge_node)
		empty_charge_node.position = Vector2(xpos, 0)
		xpos = xpos + 24


