class WrongNumberOfPlayersError < StandardError ; end
class NoSuchStrategyError < StandardError ; end

def rps_result(m1, m2)
    
    raise WrongNumberOfPlayersError

end

def rps_game_winner(game)
    player1 = game[0][1].downcase
    player2 = game[1][1].downcase
    raise WrongNumberOfPlayersError unless game.length == 2
    raise NoSuchStrategyError unless player1 =~ /^[rps]$/i and player2 =~ /^[rps]$/i
    winDict = "p" => "r", "r" => "s", "s" => "p"
    if winDict[player1].eq? player2
        return game[0]
    else if winDict[player2].eq? player1
        return game[1]
    else
        return game[0]
end

def rps_tournament_winner(tournament)
  if tournament[0][0].is_a? String
    return rps_game_winner tournament
  rps_game_winner [rps_tournament_winner tournament[0],rps_tournament_winner tournament[1]]
end
