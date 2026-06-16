shader_type canvas_item;

uniform vec3 background_color : source_color = vec3(.5);
uniform float scanline_strength : hint_range(0, 1) = .25;
uniform float scanline_width : hint_range(0., .9) = .25;

uniform vec2 shadow_displacement = vec2(.15);
uniform float shadow_strength : hint_range(0, 1) = .25;
uniform float brightness : hint_range(0, 1) = .6;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec2 scaled_uv = vec2(UV.x * PI * 256., UV.y * PI * 144.);
	float hscanlines = pow(abs(cos(scaled_uv.x)) + scanline_width / 10., (1. - scanline_width) * 100.);
	float vscanlines = pow(abs(cos(scaled_uv.y)) + scanline_width / 10., (1. - scanline_width) * 100.);
	float scanlines = clamp(hscanlines + vscanlines, 0., 1.);
	color.rgb = mix(color.rgb, background_color, scanlines * scanline_strength);
	
	vec2 shadow_uv = (vec2(1. / 256., 1. / 144.) * shadow_displacement);
	vec4 shadow = texture(TEXTURE, UV - shadow_uv);
	float shadow_hscanlines = pow(abs(cos(scaled_uv.x - shadow_displacement.x * PI)) + scanline_width / 10., (1. - scanline_width) * 100.);
	float shadow_vscanlines = pow(abs(cos(scaled_uv.y - shadow_displacement.y * PI)) + scanline_width / 10., (1. - scanline_width) * 100.);
	float shadow_scanlines = clamp(shadow_hscanlines + shadow_vscanlines, 0., 1.);
	shadow.rgb = mix(shadow.rgb, vec3(.0), shadow_scanlines * scanline_strength);
	shadow.rgb *= vec3(shadow_strength);
	shadow.rgb *= scanlines + (1. - brightness); 
	//color.rgb -= shadow.rgb;
	
	COLOR.rgb = color.rgb - shadow.rgb;
	//COLOR.rgb = vec3(shadow_scanlines);
	//COLOR.rgb = shadow.rgb;
	//COLOR.rgb = color.rgb;
}