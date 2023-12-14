shader_type canvas_item;

uniform sampler2D emition_texture;
uniform vec4 glow_color = vec4(1.0);

void fragment() {
	vec4 current_color = texture(TEXTURE, UV);
	vec4 emission_color = texture(emition_texture, UV);
	
	if(emission_color.r > 0.0) {
		COLOR = emission_color + glow_color;
	} else {
		COLOR = current_color;
	}
}
