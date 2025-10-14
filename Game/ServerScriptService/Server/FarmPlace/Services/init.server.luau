local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Knit = require(Packages.knit)

repeat
	task.wait()
until ReplicatedStorage:GetAttribute("ServerLoaded")

Knit.AddServices(script)

-- Inicializa o knit (Servidor)
Knit.Start():catch(function(error: any)
	local text = "Knit encontrou um erro: %s (KN0001)"
	error(text:format(tostring(error)))
end)
