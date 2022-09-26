Shader "Custom/ScrollScreen"
{
    Properties
    {
        _LightColor ("Light color", Color) = (1,1,1,1)
        _DarkColor ("Dark color", Color) = (1,0,0,1)
        _MainTex ("Texture", 2D) = "white" {}
        _Rows ("Number of rows", Range(0, 20)) = 4
        _StartPos ("Start position", Range(0, 20)) = 0
        _Length ("Length", Range(0, 20)) = 1
        _DisplayedLength ("Displayed length", Range(0, 20)) = 0.5
        _Speed ("Speed", Range(0, 10)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _DarkColor;
        fixed4 _LightColor;
        float _StartPos;
        float _Length;
        float _DisplayedLength;
        float _Speed;
        float _Rows;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed2 uv = IN.uv_MainTex;
            float t = _Time.y;
            float start1D = (_StartPos - t * _Speed) % _Length;
            float x1D = (start1D + _DisplayedLength * uv.x) % _Length;

            float x2D = frac(x1D);
            float y2D = ((x1D - x2D) + uv.y) / _Rows;

            fixed4 c = tex2D (_MainTex, float2(1 - x2D, 1 - y2D)) * _LightColor;
            o.Albedo = c.rgb;
            o.Metallic = 0;
            o.Smoothness = 0;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
