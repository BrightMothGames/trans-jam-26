shader_type canvas_item;

uniform sampler2D screen : hint_screen_texture;

uniform vec3 background_color : source_color = vec3(.5);
uniform float scanline_strength : hint_range(0, 1) = 1.;
uniform float scanline_width : hint_range(0., 1.) = .15;

uniform vec2 shadow_displacement = vec2(.05);
uniform float shadow_strength : hint_range(0, 1) = .25;
uniform float brightness : hint_range(0, 1) = .66;

uniform float zoom : hint_range(1.0, 5.0, .1) = 1.;

float scanline(vec2 uv) {
	float x = clamp(abs(mod(uv.x, 1.) - .5) * 100. - ((1. - scanline_width) * 50. + 1.), 0., 1.);
	float y = clamp(abs(mod(uv.y, 1.) - .5) * 100. - ((1. - scanline_width) * 50. + 1.), 0., 1.);
	return  clamp(x + y, 0., 1.);
}

void fragment() {
	vec4 color = texture(screen, SCREEN_UV);
	vec2 scaled_uv = vec2(UV.x * 256. / zoom, UV.y * 144. / zoom);
	float scanlines = scanline(scaled_uv);
	color.rgb = mix(color.rgb, background_color, scanlines * scanline_strength);
	
	vec2 uv_offset = (vec2(1. / 256., 1. / 144.) * shadow_displacement * vec2(zoom));
	vec4 shadow = texture(screen, SCREEN_UV - uv_offset);
	float shadow_scanlines = scanline(scaled_uv - shadow_displacement);
	shadow.rgb = mix(shadow.rgb, vec3(.0), shadow_scanlines * scanline_strength);
	shadow.rgb *= vec3(shadow_strength);
	shadow.rgb *= clamp(scanlines + (1. - brightness), 0., 1.); 
	
	COLOR.rgb = clamp(color.rgb - shadow.rgb, 0., 1.);
}