extends Node

var references = {}
var player: Player
var submarine: Submarine
var main_camera: Camera2D
var scene_root_node: Node2D
var enemy_spawn_timer: Timer
var current_depth_resource: DepthResource

var spawn_offset = 10

############ Initialize ############
func _ready() -> void:
	current_depth_resource = load("res://resources/0_depth.tres")
	call_deferred("level_setup")

func level_setup() -> void:
	enemy_spawn_timer = Timer.new()
	scene_root_node = get_tree().current_scene
	scene_root_node.add_child(enemy_spawn_timer)
	enemy_spawn_timer.timeout.connect(spawn_enemy)
	enemy_spawn_timer.start(current_depth_resource.enemy_spawn_cooldown)


############ Enemy Logic ############

func spawn_enemy():
	var camera_size = main_camera.get_viewport_rect().size * main_camera.zoom
	var camera_rect = [main_camera.get_screen_center_position().x - camera_size.x / 2,
					main_camera.get_screen_center_position().y - camera_size.y / 2,
					main_camera.get_screen_center_position().x + camera_size.x / 2,
					main_camera.get_screen_center_position().y + camera_size.y / 2]

	var spawn_position: Vector2 = Vector2.ZERO
	match randi_range(0,3):
		0: # left side of the screen
			spawn_position = Vector2(camera_rect[0] - spawn_offset, randi_range(camera_rect[1], camera_rect[3]))
		1: # top side of the screen
			spawn_position = Vector2(randf_range(camera_rect[0], camera_rect[2]), camera_rect[1] - spawn_offset)
		2: # right side of the screen
			spawn_position = Vector2(camera_rect[2] + spawn_offset, randi_range(camera_rect[1], camera_rect[3]))
		3: # bottom side of the screen
			spawn_position = Vector2(randf_range(camera_rect[0], camera_rect[2]), camera_rect[3] + spawn_offset)
	
	for i in current_depth_resource.enemy_spawn_amount:
		var enemy_index = current_depth_resource.enemy_toughness
		var enemy_to_spawn: PackedScene = current_depth_resource.enemy_scenes[enemy_index]
		if not enemy_to_spawn:
			print("Enemy to spawn not found!")
			continue
		var spawned_enemy: CharacterBody2D = enemy_to_spawn.instantiate()
		scene_root_node.add_child(spawned_enemy)
		spawned_enemy.position = spawn_position


############ Global references ############
func add(key: String, value):
	references[key] = value

func remove(key: String):
	if references.has(key):
		references.erase(key)
		return true
	return false

func clear_references():
	references.clear()

func fetch(key):
	if references.has(key):
		return references[key]
	return null
