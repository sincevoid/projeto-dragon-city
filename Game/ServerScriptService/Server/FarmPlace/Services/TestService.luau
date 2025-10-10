local Knit = require(game.ReplicatedStorage.Packages.knit)

local Service = Knit.CreateService({
    Name = "Service",
})

function Service.KnitInit()
    --> não é seguro para acessar outros controllers
    --> inicialize o controller aqui
end

function Service.KnitStart()
    --> safe para acessar outros controllers
    print("inicializou")
end

return Service
