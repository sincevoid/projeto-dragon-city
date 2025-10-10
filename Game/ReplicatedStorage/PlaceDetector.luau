local places = {
    ["Farm"] = 72980189537140,
    ["Pvp"] = 78414932677329,
    ["Lobby"] = 129920291664559
}

local PlaceDetector = function()
    local place = game.PlaceId
    for name, id in places do
        if place == id then
            return name
        end
    end

    return "Unknown"
end

return PlaceDetector