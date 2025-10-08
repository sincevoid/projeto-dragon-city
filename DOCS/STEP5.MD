
# Etapa 5 — Eventos, Missões Especiais e Sistemas de Engajamento

## 1. Eventos Temporários
- Eventos semanais/mensais com objetivos únicos:
  - Dragões exclusivos  
  - Recompensas de recursos raros  
  - Boosts temporários
- Eventos podem ser PvE (desafios cooperativos ou solos) ou PvP (torneios)
- Estrutura:
  - `EventService` gerencia início/fim e spawn de desafios
  - Todos os cálculos de recompensa feitos no servidor

## 2. Missões e Conquistas
- Missões diárias e semanais:
  - Farming, PvP, social e coleta
  - Recompensas: ouro, gemas, ovos especiais
- Conquistas permanentes:
  - Histórico de batalhas, evolução de dragões, participação em eventos
  - Recompensas de status e cosméticos exclusivos

## 3. PvP Avançado
- **Rankings Globais**:
  - Leaderboards por nível, vitórias e rating
  - Atualização em tempo real ou a cada hora
- **Torneios**:
  - Inscrição via moeda premium ou ranking mínimo
  - Recompensas especiais: dragões lendários ou fragmentos raros

## 4. Sistema de Balanceamento Global
- Todos os dragões possuem **Power Rating** baseado em stats, nível e raridade
- Matchmaking PvP usa Power Rating para parear jogadores
- Eventos escalados de acordo com o nível médio da ilha/jogador
- Logs de eventos ajudam a ajustar geração de recursos e dificuldade

## 5. Observações Técnicas
- Todos os eventos e missões são **processados no servidor** para evitar exploits
- Sistema modular para adicionar novos eventos, dragões e missões sem reescrever o core
- Logs e métricas são armazenados para análise de engajamento e balanceamento futuro
