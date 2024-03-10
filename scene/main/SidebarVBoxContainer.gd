extends VBoxContainer

var _new_GroupName := preload("res://library/GroupName.gd").new()

@onready var _heart := preload("res://sprite/Heart2.tscn") as PackedScene
@onready var _label_help: Label = get_node("Help")
@onready var _label_level: Label = get_node("Level")
@onready var _node_health: HBoxContainer = get_node("Health")

var _health: int

signal game_over(message: String)

func _ready() -> void:
	_health = 0
	_label_help.text = "RL Demo"

func _on_InitGame_set_health(health: int):
	_health = health
	_update_health()

func _on_EnemyAI_enemy_attack(damage: int):
	_health = _health - damage
	_update_health()
	if (_health <= 0):
		game_over.emit("You were killed.")

func _on_InitLevel_level_started(level: int):
	_label_help.text = str("Floor ", level)

func _update_health():
	var sprite: TextureRect

	for n in _node_health.get_children():
		_node_health.remove_child(n)
		n.queue_free()

	for i in range(0, _health):
		sprite = _heart.instantiate()
		_node_health.add_child(sprite)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
