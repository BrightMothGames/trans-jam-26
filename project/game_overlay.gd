extends SubViewportContainer

@onready var shader = material

var shadow_offsest: Vector2 = Vector2.ZERO


func _on_lcd_gap_value_changed(value: float) -> void:
	shader.set_shader_parameter("scanline_width", value)

func _on_lcd_str_value_changed(value: float) -> void:
	shader.set_shader_parameter("scanline_strength", value)
	
func _on_shad_x_value_changed(value: float) -> void:
	shadow_offsest.x = value
	shader.set_shader_parameter("shadow_displacement", shadow_offsest)

func _on_shad_y_value_changed(value: float) -> void:
	shadow_offsest.y = value
	shader.set_shader_parameter("shadow_displacement", shadow_offsest)

func _on_shad_str_value_changed(value: float) -> void:
	shader.set_shader_parameter("shadow_strength", value)

func _on_bright_value_changed(value: float) -> void:
	shader.set_shader_parameter("brightness", value)


func _on_zoom_value_changed(value: float) -> void:
	shader.set_shader_parameter("zoom", value)
	$sub_viewport/node_2d.scale = Vector2(value,value)
