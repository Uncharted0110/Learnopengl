#version 330 core

struct Material{
    sampler2D diffuse;
    sampler2D specular;
    float     shininess;
    sampler2D emission;
};


struct Light{
    vec3 position;

    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};


out vec4 FragColor;  

in vec3 Normal;
in vec3 FragPos;
in vec2 TexCoords;

uniform vec3 viewPos;
uniform Light light;
uniform Material material;
uniform float u_time;

void main()
{
    vec3 ambient = light.ambient * vec3(texture(material.diffuse, TexCoords));
    
    vec3 norm = normalize(Normal);
    vec3 lightDir = normalize(light.position - FragPos);
    float diff = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = diff * light.diffuse * vec3(texture(material.diffuse, TexCoords));

    vec3 viewDir = normalize(viewPos - FragPos);
    vec3 reflectDir = reflect(-lightDir, norm);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
    vec3 specular = spec * light.specular * vec3(texture(material.specular, TexCoords));

    vec3 emission;
    if( vec3(texture(material.specular, TexCoords)) == vec3(0.0))
    {
        emission = vec3(texture(material.emission, TexCoords + vec2(0.0, 2 * u_time)));
        emission *= vec3(1.0, 0.0, 0.0);
        emission = emission * (sin(u_time) + 1.0) * 10;
    }
    else
    {
        emission = vec3(0.0);
    }

    vec3 res = ambient + diffuse + specular + emission;
    FragColor = vec4(res, 1.0);
}