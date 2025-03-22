shader_type canvas_item;

// --- Uniforms --- //
uniform bool weighted = false; // Determines whether to use normal or weighted averages

uniform float outerRadius : hint_range(0.0, 1.0) = 1.0;
uniform float MainAlpha : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	float x = abs(UV.x - 0.5) * 2.0;
	float y = abs(UV.y - 0.5) * 2.0;
	float v = (sqrt((x * x) + (y * y)) / outerRadius);

	COLOR.rgb = mix(vec3((COLOR.r + COLOR.g + COLOR.b) / 3.0),  vec3(0.299 * COLOR.r + 0.587 * COLOR.g + 0.114 * COLOR.b), float(weighted)) * (1.0 - (v * MainAlpha));
}