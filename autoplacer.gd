extends Node3D
#
@export var scene: PackedScene
@export var number_of_placements = 1
@export var max_distance = 1.0
@export var max_elevation_difference = 1.0
@export var seedstr = "autoplacer"
#
var generator = RandomNumberGenerator.new()


func _ready():
	generator.seed = seedstr.hash()
	if not scene:
		push_error("scene is not set: ", get_parent().name, " -> ", self.name)
		return
	if not len(get_children(true)):
		for i in range(number_of_placements):
			var inst = place_new()
			randomize_position(inst)


func place_new():
	var inst = scene.instantiate()
	add_child(inst)
	return inst


func randomize_position(inst: Node3D):
	inst.position = Vector3(
		generator.randf_range(-max_distance, max_distance),
		generator.randf_range(-max_elevation_difference, max_elevation_difference),
		generator.randf_range(-max_distance, max_distance),
	)
