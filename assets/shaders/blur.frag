extern number radius;  // Radio del blur
extern number directionX;
extern number directionY;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 sum = vec4(0.0);
    vec2 dir = vec2(directionX, directionY);

    for (float i = -radius; i <= radius; i++) {
        sum += Texel(texture, texture_coords + dir * i * 0.002) * (1.0 / (2.0 * radius + 1.0));
    }

    return sum * color;
}