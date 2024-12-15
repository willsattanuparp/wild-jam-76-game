shader_type canvas_item;

#define PI 3.14159265359
#define PI2 (2.0 * PI)
uniform float time = 0.0;
uniform float circle_width: hint_range(0.0, 1.0, 0.05) = 0.15;
uniform float speed: hint_range(0.0, 10.0, 0.1) = 1.0;
uniform float alpha_boost: hint_range(1.0, 5.0, 0.1) = 2.0;
uniform float rot_speed : hint_range(0.0, 10.0) = 3.0; // Rotation speed
uniform float zoom_speed : hint_range(0.0, 10.0) = 1.0; // Zoom speed
uniform int num_colours : hint_range(1, 10) = 5; // Number of colors

// Generates a color palette based on input t
vec3 palette(float t) {
    return vec3(0.2, 0.1, 0.8) + 0.2 * cos(PI2 * (t + 0.25));
}

// Rotates a vector by a given angle
vec2 rotate(vec2 v, float a) {
    float s = sin(a);
    float c = cos(a);
    mat2 m = mat2(vec2(c, s), vec2(-s, c)); // Correct matrix construction for Godot
    return m * v;
}

// Taxicab distance with rotation
float taxi_rot(vec2 p, vec2 q, float r) {
    vec2 diff = abs(rotate(p - q, r));
    return diff.x + diff.y;
}

// Octagonal rotation distance
float oct_rot(vec2 p, vec2 q, float r) {
    return min(
        taxi_rot(p, q, r),
        taxi_rot(p, q, r + PI / 4.0)
    );
}

// Determines if a point is within a square with smooth edges
float in_square(vec2 p, vec2 q, float angle, float size) {
    float dist = oct_rot(p, q, angle);
    return smoothstep(0.0, 0.005, dist - size); // Adjust smoothstep threshold for normalized UV space
}

// Mixes current and new color based on square proximity
vec3 sq(vec3 current, vec3 new_col, vec2 p, vec2 q, float size) {
    float square_factor = in_square(p, q, mod(rot_speed * size, PI2), size);
    return mix(new_col, current, square_factor);
}

void fragment() {
    vec2 uv = UV; // Use normalized texture coordinates
    vec2 c = vec2(0.5, 0.5); // Center point in normalized UV space
    
    vec3 col = vec3(0.0); // Base color
    for (int i = 40; i > 0; i--) {
        float scale = pow(sqrt(1.75), float(i) + mod(TIME * zoom_speed, float(num_colours))) * 0.001 * 0.1;
        col = sq(col, palette(float(i) / float(num_colours)), uv, c, scale);
    }
    COLOR = vec4(col, 1.0); // Final output color
	//ring generation
	float dist = distance(UV, vec2(0.5));
	float mod_dist = dist - (time * speed) + 0.5;
	COLOR.a *= 1.0 - step(0.5, mod_dist);
	COLOR.a += step(0.5 - circle_width / 2.0, mod_dist) - 1.0;
	COLOR.a -= 2.0 * dist;
	COLOR.a *= alpha_boost;
}
