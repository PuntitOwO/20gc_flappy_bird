extends Node2D

@onready var label: Label = $Label
@onready var bird: Bird = $Bird
@onready var waiting_first_input := true
@onready var pipe_generator: PipeGenerator = $PipeGenerator
@onready var background: CanvasLayer = $ParallaxBackground
@onready var level := DIFFICULTY.EASY:
	set(new_level):
		level = new_level
		_update_difficulty(new_level)

enum DIFFICULTY { EASY, NORMAL, HARD, HELL }

@export_category("difficulty")
@export var spawn_times : Dictionary[DIFFICULTY, float]
@export var background_colors : Dictionary[DIFFICULTY, Color]

func _ready() -> void:
	get_tree().paused = true
	bird.score_updated.connect(_update_score)
	bird.final_score.connect(_show_final_score)

func _update_score(score: int) -> void:
	if score == 0: return
	label.text = str(score)
	if score == 5:
		print("Level: normal")
		level = DIFFICULTY.NORMAL
	elif score == 25:
		print("Level: hard")
		level = DIFFICULTY.HARD
	elif score == 50:
		print("Level: hell")
		level = DIFFICULTY.HELL

func _update_difficulty(new_level: DIFFICULTY) -> void:
	pipe_generator.set_timer_time(spawn_times[new_level])
	var tween = create_tween().set_parallel()
	for child in background.get_children()+[$PipeGenerator,$Floor/Parallax2D]:
		tween.tween_property(child, "modulate", background_colors[new_level], 5.0)

func _show_final_score(score: int, best: int) -> void:
	%CurrentScore.text = str(score)
	%BestScore.text = str(best)
	%RetryLabel.visible_ratio = 0.0
	var tween = create_tween()
	tween.tween_callback($EndScores.show)
	tween.tween_property(%Scrim, "color:a", 0.3, 0.5).from(0.0)
	tween.parallel().tween_property(%Container, "position:y", 0.0, 0.5).from(-150.0)
	tween.tween_property(%RetryLabel, "visible_ratio", 1.0, 0.4).set_delay(0.5)

func _input(event: InputEvent) -> void:
	if (event.is_pressed() and event.is_action("reset")):
		get_tree().paused = false
		get_tree().reload_current_scene()
	if (event.is_pressed() and event.is_action("fly") and waiting_first_input):
		waiting_first_input = false
		get_tree().paused = false
		$StartGameLabel.hide()
