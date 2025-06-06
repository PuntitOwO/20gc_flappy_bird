class_name PipeGenerator
extends Node2D

const PIPE_RANGE_Y = [-27, 27]
const PIPE_START_X = 160
const PIPE_SPEED = 50
const END_X = -180

@export var pipe_scene: PackedScene
var timer: Timer

func set_timer_time(time: float) -> void:
	timer.wait_time = time

func _ready() -> void:
	timer = Timer.new()
	timer.autostart = true
	timer.wait_time = 2.0
	add_child(timer, false, Node.INTERNAL_MODE_FRONT)
	timer.timeout.connect(_generate_new_pipes)

func _generate_new_pipes() -> void:
	var instance := pipe_scene.instantiate() as Node2D
	add_child(instance)
	instance.position.x = PIPE_START_X
	var y_offset = randi_range(PIPE_RANGE_Y[0], PIPE_RANGE_Y[1])
	instance.position.y = y_offset

func _physics_process(delta: float) -> void:
	for child in get_children():
		var pipe := child as Node2D
		pipe.position.x -= PIPE_SPEED * delta
		if pipe.position.x < END_X:
			remove_child(child)
			child.queue_free()
