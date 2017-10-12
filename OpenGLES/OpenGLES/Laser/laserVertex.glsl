attribute vec4 position;
attribute vec4 color;
attribute vec3 normal; //法线向量
attribute vec2 uv;

uniform float elapsedTime;
uniform mat4 transform;

uniform mat4 projectionMatrix;
uniform mat4 cameraMatrix;
uniform mat4 modelMatrix;

varying vec4 fragColor;
varying vec3 fragNormal;
varying vec2 fragUV;

void main(void) {
    fragNormal = normal;
    fragUV = uv;
    mat4 mvp = projectionMatrix * cameraMatrix * modelMatrix;
    gl_Position = mvp * position;
    gl_PointSize = 25.0;
}
