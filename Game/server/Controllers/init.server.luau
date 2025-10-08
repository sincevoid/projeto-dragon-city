local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Knit = require(Packages.knit)

local Services = {}

-- Inicializa os services
for _, v in script:GetChildren()  do
    Services[#Services+1] = require(v)
end

-- Inicializa o knit (Servidor)
Knit.Start():catch(function(error: any)
    local text = "Knit encontrou um erro: %s (KN0001)"
    error(text:format(tostring(error)))
end)