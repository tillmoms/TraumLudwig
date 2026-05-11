extends Node2D

@export var tree_scene: PackedScene
@export var obstacles_scene: PackedScene


var wall_timer = 0.4
const WALL_INTERVAL = 0.3
const LEFT_WALL_X = -900.0
const RIGHT_WALL_X = 900.0

var obstacle_timer = 0.0
const OBSTACLE_INTERVAL = 0.7

func _process(delta):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	var spawn_y = player.global_position.y - 1000
	
	# WandBäume
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

 
		

		

		

	
# Hindernisse (Steine/Laternen) mittig auf der Strecke
	obstacle_timer += delta
	if obstacle_timer >= OBSTACLE_INTERVAL:
		obstacle_timer = 0.0
		var random_x = randf_range(-530.0, 530.0)
		spawn_obstacle(Vector2(random_x, spawn_y))

func spawn_tree(pos: Vector2, scale_factor: float, wall: bool = false, side: int = 1):
	var tree = tree_scene.instantiate()
	get_parent().add_child(tree)
	tree.global_position = pos
	tree.scale = Vector2(scale_factor, scale_factor)
	tree.is_wall_tree = wall
	tree.side = side
	tree.call_deferred("init_tree")
	
func spawn_obstacle(pos: Vector2):
	var obstacle = obstacles_scene.instantiate()
	get_parent().add_child(obstacle)
	obstacle.global_position = pos
	obstacle.call_deferred("update_scale")
