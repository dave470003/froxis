extends Node2D

func _set_signal(_signal_bind) -> void:

	for s in _signal_bind:
		# [signal_name, func_name, source_node, target_node]
		for i in range(3, len(s)):
			var callable = Callable(get_node(s[i]), s[1])
			get_node(s[2]).connect(s[0], callable)
			print(s[2], s[0], s[i])


func _set_node_ref(_node_ref) -> void:
	for n in _node_ref:
		# [target_var_name, source_node, target_node]
		for i in range(2, len(n)):
			get_node(n[i])[n[0]] = get_node(n[1])

