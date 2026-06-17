shader_type canvas_item;

uniform vec3 background_color : source_color = vec3(.5);
uniform float scanline_strength : hint_range(0, 1) = 1.;
uniform float scanline_width : hint_range(0., 1.) = .15;

uniform vec2 shadow_displacement = vec2(.05);
uniform float shadow_strength : hint_range(0, 1) = .25;
uniform float brightness : hint_range(0, 1) = .66;

uniform float zoom : hint_range(1.0, 5.0, .1) = 1.;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec2 scaled_uv = vec2(UV.x * 256. / zoom, UV.y * 144. / zoom);
	float hscanlines = clamp(abs(mod(scaled_uv.x, 1.) - .5) * 100. - ((1. - scanline_width) * 50. + 1.), 0., 1.);
	float vscanlines = clamp(abs(mod(scaled_uv.y, 1.) - .5) * 100. - ((1. - scanline_width) * 50. + 1.), 0., 1.);
	//float hscanlines = pow(abs(cos(scaled_uv.x)) + scanline_width / 10., (1. - scanline_width) * 100.);
	//float vscanlines = pow(abs(cos(scaled_uv.y)) + scanline_width / 10., (1. - scanline_width) * 100.);
	float scanlines = clamp(hscanlines + vscanlines, 0., 1.);
	color.rgb = mix(color.rgb, background_color, scanlines * scanline_strength);
	
	vec2 shadow_uv = (vec2(1. / 256., 1. / 144.) * shadow_displacement);
	vec4 shadow = texture(TEXTURE, UV - shadow_uv);
	float shadow_hscanlines = clamp(abs(mod(scaled_uv.x - shadow_displacement.x, 1.) - .5) * 100. - ((1. - scanline_width) * 50. + 1.), 0., 1.);
	float shadow_vscanlines = clamp(abs(mod(scaled_uv.y - shadow_displacement.y, 1.) - .5) * 100. - ((1. - scanline_width) * 50. + 1.), 0., 1.);
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