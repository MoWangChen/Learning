attribute vec4 position;
attribute vec4 color;
attribute vec3 normal; //法线向量
attribute vec2 uv;

uniform float elapsedTime;
uniform mat4 transform;

uniform mat4 projectionMatrix;
uniform mat4 cameraMatrix;
uniform mat4 modelMatrix;

varying vec3 fragPosition;
varying vec4 fragColor;
varying vec3 fragNormal;
varying vec2 fragUV;

void main(void) {
    fragNormal = normal;
    fragUV = uv;
    fragPosition = position.xyz;
    mat4 mvp = projectionMatrix * cameraMatrix * modelMatrix;
    gl_Position = mvp * position;
    gl_PointSize = 25.0;
}

void test(void) {
    fragColor = color;
    float angle = elapsedTime * 1.0;
    float xPos = position.x * cos(angle) - position.y * sin(angle);
    float yPos = position.x * sin(angle) + position.y * cos(angle);
    gl_Position = vec4(xPos, yPos, position.z, 1.0);
}

void testMatrixTransform(void) {
    fragColor = color;
    gl_Position = transform * position;
    gl_PointSize = 25.0;
}
