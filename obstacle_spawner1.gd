extends Node2D

@export var tree_scene: PackedScene



var wall_timer = 0.0
const WALL_INTERVAL = 0.4
const LEFT_WALL_X = -760.0
const RIGHT_WALL_X = 760.0

var obstacle_timer = 0.0
const OBSTACLE_INTERVAL = 1.5

func _process(delta):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	var spawn_y = player.global_position.y - 700
	
	# WandBäume
	wall_timer += delta
	if wall_timer >= WALL_INTERVAL:
		wall_timer = 0.0
		spawn_tree(Vector2(LEFT_WALL_X, spawn_y), 1.0, true, -1)
		spawn_tree(Vector2(RIGHT_WALL_X, spawn_y), 1.0, true, 1)
	
	# HindernisBäume
	obstacle_timer += delta
	if obstacle_timer >= OBSTACLE_INTERVAL:
		obstacle_timer = 0.0
		var random_x = randf_range(-560.0, 560.0)
		spawn_tree(Vector2(random_x, spawn_y), 0.8, false)

func spawn_tree(pos: Vector2, scale_factor: float, wall: bool = false, side: int = 1):
	var tree = tree_scene.instantiate()
	get_parent().add_child(tree)
	tree.global_position = pos
	tree.scale = Vector2(scale_factor, scale_factor)
	tree.is_wall_tree = wall
	tree.side = side
