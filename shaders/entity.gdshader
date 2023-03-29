shader_type canvas_item;

uniform bool is_hurt = false;

float luminance(vec3 color) {
	return dot(color, vec3(0.299, 0.587, 0.114));
}

void fragment() {
	vec3 color = texture(TEXTURE, UV).rgb;
	vec3 output;
	
	float lum = luminance(color);

	if (is_hurt) {
		if (lum <= 0.1) { // darkest colors
			output = vec3(1.0, 0.75, 0.0);
		}
		else if (lum >= 0.6) { // brightest colors
			output = vec3(0.0);
		}
		else { // middle colors
			output = vec3(1.0, 0.0, 0.0);
		}
	}
	else {
		output = color;
	}
	
	COLOR.rgb = output;
}
