extends Node2D

@onready var label: Label = $Label
@onready var bird: Bird = $Bird

func _ready() -> void:
	bird.score_updated.connect(_update_score)

func _update_score(score: int) -> void:
	label.text = str(score)
