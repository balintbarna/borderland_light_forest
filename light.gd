extends Node3D
#
@export var base_color = Color(1, 1, 1, 1)
@export var base_energy = 1.0
@export var modulation_speed = 1.0
@export var modulation_offset = 0.0
#
@onready var mesh_material = $MeshInstance3D.mesh.material
@onready var light = $OmniLight3D


func _process(_delta):
	var hue = get_positional_hue()
	var energy = calculate_energy()
	apply_settings_to_children(Color.from_hsv(hue, 1, energy, 1), energy)


func get_positional_hue():
	var v = global_position
	var h = base_color.h
	return sin(h + cos(v.x + v.y + v.z)) / 2.0 + 0.5


func calculate_energy():
	var modulator = sin(Time.get_ticks_msec() * modulation_speed / 1000.0 + modulation_offset) / 2.0 + 0.5
	return base_energy * modulator


func apply_settings_to_children(color: Color, energy: float):
	mesh_material.albedo_color = color
	mesh_material.emission = color
	light.light_color = color
	light.omni_range = 5 * energy
	light.light_energy = energy
