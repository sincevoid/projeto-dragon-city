local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local IsServer = RunService:IsServer()
local IsClient = not IsServer

-- Importa o ProfileService
local ProfileService = require(ReplicatedStorage:WaitForChild("ProfileService"))

-- Nome do ProfileStore (banco de dados)
local PROFILE_STORE_NAME = "PlayerData"

-- TEMPORÁRIO
local DataTemplate = {
    Coins = 0,
    Gems = 0,
    Level = 1,
    XP = 0,
    Inventory = {},
}

-- Cria o store
local ProfileStore = ProfileService.GetProfileStore(PROFILE_STORE_NAME, DataTemplate)

-- Cria tabela principal
local DataManager = {}

-- Tabela interna para armazenar os perfis ativos no servidor
local Profiles = {}

-- RemoteFunction para o cliente buscar dados
local DataRemote = nil
if IsServer then
    DataRemote = Instance.new("RemoteFunction")
    DataRemote.Name = "DataManagerRemote"
    DataRemote.Parent = ReplicatedStorage
else
    DataRemote = ReplicatedStorage:WaitForChild("DataManagerRemote")
end

-----------------------------------------------------
-- SERVIDOR
-----------------------------------------------------
if IsServer then
    function DataManager:Get(player: Player)
        local profile = Profiles[player]
        if not profile then return nil end
        return profile.Data
    end

    function DataManager:Update(player: Player, newData: table)
        local profile = Profiles[player]
        if not profile then
            warn("Tentativa de atualizar dados de jogador inexistente.")
            return
        end
        for key, value in pairs(newData) do
            profile.Data[key] = value
        end
    end

    -- Carrega o perfil quando o jogador entra
    Players.PlayerAdded:Connect(function(player)
        local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId, "ForceLoad")
        if profile then
            profile:AddUserId(player.UserId)
            profile:Reconcile() -- Garante que os campos padrão existam
            profile:ListenToRelease(function()
                Profiles[player] = nil
                player:Kick("Seus dados foram carregados em outro servidor.")
            end)
            if player:IsDescendantOf(Players) then
                Profiles[player] = profile
                print("[DataManager] Perfil carregado para", player.Name)
            else
                profile:Release()
            end
        else
            player:Kick("Falha ao carregar seus dados. Tente novamente.")
        end
    end)

    -- Salva e libera o perfil quando o jogador sai
    Players.PlayerRemoving:Connect(function(player)
        local profile = Profiles[player]
        if profile then
            profile:Release()
            Profiles[player] = nil
        end
    end)

    -- Cliente pedindo dados
    DataRemote.OnServerInvoke = function(_, player)
        local profile = Profiles[player]
        if profile then
            return profile.Data
        else
            return nil
        end
    end
end

-----------------------------------------------------
-- CLIENTE
-----------------------------------------------------
if IsClient then
    function DataManager:Get(player)
        -- No cliente, apenas pede os dados ao servidor
        local success, data = pcall(function()
            return DataRemote:InvokeServer(player)
        end)
        if success then
            return data
        else
            warn("Erro ao buscar dados do jogador:", data)
            return nil
        end
    end
end

return DataManager
