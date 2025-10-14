--[[
    JoinService
    -----------
    Serviço responsável por gerenciar eventos de entrada e saída de jogadores.

    Funções:
    - OnPlayerJoin(player): executa lógica ao jogador entrar no jogo.
    - OnPlayerLeave(player): executa lógica ao jogador sair do jogo.

    Futuras expansões:
    - Carregamento e salvamento de dados
    - Inicialização de perfil (inventário, ilha, moedas, etc.)
    - Integração com outros serviços (IslandService, DataService, etc.)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Knit = require(game.ReplicatedStorage.Packages.knit)

local JoinService = Knit.CreateService({
	Name = "JoinService",
	Client = {}, -- Mantido vazio, caso precise expor algo no futuro
})

--// PLAYER JOIN / LEAVE ------------------------------------------------------

-- Chamado quando o jogador entra no jogo
function JoinService:OnPlayerJoin(player: Player)
	if RunService:IsStudio() then
		_G.print(string.format("[JoinService] Jogador entrou: %s", player.Name))
	end

	-- Exemplo: integração futura
	-- local IslandService = Knit.GetService("IslandService")
	-- IslandService:CreateIslandFor(player)
end

-- Chamado quando o jogador sai do jogo
function JoinService:OnPlayerLeave(player: Player)
	if RunService:IsStudio() then
		_G.print(string.format("[JoinService] Jogador saiu: %s", player.Name))
	end

	-- Exemplo: salvar progresso
	-- local DataService = Knit.GetService("DataService")
	-- DataService:SavePlayerData(player)
end

--// KNIT LIFECYCLE -----------------------------------------------------------

function JoinService:KnitInit()
	-- Conecta eventos globais de entrada e saída
	Players.PlayerAdded:Connect(function(player)
		self:OnPlayerJoin(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		self:OnPlayerLeave(player)
	end)
	if RunService:IsStudio() then
		_G.print("[JoinService] Inicializado")
	end
end

function JoinService:KnitStart()
	if RunService:IsStudio() then
		_G.print("[JoinService] Em execução")
	end
end

return JoinService
