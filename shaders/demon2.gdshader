shader_type spatial;
render_mode unshaded, blend_mix, depth_draw_always;

uniform vec4 aura_color = vec4(1.0, 0.0, 0.0, 0.5);
uniform float outline_width : hint_range(0.0, 0.3) = 0.02;
uniform float time_scale : hint_range(0.0, 10.0) = 1.0;
uniform float noise_scale : hint_range(0.0, 1.0) = 0.5;
uniform float alpha_cutoff : hint_range(0.0, 1.0) = 0.1;

float noise(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void vertex() {
    VERTEX += NORMAL * outline_width;

    vec3 noise_offset = vec3(noise(UV + TIME * time_scale), noise(UV.yx + TIME * time_scale), noise(UV.xy - TIME * time_scale)) - 0.5;
    VERTEX += noise_offset * outline_width * noise_scale;
}

void fragment() {
    float noise_value = noise(UV * noise_scale + TIME * time_scale);
    float alpha = smoothstep(alpha_cutoff, 1.0, noise_value);

    ALBEDO = aura_color.rgb;
	
    ALPHA = aura_color.a * alpha;
}