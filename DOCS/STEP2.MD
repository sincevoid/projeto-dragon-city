# Projeto Dragon City 3D – Documento Técnico (Etapa 2)

## 1. Sistema de economia e progressão

### 1.1 Moedas do jogo

O sistema de economia possui **três tipos principais de moedas**, armazenadas no perfil do jogador e sincronizadas apenas pelo servidor:

-   **Ouro (Gold)**

    -   Usado para comprar habitats, estruturas e iniciar reproduções.
    -   Obtido por: coleta de habitats, vitórias PvE/PvP, login diário.
    -   Armazenado no DataStore do jogador (`Profile.Currencies.Gold`).

-   **Comida (Food)**

    -   Usada para evoluir dragões de nível.
    -   Obtida por: plantações, eventos e recompensas de missões.
    -   Representa o ciclo de produção → coleta → gasto (loop de progressão principal).

-   **Gemas (Gems)**
    -   Moeda premium, pode ser comprada com Robux.
    -   Usada para acelerar construções, incubação, abrir gacha premium, etc.
    -   Sistema de segurança: validação de transação em servidor com `MarketplaceService`.

---

## 2. Sistema de progressão do jogador

Cada jogador possui um **nível global**, que define desbloqueios (estruturas, habitats, modos de jogo).

-   Campos armazenados:
    -   `XP` (experiência total)
    -   `Level` (nível calculado via tabela de XP)
-   A cada nível, o servidor confere uma **tabela de recompensas** que pode incluir:
    -   Novos tipos de ovos disponíveis.
    -   Acesso a ilhas adicionais.
    -   Slots extras na incubadora.

O cálculo de nível segue a fórmula:

XP necessário = 100 × (nível atual²)

## 3. Sistema de ovos e incubação

### 3.1 Obtenção de ovos

Existem **três formas principais** de obter ovos:

1. **Compra direta na loja**

    - Ovos comuns sempre disponíveis.
    - Raros e eventos rotativos via módulo de rotação semanal.
    - Transações verificadas pelo servidor.

2. **Eventos e minigames no lobby**

    - Eventos ativados manualmente por administradores.
    - Recompensas: ovos temáticos e fragmentos.

3. **Sistema de fragmentos (crafting)**
    - Cada dragão tem fragmentos identificados por ID único.
    - Ao acumular 100 fragmentos → servidor cria um novo ovo.
    - Fragmentos são obtidos por login diário, PvP, e tarefas semanais.

### 3.2 Sistema de incubação

-   Cada jogador possui uma **Incubadora** com **1 slot inicial**.
-   Slots adicionais são desbloqueáveis com gemas.
-   Incubação tem **tempo variável** (baseado na raridade do ovo).
-   Jogador pode:
    -   Acelerar o processo com gemas.
    -   Cancelar (perdendo o ovo).
-   Após o tempo, o dragão nasce e é movido para um **habitat compatível**.

---

## 4. Sistema de habitats e alimentação

### 4.1 Habitats

-   Estruturas fixas que armazenam dragões de elementos específicos (fogo, água, terra, etc).
-   Cada habitat:
    -   Possui limite de dragões.
    -   Gera ouro passivamente ao longo do tempo.
    -   Pode ser upado (aumenta capacidade e taxa de produção).
-   Dados armazenados:

Habitat = {
id = "habitat_terra",
element = "Terra",
level = 2,
incomeRate = 15, -- ouro/minuto
capacity = 3
}

### 4.2 Alimentação e evolução

-   Cada dragão possui os atributos:
-   `level`, `xp`, `rarity`, `element`, `damage`, `health`.
-   Jogador usa **Comida** para aumentar o XP do dragão.
-   Quando atinge XP máximo → sobe de nível.
-   A cada evolução visual (ex: Nível 10, 20, 30), muda o modelo 3D ou efeitos visuais.

---

## 5. Sistema de Gacha (Invocação de Dragões)

### 5.1 Tipos de Gacha

1. **Gacha Comum**

-   Custa ouro.
-   Chance de dragões comuns e raros baixos.
-   Contém sistema de **pity counter** (garante raridade após X tentativas).

2. **Gacha Premium**

-   Custa gemas.
-   Maior chance de dragões raros e lendários.
-   Chance variável exibida antes da rolagem (transparência de probabilidades).

3. **Gacha de Evento**

-   Limitado a um período.
-   Inclui dragões temáticos e exclusivos.

### 5.2 Estrutura técnica

-   O servidor executa a rolagem, nunca o cliente.
-   Recompensa enviada como “ovo” diretamente para o inventário.
-   Registro de histórico no DataStore:

Profile.Gacha = {
pityCounter = 0,
lastRolls = { {dragonId="fire_dragon", rarity="rare", time=1694030}, ... }
}

-   Tabela de probabilidades configurável via ModuleScript:

{
common = 0.70,
rare = 0.20,
epic = 0.09,
legendary = 0.01
}

---

## 6. Sistema de monetização (Pay-to-Progress)

O objetivo é permitir **vantagem de progresso**, mas sem quebrar o equilíbrio PvP.

### 6.1 Recursos pagos

-   **Pacotes de gemas (Robux)**
-   Comprados diretamente via `MarketplaceService`.
-   **Passe VIP**
-   Benefícios ativos por tempo limitado:
    -   +25% ouro ganho.
    -   +1 slot na incubadora.
    -   +1 slot de gacha diário gratuito.
-   Renovação automática com gemas ou Robux.

### 6.2 Aceleração

-   Jogador pode pagar gemas para:
-   Finalizar instantaneamente construções/incubações.
-   Dobrar recompensas de batalha PvE.
-   Recarregar energia dos dragões no PvP.

### 6.3 Itens cosméticos pagos

-   Skins de dragões e partículas visuais não afetam gameplay.
-   Desbloqueadas via gemas ou eventos limitados.

---

## 7. Segurança e validação

### 7.1 Validação de compras

-   Todas as compras (Robux ou Gemas) passam por:
-   Checagem de recibo (`ProcessReceipt`).
-   Registro de log em DataStore separado (auditoria).

### 7.2 Anti-exploit

-   Nenhum valor crítico é calculado no cliente.
-   Todos os RemoteEvents possuem **checagem de servidor**.
-   Sistema de cooldown e rate-limit em requisições gacha e incubação.

---

## 8. Próximas etapas

Na **Etapa 3**, será documentado:

-   **Sistema de combate PvP e PvE (dragões, habilidades, arenas)**
-   **Estrutura de matchmaking e sincronização**
-   **Balanceamento de dano e elementos**
