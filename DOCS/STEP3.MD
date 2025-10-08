
# Etapa 3 — Sistema de Combate PvP e PvE

## 1. Visão Geral do Combate

O sistema de combate é **baseado em turnos simplificados**, mas rodando em **tempo real sincronizado** entre os jogadores ou entre jogador e servidor (PvE).  

Existem dois modos principais:
- **PvP Arenas (1v1 e 2v2)**: Jogadores competem em arenas instanciadas.  
- **PvE Combates de Missão/Evento**: Jogador contra dragões controlados pelo servidor.  

O combate é **processado majoritariamente no servidor**. O cliente recebe apenas a replicação visual e inputs do jogador.

## 2. Estrutura de Dados dos Dragões

Cada dragão em combate possui:

```lua
Dragon = {
    id = "fire_dragon_001",
    name = "Flare",
    element = "Fire",
    level = 12,
    rarity = "Rare",
    stats = {
        health = 540,
        attack = 72,
        defense = 48,
        speed = 65
    },
    abilities = {
        "fire_breath",
        "heat_wave"
    },
    buffs = {},
    debuffs = {},
    isAlive = true,
    owner = playerUserId
}
```

- `stats` são escalados conforme nível e raridade.  
- `abilities` contêm habilidades únicas com cooldown, tempo de execução e efeitos.  
- `buffs` e `debuffs` armazenam efeitos temporários (stun, burn, defense up, etc).  

## 3. Cálculo de Dano

O dano é calculado **apenas no servidor** com base em:

```
danoFinal = (ataque × poderHabilidade × bônusElemento) - defesa
```

### 3.1 Multiplicadores de Elemento

Tabela de vantagem/desvantagem:

| Atacante      | Forte contra  | Fraco contra |
|---------------|---------------|--------------|
| Fogo          | Terra, Natureza | Água       |
| Água          | Fogo           | Eletricidade|
| Terra         | Eletricidade   | Ar         |
| Ar            | Natureza       | Terra      |
| Natureza      | Água           | Fogo       |
| Eletricidade  | Água           | Terra      |

- Forte = ×1.5  
- Fraco = ×0.75  
- Neutro = ×1.0

## 4. Sistema de Habilidades

Cada habilidade é definida com:

```lua
Skill = {
    id = "fire_breath",
    name = "Sopro de Fogo",
    element = "Fire",
    power = 1.2,       -- multiplicador de dano
    cooldown = 5,      -- segundos
    castTime = 1.2,    -- tempo de execução
    effect = {
        type = "burn",
        chance = 0.2,
        duration = 4,
        damagePerSecond = 5
    }
}
```

Tipos de habilidades:
- **Ofensivas**: causam dano direto.  
- **Suporte**: curam ou aumentam atributos aliados.  
- **Controle**: aplicam efeitos de status nos inimigos.

## 5. Sincronização e Replicação

### 5.1 PvP

1. **Matchmaking**
   - Jogadores são agrupados com base em **nível médio dos dragões**.
   - Cria uma **instância de arena** para cada partida.
2. **Turnos**
   - Baseados na velocidade média dos dragões.
   - Jogador envia ação via `RemoteEvent` (`UseSkill`, `SwapDragon`).
   - Servidor valida:
     - Dragão vivo
     - Cooldown disponível
     - Turno correto
3. **Execução**
   - Servidor aplica dano, buffs e debuffs.
   - Atualiza estado dos dragões e envia resultados visuais ao cliente.
4. **Encerramento**
   - Quando todos os dragões de um jogador morrem:
     - Servidor define vencedor.
     - Premia moedas/XP/fragmentos.
     - Atualiza estatísticas PvP no perfil.

### 5.2 PvE

- Dragões inimigos controlados por IA do servidor.
- IA prioriza habilidades:
  - Cooldowns disponíveis
  - Vantagem elemental
  - Situação do combate
- Eventos especiais podem ter **chefes com múltiplas fases e habilidades únicas**.

## 6. Matchmaking e Arenas

- **Fila de jogadores:** mantém jogadores esperando oponentes de nível semelhante.
- **Balanceamento:** limite de diferença de nível médio de ±2.
- **Fallback:** se não houver oponente humano em X segundos, combate PvE é gerado.

## 7. Estrutura do Código do Combate

- `CombatService` (ServerScriptService): controla instância da arena, turnos e resultados.
- `DragonDataModule` (ReplicatedStorage/Modules): define stats base e habilidades de todos os dragões.
- `SkillModule` (ReplicatedStorage/Modules): define habilidades e efeitos.
- `RemoteEvents`:  
  - `PlayerAction` (cliente → servidor)  
  - `CombatUpdate` (servidor → cliente)  
- Todas as verificações de dano, buffs e validação **ocorrem no servidor**.

## 8. Balanceamento e Progressão

- Dragões mais raros possuem multiplicadores maiores e habilidades especiais.
- Power Rating = função de Level × (Attack + Defense + HP) × RarityMultiplier
- Elementos influenciam decisões de combate.
- Progressão PvP/PvE é registrada no perfil do jogador, incluindo vitórias, derrotas e histórico de batalhas.

## 9. Observações Técnicas

- Servidor mantém **estado mínimo da arena** para performance.  
- Cliente recebe apenas **posições, animações e efeitos visuais**.  
- Todas as ações do jogador passam por **validação de servidor** para prevenir exploits.  
- Estrutura modular permite **adição futura de habilidades, elementos e dragões** sem reescrever o core.
