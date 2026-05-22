Relatório do Projeto — Mortivicionismo As Pétalas do Progresso
Data: 20 de maio de 2026

Resumo
- Escaneei a árvore de arquivos do projeto GameMaker e compilei um relatório resumido com listas de objetos, scripts, sistemas (rooms/persistentes) e assets principais.
- Este README contém descrições inferidas a partir dos nomes dos arquivos e estrutura do projeto; para descrições por linha de código deve-se executar análise por arquivo (opcional).

Objetos (principais encontrados)
- oPlayerMilitar: jogador principal (eventos Create, Step, Draw, Alarm). Controla movimento, estado e render do personagem militar.
- oTitleScreen: tela de título (Create/Draw/Step). Deve gerenciar entrada inicial e transição para o jogo.
- oTransition: gerencia transições de tela/efeitos (Draw e Step específicos).
- oSaveSlotsUI / oSaveSlotsUI.yy: interface para seleção de slots de save.
- oInventoryUI / oInventoryManager: UI e lógica de inventário, manipulação de itens e renderização do inventário.
- oGame / oGameInit / oGameState: objetos de controle global do jogo (estado, inicialização, persistência entre salas).
- oPlayerHitbox / oHitbox / oHitbox (ou similar): colisões e detecção de hits.
- oControl / oDebug / oDebugTools: objetos utilitários para debug e controle de fluxo.
- Obj_inimigo* / Obj_par_inimigos / Obj_InimigoTeste: inimigos e agrupadores de inimigos.
- oTitleScreen / oSaveSlotsUI / oTransition / oInventoryUI / oInventoryManager / oPlayerMilitar / oGameInit etc. (lista extensa localizada em `objects/`)

Scripts (principais encontrados)
- scr_trauma_update: atualiza sistema de trauma (status, efeitos ao longo do tempo).
- scr_trauma_create: cria entradas de trauma para entidades/jogador.
- scr_trauma_add: adiciona trauma (gatilho de eventos negativos).
- scr_trauma_check_gatilhos: verifica condições que disparam traumas.
- scr_escolha_resultado: lógica para processar resultados de escolhas do jogador.
- scr_item_add / scr_item_remove / ItemDatabase: scripts e DB para manipulação de itens no inventário.
- scr_save_load: funções de salvar/carregar jogos (presente em `scripts/` — verificar se existe e está ligado a `oSaveSlotsUI`).
- iniciar_digitacao: provável helper para efeitos de texto digitado na tela.
- GMLive* scripts: utilitários de live-reload/integração de desenvolvimento (se não for usado em build final, pode ser removido ou isolado).
- MACROS: macros e constantes do projeto.

Sistemas / Rooms / Serviços
- Pastas `rooms/` contêm cenas como `rm_TitleScreen`, `rm_SaveSlots`, `Roo_area_de_treinamento`, `Roo_cidade_destruida_pt`.
- Objetos como `oGameInit` e `oGameState` atuam como Singletons para manutenção de estado entre rooms.

Coisos (assets e misc)
- Sprites: `sprites/` (muitos subdiretórios, ex.: `Spr_gatoman`, `Spr_bala_walther_p38`, `spr_missing`).
- Sons: `sounds/` e `audiogroups/` (BGM e SFX separados).
- Fonts: `fonts/` (p.ex. `Fnt_dialogo`).
- Tilesets e tiles usados nas rooms estão em `tilesets/`.

Itens possivelmente não utilizados (baseado apenas em nomes / estrutura)
- `spr_missing` indica assets placeholder; revisar se usado em runtime.
- Pastas `GMLive_fallback` / `GMLiveAPI_js` podem ser utilitários de desenvolvimento que não devem ir para build final.
- Arquivos e pastas duplicadas ou com nomes genéricos (`Script1`, `Object10`) sugerem código temporário/legacy a revisar.

Problemas comuns detectáveis sem executar o jogo
- Uso de variáveis globais dispersas (GameMaker frequentemente usa `global.`) — pode gerar efeitos colaterais e bugs de estado.
- Nomes ambíguos (`Script1`, `Object10`) dificultam manutenção; renomear para função clara.
- Falta de documentação inline nos scripts — recomendo comentários em scripts críticos (`save/load`, `inventário`, `trauma`).
- Possível lógica de render em `Draw` que mistura lógica e desenho — separar quando possível.
- Recursos grandes (muitos sprites/áudios) sem referência podem aumentar build size.

Recomendações imediatas
- Executar uma varredura automática de referências para identificar assets não referenciados (sprites, sounds, scripts). Posso rodar essa varredura se autorizar.
- Gerar documentação por objeto/script (exportar conteúdo de `Create/Step/Draw/Alarm` e gerar resumo por arquivo). Posso automatizar isso também.
- Padronizar nomes e mover scripts utilitários de desenvolvimento para `extensions/` ou pasta `dev_tools/`.
- Adicionar um `README.md` com instruções de build/export e um `CONTRIBUTING.md` com convenções de nome.

Próximos passos que posso executar agora
- 1) Varredura automática de referências para marcar assets não utilizados.
- 2) Análise por arquivo (abrir cada `.gml` e gerar descrição exata por evento).
- 3) Criar checklist de limpeza (renomear, remover placeholders, documentar).

Se desejar que eu prossiga com a varredura automática e a descrição por arquivo (mais detalhada), confirme e eu executo.

---
Gerado automaticamente a partir da estrutura do workspace. Para atualizações ou mais detalhes por arquivo, peça: "Faça a análise completa por arquivo".

Detalhamento (análise por arquivo) — objetos processados nesta etapa

`oPlayerMilitar`:
- Create: inicializa movimento, câmera, estado de combate, timers e funções auxiliares (`ProcessInput`, `ProcessMovement`, `ProcessAnimation`, `ProcessInteraction`, `ProcessCamera`, `ProcessCombat`, `AttemptReload`, `RepeatReloadAction`). Define `PLAYER_STATE` (FREE, ATTACK) e métodos de ataque que criam `oHitbox` e usam alarm[0] para duração de ataque.
- Step: checa `global.game_paused`, trata carregamento de posições (`is_loading_game`) e chama `ProcessState()` e `ProcessCamera()`.
- Draw: `draw_self()`; desenho padrão sem lógica extra.
- Alarm[0]: encerra estado de ataque (`state = PLAYER_STATE.FREE`) e reseta `image_blend`.

Observações: `oPlayerMilitar` contém lógica combinada de movimento, câmera e armas; boas práticas recomendam separar arma (weapon) e câmera em módulos/objetos próprios para reduzir acoplamento.

`oGameInit`:
- Create: cria instâncias de `oControl` e `oDebug`, e chama `room_goto_next()` para começar a primeira sala.

`oInventoryManager`:
- Create: inicializa inventário (`maxSlots`, `inventorySlots`), define funções `InventoryAdd`, `InventoryRemove`, `InventoryHasItem`, inicializa sistemas de traumas e medalhas (structs `Trauma` e `Medal`), e define UI state e `current_tab`.

`oTitleScreen`:
- Create: detecta saves existentes, configura `menu_options` com "NOVO JOGO/CONTINUAR", define GUI size e animação do cursor.
- Step: bloqueia input durante `oTransition`, navega menu com teclado e cria `oTransition` para trocar para `rm_SaveSlots` quando iniciar jogo.

`oTransition`:
- Create: inicializa `alpha`, `state` (fade out/in), `target_room` e `fade_speed`.
- Step: avança `alpha`, ao completar fade out faz `room_goto(target_room)`, depois faz fade in e destrói a instância.

Próximo lote: vou processar os scripts principais (`scr_trauma_*`, `scr_item_*`, `scr_save_load`, `iniciar_digitacao`) e os objetos de UI (`oSaveSlotsUI`, `oInventoryUI`) para documentar seus eventos e funções.
