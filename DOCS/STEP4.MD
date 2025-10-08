
# Etapa 4 — Ilhas, Farming e Mecânicas de Progressão

## 1. Visão Geral do Mundo Farming
- O jogador cai em uma **ilha central**, onde vê todos os jogadores do mesmo servidor.  
- Cada jogador tem **ilhas individuais** conectadas por portais.  
  - Se você é o dono da ilha → pode construir, alimentar e evoluir dragões.  
  - Se não é o dono → modo espectador, com opção de voltar para a ilha central.  
- **Objetivo:** evoluir dragões, coletar recursos e construir sua ilha.

## 2. Estrutura das Ilhas
- Cada ilha possui:
  - Espaços para dragões (habitats)
  - Incubadoras de ovos
  - Armazenamento de recursos (comida, ouro)
  - Decorações (cosméticos)
- O servidor **carrega apenas as ilhas ativas** próximas ao jogador para reduzir lag.
- Ilhas podem ter níveis de upgrade:
  - Mais habitats
  - Mais slots de incubadora
  - Boosts passivos para XP ou recursos

## 3. Sistema de Recursos e Farming
- Recursos principais:
  - **Comida de dragão** → sobe nível dos dragões
  - **Ouro** → comprar itens, habitats ou decorações
  - **Fragmentos de dragão** → para obter dragões raros
- Geração de recursos:
  - Habitats geram comida ao longo do tempo
  - Eventos diários fornecem recursos extras
  - PvE em ilha → derrotar criaturas NPC gera ouro ou fragmentos
- Interação de outros jogadores:
  - Trocas e visitas permitem coletar recompensas simbólicas
  - PvP amistoso ou mini-eventos entre ilhas

## 4. Mecânica de Ovos e Incubação
- Jogador pode possuir múltiplos ovos simultaneamente
- Cada ovo tem:
  - **Tempo de incubação**
  - **Tipo** (comum, raro, épico, evento)
  - **Boosts premium** que aceleram incubação
- Incubação:
  - Servidor registra timestamp do início
  - Cliente recebe atualização de progresso visual

## 5. Interação entre Jogadores
- Ao visitar outra ilha:
  - Jogador entra em **modo espectador**
  - Pode apenas visualizar dragões, habitats e decorações
  - Opcional: interações sociais (emoji, chat, trocas)
- Instâncias do servidor limitam **quantidade de ilhas carregadas** simultaneamente para performance

## 6. Estrutura Técnica
- `IslandService` (ServerScriptService):
  - Gerencia spawn de ilhas, visitantes e recursos
  - Carregamento e descarregamento dinâmico
- `DragonHabitatModule` (ReplicatedStorage):
  - Define habitats, limites, boosts
- `ResourceModule`:
  - Controla coleta, geração e armazenamento
- `RemoteEvents`:
  - `VisitIsland` (cliente → servidor)
  - `UpdateResource` (servidor → cliente)
  - `SpawnDragon` (servidor → cliente)

## 7. Balanceamento e Progressão
- Quantidade de recursos por habitat escalada por nível do jogador
- Dragões raros geram mais recompensas
- Boosts e premium aceleram progressão, mas não quebram balanceamento
- Eventos temporários aumentam a geração de recursos ou drop de ovos especiais

## 8. Observações Técnicas
- Ilhas são **instanciadas dinamicamente** para reduzir uso de memória
- Todos os cálculos de recursos, evolução e coleta são feitos **no servidor**
- Cliente apenas recebe dados replicados para exibição e animações
- Estrutura modular permite:
  - Adição de novos habitats, recursos e eventos
  - Expansão futura de ilhas ou mecânicas de visita
