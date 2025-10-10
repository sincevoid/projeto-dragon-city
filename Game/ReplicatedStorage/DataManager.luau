local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local IsServer =  RunService:IsServer()
local IsClient = not IsServer

local DataManager = {}

function DataManager:Get(player: Player?)
    if IsServer then
        -- Busca a data do jogador 
    elseif IsClient then
        -- Busca a data do jogador
    end
end

function DataManager:Update()
    if IsClient then return error("Você não deveria ter acesso a isso... (DT0001)") end
    --> Update data
end

return DataManager