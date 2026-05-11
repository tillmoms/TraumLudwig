extends Node2D

@export var tree_scene: PackedScene
@export var obstacles_scene: PackedScene


var wall_timer = 0.4
const WALL_INTERVAL = 0.3
const LEFT_WALL_X = -900.0
const RIGHT_WALL_X = 900.0

var obstacle_timer = 0.0
const OBSTACLE_INTERVAL = 1.0

# NEU: Tutorial-Distanz
const TUTORIAL_DISTANCE = 5000.0
var player_start_y = 0.0
var start_position_set = false

func _process(delta):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	# NEU: Startposition einmalig speichern
	if not start_position_set:
		player_start_y = player.global_position.y
		start_position_set = true
	
	# NEU: Zurückgelegte Strecke berechnen (player bewegt sich nach oben, also negativ)
	var distance_traveled = player_start_y - player.global_position.y
	
	var spawn_y = player.global_position.y - 800
	
	# WandBäume (laufen wie immer)
	wall_timer += delta
	
	if wall_timer >= WALL_INTERVAL:
		wall_timer = 0.0
		# Innere Wand
		spawn_tree(Vector2(LEFT_WALL_X, spawn_y + randf_range(-20.0, 20.0)), 1.0, true, -1)
		spawn_tree(Vector2(RIGHT_WALL_X, spawn_y + randf_range(-20.0, 20.0)), 1.0, true, 1)
		# Mittlere Wand
		spawn_tree(Vector2(-900.0, spawn_y + randf_range(-80.0, 80.0)), 1.0, true, -2)
		spawn_tree(Vector2(900.0, spawn_y + randf_range(-80.0, 80.0)), 1.0, true, 2)
		# Äußere Wand
		spawn_tree(Vector2(-1100.0, spawn_y + randf_range(-100.0, 100.0)), 1.0, true, -3)
		spawn_tree(Vector2(1100.0, spawn_y + randf_range(-100.0, 100.0)), 1.0, true, 3)
		# Weiteste Wand
		spawn_tree(Vector2(-1300.0, spawn_y + randf_range(-120.0, 120.0)), 1.0, true, -4)
		spawn_tree(Vector2(1300.0, spawn_y + randf_range(-120.0, 120.0)), 1.0, true, 4)

	# Hindernisse (Steine/Laternen) - NUR nach Tutorial-Distanz
	if distance_traveled >= TUTORIAL_DISTANCE:
		obstacle_timer += delta
		if obstacle_timer >= OBSTACLE_INTERVAL:
			obstacle_timer = 0.0
			var target_x = randf_range(-560.0, 560.0)
			spawn_obstacle(spawn_y, target_x)

func spawn_tree(pos: Vector2, scale_factor: float, wall: bool = false, side: int = 1):
	var tree = tree_scene.instantiate()
	get_parent().add_child(tree)
	tree.global_position = pos
	tree.scale = Vector2(scale_factor, scale_factor)
	tree.is_wall_tree = wall
	tree.side = side
	tree.call_deferred("init_tree")
	
func spawn_obstacle(spawn_y: float, target_x: float):
	var obstacle = obstacles_scene.instantiate()
	get_parent().add_child(obstacle)
	# Spawn am Fluchtpunkt (X = 0), aber Ziel-X merken
	obstacle.global_position = Vector2(0.0, spawn_y)
	obstacle.target_x = target_x
	obstacle.spawn_y = spawn_y
	obstacle.call_deferred("update_scale")
