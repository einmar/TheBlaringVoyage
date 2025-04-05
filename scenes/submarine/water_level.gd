extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    scale = Vector2(0,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func _on_submarine_water_level_changed(water_level: float) -> void:
	var pos = position_empty + position_full_delta * water_level
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(0,pos), 0.5)
	


func _on_water_area_body_entered(body: Node2D) -> void:
	if body is Player:
		body.in_water = true


func _on_water_area_body_exited(body: Node2D) -> void:
	if body is Player:
		body.in_water = false
