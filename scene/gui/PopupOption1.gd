extends Label

var _triggerKeycode: int
var _callback: Callable
var _callback_arg

signal option_selected

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup_trigger_char(keycode: int):
	_triggerKeycode = keycode

func setup_callable(callback: Callable, arg):
	_callback = callback
	_callback_arg = arg

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == _triggerKeycode:
		_callback.call(_callback_arg)
