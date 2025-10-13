--[[
    ClientInitializer
    -----------------
    Script responsável por:
    - Detectar o local atual (place) e destruir elementos não pertencentes a ele
    - Identificar e registrar componentes Knit replicados
    - Inicializar o grupo de componentes correspondente ao lugar atual

    Dependências:
    - PlaceDetector: determina o ID do place atual
    - Helper: funções auxiliares para manipulação de instâncias e Knit Components
]]

local REPLICATED_STORAGE = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local PlaceDetector = require(REPLICATED_STORAGE.Shared:WaitForChild("PlaceDetector"))
local Helper = require(REPLICATED_STORAGE.Shared.Helpers.InitializerHelper)

local KnitComponents = {}
local initComponent = nil

-- Aguarda o carregamento completo do jogo (garantia para evitar race conditions)
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Percorre todos os grupos de cliente no diretório
for _, group in pairs(script.Parent.ClientPlayer:GetChildren()) do
    -- Se for o grupo de itens replicados (válidos para todos os places)
    if group.Name == "Replicated" then
        for _, item in ipairs(group:GetChildren()) do
            if RunService:IsStudio() then
                print(string.format("Item %s (%s): %s", item.Name, item.ClassName, tostring(Helper:IsAKnitComponent(item))))
            end
            
            if Helper:IsAKnitComponent(item) then
                table.insert(KnitComponents, item)
            end
        end
        continue
    end

    -- Remove grupos que não pertencem ao place atual
    local placeId = group:GetAttribute("PlaceId")
    if placeId ~= PlaceDetector:GetCurrentPlaceId() then
        group:Destroy()
        continue
    end

    -- Move descendentes diretos para o ClientPlayer e identifica o componente de inicialização
    for _, descendant in ipairs(group:GetDescendants()) do
        if descendant.Parent == group then
            Helper:moveChildren(descendant.Parent, script.Parent.ClientPlayer, true)

            if string.lower(descendant.Name) == string.lower(Helper:GetKnitGroupComponentName()) then
                initComponent = descendant
            end
        end
    end
end

-- Exibe no console o nome do valor de load definido no Helper
print(Helper:GetLoadValue(script))

-- Registra todos os Knit Components encontrados
Helper:AddReplicatedKnitComponents(KnitComponents, initComponent)

-- Define um atributo de carregamento no ReplicatedStorage (sinaliza que o processo terminou)
REPLICATED_STORAGE:SetAttribute(Helper:GetLoadValue(script), true)
