precision highp float;

struct Fog {
    int fogType; // 0: 线性, 1: exp, 2: 2次exp
    float fogStart;
    float fogEnd;
    float fogIndensity;
    vec3 fogColor;
};

varying highp vec3 fragPosition;
varying lowp vec4 fragColor;
varying highp vec3 fragNormal;
varying highp vec2 fragUV;
uniform vec3 eyePosition;

uniform highp float elapsedTime;
uniform vec3 lightDirection;
uniform mat4 normalMatrix;
uniform mat4 modelMatrix;
uniform sampler2D grassMap;
uniform sampler2D dirtMap;

uniform Fog fog;

float linearFogFactor(float fogStart, float fogEnd) {

    vec4 worldVertexPosition = modelMatrix * vec4(fragPosition, 1.0);
    float distanceToEye = distance(eyePosition, worldVertexPosition.xyz);
    // linear
    float fogFactor = (fogEnd - distanceToEye) / (fogEnd - fogStart); // 1.0 ~ 0.0
    fogFactor = 1.0 - clamp(fogFactor, 0.0 , 1.0);
    return fogFactor;
}

float exponentialFogFactor(float fogDensity) {
    vec4 worldVertexPosition = modelMatrix * vec4(fragPosition, 1.0);
    float distanceToEye = distance(eyePosition, worldVertexPosition.xyz);

    float fogFactor = 1.0 / exp(distanceToEye * fogDensity);
    fogFactor = 1.0 - clamp(fogFactor, 0.0, 1.0);
    return fogFactor;
}

float exponentialSquareFogFactor(float fogDensity) {
    vec4 worldVertexPosition = modelMatrix * vec4(fragPosition, 1.0);
    float distanceToEye = distance(eyePosition, worldVertexPosition.xyz);

    float fogFactor = 1.0 / exp(pow(distanceToEye * fogDensity, 2.0));
    fogFactor = 1.0 - clamp(fogFactor, 0.0, 1.0);
    return fogFactor;
}

vec3 colorWithFog(vec3 inputColor) {
    float fogFactor = 0.0;
    if(fog.fogType == 0) {
        fogFactor = linearFogFactor(fog.fogStart, fog.fogEnd);
    }else if (fog.fogType == 1) {
        fogFactor = exponentialFogFactor(fog.fogIndensity);
    }else if (fog.fogType == 2) {
        fogFactor = exponentialSquareFogFactor(fog.fogIndensity);
    }
    return mix(inputColor, fog.fogColor, fogFactor);
}

void main(void) {
    vec3 normalizedLightDirection = normalize(-lightDirection);
    vec3 transformedNormal = normalize((normalMatrix * vec4(fragNormal, 1.0)).xyz);
    
    float diffuseStrength = dot(normalizedLightDirection, transformedNormal);
    diffuseStrength = clamp(diffuseStrength, 0.0, 1.0);
    vec3 diffuse = vec3(diffuseStrength);
    
    vec3 ambient = vec3(0.3);
    
    vec4 finalLightStrength = vec4(ambient + diffuse, 1.0);
    
    vec4 grassColor = texture2D(grassMap, fragUV);
    vec4 dirtColor = texture2D(dirtMap, fragUV);
    
    vec4 materialColor = vec4(0.0);
    if (fragPosition.y <= 30.0) {
        materialColor = dirtColor;
    }else if (fragPosition.y > 30.0 && fragPosition.y < 60.0) {
        float dirtFactor = (60.0 - fragPosition.y) / 30.0;
        materialColor = dirtColor * dirtFactor + grassColor * (1.0 - dirtFactor);
    }else {
        materialColor = grassColor;
    }
    
    vec3 finalColor = materialColor.rgb * finalLightStrength.rgb;
    finalColor = colorWithFog(finalColor);
    gl_FragColor = vec4(finalColor, 1.0);
    
//    gl_FragColor = vec4(materialColor.rgb * finalLightStrength.rgb, 1.0);
}

void test(void) {
    highp float processedElapsedTime = elapsedTime;
    highp float intensity = (sin(processedElapsedTime) + 1.0) / 2.0;
    gl_FragColor = fragColor * intensity;
}
