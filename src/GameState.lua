local state = "menu"

local GameState = {}

function GameState.set(newState)
    state = newState
end

function GameState.get()
    return state
end

function GameState.is(s)
    return state == s
end

return GameState
