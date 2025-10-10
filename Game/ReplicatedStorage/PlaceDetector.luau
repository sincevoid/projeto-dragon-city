local places = {
    ["Farm"] = 72980189537140,
    ["Pvp"] = 78414932677329,
    ["Lobby"] = 129920291664559
}

local PlaceDetector = {}

function PlaceDetector:GetCurrentPlace()
    return places[game.PlaceId] or "Unknown"
end

function PlaceDetector:GetCurrentPlaceId()
    return game.PlaceId
end

return PlaceDetector