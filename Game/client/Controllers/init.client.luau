local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Knit = require(Packages.knit)

-- > Espera o jogo carregar se ainda não carregou...
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Controllers = {}

-- Inicializa os controllers
for _, v in script:GetChildren()  do
    Controllers[#Controllers+1] = require(v)
end

-- Inicializa o knit
Knit.Start():catch(function(error: any)
    local text = "Knit encontrou um erro: %s (KN0001)"
    error(text:format(tostring(error)))
end)