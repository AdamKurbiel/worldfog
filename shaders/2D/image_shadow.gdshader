shader_type canvas_item;

uniform float echo_distance : hint_range(0.0, 1.0) = 0.08;
uniform float echo_speed : hint_range(0.0, 10.0) = 2.0;
uniform float echo_strength : hint_range(0.0, 1.0) = 0.35;
uniform int echo_count : hint_range(1, 10) = 5;

void fragment() {
    vec4 original = texture(TEXTURE, UV);

    vec4 shadow = vec4(0.0);

    for (int i = 1; i <= 10; i++) {
        if (i > echo_count)
            break;

        float t = float(i) / float(echo_count);
        float movement = sin(TIME * echo_speed) * 0.5 + 0.5;

        vec2 offset = vec2(
            -echo_distance * t * movement,
            0.0
        );

        vec4 sample = texture(TEXTURE, UV + offset);
        sample.a *= echo_strength * (1.0 - t);

        shadow += sample;
    }
    COLOR = shadow + original;
}