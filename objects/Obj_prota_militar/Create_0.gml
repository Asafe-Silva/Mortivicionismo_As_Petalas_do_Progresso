// Create
spd     = 2;
hsp     = 0;
vsp     = 0;


// Inicializa variáveis globais
global.dialogo = false;


// Velocidade do zoom
cam_zoom = 1;          // zoom inicial (1 = 100%)
cam_target_zoom = 1;   // zoom alvo
cam_speed = 0.05;      // velocidade de interpolação do zoom

// Câmera

cam = view_camera[0];  // pega a câmera da view 0 (ou a sua view ativa)
cam_width = camera_get_view_width(cam);
cam_height = camera_get_view_height(cam);




move_x  = 0; // -1,0,1
move_y  = 0; // -1,0,1


movimento = 0;                // 0 = parado, 1 = andando
image_index = 0;



// direção horizontal "memorizada"
// trazer o mesmo mapeamento que você usa: 1 = olhando esquerda, -1 = olhando direita
olhar = 1;     // valor inicial (escolha o que preferir)
last_axis = "y"; // qual eixo foi o último mexido ("x" ou "y")



