
uniform sampler2D t_normal;
uniform sampler2D t_audio;
uniform sampler2D t_sem;
uniform sampler2D t_iriL;
uniform sampler2D t_iriR;

uniform vec3 color2;
uniform vec3 color1;
uniform vec3 color3;

uniform vec3 rightHand;
uniform vec3 leftHand;

uniform float custom1;
uniform float custom2;
uniform float custom3;

varying vec2 vUv;
varying vec3 vVel;
varying vec4 vAudio;
varying vec3 vMPos;
varying vec3 vPos;

varying vec3 vNorm;
varying vec3 vMNorm;
varying vec3 vCamPos;

varying vec3 vLightDir;
//varying float vLife;

varying vec3 vCamVec;

varying vec2 vSEM;
varying float vFR;
varying vec3 vReflection;

void main(){

 
float texScale= 10.; 
float normalScale= .8; 

// FROM @thespite
  vec3 n = normalize( vNorm.xyz );
  vec3 blend_weights = abs( n );
  blend_weights = ( blend_weights - 0.2 ) * 7.;  
  blend_weights = max( blend_weights, 0. );
  blend_weights /= ( blend_weights.x + blend_weights.y + blend_weights.z );

  vec2 coord1 = vPos.yz * texScale;
  vec2 coord2 = vPos.zx * texScale;
  vec2 coord3 = vPos.xy * texScale;

  vec3 bump1 = texture2D( t_normal , coord1 ).rgb;  
  vec3 bump2 = texture2D( t_normal , coord2  ).rgb;  
  vec3 bump3 = texture2D( t_normal , coord3  ).rgb; 

  vec3 blended_bump = bump1 * blend_weights.xxx +  
                      bump2 * blend_weights.yyy +  
                      bump3 * blend_weights.zzz;

  vec3 tanX = vec3( vNorm.x, -vNorm.z, vNorm.y);
  vec3 tanY = vec3( vNorm.z, vNorm.y, -vNorm.x);
  vec3 tanZ = vec3(-vNorm.y, vNorm.x, vNorm.z);
  vec3 blended_tangent = tanX * blend_weights.xxx +  
                         tanY * blend_weights.yyy +  
                         tanZ * blend_weights.zzz; 

  vec3 normalTex = blended_bump * 2.0 - 1.0;
  normalTex.xy *= normalScale;
  normalTex.y *= -1.;
  normalTex = normalize( normalTex );
  mat3 tsb = mat3( normalize( blended_tangent ), normalize( cross( vNorm, blended_tangent ) ), normalize( vNorm ) );
  
  vec3 fNorm = tsb * normalTex;
   
  float l =  100. / vMPos.y;

  vec3 leftRay = leftHand - vMPos.xyz;
  vec3 rightRay = rightHand - vMPos.xyz;

  //float lMatch = max(0.,dot( fNorm , normalize(leftRay)));
  //float rMatch = max(0.,dot( fNorm , normalize(rightRay)));

  float lMatch = abs(dot( fNorm , normalize(leftRay)));
  float rMatch = abs(dot( fNorm , normalize(rightRay)));

  vec4 aL = texture2D( t_audio , vec2( lMatch , 0. ) );
  vec4 aR = texture2D( t_audio , vec2( rMatch , 0. ) );

  vec4 iriL = texture2D( t_iriL , vec2( lMatch , 0. ) );
  vec4 iriR = texture2D( t_iriR , vec2( rMatch , 0. ) );


  vec3 lambL = iriL.xyz * lMatch * aL.xyz * 2.;
  vec3 lambR = iriR.xyz * rMatch * aR.xyz * 2.;

 // aC *= texture2D( t_audio , vec2( vUv.x , 0. ) );
 // aC *= texture2D( t_audio , vec2( vUv.y , 0. ) );


  float lamb = max( 0. , dot( -vLightDir , vMNorm ));
  float refl = max( 0. , dot( reflect( vLightDir , vMNorm  )  , vCamVec ));
 // float refl = vMPos - lightPos
  float fr = max( 0. , dot( vCamVec , vMNorm ));
  float iFR = 1. - fr;

  vec3 a = texture2D( t_audio , vec2( abs(sin(dot( reflect( vLightDir , vMNorm  )  , vCamVec ))) , 0. ) ).xyz *iFR;
  vec4 aC = texture2D( t_audio , vec2( abs(sin(dot( -vLightDir , vMNorm ))) , 0. )  );

  vec3 rC = color2 * pow( refl , custom1 * 30. );
  vec3 lC = color1 * pow( lamb , custom2 * 5. );

  //gl_FragColor = vec4( vUv.x, vLife /10000., vUv.y, 1. ); //aC ; //* vec4(  1000. - vMPos.y , 100. / vMPos.y , .3, 1. );
 // gl_FragColor = vec4( vec3( .5 , .4 , .2 ) + vec3( 1. , 1. , .6 ) * aC.xyz * aC1.xyz , 1. ); //aC ; //* vec4(  1000. - vMPos.y , 100. / vMPos.y , .3, 1. );
  //gl_FragColor = vec4( (rC + lC ) + 1. * color3 * a * aC.xyz * custom3, 1. );

  //gl_FragColor = vec4( normalize(vMNorm.xyz) * normalize(vMNorm.xyz) + vec3( .5) , 1. );
 
  vec4 sem = texture2D( t_sem , vSEM );

 // vec3 lCol = 
  vec3 col = lambL + lambR;
  
  //col *=  aL.xyz * aR.xyz;//abs(dot( fNorm , normalize(leftRay)));
  gl_FragColor =  vec4( col , 1.); //vec4( vSEM.x , 0. , vSEM.y , 1. );
  //gl_FragColor = vec4( 0.5 * normalize(vReflection ) + 0.7 , 1. ); //vec4( vSEM.x , 0. , vSEM.y , 1. );

}
