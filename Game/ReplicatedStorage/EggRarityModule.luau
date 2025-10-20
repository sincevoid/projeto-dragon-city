-- EggRarityModule.lua
local EggRarityModule = {}

-- tabela de raridades
EggRarityModule.Rarities = {
	{ Name = "Common", Chance = 60, Model = "CommonEgg" },
	{ Name = "Rare", Chance = 25, Model = "RareEgg" },
	{ Name = "Epic", Chance = 10, Model = "EpicEgg" },
	{ Name = "Legendary", Chance = 5, Model = "LegendaryEgg" },
}

function EggRarityModule:GetRandomEgg()
	local roll = math.random(1, 100)
	local cumulative = 0
	for _, rarity in ipairs(self.Rarities) do
		cumulative += rarity.Chance
		if roll <= cumulative then
			return rarity.Model, rarity.Name
		end
	end
	return self.Rarities[1].Model, self.Rarities[1].Name
end

return EggRarityModule
