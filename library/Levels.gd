# Levels.gd

const _new_GroupName = preload("GroupName.gd")

const LEVELS_DICT = {
	1: {
		_new_GroupName.DWARF: 4
	},
	2: {
		_new_GroupName.DWARF: 6
	},
	3: {
		_new_GroupName.DWARF: 3,
		_new_GroupName.TROLL: 1
	},
	4: {
		_new_GroupName.DWARF: 5,
		_new_GroupName.TROLL: 1
	},
	5: {
		_new_GroupName.DWARF: 3,
		_new_GroupName.HARPY: 3
	},
	6: {
		_new_GroupName.HARPY: 2,
		_new_GroupName.DWARF: 3,
		_new_GroupName.TROLL: 1
	},
	7: {
		_new_GroupName.ELF: 1,
		_new_GroupName.DWARF: 4,
		_new_GroupName.TROLL: 2
	},
	8: {
		_new_GroupName.ELF: 2,
		_new_GroupName.HARPY: 2,
		_new_GroupName.TROLL: 2
	},
	9: {
		_new_GroupName.ELF: 2,
		_new_GroupName.HARPY: 2,
		_new_GroupName.TROLL: 3,
		_new_GroupName.DWARF: 3
	},
	10: {
		_new_GroupName.ELF: 1,
		_new_GroupName.HARPY: 2,
		_new_GroupName.TROLL: 2,
		_new_GroupName.DWARF: 1,
		_new_GroupName.DEMON: 1
	},
}
