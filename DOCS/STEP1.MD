# Projeto Dragon City 3D – Documento Técnico (Etapa 1)

## 1. Estrutura geral do jogo

### 1.1 Visão geral

O jogo é um **multiplayer 3D inspirado em Dragon City**, onde o jogador cria e evolui dragões, interage com outros jogadores e participa de batalhas PvP e PvE.  
O jogo é dividido em **três ambientes principais**:

-   **Lobby central (Social Hub)**
-   **Mundo PvP (Arenas de combate)**
-   **Mundo Farming (Ilhas de criação e evolução de dragões)**

Cada ambiente será carregado e gerenciado de forma independente por meio de **portais** e **teleporte entre instâncias** para otimizar performance e reduzir uso de memória no cliente.

---

## 2. Estrutura dos mundos

### 2.1 Lobby

O **Lobby** é o ponto inicial do jogador. Ele funciona como um servidor social com limite de jogadores (ex: 24 por servidor).  
Características técnicas:

-   **Áreas principais**:

    -   Zona de spawn inicial.
    -   **Lojas** (loja de ovos, loja de itens cosméticos, loja premium).
    -   **Zona de eventos temporários** (pode ser substituída ou desativada via módulo).
    -   **Portais**:
        -   **Portal PvP** → leva o jogador para o mundo de arenas.
        -   **Portal Farming** → leva o jogador para o mundo das ilhas.

-   **Funções técnicas**:
    -   Sistema de replicação controlado apenas para interações visuais e chats (minimizando replicação de scripts).
    -   NPCs e lojas usam módulos centralizados com eventos de compra.
    -   Todos os objetos estáticos do lobby devem ser otimizados via **MeshPart** com **CollisionGroup desativado** sempre que possível.

---

### 2.2 Mundo PvP

O **Mundo PvP** é composto por **várias arenas instanciadas**. Cada arena é criada dinamicamente quando jogadores entram para batalhar.

-   **Arenas 1v1, 2v2 ou customizadas** (ex: evento semanal).
-   **Sistema de matchmaking simples** (fila por tipo de batalha).
-   **Controle de instância:**
    -   Cada arena é um modelo salvo no **ServerStorage** e clonado para um **Folder** temporário quando necessário.
    -   O sistema registra no servidor o estado da arena e destrói a instância após a partida.
-   **Sincronização mínima**: apenas status de vida, energia e animações de dragões são replicados para o cliente.

---

### 2.3 Mundo Farming

O **Mundo Farming** é o núcleo da mecânica de progressão do jogo.

#### Estrutura técnica:

-   O jogador é teleportado para uma **ilha central compartilhada**.
-   Nessa ilha, há **portais** que levam para as **ilhas individuais** dos jogadores conectados no servidor.
-   Cada ilha é **gerada sob demanda (instanciada)** para reduzir carga de memória.

#### Sistema de ilhas:

-   **Ilhas individuais**:
    -   Carregadas apenas para o dono ou visitantes.
    -   Estrutura salva no DataStore (posição dos habitats, dragões, ovos etc.).
    -   Ao entrar na ilha, o servidor carrega apenas as partes necessárias do modelo salvo.
-   **Ilha central**:
    -   Contém todos os portais ativos.
    -   Portais são gerados dinamicamente com base nos jogadores presentes no servidor.
    -   Sistema de “visit mode”: se o jogador entra em uma ilha que não é sua, ele não pode interagir, apenas observar.
    -   Botão “Voltar à Ilha Central” aparece no GUI do visitante.

#### Performance:

-   As ilhas são armazenadas como **modelos serializados em JSON** ou **ModuleScripts** contendo apenas dados (não instâncias físicas).
-   O servidor reconstrói a ilha do jogador no momento da entrada.
-   Objetos ociosos são destruídos após **timeout** configurável (ex: 120 segundos sem presença do jogador).

---

## 3. Teleporte e replicação de dados

### 3.1 Sistema de portais

Cada portal é um **Trigger Zone (ProximityPrompt)** com script centralizado no servidor.

Fluxo:

1. Jogador interage com o portal.
2. Sistema verifica tipo de portal e salva estado atual do jogador (inventário, dragões carregados, posição).
3. Servidor executa `TeleportService:TeleportAsync()` para o destino correspondente.
4. Ao chegar no novo mundo, o servidor recupera os dados e recria a instância do jogador.

### 3.2 Replicação

-   Dados críticos (dragões, moedas, ilhas) são mantidos apenas no servidor.
-   Clientes recebem apenas dados necessários para renderização e interface.
-   Comunicação entre cliente e servidor via **RemoteEvents e RemoteFunctions**, com módulos centralizados.

---

## 4. Estrutura modular

O projeto deve seguir um padrão modular para facilitar manutenção e expansão futura.

### 4.1 Estrutura de pastas sugerida

ReplicatedStorage/
├── Modules/
│ ├── Data/
│ ├── UI/
│ ├── Combat/
│ ├── Farming/
│ ├── Portals/
│ └── Shop/
├── SharedAssets/
│ ├── Models/
│ ├── Animations/
│ └── Effects/
ServerScriptService/
├── Systems/
│ ├── IslandLoader.lua
│ ├── PvPManager.lua
│ ├── ShopHandler.lua
│ ├── PortalService.lua
│ └── SaveData.lua
StarterGui/
├── MainUI/
├── IslandUI/
└── PvPUI/

---

## 5. Próximas etapas

A próxima etapa definirá:

-   **Sistemas de economia e progressão (moedas, XP, níveis)**
-   **Mecânica de obtenção de ovos e incubação**
-   **Sistemas de gacha e monetização**
