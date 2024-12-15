shader_type canvas_item;

#define PI 3.14159265359
#define PI2 (2.0 * PI)

uniform float x: hint_range(0.0, 1.0, 0.01) = 0.0;
uniform float circle_width: hint_range(0.0, 1.0, 0.05) = 0.35;
uniform float speed: hint_range(0.0, 10.0, 0.1) = 1.5;
uniform float alpha_boost: hint_range(0.0, 5.0, 0.1) = 0.7;
uniform float rot_speed : hint_range(0.0, 10.0) = 8.0;
uniform float zoom_speed : hint_range(0.0, 25.0) = 25.0; 

vec3 palette(float t) {
    return vec3(0.2, 0.1, 0.8) + 0.2 * cos(PI2 * (t + 0.25));
}

vec2 rotate(vec2 v, float a) {
    float s = sin(a);
    float c = cos(a);
    mat2 m = mat2(vec2(c, s), vec2(-s, c));
    return m * v;
}
float taxi_rot(vec2 p, vec2 q, float r) {
    vec2 diff = abs(rotate(p - q, r));
    return diff.x + diff.y;
}
float draw_oct(vec2 p, vec2 q, float angle, float size) {
    float dist = min(taxi_rot(p, q, angle),taxi_rot(p, q, angle + PI / 4.0));
    return smoothstep(0.0, 0.01, dist - size);
}

vec3 sq(vec3 current, vec3 new_col, vec2 p, vec2 q, float size) {
    float square_factor = draw_oct(p, q, mod(rot_speed * size, PI2), size);
    return mix(new_col, current, square_factor);
}

void fragment() {
    vec2 uv = UV;
    vec2 c = vec2(0.5, 0.5);
    vec3 col = vec3(0.0);
    for (int i = 25; i > 0; i--) {
        float scale = pow(1.4, float(i) + mod(x * zoom_speed, 12.0)) * 0.0001;
        col = sq(col, palette( 1.0 - (float(i) / 12.0)), uv, c, scale);
    }
    COLOR = vec4(col, 1.0);
	float dist = distance(UV, vec2(0.5));
	float mod_dist = dist - ((x/2.0) * speed) + 0.5;
	COLOR.a *= 1.0 - smoothstep(.45,.5, mod_dist);
	COLOR.a += smoothstep(0.5 - circle_width / 2.0,0.5, mod_dist) - 1.0;
	COLOR.a -= 2.0 * dist;
	COLOR.a *= alpha_boost;
}
