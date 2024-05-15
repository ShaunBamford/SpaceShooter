extends Control


func _on_button_pressed():
	get_tree().reload_current_scene()
	
func set_score(value):
	$Panel/Score.text = "Score: " + str(value)
	
func set_high_score(value):
	$"Panel/High Score".text = "Hi-score: " + str(value)
