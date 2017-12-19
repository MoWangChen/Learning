attribute vec4 position;
attribute vec4 color;
attribute vec3 normal; //法线向量
attribute vec2 uv;

attribute vec3 tangent;
attribute vec3 bitangent;

uniform float elapsedTime;
uniform mat4 transform;

uniform mat4 projectionMatrix;
uniform mat4 cameraMatrix;
uniform mat4 modelMatrix;

uniform vec2 billboardSize;
uniform vec3 billboardCenterPosition;
uniform bool lockToYAxis;

varying vec3 fragPosition;
varying vec4 fragColor;
varying vec3 fragNormal;
varying vec2 fragUV;
varying vec3 fragTangent;
varying vec3 fragBitangent;

// clipplane
//uniform bool clipplaneEnabled;
//uniform vec4 clipplane;
//varying highp float gl_ClipDistance[1];

void main(void) {
    fragNormal = normal;
    fragUV = uv;
    fragTangent = tangent;
    fragBitangent = bitangent;
    mat4 vp = projectionMatrix * cameraMatrix;
    
    vec3 cameraRightInWorldspace = vec3(cameraMatrix[0][0], cameraMatrix[1][0], cameraMatrix[2][0]);
    vec3 cameraUpInWorldspace = vec3(0.0, 1.0, 0.0);
    if (lockToYAxis == false) {
        cameraUpInWorldspace = vec3(cameraMatrix[0][1], cameraMatrix[1][1], cameraMatrix[2][1]);
    }
    vec3 vertexPositionInWorldspace = billboardCenterPosition + cameraRightInWorldspace * position.x * billboardSize.x + cameraUpInWorldspace * position.y * billboardSize.y;
    fragPosition = vertexPositionInWorldspace;

    gl_Position = vp * vec4(vertexPositionInWorldspace, 1.0);
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

