precision highp float;

// 平行光
struct Directionlight {
    vec3 direction;
    vec3 color;
    float indensity;
    float ambientIndensity;
};

struct Material {
    vec3 diffuseColor;
    vec3 ambientColor;
    vec3 specularColor;
    float smoothness; // 0 ~ 1000 越高显得越光滑
};

varying lowp vec4 fragColor;
varying highp vec3 fragNormal;
varying highp vec2 fragUV;
varying vec3 fragPosition;
varying vec3 fragTangent;
varying vec3 fragBitangent;

uniform highp float elapsedTime;
uniform Directionlight light;
uniform Material material;
uniform vec3 eyePosition;
uniform mat4 normalMatrix;
uniform mat4 modelMatrix;

uniform sampler2D diffuseMap;
uniform sampler2D normalMap;
uniform bool useNormalMap;

void main(void) {
    vec4 worldVertexPosition = modelMatrix * vec4(fragPosition, 1.0);
    
    vec3 normalizedLightDirection = normalize(light.direction - worldVertexPosition.xyz);
    vec3 transformedNormal = normalize((normalMatrix * vec4(fragNormal, 1.0)).xyz);
    vec3 transformedTangent = normalize((normalMatrix * vec4(fragTangent, 1.0)).xyz);
    vec3 transformedBitangent = normalize((normalMatrix * vec4(fragBitangent, 1.0)).xyz);

    mat3 TBN = mat3(transformedNormal,
                    transformedTangent,
                    transformedBitangent);
    if(useNormalMap) {
        vec3 normalFromMap = (texture2D(normalMap, fragUV).rgb * 2.0 - 1.0);
        transformedNormal = TBN * normalFromMap;
    }
    
    // 计算漫反射
    float diffuseStrength = dot(normalizedLightDirection, transformedNormal);
    diffuseStrength = clamp(diffuseStrength, 0.0, 1.0);
    vec3 diffuse = vec3(diffuseStrength * light.color * texture2D(diffuseMap, fragUV).rgb * light.indensity);

    // 计算环境光
    vec3 ambient = vec3(light.ambientIndensity) * material.ambientColor;

    // 计算高光
    vec3 eyeVector = normalize(eyePosition - worldVertexPosition.xyz);
    vec3 halfVector = normalize(normalizedLightDirection + eyeVector);
    float specularStrength = dot(halfVector, transformedNormal);
    specularStrength = pow(specularStrength, material.smoothness);
    vec3 specular = specularStrength * material.specularColor * light.color * light.indensity;

    // 最终颜色
    vec3 finalColor = diffuse + ambient + specular;
    gl_FragColor = vec4(finalColor, 1.0);
}


//void test1(void) {
//    vec3 normalizedLightDirection = normalize(-lightDirection);
//    vec3 transformedNormal = normalize((normalMatrix * vec4(fragNormal, 1.0)).xyz);
//
//    float diffuseStrength = dot(normalizedLightDirection, transformedNormal);
//    diffuseStrength = clamp(diffuseStrength, 0.0, 1.0);
//    vec3 diffuse = vec3(diffuseStrength);
//
//    vec3 ambient = vec3(0.3);
//
//    vec4 finalLightStrength = vec4(ambient + diffuse, 1.0);
//    vec4 materialColor = texture2D(diffuseMap, fragUV);
//
//    gl_FragColor = finalLightStrength * materialColor;
//}


void test(void) {
    highp float processedElapsedTime = elapsedTime;
    highp float intensity = (sin(processedElapsedTime) + 1.0) / 2.0;
    gl_FragColor = fragColor * intensity;
}
