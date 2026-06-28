extends Panel

# Greybox-Farben für die Hebel — kannst du beliebig erweitern/kürzen
var colors := [Color.RED, Color.BLUE, Color.YELLOW, Color.GREEN]

# Welche Farbe jeder Slot gerade zeigt (Index in "colors")
var current := [0, 0, 0, 0]

# Die 4 Slot-ColorRects — gleich im Inspector zuweisen
@export var slots: Array[ColorRect]

func _ready():
	for i in slots.size():
		slots[i].gui_input.connect(_on_slot_input.bind(i))
		_update_slot(i)

func _on_slot_input(event: InputEvent, index: int):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		current[index] = (current[index] + 1) % colors.size()
		_update_slot(index)

func _update_slot(index: int):
	slots[index].color = colors[current[index]]
