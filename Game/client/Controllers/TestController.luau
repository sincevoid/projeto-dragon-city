local Knit = require(game.ReplicatedStorage.Packages.knit)

local TestController = Knit.CreateController({
    Name = "TestController",
})

function TestController.KnitInit()
    --> não é seguro para acessar outros controllers
    --> inicialize o controller aqui
end

function TestController.KnitStart()
    --> safe para acessar outros controllers
    print("inicializou")
end

return TestController
