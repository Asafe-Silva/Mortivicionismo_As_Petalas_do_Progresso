// Obj_controle agora delega inicialização global para Obj_GameState
// Certifica-se de que Obj_GameState exista (será criado no mesmo room se necessário)
if (!instance_exists(Obj_GameState)) {
	// cria no mesmo layer/posição do controle
	instance_create(x, y, Obj_GameState);
}
