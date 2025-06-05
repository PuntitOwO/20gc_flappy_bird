extends Area2D

func _ready() -> void:
	body_exited.connect(_on_bird_exited)

func _on_bird_exited(body: Node2D) -> void:
	var bird := body as Bird
	bird.score += 1
