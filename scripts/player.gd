class_name Player extends CharacterBody2D

signal lazer_shot(lazer_scene, location)
signal killed

@export var speed = 300
@export var rate_of_fire = 0.25
@onready var muzzle = $muzzle
@export var power_time = 30


var lazer_scene = preload("res://scenes/lazer.tscn")
var shoot_cd := false

var bln_button_is_down = false
var bln_button_has_been_pressed = false

func _process(delta):
	if Input.is_action_pressed("shoot"):
		if !shoot_cd:
			shoot_cd = true
			shoot()
			await get_tree().create_timer(rate_of_fire).timeout
			shoot_cd = false
			
	if bln_button_has_been_pressed:
		if bln_button_is_down:
				print ("Button is pressed")
				if !shoot_cd:
					shoot_cd = true
					shoot()
					await get_tree().create_timer(rate_of_fire).timeout
					shoot_cd = false
		else:
				print ("Button no longer pressed")


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

	
	
func power_up():
	var powerups = ["speed","shoot"]
	var selected_powerup = powerups.pick_random()
	if selected_powerup == "speed":
		speed = 700
		await get_tree().create_timer(power_time).timeout
		speed = 300
	elif selected_powerup == "shoot":
		rate_of_fire = 0
		await get_tree().create_timer(power_time).timeout
		rate_of_fire = 0.25







func _on_button_pressed():
	bln_button_is_down = true
	bln_button_has_been_pressed = true


func _on_button_released():
	bln_button_is_down = false
