Shader "Custom/ToonRampBump" {
    Properties {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RampTex ("Ramp (RGB)", 2D) = "white" {}
        _BumpMap ("Bumpmap", 2D) = "bump" {}
	}
    SubShader {
    	Tags { "RenderType"="Opaque" }
        CGPROGRAM
        #pragma surface surf Ramp noambient 
        #pragma shader_feature USE_OUTLINE

        sampler2D _MainTex;
        sampler2D _RampTex;
        sampler2D _BumpMap;

        half4 LightingRamp (SurfaceOutput s, half3 lightDir, half atten) {
            half NdotL = dot (s.Normal, lightDir);
            half diff = NdotL * 0.5f + 0.5f;
            half3 ramp = tex2D (_RampTex, float2(diff,0.5f)).rgb;
            half4 c;
            c.rgb = s.Albedo * ramp;
            return c;
        }

        struct Input {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };
        
        void surf (Input IN, inout SurfaceOutput o) {
            o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
            o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
        }
        ENDCG
    } 
     
    FallBack "Diffuse"
}
