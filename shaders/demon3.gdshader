shader_type spatial;


render_mode cull_front;

uniform sampler2D vert_noise : source_color;
uniform vec2 noise_scroll_speed = vec2(1.0,1.0);

varying float distanceToCam; // distance from cam to center
varying vec4 world_pos;  // of current vertex
varying float vertexToCam; // distance from current vertex to the camera

varying float depth;

const float wave_speed[3] = { 4.0, 1.0, 1.0 };
const float wavelength[3] = { 5.3, 0.8, 2.5 };
const float wave_amp[3] = { 0.1, 0.2, 0.05 };
uniform float aura_padding = 0.5;
uniform vec3 aura_color : source_color;

float sum_of_sines(float theta){
	float sum = 0.0;
	for(int i = 0; i < wave_speed.length(); i++) {
		sum += wave_amp[i] * sin((theta*wavelength[i]) + (TIME*wave_speed[i]));
	}
	return sum;
}

void vertex() {
	depth = distance(CAMERA_POSITION_WORLD, NODE_POSITION_WORLD);
	
	float facing_away = 1.0 - abs(dot(NORMAL, vec3(0.0, 0.0, 1.0)));
	//float facing_away = abs(dot(viewspace_binormal, vec3(0.0, 0.0, 1.0)));
	float theta = atan(VERTEX.y, VERTEX.z); // [-PI, PI]
	float dist_from_center = length(VERTEX);
	float grow_amount = sum_of_sines(theta);
	
	
	VERTEX += (aura_padding + grow_amount) * NORMAL;
}

float circle(vec2 uv){
	return length(uv - vec2(0.5));
}

float weighted_avg(float[2] vals, float[2] weights) {
	float sum = 0.0;
	float totalWeight = 0.0;
	for(int i = 0; i < vals.length(); i++){
		sum += vals[i] * weights[i];
		totalWeight += weights[i];
	}
	return sum / totalWeight;
}

void fragment() {
//	  	  float f1 = dot(VIEW, vec3(0,0,1));
//+       float f2 = length(sin(UV * vec2(25)));
//+       float f = weighted_avg({f1, f2}, {1.0, 0.1});
//+       //rad = (0.01) * (1.0 / FRAGCOORD.z);  //
//+       //f = smoothstep(0.95 * (1.0 - rad), 1, f); // [
//+       ALBEDO = vec3(100.0 * fract(f));

//float rad = 1.0 / pow(depth,0.5);
	float density = 10.0;
	//float density = 50.0 / sqrt(max(depth, 1.0));
	float f1 = dot(VIEW, vec3(0,0,1));
	float rad = 0.05;
	f1 = smoothstep(1.0-rad, 1.0, f1); // 
	//f1 = 0.0;
	float f2 = length(sin(UV * vec2(density)));
	float f = weighted_avg({f1, f2}, {0.0, 1.0});
	vec3 foo = normalize(vec3(cos(TIME), 0, sin(TIME)));
	float d = dot(BINORMAL, foo); 
	float threshold = d;
	f = smoothstep((1.0 - threshold), 1, f);
	float dark_spots = smoothstep(f-0.1, f+0.1, 0.3);
	vec3 dc = vec3(0.3, 0.9, 0.8);
	vec3 dark_colors = vec3(dark_spots * dc);
	ALBEDO = vec3(f * aura_color) + dark_colors;
	ALPHA = max(ALBEDO.b, 0.3);
	
	// what i want:
	// further away, the radius gets smaller
		// radius defined by first bound in smoothstep func- closer to 1=smaller
	// move back- depth increases, and fragcoord.z approaches 0
		// fragcoord.z ~= 1/depth
	//float depth = 1.0 / FRAGCOORD.z;
	//depth /= 80.0;
	//depth = log(depth) / 5.0;
	
	//rad = smoothstep(0, 1.0/50.0, FRAGCOORD.z);
	//rad = 1.0 - rad;/
	//rad = rad * rad;
	//rad = 1.0 / (rad * rad);
	// so: 
	//f = smoothstep(depth, 1, f);
	//f = smoothstep(0, 1, rad); 
	//f = rad;
	//
	//vec2 v = sin(UV * vec2(25));
	//float f2 = length(v);
	//f2 = step(1.1, f2);
	//f2 /= 5.0;
//
	//f = weighted_avg({f, f2}, {1.0, 0.001});
	//vec3 c = vec3(f);
	//float darkness = dot(vec2(1.0-f), vec2(1.0));
	//darkness = 2.13;
	//c = c + (darkness * vec3(0.01,0.01,0));
	
	//ALBEDO = (c);
	//ALBEDO = d;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
