extends Control

const TOTAL_DISTANCE = 40000.0
const TUTORIAL_DISTANCE = 5000.0

var elapsed_time: float = 0.0
var is_running: bool = true
var start_y: float = 0.0
var start_set: bool = false

@onready var progressbar = $ProgressBar
@onready var timer_label = $TimerHintergrund/TimerLabel
@onready var level_complete_screen = $LevelComplete
@onready var zeit_label = $LevelComplete/ZeitLabel
@onready var neustart_button = $LevelComplete/NeustartButton
@onready var menu_button = $LevelComplete/MenuButton
@onready var tutorial_screen = $Tutorial

func _ready():
	neustart_button.pressed.connect(_on_neustart_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	
	# Tutorial anzeigen + Spiel pausieren
	tutorial_screen.visible = true


func _process(delta):
	if not is_running:
		return
	
	elapsed_time += delta
	timer_label.text = format_time(elapsed_time)
	
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	if not start_set:
		start_y = player.global_position.y
		start_set = true
	
	var castle = get_tree().get_first_node_in_group("castle")
	var distance_traveled = start_y - player.global_position.y
	
	if castle != null:
		var total_distance = start_y - castle.global_position.y
		progressbar.value = clamp(distance_traveled / total_distance, 0.0, 1.0)
	else:
		progressbar.value = clamp(distance_traveled / TOTAL_DISTANCE, 0.0, 1.0)

	# Tutorial ausblenden nach Tutorial-Distanz
	if tutorial_screen.visible and distance_traveled >= TUTORIAL_DISTANCE:
		tutorial_screen.visible = false

func format_time(seconds: float) -> String:
	var minutes = int(seconds) / 60
	var secs = int(seconds) % 60
	return "%02d:%02d" % [minutes, secs]


func stop_timer():
	is_running = false


func get_final_time() -> String:
	return format_time(elapsed_time)


func show_level_complete():
	is_running = false
	zeit_label.text = "Deine Zeit: " + format_time(elapsed_time)
	level_complete_screen.visible = true


func _on_neustart_pressed():
	get_tree().reload_current_scene()


func _on_menu_pressed():
	# Pfad zur Menü-Scene anpassen falls anders!
	get_tree().change_scene_to_file("res://ludwigmenü.tscn")
