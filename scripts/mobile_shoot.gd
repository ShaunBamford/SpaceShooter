class_name MobileShoot extends Control

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

func shoot():
	lazer_shot.emit(lazer_scene, muzzle.global_position)
	

