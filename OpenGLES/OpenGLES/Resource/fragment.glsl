precision highp float;

varying lowp vec4 fragColor;
varying highp vec3 fragNormal;
varying highp vec2 fragUV;

uniform highp float elapsedTime;
uniform vec3 lightDirection;
uniform mat4 normalMatrix;
uniform sampler2D diffuseMap;

void main(void) {
    vec3 normalizedLightDirection = normalize(-lightDirection);
    vec3 transformedNormal = normalize((normalMatrix * vec4(fragNormal, 1.0)).xyz);
    
    float diffuseStrength = dot(normalizedLightDirection, transformedNormal);
    diffuseStrength = clamp(diffuseStrength, 0.0, 1.0);
    vec3 diffuse = vec3(diffuseStrength);
    
    vec3 ambient = vec3(0.3);
    
    vec4 finalLightStrength = vec4(ambient + diffuse, 1.0);
//    vec4 materialColor = texture2D(diffuseMap, fragUV);
    vec4 materialColor = vec4((sin(elapsedTime) + 1.0) / 2.0, (cos(elapsedTime) + 1.0) / 4.0 + 0.5, (sin(elapsedTime) + 1.0) / 2.0, 1.0);
    
//    gl_FragColor = finalLightStrength * materialColor;
    gl_FragColor = vec4(materialColor.rgb * finalLightStrength.rgb, 1.0);
}

void test(void) {
    highp float processedElapsedTime = elapsedTime;
    highp float intensity = (sin(processedElapsedTime) + 1.0) / 2.0;
    gl_FragColor = fragColor * intensity;
}
