shader_type canvas_item;

uniform vec4 rect0;
uniform vec4 rect1;
uniform vec4 rect2;
uniform vec4 rect3;

bool encloses(vec4 rect, vec2 pixel) {
	if (pixel.x > rect.r && pixel.x < rect.r+rect.b) {
		if (pixel.y > rect.g && pixel.y < rect.g+rect.a) {
			return true;
		}
	}
	return false;
}

void fragment() {
	vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 current_pixel = SCREEN_UV * resolution;
	vec4 color = COLOR;
	
	if (encloses(rect0, current_pixel) ||
		encloses(rect1, current_pixel) ||
		encloses(rect2, current_pixel) ||
		encloses(rect3, current_pixel)) {
		color.a = 0.0;
	}
	
	COLOR = color;
}