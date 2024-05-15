class_name Player extends CharacterBody2D

signal lazer_shot(lazer_scene, location)
signal killed

@export var speed = 300
@export var rate_of_fire = 0.25
@onready var muzzle = $muzzle

var lazer_scene = preload("res://scenes/lazer.tscn")
var shoot_cd := false


func _process(delta):
	if Input.is_action_pressed("shoot"):
		if !shoot_cd:
			shoot_cd = true
			shoot()
			await get_tree().create_timer(rate_of_fire).timeout
			shoot_cd = false

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("move_left","move_right"), Input.get_axis("move_up","move_down"))
	velocity = direction * speed
	move_and_slide()
	
	global_position = global_position.clamp(Vector2.ZERO, get_viewport_rect().size)

func shoot():
	lazer_shot.emit(lazer_scene, muzzle.global_position)
	
func die():
	killed.emit()
	queue_free()


func _on_button_pressed():
	shoot()
