extends Node2D

var _new_Skills := preload("res://library/Skills.gd").new()
var _bought_skills_ids: Array = []
var _available_skills: Array = []
var _is_open: bool = true

signal increase_health(amount: int)
signal learn_shuriken()
signal learn_teleport()
signal learn_trap()
signal learn_invisibility()
signal reduce_skill_cooldown()

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_available_skills()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func reset():
	_bought_skills_ids = []
	_is_open = true
	_update_available_skills()

func purchase_skill(skill_name: String):
	var id = _get_id_for_skill(skill_name)
	if id != null:
		_bought_skills_ids.append(id)
		_update_available_skills()

	_is_open = false

	_after_purchase_skill(skill_name)

func _update_available_skills():
	var local_available_skills = []
	var skill
	for i in range(0, _new_Skills.SKILL_DICT.values().size()):
		skill = _new_Skills.SKILL_DICT.values()[i]
		if _bought_skills_ids.has(skill.id):
			continue
		if skill.dependency == null:
			local_available_skills.append(skill)
		elif _bought_skills_ids.has(skill.dependency):
			local_available_skills.append(skill)

	_available_skills = local_available_skills
	_shuffle_skills()

func _get_id_for_skill(skill_name: String):
	if _new_Skills.SKILL_DICT.keys().has(skill_name):
		return _new_Skills.SKILL_DICT[skill_name].id
	return null

func _shuffle_skills():
	_available_skills.shuffle()

func has_skill(skill_name: String):
	var id = _get_id_for_skill(skill_name)
	if id != null:
		return _bought_skills_ids.has(id)
	return false

func _after_purchase_skill(skill_name):
	match skill_name:
		_new_Skills.SKILL_UPGRADE_HEALTH:
			increase_health.emit(1)
		_new_Skills.SKILL_TRAP_1:
			learn_trap.emit()
		_new_Skills.SKILL_INVISIBILITY_1:
			learn_invisibility.emit()
		_new_Skills.SKILL_SHURIKEN_1:
			learn_shuriken.emit()
		_new_Skills.SKILL_TELEPORT_1:
			learn_teleport.emit()
		_new_Skills.SKILL_INVISIBILITY_3:
			reduce_skill_cooldown.emit("invisibility")
		_new_Skills.SKILL_CHARGE_2:
			reduce_skill_cooldown.emit("charge")
		_new_Skills.SKILL_TRAP_2:
			reduce_skill_cooldown.emit("trap")
		_new_Skills.SKILL_SHURIKEN_3:
			reduce_skill_cooldown.emit("shuriken")

func _on_PCMove_next_level():
	_is_open = true
