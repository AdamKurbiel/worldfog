shader_type canvas_item;

uniform vec4 shadow_color : source_color = vec4(0.0, 0.0, 0.0, 0.7);
uniform float shadow_distance = 8.0;
uniform float speed = 2.0;
uniform float softness = 2.0;

void fragment() {
    vec4 text = texture(TEXTURE, UV);

    float t = TIME * speed;

    vec2 dir = vec2(
        cos(t),
        sin(t)
    );

    vec2 pixel = TEXTURE_PIXEL_SIZE;

    float shadow = 0.0;


    for (float i = 1.0; i <= 12.0; i += 1.0) {
        float amount = i / 12.0;

        vec2 offset = dir * shadow_distance * amount * pixel * 10.0;

        shadow += texture(TEXTURE, UV - offset).a;
    }

    shadow /= 12.0;

    shadow *= 1.0 - text.a;

    vec4 result = shadow_color;
    result.a *= shadow;

    COLOR = result + text;
}