function Sparkle(){

  var geo = new THREE.PlaneBufferGeometry( 6 , 6 , 100 , 100 );



  var uniforms = {
    t_normal: G.t_normal,
    t_audio: G.t_audio,
    t_iri: G.t_iri,
    t_iriFace: G.t_iriFace,
    t_text: G.t_text,

    timer: G.time,

    
    bumpHeight:{ type:"f" , value: .3 },
    bumpSize:{ type:"f" , value: .6 },
    bumpSpeed:{ type:"f" , value: .1 },
    bumpCutoff:{ type:"f" , value: .4 },
    
    lightPos:G.lightPos,
    lightCutoff:{ type:"f" , value: .2},
    lightPower:{ type:"f" , value: .2},
    
    
    opacity:{ type:"f" , value: 1 },
    texScale:{ type:"f" , value: 10 },
    normalScale:{ type:"f" , value: .1 }

  }

  var mat = new THREE.ShaderMaterial({

     uniforms: uniforms,
     vertexShader: shaders.vs.sparkly,
     fragmentShader: shaders.fs.sparkly,

  });

  var mesh = new THREE.Mesh( geo , mat );


  return mesh
}
