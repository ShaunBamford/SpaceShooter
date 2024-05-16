class_name powerup extends Area2D

signal killed
signal hit

@export var speed = 150
@export var hp = 1
@export var points = 100

func _physics_process(delta):
	global_position.y += speed * delta

func die():
	queue_free()

func _on_body_entered(body):
	if body is Player:
		body.power_up()
		die()

func take_damage(amount):
	hp -= amount
	if hp <= 0:
		killed.emit(points)
		die()

func _on_visible_on_screen_notifier_2d_screen_exited():
	die()
