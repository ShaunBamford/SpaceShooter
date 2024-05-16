extends Node2D

@export var enemy_scenes : Array[PackedScene]  = []
@export var powerups : Array[PackedScene]  = []

@onready var playerSpawnPosition = $playerSpawnPos
@onready var lazerContainer = $LazerContainer
@onready var timer = $EnemySpawnTimer
@onready var enemy_container = $EnemyContainer
@onready var hud = $UILayer/HUD
@onready var gos = $UILayer/GameOverSceen
@onready var pb = $ParallaxBackground
@onready var puc = $PowerUpContainer

@onready var lazer_sound = $SFX/lazer
@onready var hit_sound = $SFX/hit
@onready var explode_Sound = $SFX/explode

var player = null
var score := 0:
	set(value):
		score = value
		hud.score = score
		
var high_score := 0
var scroll_speed = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)
	if save_file!=null:
		high_score = save_file.get_32()
	else:
		high_score = 0
		save_game()
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
	if timer.wait_time > 0.3 and score < 100000:
		timer.wait_time -= delta*0.09
	elif score >= 100000:
		timer.wait_time = 0.1

	else:
		timer.wait_time = 0.3

		
	pb.scroll_offset.y += delta * scroll_speed
	if pb.scroll_offset.y >= 960:
		pb.scroll_offset.y = 0


func _on_player_lazer_shot(lazer_scene, location):
	var lazer = lazer_scene.instantiate()
	lazer.global_position = location
	lazerContainer.add_child(lazer)
	lazer_sound.play()


func _on_enemy_spawn_timer_timeout():
	var e = enemy_scenes.pick_random().instantiate()
	e.global_position = Vector2(randf_range(50, 500), -50)
	e.killed.connect(_on_enemy_killed)
	e.hit.connect(_on_enemy_hit)
	enemy_container.add_child(e)

func _on_enemy_hit():
	hit_sound.play()

func _on_enemy_killed(points):
	hit_sound.play()
	score += points
	if score >= high_score:
		high_score = score

func on_player_killed():
	explode_Sound.play()
	gos.set_score(score)
	gos.set_high_score(high_score)
	save_game()
	await get_tree().create_timer(0.1).timeout
	gos.visible = true
	



func _on_power_up_timer_timeout():
	var p = powerups.pick_random().instantiate()
	p.global_position = Vector2(randf_range(50, 500), -50)
	p.killed.connect(_on_enemy_killed)
	p.hit.connect(_on_enemy_hit)
	enemy_container.add_child(p)
