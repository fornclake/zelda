shader_type canvas_item;

uniform bool is_hurt = false;

void fragment() {
	vec3 color = texture(TEXTURE, UV).rgb;
	vec3 output;
	
	if (is_hurt) {
		if (color.rgb == vec3(0.0)) {
			output = vec3(1.0, 0.75, 0.0);
		}
		else if (color.r + color.g + color.b > 2.0) {
			output = vec3(0.0);
		}
		else {
			output = vec3(1.0, 0.0, 0.0);
		}
	}
	else {
		output = color;
	}
	
	COLOR.rgb = output;
}
