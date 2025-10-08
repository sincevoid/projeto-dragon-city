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
    if IsClient then return error("You should not be able to do this... (DT0001)") end
    --> Update data
end

return DataManager