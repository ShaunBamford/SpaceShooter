extends Node2D

@export var enemy_scenes : Array[PackedScene]  = []

@onready var playerSpawnPosition = $playerSpawnPos
@onready var lazerContainer = $LazerContainer
@onready var timer = $EnemySpawnTimer
@onready var enemy_container = $EnemyContainer
@onready var hud = $UILayer/HUD
@onready var gos = $UILayer/GameOverSceen

var player = null
var score := 0:
	set(value):
		score = value
		hud.score = score
		
var high_score := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	score = 0
	player = get_tree().get_first_node_in_group("player")
	player.global_position = playerSpawnPosition.global_position
	player.lazer_shot.connect(_on_player_lazer_shot)
	player.killed.connect(on_player_killed)
	
func save_game():
	var save_file = FileAccess.open(("user://save.data"), FileAccess.WRITE)
	save_file.store_32(high_score)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _on_player_lazer_shot(lazer_scene, location):
	var lazer = lazer_scene.instantiate()
	lazer.global_position = location
	lazerContainer.add_child(lazer)


func _on_enemy_spawn_timer_timeout():
	var e = enemy_scenes.pick_random().instantiate()
	e.global_position = Vector2(randf_range(50, 500), -50)
	e.killed.connect(_on_enemy_killed)
	enemy_container.add_child(e)

func _on_enemy_killed(points):
	score += points
	if score >= high_score:
		high_score = score


func on_player_killed():
	gos.set_score(score)
	gos.set_high_score(high_score)
	await get_tree().create_timer(1.5).timeout
	gos.visible = true
