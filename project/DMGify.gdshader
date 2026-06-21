shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;


void fragment() {
	vec3 gamma_color = texture(screen_texture, SCREEN_UV).rgb;
	vec3 color = pow(gamma_color, vec3(2.0));
	float gray = dot(color, vec3(0.2126, 0.7152, 0.0722));
	float gamma_gray = sqrt(gray);
	gamma_gray *= 4.;
	gamma_gray = ceil(gamma_gray);
	gamma_gray /= 4.;
	COLOR.rgb = vec3(gamma_gray);
	COLOR.rgb = gamma_color.rgb;
}
