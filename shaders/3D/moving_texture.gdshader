shader_type spatial;

uniform sampler2D texture_albedo;

uniform float speed = 1.0;

void fragment() {
    vec2 uv = UV;

    uv.y += TIME * speed;

    ALBEDO = texture(texture_albedo, uv).rgb;
}